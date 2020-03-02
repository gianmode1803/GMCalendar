//
//  Date+Monthstring.swift
//  CalendarView
//
//  Created by Gianpiero Mode on 20/02/2020.
//  Copyright © 2020 Gianpiero Mode. All rights reserved.
//

import Foundation

extension Date {
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
            return df.string(from: self)
    }
}
