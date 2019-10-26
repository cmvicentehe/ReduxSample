//
//  NotesView.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 17/09/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class NotesView: UIView {

    var viewModel: ToDoViewModel?

    lazy var notesTextfield: UITextField = {
        let notesTextfield = UITextField(frame: .zero)
        notesTextfield.translatesAutoresizingMaskIntoConstraints = false
        notesTextfield.textAlignment = .left
        notesTextfield.borderStyle = .roundedRect
        notesTextfield.backgroundColor = .clear

        return notesTextfield
    }()

    lazy var notesTextView: UITextView = {
        let notesTextView = UITextView(frame: .zero)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.isSelectable = true
        notesTextView.isEditable = true
        notesTextView.textAlignment = .left
        notesTextView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        notesTextView.isScrollEnabled = false
        notesTextView.textColor = UIColor.lightGray
        notesTextView.backgroundColor = .clear
        notesTextView.isUserInteractionEnabled = viewModel != nil ? true : false
        // TODO: Delete this hardcoded text
        notesTextView.text = /*viewModel?.notes ?? */"# Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. #"
        notesTextView.sizeToFit()
        notesTextView.setNeedsDisplay()

        return notesTextView
    }()

    init(frame: CGRect, viewModel: ToDoViewModel? = nil) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setUpNotesView()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
}

private extension NotesView {

    func setUpNotesView() {

        addSubview(notesTextfield)
        addSubview(notesTextView)

        notesTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        notesTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ToDoDetailVCVisualConstants.margin12).isActive = true
        notesTextfield.topAnchor.constraint(equalTo: topAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true
        notesTextfield.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ToDoDetailVCVisualConstants.margin12).isActive = true

        notesTextView.leadingAnchor.constraint(equalTo: notesTextfield.leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: notesTextfield.trailingAnchor).isActive = true
        notesTextView.topAnchor.constraint(equalTo: notesTextfield.topAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: notesTextfield.bottomAnchor).isActive = true
        notesTextView.heightAnchor.constraint(equalTo: notesTextfield.heightAnchor).isActive = true

        heightAnchor.constraint(equalTo: notesTextView.heightAnchor).isActive = true
    }
}
