//
//  DayModel.swift
//  CalendarView
//
//  Created by Gianpiero Mode on 20/02/2020.
//  Copyright © 2020 Gianpiero Mode. All rights reserved.
//

import Foundation

public enum DayItems: String, Equatable, CaseIterable{
    
    case monday = "monday_header"//"monday"
    case tuesday = "tuesday_header"//"tuesday"
    case wednesday = "wednesday_header"//"wednesday"
    case thursday = "thursday_header"//"thursday"
    case friday = "friday_header"//"friday"
    case saturday = "saturday_header"//"saturday"
    case sunday = "sunday_header"//"sunday"
    
    static var numberOfItems = 7
    
    static var allCasesIterable = [DayItems.monday, DayItems.tuesday, DayItems.wednesday, DayItems.thursday, DayItems.friday, DayItems.saturday, DayItems.sunday]

    init?(_ rawNumber: Int) {
        switch rawNumber {
        case 1:
            self = DayItems(rawValue: "day_item_monday")!
        case 2:
            self = DayItems(rawValue: "day_item_tuesday")!
        case 3:
            self = DayItems(rawValue: "day_item_wednesday")!
        case 4:
            self = DayItems(rawValue: "day_item_thursday")!
        case 5:
            self = DayItems(rawValue: "day_item_friday")!
        case 6:
            self = DayItems(rawValue: "day_item_saturday")!
        case 7:
            self = DayItems(rawValue: "day_item_sunday")!
        default:
            self = DayItems(rawValue: "day_item_sunday")!
        }
        
    }
    
    public func getDayFromNumber(number: Int) -> Self{
        switch number {
        case 1:
            return .monday
        case 2:
            return .tuesday
        case 3:
            return .wednesday
        case 4:
            return .thursday
        case 5:
            return .friday
        case 6:
            return .saturday
        case 7:
            return .sunday
        default:
            return .sunday
        }
    }
    public func getDayName() -> String{
        let calendar = Calendar(identifier: .gregorian)
        
        //1 sunday, 2 monday
        let firstDay = calendar.firstWeekday
        
        let days = calendar.weekdaySymbols
        
        switch self {
        case .monday:
            if firstDay == 1{
                return String(days[1])
            }else{
                return String(days[0])
            }
        case .tuesday:
            if firstDay == 1{
                return String(days[2])
            }else{
                return String(days[1])
            }
        case .wednesday:
            if firstDay == 1{
                return String(days[3])
            }else{
                return String(days[2])
            }
        case .thursday:
            if firstDay == 1{
                return String(days[4])
            }else{
                return String(days[3])
            }
        case .friday:
            if firstDay == 1{
                return String(days[5])
            }else{
                return String(days[4])
            }
        case .saturday:
            if firstDay == 1{
                return String(days[6])
            }else{
                return String(days[5])
            }
        case .sunday:
            if firstDay == 1{
                return String(days[0])
            }else{
                return String(days[6])
            }
        }
    }
}
public enum WeekNumber: Equatable{
    case first
    case last
}
