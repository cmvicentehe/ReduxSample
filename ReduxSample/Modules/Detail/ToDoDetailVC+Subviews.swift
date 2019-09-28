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
        setUpScrollView()
        setUpContentView()

        let sendButtonView = createContainerView()
        sendButtonView.addSubview(sendButton)
        
        contentView.addSubview(titleView)
        contentView.addSubview(notesView)
        contentView.addSubview(sendButtonView)

        let margin12 = ToDoDetailVCVisualConstants.margin12
        let views = ["titleView": titleView,
                     "notesView": notesView,
                     "sendButtonView": sendButtonView]
        let metrics = ["margin12": margin12]

        sendButton.leadingAnchor.constraint(equalTo: sendButtonView.leadingAnchor, constant: margin12).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: sendButtonView.trailingAnchor, constant: -margin12).isActive = true
        sendButton.topAnchor.constraint(equalTo: sendButtonView.topAnchor, constant: margin12).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: sendButtonView.bottomAnchor, constant: -margin12).isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleView]|",
                                                                  options: .alignAllCenterY,
                                                                  metrics: metrics,
                                                                  views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleView]-margin12-[notesView]-margin12-[sendButtonView]-(>=margin12)-|",
                                                                  options: .alignAllCenterX,
                                                                  metrics: metrics,
                                                                  views: views))

        contentView.addConstraint(NSLayoutConstraint(item: notesView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0))

        contentView.addConstraint(NSLayoutConstraint(item: sendButtonView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0))
    }

    func setUpScrollView() { 
        view.addSubview(scrollView)
        
        if #available(iOS 11.0, *) {
            let safeGuide = view.safeAreaLayoutGuide
            scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setUpContentView() {
        scrollView.addSubview(contentView)
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setUpSendButtonView() {
        let sendButtonView = createContainerView()
        
        sendButtonView.addSubview(sendButton)
        scrollView.addSubview(sendButtonView)
        
        sendButton.leadingAnchor.constraint(equalTo: sendButtonView.leadingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: sendButtonView.trailingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        sendButton.topAnchor.constraint(equalTo: sendButtonView.topAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: sendButtonView.bottomAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
    }
}

extension ToDoDetailVC {
    
    func createContainerView() -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        return containerView
    }
}

struct ToDoDetailVCVisualConstants {
    static let margin12: CGFloat = 12.0
    static let margin6: CGFloat = 6.0
    static let buttonHeight: CGFloat = 44.0
    static let buttonWidth: CGFloat = 44.0
}
