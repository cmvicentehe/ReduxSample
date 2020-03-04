//
//  DateSelectorVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 26/10/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class DateSelectorVC: ReduxSampleVC {

    lazy var picker: UIDatePicker = { [weak self] in

        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.backgroundColor = .white

        return picker
    }()

    lazy var toolbar: UIToolbar = {

        let toolbar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0, width: view.bounds.width,
                                              height: DateSelectorVisualConstants.toolbarHeight))
        toolbar.barStyle = .default
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isUserInteractionEnabled = true

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexible, acceptButton]

        return toolbar
    }()

    lazy var acceptButton: UIBarButtonItem = { [weak self] in

        let acceptTitle =  NSLocalizedString("accept", comment: "")
        let acceptButton = UIBarButtonItem(title: acceptTitle, style: .plain, target: self, action: #selector(acceptButtonTouchedUpInside))

        return acceptButton
    }()

    lazy var cancelButton: UIBarButtonItem = { [weak self] in

        let cancelTitle =  NSLocalizedString("cancel", comment: "")
        let cancelButton = UIBarButtonItem(title: cancelTitle, style: .plain, target: self, action: #selector(cancelButtonTouchedUpInside))

        return cancelButton
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        setUpViews()
        dismissDateSelectorWhenUserTouchedAround()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationStack()
    }
}

// MARK: Actions
private extension DateSelectorVC {

    @objc func acceptButtonTouchedUpInside() {

        dismissDateSelector { [weak self] in
            self?.replaceReducer()
            self?.dispatchChangeTaskDateAction()
        }
    }

    @objc func cancelButtonTouchedUpInside() {
        dismissDateSelector(completion: nil)
    }
}

// MARK: Redux methods
private extension DateSelectorVC {

    @objc func dismissDateSelectorBytouchingOutside() {
        dismissDateSelector(completion: nil)
    }

    func dismissDateSelector(completion: (() -> Void)?) {

        dismiss(animated: true) {
            completion?()
        }
    }

    func replaceReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: changeSelectedTaskDateReducer)
    }

    func dispatchChangeTaskDateAction() {

        let date = picker.date
        let changeTaskDateAction = ChangeSelectedTaskDateAction(date: date)
        dispatch(action: changeTaskDateAction)
    }
}

// MARK: View configuration
private extension DateSelectorVC {

    func setUpViews() {

        view.addSubview(picker)
        view.addSubview(toolbar)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)

        picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        toolbar.leadingAnchor.constraint(equalTo: picker.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: picker.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        toolbar.widthAnchor.constraint(equalTo: picker.widthAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: DateSelectorVisualConstants.toolbarHeight).isActive = true
    }

    func dismissDateSelectorWhenUserTouchedAround() {

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDateSelectorBytouchingOutside))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: UIGestureRecognizerDelegate methods
extension DateSelectorVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view == touch.view
    }
}

private struct DateSelectorVisualConstants {
    
    static let toolbarHeight: CGFloat = 44.0
}
