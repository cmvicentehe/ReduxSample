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

    lazy var sendButtonView: UIView = {
        let sendButtonView = createContainerView()
        return sendButtonView
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton.init(type: .custom)
        let buttonTitle = NSLocalizedString("send", comment: "")
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle(buttonTitle, for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        
        return sendButton
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

private extension ToDoDetailVC {
    
    func bindViewModelIfNeeded() {
        guard let selectedTask = state.selectedTask else {
            print("There is no seleceted task. Adding task state")
            return
        }

        let isCompleted = (selectedTask.state == .done) ? true : false
        let formatterType = FormatterType.default
        let date = CustomDateFormatter.convertDateToString(date: selectedTask.dueDate, with: formatterType)
        viewModel = ToDoViewModel(taskIdentifier: selectedTask.identifier,
                                  title: selectedTask.name,
                                  date: date,
                                  notes: selectedTask.notes ?? "--",
                                  isSelected: isCompleted)
    }

    func reloadDetailView() {
        guard let viewModelNotNil = viewModel else {
            return
        }
        titleView.update(viewModel: viewModelNotNil)
        notesView.update(viewModel: viewModelNotNil)
        dateView.update(viewModel: viewModelNotNil)
    }

    @objc func userDidTapDateView() {
        replaceReducerByShowDateSelectorReducer()
        dispatchShowDateSelectorAction()
    }

    func replaceReducerByShowDateSelectorReducer() {
        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: showDateSelectorReducer)
    }

    func dispatchShowDateSelectorAction() {
        let showDateSelectorAction = ShowDateSelectorAction()
        dispatch(action: showDateSelectorAction)
    }
}

// MARK: Detail Updater
extension ToDoDetailVC: DetailUpdater {
    func update(with state: AppState) {
        self.state = state
        bindViewModelIfNeeded()
        reloadDetailView()
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

        if keyboardScreenEndFrame.intersects(titleView.frame) ||
            keyboardScreenEndFrame.intersects(notesView.frame) {

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
    }

    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.setContentOffset(.zero, animated: false)
            self?.scrollViewBottomConstraint?.constant = 0
            self?.view.layoutIfNeeded()
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
