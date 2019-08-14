//
//  ToDoCell.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

struct ToDoCellConstants {
    static let cellIdentifier = "ToDoCell"
    static let estimatedRowHeight = 44.0
}

struct ToDoCellVisualConstants {
    static let margin12: CGFloat = 12.0
    static let margin6: CGFloat = 6.0
    static let buttonHeight: CGFloat = 44.0
}

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

        return title
    }()

    lazy var subtitle: UILabel = {
        let subtitle = UILabel(frame: .zero)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        
        return subtitle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Bindable protocol
extension ToDoCell {
    func bind(viewModel: ToDoViewModel) {
        self.viewModel = viewModel
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        completeButton.isSelected = viewModel.isSelected
    }
}

// MARK: Private extension
private extension ToDoCell {
    func setUpViews() {
        contentView.addSubview(title)
//      contentView.addSubview(subtitle)
        contentView.addSubview(completeButton)

        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -ToDoCellVisualConstants.margin12).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ToDoCellVisualConstants.margin12).isActive = true
        title.leftAnchor.constraint(equalTo: completeButton.rightAnchor, constant: ToDoCellVisualConstants.margin6).isActive = true
        completeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: ToDoCellVisualConstants.margin12).isActive = true
        completeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: ToDoCellVisualConstants.buttonHeight).isActive = true
    }
}

//MARK: Action methods
private extension ToDoCell {
    @objc func completeButtonTapped() {

        guard let viewModelNotNil = viewModel else {
            fatalError("View model is nil")
        }

        guard let store = AppDelegateUtils.appDelegate?.store else {
            fatalError("Store is nil")
        }

        store.replaceReducer(reducer: changeTaskStateReducer)

        let action = ChangeTaskStateAction(taskIdentifier: viewModelNotNil.identifier)
        store.dispatch(action: action)
    }
}
