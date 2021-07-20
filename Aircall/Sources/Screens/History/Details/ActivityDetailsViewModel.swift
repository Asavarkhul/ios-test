//
//  ActivityDetailsViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum DisplayedActivityItems {
    case header(String)
    case call(CallViewModel)
    case network(NetworkViewModel)
}

struct ActivityViewModel {

    // MARK: - Properties

    let activity: Activity
    let actions: Actions
    let repository: ActivityRepository

    // MARK: - Private

    private let dialogDataSourceSubject = PublishSubject<DialogAlertDataSource>()

    // MARK: - Actions

    struct Actions {
        let onArchive: () -> Void
    }

    // MARK: - Inputs

    struct Inputs {
        let startTrigger: Observable<Void>
        let didPressArchive: Observable<Void>
    }

    // MARK: - Outputs

    struct Outputs {
        let title: Observable<String>
        let items: Observable<[DisplayedActivityItems]>
        let alertDataSource: Observable<DialogAlertDataSource>
        let isLoading: Observable<Bool>
        let actions: Observable<Void>
    }

    // MARK: - Transform

    func transform(inputs: Inputs) -> Outputs {
        let isLoadingSubject = PublishSubject<Bool>()

        let title = Observable.just(
            Constants.titleDate(date: activity.createdAt)  ?? "⏱"
        )

        let items = inputs
            .startTrigger
            .map { activity }
            .map { buildItems(from: $0) }

        let archiveAction = inputs
            .didPressArchive
            .map { activity.id }
            .performRequest(
                repository.archiveActivity,
                onLoading: { isLoadingSubject.onNext($0) },
                onError: { makeDataSource(for: $0) }
            )
            .mapToVoid()
            .do(onNext: {
                DispatchQueue.main.async {
                    actions.onArchive()
                }
            })

        return .init(
            title: title,
            items: items,
            alertDataSource: dialogDataSourceSubject,
            isLoading: isLoadingSubject,
            actions: archiveAction
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
        case .dataSourceAvailabilityProblem: return Constants.dataSourceAvailabilityProblemMessage
        case .generalError: return Constants.generalErrorMessage
        }
    }

    private func makeContextualizedError(with message: String) {
        let alertMessage = AlertMessage(
            localizedTitle: Constants.commonAlertTitle,
            localizedMessage: message,
            localizedCancelActionTitle: Constants.commonOkTitle
        )

        let alertDataSource = DialogAlertDataSource(
            message: alertMessage,
            action: {}
        )

        dialogDataSourceSubject.onNext(alertDataSource)
    }

    private func buildItems(from activity: Activity) -> [DisplayedActivityItems] {
        return [
            .header(Constants.callInformationTitleText),
            .call(.init(activity: activity)),
            .network(.init(activity: activity))
        ]
    }
}

extension ActivityViewModel {
    enum Constants {
        static var commonAlertTitle: String {
            Current.translator.translation(for: "mobile/error/common-alert-title.text")
        }
        static var commonAlertMessage: String {
            Current.translator.translation(for: "mobile/error/common-alert-message.text")
        }
        static var commonOkTitle: String {
            Current.translator.translation(for: "mobile/error/common-alert-action.text")
        }
        static var dataConsistencyProblemMessage: String {
            Current.translator.translation(for: "mobile/error/data-consistency-problem-essage.text")
        }
        static var dataSourceAvailabilityProblemMessage: String {
            Current.translator.translation(for: "mobile/error/dataSource-availability-problem-essage.text")
        }
        static var generalErrorMessage: String {
            Current.translator.translation(for: "mobile/error/general-error-message.text")
        }
        static var callInformationTitleText: String {
            Current.translator.translation(for: "mobile/activity/details/call-information-title.text")
        }

        static func titleDate(date: String) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Current.locale()
            dateFormatter.dateFormat = "MMM dd, HH:mm"
            guard let formattedDate = Date.getDate(from: date) else {
                assertionFailure() // We should monitor this ☝️
                return nil
            }
            return dateFormatter.string(from: formattedDate)
        }
    }
}

