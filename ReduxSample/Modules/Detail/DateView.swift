//
//  DateView.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/09/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class DateView: UIView {

    var viewModel: ToDoViewModel?

    lazy var dateLabel: UILabel = {
        let dateLabel = createLabel()
        let text = NSLocalizedString("due_date", comment: "")
        dateLabel.text = "\(text) :"

        return dateLabel
    }()

    lazy var date: UILabel = {
        let date = createLabel()
        date.text = viewModel?.date ?? "--"
        date.textColor = .lightGray

        return date
    }()

    var dateString: String {
        return date.text ?? "--"
    }

    init(frame: CGRect, viewModel: ToDoViewModel? = nil) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setUpView()
    }

    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
}

// MARK: DateView update methods
extension DateView {
    func update(viewModel: ToDoViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [weak self] in
            self?.date.text = viewModel.date ?? "--"
        }
    }
}

private extension DateView {

    func createLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }

    func setUpView() {
        addSubview(dateLabel)
        addSubview(date)

        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DateViewVisualConstants.margin12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: date.leadingAnchor, constant: DateViewVisualConstants.margin6).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: DateViewVisualConstants.margin12).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DateViewVisualConstants.margin12).isActive = true

        date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DateViewVisualConstants.margin12).isActive = true
        date.topAnchor.constraint(equalTo: topAnchor, constant: DateViewVisualConstants.margin12).isActive = true
        date.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DateViewVisualConstants.margin12).isActive = true

        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        date.setContentHuggingPriority(.defaultLow, for: .horizontal)
        date.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}

private struct DateViewVisualConstants {
    static let margin12: CGFloat = 12.0
    static let margin6: CGFloat = 6.0
}
