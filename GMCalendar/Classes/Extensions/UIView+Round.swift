//
//  UIView+Round.swift
//  CalendarView
//
//  Created by Gianpiero Mode on 20/02/2020.
//  Copyright © 2020 Gianpiero Mode. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func roundBourdersUntilCircle(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
