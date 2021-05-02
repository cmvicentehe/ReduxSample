//
//  ToDoDetailVC+Subviews.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 07/09/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

extension ToDoDetailVC {
    
    func setUpViews() {

        view.backgroundColor = .white
        setUpNavigationRightButton()
        setUpScrollView()
        setUpContentView()

        contentView.addSubview(titleView)
        contentView.addSubview(dateView)
        contentView.addSubview(notesView)
        deleteButtonView.addSubview(deleteButton)
        contentView.addSubview(deleteButtonView)

        setUpConstraints()
    }

    func createContainerView() -> UIView {

       let containerView = UIView(frame: .zero)
       containerView.translatesAutoresizingMaskIntoConstraints = false
       containerView.backgroundColor = .white

       return containerView
    }
}

private extension ToDoDetailVC {

    func setUpNavigationRightButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(userDidTapSaveButton))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }

    func setUpScrollView() {

        view.addSubview(scrollView)

        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        guard #available(iOS 11.0, *) else {
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            return
        }

        let safeGuide = view.safeAreaLayoutGuide
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        scrollViewBottomConstraint?.isActive = true
    }

    func setUpContentView() {

        scrollView.addSubview(contentView)

        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

    func setUpDeleteButtonView() {

        let deleteButtonView = createContainerView()

        deleteButtonView.addSubview(deleteButton)
        scrollView.addSubview(deleteButtonView)

        deleteButton.leadingAnchor.constraint(equalTo: deleteButtonView.leadingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: deleteButtonView.trailingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: deleteButtonView.topAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: deleteButtonView.bottomAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
    }

    func setUpConstraints() {

           let margin12 = ToDoDetailVCVisualConstants.margin12
           let views = ["titleView": titleView,
                        "dateView": dateView,
                        "notesView": notesView,
                        "deleteButtonView": deleteButtonView]
           let metrics = ["margin12": margin12]

           deleteButton.leadingAnchor.constraint(equalTo: deleteButtonView.leadingAnchor, constant: margin12).isActive = true
           deleteButton.trailingAnchor.constraint(equalTo: deleteButtonView.trailingAnchor, constant: -margin12).isActive = true
           deleteButton.topAnchor.constraint(equalTo: deleteButtonView.topAnchor, constant: margin12).isActive = true
           deleteButton.bottomAnchor.constraint(equalTo: deleteButtonView.bottomAnchor, constant: -margin12).isActive = true

           contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleView]|",
                                                                     options: .alignAllCenterY,
                                                                     metrics: metrics,
                                                                     views: views))

           contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleView]-margin12-[dateView]-margin12-[notesView]-margin12-[deleteButtonView]-margin12-|",
                                                                     options: .alignAllCenterX,
                                                                     metrics: metrics,
                                                                     views: views))

           contentView.addConstraint(NSLayoutConstraint(item: dateView,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: titleView,
                                                               attribute: .width,
                                                               multiplier: 1.0,
                                                               constant: 0.0))

           contentView.addConstraint(NSLayoutConstraint(item: notesView,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: titleView,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0.0))

           contentView.addConstraint(NSLayoutConstraint(item: deleteButtonView,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: titleView,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0.0))
       }
}

struct ToDoDetailVCVisualConstants {
    
    static let margin12: CGFloat = 12.0
    static let margin6: CGFloat = 6.0
    static let buttonHeight: CGFloat = 44.0
    static let buttonWidth: CGFloat = 44.0
}
