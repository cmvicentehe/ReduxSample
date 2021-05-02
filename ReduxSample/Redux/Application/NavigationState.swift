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

    var rootViewController: UIViewController { get }
    var window: UIWindow { get }
    func show(viewController: UIViewController, navigationStyle: NavigationStyle)
    func updateRootViewController(with viewController: UIViewController)
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
        DispatchQueue.main.async { [weak self] in
            switch navigationStyle {
            case .push:
                self?.push(viewController: viewController)
            case .modal:
                self?.present(viewController: viewController)
            case .updateWindow:
                self?.updateWindow(with: viewController)
            }
        }
    }

    func updateRootViewController(with viewController: UIViewController) {
        rootViewController = viewController
    }
}

private extension NavigationStateImpl {

    func push(viewController: UIViewController) {

        DispatchQueue.main.async { [weak self] in

            self?.rootViewController.show(viewController, sender: self)
            self?.updateRootViewController(with: viewController)
        }
    }

    func present(viewController: UIViewController) {

        DispatchQueue.main.async { [weak self] in

            self?.rootViewController.present(viewController, animated: true)
            self?.updateRootViewController(with: viewController)
        }
    }

    func updateWindow(with viewController: UIViewController) {

        DispatchQueue.main.async { [weak self] in

            self?.window.rootViewController = viewController
            self?.updateRootViewController(with: viewController)
        }
    }
}
