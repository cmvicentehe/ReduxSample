//
//  ToDoCell.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {

    var viewModel: ToDoViewModel?

    lazy var completeButton: UIButton = { [unowned self] in

        let completeButton = UIButton(type: .custom)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        let notSelectedImage = #imageLiteral(resourceName: "unchecked")
        let selectedImage = #imageLiteral(resourceName: "checked")
        completeButton.setImage(notSelectedImage, for: .normal)
        completeButton.setImage(selectedImage, for: .selected)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

        return completeButton
        }()

    lazy var title: UILabel = {

        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: ToDoCellFontConstants.titleSize, weight: .bold)

        return title
    }()

    lazy var subtitle: UILabel = {

        let subtitle = UILabel(frame: .zero)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textColor = .lightGray
        subtitle.font = UIFont.systemFont(ofSize: ToDoCellFontConstants.subtitleSize, weight: .light)
        
        return subtitle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid init method use (init(style: , reuseIdentifier:)) instead")
    }
}

// MARK: Bindable protocol
extension ToDoCell {

    func bind(viewModel: ToDoViewModel) {

        self.viewModel = viewModel
        title.text = viewModel.title
        subtitle.text = viewModel.date ?? "--"
        completeButton.isSelected = viewModel.isSelected
    }
}

// MARK: Private extension
private extension ToDoCell {

    func setUpViews() {

        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(completeButton)

        completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        completeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: ToDoCellVisualConstants.buttonHeight).isActive = true
        completeButton.widthAnchor.constraint(equalToConstant: ToDoCellVisualConstants.buttonWidth).isActive = true

        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ToDoCellVisualConstants.margin12).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        title.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: ToDoCellVisualConstants.margin6).isActive = true

        subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ToDoCellVisualConstants.margin12).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ToDoCellVisualConstants.margin12).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    }

    func replaceReducerByChangeTaskState(store: Store) {
        store.replaceReducer(reducer: changeTaskStateReducer)
    }

    func dispatchUpdateTaskAction(store: Store, viewModel: ToDoViewModel) {
        guard let state = store.getState() as? AppState else {
            print("Invalid state type")
            return
        }

        let networkClient = state.networkClient
        let action = ChangeTaskStateAction(taskIdentifier: viewModel.taskIdentifier,
                                           networkClient: networkClient)
        store.dispatch(action: action)
    }
}

// MARK: Action methods
private extension ToDoCell {
    @objc func completeButtonTapped() {

        guard let viewModelNotNil = viewModel else {
            print("View model is nil")
            return
        }

        guard let store = AppDelegateUtils.appDelegate?.store else {
            print("Store is nil")
            return
        }

        replaceReducerByChangeTaskState(store: store)
        dispatchUpdateTaskAction(store: store,
                                 viewModel: viewModelNotNil)
    }
}

struct ToDoCellConstants {

    static let cellIdentifier = "ToDoCell"
    static let estimatedRowHeight = 44.0
}

private struct ToDoCellVisualConstants {

    static let margin12: CGFloat = 12.0
    static let margin6: CGFloat = 6.0
    static let buttonHeight: CGFloat = 44.0
    static let buttonWidth: CGFloat = 44.0
}

private struct ToDoCellFontConstants {
    
    static let titleSize: CGFloat = 16.0
    static let subtitleSize: CGFloat = 12.0
}
