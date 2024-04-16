import UIKit
import PickleFeature
import RxFlow
import RxSwift
import RxCocoa
import DSKit

import Core

public class PickleFlow: Flow {

    private var rootViewController: UINavigationController!
    var viewController: PickleViewController!

    public var root: Presentable {
        return self.rootViewController
    }
    
    public init() {
        setupViewController()
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MGStep else { return .none }

        switch step {
        case .pickle:
            return setupPickleScreen()
        default:
            return .none
        }
    }
    
    private func setupViewController() {
        viewController = PickleViewController()
        rootViewController = UINavigationController(rootViewController: viewController)
    }
    
    private func setupPickleScreen() -> FlowContributors {
        rootViewController.tabBarItem.title = "피클"
        rootViewController.tabBarItem.image = DSKitAsset.Assets.baPickleTapBar.image
        rootViewController.tabBarItem.selectedImage = DSKitAsset.Assets.blPeopleTapBar.image
        return .one(flowContributor: .contribute(withNextPresentable: self.root, withNextStepper: PickleStepper.shared))
    }
}
