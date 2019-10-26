//
//  DateSelectorVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 26/10/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

class DateSelectorVC: ReduxSampleVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationStack()
    }
}
