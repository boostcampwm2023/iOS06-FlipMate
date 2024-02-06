//
//  ChartDIContainer.swift
//  FlipMate
//
//  Created by 신민규 on 12/5/23.
//

import UIKit

final class ChartDIContainer: ChartFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeChartFlowCoordinator(navigationController: UINavigationController) -> ChartFlowCoordinator {
        return ChartFlowCoordinator(
            dependencies: self,
            navigationController: navigationController)
    }
    
    func makeChartViewController() -> UIViewController {
        return ChartViewController(
            viewModel: ChartViewModel(
                dailyChartUseCase: DefaultFetchDailyChartUseCase(
                    repository: DefaultChartRepository(
                        provider: dependencies.provider
                    )
                )
            )
        )
    }
}
