//
//  ToDoDetailVC+Redux.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 03/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

extension ToDoDetailVC {
    
    func replaceReducerByShowDateSelectorReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: showDateSelectorReducer)
    }

    func replaceReducerByDeleteTaskReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: deleteTaskReducer)
    }

    func replaceReducerByPopViewControllerReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: popViewControllerReducer)
    }

    func replaceReducerByUpdateTaskReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: updateTaskReducer)
    }

    func replaceReducerByShowActivityIndicatorReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: showActivityIndicatorReducer)
    }

    func replaceReducerByHideActivityIndicatorReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: hideActivityIndicatorReducer)
    }

    func replaceReducerByUpdateTaskSelectionStateReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: updateTaskSelectionStateReducer)
    }

    func dispatchShowDateSelectorAction() {

        dismissKeyboard()
        let showDateSelectorAction = ShowDateSelectorAction()
        dispatch(action: showDateSelectorAction)
    }

    func dispatchDeleteTaskAction() {

        guard let identifier = state.selectedTask?.identifier else {
            print("Invalid task identifier to be deleted")
            return
        }

        let networkClient = state.networkClient
        let deleteTaskAction = DeleteTaskAction(taskIdentifier: identifier,
                                                networkClient: networkClient)
        dispatch(action: deleteTaskAction)
    }

    func dispatchPopViewControllerAction() {

        let popViewControllerAction = PopViewControllerAction()
        dispatch(action: popViewControllerAction)
    }

    func dispatchUpdateTaskAction() {

        let store = AppDelegateUtils.appDelegate?.store

        guard let selectedTask = state.selectedTask else {
            print("Invalid selected task")
            return
        }

        var taskState: TaskState = .toDo
        var notes = "--"
        var title = "--"
        var dateString = "--"

        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async { [weak self] in
            
            let isSelected = self?.titleView.completeButton.isSelected ?? false
            title = self?.titleView.title ?? "--"
            taskState = isSelected ? TaskState.done : .toDo
            dateString = self?.dateView.dateString ?? "--"
            notes = self?.notesView.notesTextView.text ?? "--"
            group.leave()
        }

        group.wait()
        let date = CustomDateFormatter.convertDateStringToDate(dateString: dateString, with: FormatterType.default)
        let updatedTask = ToDoTask(identifier: selectedTask.identifier,
                                   name: title,
                                   dueDate: date,
                                   notes: notes,
                                   state: taskState)
        let networkClient = state.networkClient
        let updateTaskAction = UpdateTaskAction(task: updatedTask, networkClient: networkClient)
        store?.dispatch(action: updateTaskAction)
    }

    func dispatchShowActivityIndicatorAction() {

       let showActivityIndicatorAction = ShowActivityIndicatorAction()
       dispatch(action: showActivityIndicatorAction)
    }

    func dispatchHideActivityIndicatorAction() {

        let hideActivityIndicatorAction = HideActivityIndicatorAction()
        dispatch(action: hideActivityIndicatorAction)
    }

    func dispatchUpdateTaskSelectionStateAction(_ taskSelectionState: TaskSelectionState) {

        let updateTaskSelectionStateAction = UpdateTaskSelectionStateAction(taskSelectionState: taskSelectionState )
        dispatch(action: updateTaskSelectionStateAction)
    }
}

// MARK: State management
extension ToDoDetailVC {

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

    func refreshDetailInfo() {

        bindViewModelIfNeeded()
        reloadDetailView()
    }

    func updateTaskInfo() {

        switch state.taskSelectionState {
        case .addingTask, .notSelected: break
        case .editingTask:
            refreshDetailInfo()
        case .deletingTask, .savingTask:
            replaceReducerByHideActivityIndicatorReducer()
            dispatchHideActivityIndicatorAction()
        }
    }

    func handleViewState() {

        let viewState = state.viewState
        switch viewState {
        case .activityIndicatorRequired:
            replaceReducerByShowActivityIndicatorReducer()
            dispatchShowActivityIndicatorAction()
        case .fetching:
            handleTaskSelectionState()
        case .fetched, .notHandled:
            updateTaskInfo()
        case .finish:
           replaceReducerByPopViewControllerReducer()
           dispatchHideActivityIndicatorAction()
        }
    }

    func handleTaskSelectionState() {

        switch state.taskSelectionState {
        case .addingTask, .notSelected, .editingTask: break
        case .deletingTask:
            replaceReducerByDeleteTaskReducer()
            dispatchDeleteTaskAction()
        case .savingTask:
            replaceReducerByUpdateTaskReducer()
            dispatchUpdateTaskAction()
        }
    }
}

// MARK: Detail Updater
extension ToDoDetailVC: DetailUpdater {

    func update(with state: AppState) {

        self.state = state
        handleViewState()
    }
}
