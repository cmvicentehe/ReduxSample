//
//  ReduxSampleVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class ReduxSampleVC: UIViewController {

    var state: AppState
    let suscriber: Suscriber?

    init(state: AppState, suscriber: Suscriber? = nil) {
        self.state = state
        self.suscriber = suscriber
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
       suscriber?.unsuscribe()
    }
}

// MARK: View life cycle
extension ReduxSampleVC {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suscriber?.suscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         suscriber?.unsuscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         suscriber?.unsuscribe()
    }
}
