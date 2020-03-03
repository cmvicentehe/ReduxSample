//
//  ToDoDetailVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

protocol DetailUpdater {
    func update(with state: AppState)
}

class ToDoDetailVC: ReduxSampleVC {
    
    var viewModel: ToDoViewModel?
    var scrollViewBottomConstraint: NSLayoutConstraint?
    
    lazy var scrollView: UIScrollView = {

        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var contentView: UIView = {

        let contentView = createContainerView()
        return contentView
    }()
    
    lazy var titleView: TitleView = {

        let titleView = TitleView(frame: .zero, viewModel: viewModel)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        return titleView
    }()

    lazy var dateView: DateView = { [weak self] in

        let dateView = DateView(frame: .zero, viewModel: viewModel)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userDidTapDateView))

        dateView.addGestureRecognizer(tapGestureRecognizer)

        return dateView
        }()
    
    lazy var notesView: NotesView = {

        let notesView = NotesView(frame: .zero, viewModel: viewModel)
        notesView.translatesAutoresizingMaskIntoConstraints = false
        
        return notesView
    }()

    lazy var deleteButtonView: UIView = {

        let deleteButtonView = createContainerView()
        return deleteButtonView
    }()
    
    lazy var deleteButton: UIButton = { [weak self] in

        let deleteButton = UIButton.init(type: .custom)
        let buttonTitle = NSLocalizedString("delete", comment: "")
        let taskSelectionState = self?.state.taskSelectionState
        deleteButton.isEnabled = (taskSelectionState != .addingTask) ? true : false
        deleteButton.alpha = (taskSelectionState != .addingTask) ? 1.0 : 0.2
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle(buttonTitle, for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)

        deleteButton.addTarget(self, action: #selector(userDidTapDeleteButton), for: .touchUpInside)
        
        return deleteButton
        }()
    
    init(state: AppState, viewModel: ToDoViewModel?, suscriber: Suscriber? = nil) {

        self.viewModel = viewModel
        super.init(state: state, suscriber: suscriber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid init method use (init(state: , suscriber:)) instead")
    }
}

// MARK: ViewController life cycle
extension ToDoDetailVC {
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setUpViews()
        viewModel?.detailUpdater = self
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        hideKeyboardWhenTappedAround()
        registerToKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unregisterToKeyboardEvents()
    }
}

// MARK: Private Keyboard methods
 private extension ToDoDetailVC {

    func registerToKeyboardEvents() {

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterToKeyboardEvents() {

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func manageKeyboardAppearing(_ keyboardHeight: CGFloat) {

        UIView.animate(withDuration: 0.3) { [weak self] in

            guard let viewHeight = self?.view.frame.height,
                let contentViewHeight = self?.contentView.frame.height else {
                    print("View or scroll content view height is nil")
                    return
            }

            let availableSpace = viewHeight - keyboardHeight
            let yposition = contentViewHeight - availableSpace
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: yposition), animated: false)
            self?.scrollViewBottomConstraint?.constant = -keyboardHeight
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillShow(notification: Notification) {

        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height

        if keyboardScreenEndFrame.intersects(titleView.frame) ||
            keyboardScreenEndFrame.intersects(notesView.frame) {

            manageKeyboardAppearing(keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {

        UIView.animate(withDuration: 0.3) { [weak self] in

            self?.scrollView.setContentOffset(.zero, animated: false)
            self?.scrollViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
    }

    func hideKeyboardWhenTappedAround() {

        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: Internal Keyboard methods
extension ToDoDetailVC {

    @objc func dismissKeyboard() {

           DispatchQueue.main.async { [weak self] in
               self?.view.endEditing(true)
           }
       }
}

// MARK: User interaction
extension ToDoDetailVC {

    @objc func userDidTapDateView() {

          replaceReducerByShowDateSelectorReducer()
          dispatchShowDateSelectorAction()
    }

    @objc func userDidTapDeleteButton() {

        replaceReducerByUpdateTaskSelectionStateReducer()
        dispatchUpdateTaskSelectionStateAction(.deletingTask)
    }

    @objc func userDidTapSaveButton() {
        
        replaceReducerByUpdateTaskSelectionStateReducer()
        dispatchUpdateTaskSelectionStateAction(.savingTask)
    }
}
