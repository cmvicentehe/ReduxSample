//
//  TitleView.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 17/09/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class TitleView: UIView {

    var viewModel: ToDoViewModel?

    lazy var titleTextfield: UITextField = {
        let titleTextfield = UITextField(frame: .zero)
        titleTextfield.translatesAutoresizingMaskIntoConstraints = false
        titleTextfield.textAlignment = .left
        titleTextfield.borderStyle = .roundedRect
        titleTextfield.backgroundColor = .clear

        return titleTextfield
    }()

    lazy var titleTextView: UITextView = {
        let titleTextView = UITextView(frame: .zero)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.isSelectable = true
        titleTextView.isEditable = true
        titleTextView.textAlignment = .left
        titleTextView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleTextView.isScrollEnabled = false
        titleTextView.textColor = UIColor.lightGray
        titleTextView.backgroundColor = .clear
        titleTextView.isUserInteractionEnabled = viewModel != nil ? true : false
        titleTextView.text = viewModel?.title ?? "--"
        titleTextView.sizeToFit()
        titleTextView.setNeedsDisplay()

        return titleTextView
    }()

    lazy var completeButton: UIButton = { [unowned self] in
        let completeButton = UIButton(type: .custom)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        let notSelectedImage = #imageLiteral(resourceName: "unchecked")
        let selectedImage = #imageLiteral(resourceName: "checked")
        completeButton.setImage(notSelectedImage, for: .normal)
        completeButton.setImage(selectedImage, for: .selected)
        completeButton.isSelected = viewModel?.isSelected ?? false
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

        return completeButton
    }()

    init(frame: CGRect, viewModel: ToDoViewModel? = nil) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setUpTitleView()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
}

// MARK: TitleView update methods
extension TitleView {
    func update(viewModel: ToDoViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [weak self] in
            self?.titleTextView.text = self?.viewModel?.title
            self?.completeButton.isSelected = self?.viewModel?.isSelected ?? false
        }
    }
}

private extension TitleView {

    func setUpTitleView() {
        addSubview(titleTextfield)
        addSubview(titleTextView)
        addSubview(completeButton)

        completeButton.topAnchor.constraint(equalTo: topAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        completeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: ToDoDetailVCVisualConstants.buttonHeight).isActive = true
        completeButton.widthAnchor.constraint(equalToConstant: ToDoDetailVCVisualConstants.buttonWidth).isActive = true

        titleTextfield.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: ToDoDetailVCVisualConstants.margin6).isActive = true
        titleTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ToDoDetailVCVisualConstants.margin12).isActive = true
        titleTextfield.topAnchor.constraint(equalTo: completeButton.topAnchor).isActive = true
        titleTextfield.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true

        titleTextView.leadingAnchor.constraint(equalTo: titleTextfield.leadingAnchor).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: titleTextfield.trailingAnchor).isActive = true
        titleTextView.topAnchor.constraint(equalTo: titleTextfield.topAnchor).isActive = true
        titleTextView.bottomAnchor.constraint(equalTo: titleTextfield.bottomAnchor).isActive = true
        titleTextView.heightAnchor.constraint(equalTo: titleTextfield.heightAnchor).isActive = true

        heightAnchor.constraint(equalTo: titleTextView.heightAnchor).isActive = true
    }

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
