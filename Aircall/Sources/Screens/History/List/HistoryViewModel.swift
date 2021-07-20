//
//  HistoryViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum HistoryItems {
    case activity(ActivityCellViewModel)
}

struct HistoryViewModel {

    // MARK: - Properties

    let repository: HistoryRepository
    let actions: Actions

    // MARK: - Private

    private let translator = Current.translator
    private let failBackSubject = PublishSubject<Void>()
    private let archivedDataSource = PublishSubject<[Activity]>()
    private let dialogDataSourceSubject = PublishSubject<DialogAlertDataSource>()

    // MARK: - Actions

    struct Actions {
        let onSelectActivity: (Activity) -> Void
    }

    // MARK: - Inputs

    struct Inputs {
        let startTrigger: Observable<Void>
        let didPressActivityAtIndex: Observable<Int>
        let didArchiveActivtyAtIndex: Observable<(index: Int, completionHandler: (Bool) -> Void)>
        let didPressReset: Observable<Void>
    }

    // MARK: - Outputs

    struct Outputs {
        let title: Observable<String>
        let items: Observable<[HistoryItems]>
        let alertDataSource: Observable<DialogAlertDataSource>
        let isLoading: Observable<Bool>
        let actions: Observable<Void>
    }

    // MARK: - Transform

    func transform(inputs: Inputs) -> Outputs {
        let isLoadingSubject = PublishSubject<Bool>()

        let getHistory = inputs
            .startTrigger
            .performRequest(
                repository.getHistory,
                onLoading: { isLoadingSubject.onNext($0) },
                onError: { makeDataSource(for: $0) }
            )

        let originalDataSource = getHistory
            .map { $0.map { Activity(response: $0) } }
            .share()

        let resetedDataSource: Observable<[Activity]> = inputs
            .didPressReset
            .performRequest(
                repository.reset,
                onLoading: { isLoadingSubject.onNext($0) },
                onError: { makeDataSource(for: $0) }
            )
            .withLatestFrom(originalDataSource)
            .map {
                $0.map {
                    var activity = $0
                    activity.unArchive()
                    return activity
                }
            }
            .share()

        let dataSource = Observable.merge(
            originalDataSource,
            resetedDataSource,
            archivedDataSource
        )
        .share()

        let failBackDataSource = failBackSubject
            .withLatestFrom(dataSource)

        let upToDateDataSource = Observable.merge(
            dataSource,
            failBackDataSource
        )
        .share()

        let archiveActivityRequest: ((activityID: String, completionHandler: (Bool) -> Void))
            -> Single<Result<ArchiveActivityResponse, Swift.Error>> = { data -> Single<Result<ArchiveActivityResponse, Swift.Error>> in
            return self.repository.archiveActivity(data.activityID)
                .do(onSuccess: { result in
                    switch result {
                    case .success:
                        data.completionHandler(true)
                    case .failure:
                        data.completionHandler(false)
                    }
                })
        }

        let selectActivityAction = Observable
            .zip(inputs.didPressActivityAtIndex, upToDateDataSource)
            .do(onNext: { index, activities in
                guard activities.indices.contains(index) else { return }
                DispatchQueue.main.async {
                    self.actions.onSelectActivity(activities[index])
                }
            })
            .mapToVoid()

        let dataSourceWithoutArchivedActivities = upToDateDataSource
            .map { $0.filter { !$0.isArchived } }

        let archiveActivityAction = inputs.didArchiveActivtyAtIndex
            .withLatestFrom(dataSourceWithoutArchivedActivities) { (archiveActivity: $0, activities: $1) }
            .filter {
                if $0.activities.indices.contains($0.archiveActivity.index) {
                    return true
                } else {
                    $0.archiveActivity.completionHandler(false)
                    return false
                }
            }
            .map {
                (activityID: $0.activities[$0.archiveActivity.index].id, completionHandler: $0.archiveActivity.completionHandler)
            }
            .performRequest(
                archiveActivityRequest,
                onLoading: { isLoadingSubject.onNext($0) },
                onError: { makeDataSource(for: $0) }
            )
            .withLatestFrom(dataSourceWithoutArchivedActivities) { (archiveActivity: $0, dataSource: $1) }
            .map { archiveActivityResponse, activities -> [Activity] in
                var activities = activities
                guard let index = activities.firstIndex(
                    where: { $0.id == "\(archiveActivityResponse.id)" }
                ) else {
                    return activities
                }
                activities[index].archive()
                return activities
            }.do(onNext: {
                archivedDataSource.onNext(($0))
            })
            .mapToVoid()

        let displayedDataSource: Observable<[HistoryItems]> = dataSourceWithoutArchivedActivities
            .map { $0.map { .activity(.init(activity: $0)) } }

        let title = Observable.just(Constants.title)

        let actions = Observable.merge(
            selectActivityAction,
            archiveActivityAction
        )

        return .init(
            title: title,
            items: displayedDataSource,
            alertDataSource: dialogDataSourceSubject,
            isLoading: isLoadingSubject,
            actions: actions
        )
    }

    // MARK: - Helpers

    private func makeDataSource(for error: Error) {
        if let error = error as? HistoryError {
            makeContextualizedError(with: getErrorMessage(from: error))
        } else {
            makeContextualizedError(with: Constants.commonAlertMessage)
        }
    }

    private func getErrorMessage(from error: HistoryError) -> String {
        switch error {
        case .dataConsistencyProblem: return Constants.dataConsistencyProblemMessage
        case .dataSourceAvailabilityProblem: return Constants.dataConsistencyProblemMessage
        case .generalError: return Constants.generalErrorMessage
        }
    }

    private func makeContextualizedError(with message: String) {
        let alertMessage = AlertMessage(
            localizedTitle: Constants.commonAlertTitle,
            localizedMessage: message,
            localizedCancelActionTitle: Constants.commonOkTitle
        )

        let closeAction = {
            failBackSubject.onNext(())
        }

        let alertDataSource = DialogAlertDataSource(
            message: alertMessage,
            action: closeAction
        )

        dialogDataSourceSubject.onNext(alertDataSource)
    }
}

private extension HistoryViewModel {
    enum Constants {
        static var title: String { Current.translator.translation(for: "mobile/history/title.text") }
        static var commonAlertTitle: String { Current.translator.translation(for: "mobile/error/common-alert-title.text") }
        static var commonAlertMessage: String { Current.translator.translation(for: "mobile/error/common-alert-message.text") }
        static var commonOkTitle: String { Current.translator.translation(for: "mobile/error/common-alert-action.text") }
        static var failToArchiveMessage: String { Current.translator.translation(for: "mobile/error/fail-to-archive-activity-message.text") }
        static var dataConsistencyProblemMessage: String { Current.translator.translation(for: "mobile/error/data-consistency-problem-essage.text") }
        static var dataSourceAvailabilityProblemMessage: String { Current.translator.translation(for: "mobile/error/dataSource-availability-problem-essage.text") }
        static var generalErrorMessage: String { Current.translator.translation(for: "mobile/error/general-error-message.text") }
    }
}

private extension Activity {
    init(response: ActivityResponse) {
        self.id = "\(response.id)"
        self.createdAt = response.createdAt
        self.direction = .init(direction: response.direction)
        self.from = response.from
        self.to = response.to
        self.via = response.via
        self.duration = response.duration
        self.isArchived = response.isArchived
        self.callType = .init(callType: response.callType)
    }
}

private extension Activity.Direction {
    init(direction: ActivityResponse.Direction) {
        switch direction {
        case .inbound: self = .inbound
        case .outbound: self = .outbound
        }
    }
}

private extension Activity.CallType {
    init(callType: ActivityResponse.CallType) {
        switch callType {
        case .answered: self = .answered
        case .missed: self = .missed
        case .voicemail: self = .voicemail
        }
    }
}
