//
//  HistoryViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoryViewModel {

    // MARK: - Properties

    let repository: HistoryRepository
    let actions: Actions

    // MARK: - Actions

    struct Actions {
        let onSelectActivity: (Activity) -> Void
    }

    // MARK: - Inputs

    struct Inputs {
        let startTrigger: Observable<Void>
        let didPressActivityAtIndex: Observable<Int>
        let didArchiveActivtyAtIndex: Observable<Int>
        let didPressReset: Observable<Void>
    }

    // MARK: - Outputs

    struct Outputs {
        let activities: Observable<[Activity]>
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
            .share()

        let originalDataSource: Observable<[Activity]> = getHistory
            .map {
                $0.map { Activity(response: $0) }
            }
        
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

        let dataSource = Observable.merge(
            originalDataSource,
            resetedDataSource
        )

        let archiveActivity = Observable
            .combineLatest(inputs.didArchiveActivtyAtIndex, dataSource)
            .map { index, activities in
                guard activities.indices.contains(index) else { return "" }
                return activities[index].id
            }
            .performRequest(
                repository.archiveActivity,
                onLoading: { isLoadingSubject.onNext($0) },
                onError: { makeDataSource(for: $0) }
            )

        let archivedDataSource: Observable<[Activity]> = Observable
            .combineLatest(archiveActivity, dataSource)
            .map { archiveActivityResponse, activities in
                var activities = activities
                guard let index = activities.firstIndex(
                    where: { $0.id == "\(archiveActivityResponse.id)" }
                ) else {
                    return activities
                }
                activities[index].archive()
                return activities
            }

        let selectActivity = Observable
            .combineLatest(inputs.didPressActivityAtIndex, dataSource)
            .do(onNext: { index, activities in
                guard activities.indices.contains(index) else { return }
                self.actions.onSelectActivity(activities[index])
            })
            .mapToVoid()

        let displayedDataSource = Observable.merge(
            dataSource,
            archivedDataSource
        ).map {
            $0.filter { !$0.isArchived }
        }

        return .init(
            activities: displayedDataSource,
            isLoading: isLoadingSubject,
            actions: selectActivity
        )
    }

    // MARK: - Helpers

    private func makeDataSource(for error: Error) {
        
    }
}

private extension Activity {
    init(response: ActivityResponse) {
        self.id = "\(response.id)"
        self.createdAt = response.createdAt
        self.direction = response.direction.rawValue
        self.from = response.from
        self.to = response.to
        self.via = response.via
        self.duration = response.duration
        self.isArchived = response.isArchived
        self.callType = response.callType
    }
}
