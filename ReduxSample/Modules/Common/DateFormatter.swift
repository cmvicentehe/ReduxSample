//
//  DateFormatter.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/09/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

enum FormatterType: String {
    case `default` = "dd/MM/yyyy"
}

 struct CustomDateFormatter {

    static func convertDateToString(date: Date?, with format: FormatterType) -> String? {
        guard let dateNotNil = date else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: dateNotNil)
        return dateString
    }
}