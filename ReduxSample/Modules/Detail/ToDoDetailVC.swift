//
//  ToDoDetailVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class ToDoDetailVC: ReduxSampleVC {
    
    var viewModel: ToDoViewModel?
    
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
    
    lazy var notesView: NotesView = {
        let notesView = NotesView(frame: .zero, viewModel: viewModel)
        notesView.translatesAutoresizingMaskIntoConstraints = false
        
        return notesView
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton.init(type: .custom)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("#SEND#", for: .normal) // TODO: Localize text
        sendButton.setTitleColor(UIColor.blue, for: .normal)
        
        return sendButton
    }()
    
    override init(state: AppState, suscriber: Suscriber? = nil) {
        super.init(state: state, suscriber: suscriber)
        bindViewModelIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid init method use (init(state: , suscriber:)) instead")
    }
}

// MARK: ViewController life cycle
extension ToDoDetailVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerToKeyboardEvents()
        setUpViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterToKeyboardEvents()
        updateNavigationStack()
    }
}

private extension ToDoDetailVC {
    
    func bindViewModelIfNeeded() {
        guard let selectedTask = state.selectedTask else {
            print("There is no seleceted task. Adding task state")
            return
        }
        
        let isCompleted = (selectedTask.state == .done) ? true : false
        viewModel = ToDoViewModel(identifier: selectedTask.identifier,
                                  title: selectedTask.name,
                                  notes: selectedTask.notes ?? "",
                                  isSelected: isCompleted)
    }
    
    func updateNavigationStack() {
        replaceReducerByUpdateNavigationStateReducer()
        dispatchUpdateNavigationStateAction()
    }
    
    func replaceReducerByUpdateNavigationStateReducer() {
        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: updateNavigationStateReducer)
    }
    
    func dispatchUpdateNavigationStateAction() {
        let updateNavigationStateAction = UpdateNavigationStateAction()
        dispatch(action: updateNavigationStateAction)
    }
}

// MARK: Keyboard methods
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

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height

        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0.0,
                                                   bottom: keyboardHeight,
                                                   right: 0.0)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = .zero
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: REDUX methods
extension ToDoDetailVC: ActionDispatcher {}
