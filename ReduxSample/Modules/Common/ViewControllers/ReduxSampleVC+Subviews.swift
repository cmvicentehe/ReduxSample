//
//  ReduxSampleVC+Subviews.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 02/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

extension ReduxSampleVC {
    
    func setUpActivityIndicator() {

        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor).isActive = true

        activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: Activity indicator methods
extension ReduxSampleVC {

    func showActivityIndicator() {

        DispatchQueue.main.async { [weak self] in

            guard let selfNotNil = self,
                !selfNotNil.activityIndicator.isAnimating,
                selfNotNil.activityIndicatorView.isHidden else {
                return
            }

            selfNotNil.activityIndicatorView.isHidden = false
            selfNotNil.activityIndicator.startAnimating()

            selfNotNil.activityIndicatorView.bringSubviewToFront(selfNotNil.activityIndicator)
            selfNotNil.view.bringSubviewToFront(selfNotNil.activityIndicatorView)
        }
    }

    func hideActivityIndicator() {

        DispatchQueue.main.async { [weak self] in

            guard let selfNotNil = self,
                selfNotNil.activityIndicator.isAnimating,
                !selfNotNil.activityIndicatorView.isHidden else {
                return
            }

            selfNotNil.activityIndicatorView.isHidden = true
            selfNotNil.activityIndicator.stopAnimating()

            selfNotNil.activityIndicatorView.bringSubviewToFront(selfNotNil.activityIndicator)
            selfNotNil.view.bringSubviewToFront(selfNotNil.activityIndicatorView)
        }
    }
}
