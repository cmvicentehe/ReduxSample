//
//  NavigationState.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 21/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

enum NavigationStyle {
    case push
    case modal
    case updateWindow
}

protocol NavigationState {
    func show(viewController: UIViewController, navigationStyle: NavigationStyle)
}

class NavigationStateImpl {
    private(set) var rootViewController: UIViewController
    private(set) var window: UIWindow

    init(rootViewController: UIViewController, window: UIWindow) {
        self.rootViewController = rootViewController
        self.window = window
    }
}

extension NavigationStateImpl: NavigationState {
    func show(viewController: UIViewController, navigationStyle: NavigationStyle) {
        switch navigationStyle {
        case .push:
            push(viewController: viewController)
        case .modal:
            present(viewController: viewController)
        case .updateWindow:
            updateWindow(with: viewController)
        }
    }
}

private extension NavigationStateImpl {
    func push(viewController: UIViewController) {
        rootViewController.show(viewController, sender: self)
        updateRootViewController(with: viewController)
    }

    func present(viewController: UIViewController) {
        rootViewController.present(viewController, animated: true)
        updateRootViewController(with: viewController)
    }

    func updateWindow(with viewController: UIViewController) {
        window.rootViewController = viewController
        updateRootViewController(with: viewController)
    }

    func updateRootViewController(with viewController: UIViewController) {
        rootViewController = viewController
    }
}
