//
//  String+Localization.swift
//  CalendarView
//
//  Created by Gianpiero Mode on 26/02/2020.
//  Copyright © 2020 Gianpiero Mode. All rights reserved.
//

import Foundation
import UIKit

extension String{
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: GMCalendar.self), value: "", comment: "")
    }
}

