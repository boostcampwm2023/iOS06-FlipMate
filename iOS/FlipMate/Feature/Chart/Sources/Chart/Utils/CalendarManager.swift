//
//  CalendarManager.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Foundation

enum CalendarScrollState {
    case left
    case none
    case right
}

final class CalendarManager {
    // MARK: - Properties
    private var previousWeek: Date {
        return addDays(date: currentWeek, days: -7)
    }
    
    private var nextWeek: Date {
        return addDays(date: currentWeek, days: 7)
    }
    
    private(set) var currentWeek = Date()
    
    // MARK: - Methods
    func updateCurrentWeek(date: Date) {
        currentWeek = date
    }
    
    func updateCurrentWeek(calendarScrollState: CalendarScrollState) {
        switch calendarScrollState {
        case .left:
            updateCurrentWeekToPreviousWeek()
        case .none:
            break
        case .right:
            updateCurrentWeekToNextWeek()
        }
    }
    
    func previousWeekItem() -> [WeeklySectionItem] {
        let date = addDays(date: currentWeek, days: -7)
        return weekendItem(date)
    }
    
    func nextWeekItem() -> [WeeklySectionItem] {
        let date = addDays(date: currentWeek, days: 7)
        return weekendItem(date)
    }
    
    func currentWeekItem() -> [WeeklySectionItem] {
        return weekendItem(currentWeek)
    }
    
}

// MARK: - Private Methods
private extension CalendarManager {
    private func updateCurrentWeekToPreviousWeek() {
        currentWeek = previousWeek
    }
    
    private func updateCurrentWeekToNextWeek() {
        currentWeek = nextWeek
    }
    
    func addDays(date: Date, days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: date) ?? Date()
    }
    
    func findSunDay(date: Date) -> Date {
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7)
        
        while current > oneWeekAgo {
            let currentWeekDay = Calendar.current.dateComponents([.weekday], from: current).weekday
            if currentWeekDay == 1 {
                return current
            }
            current = addDays(date: current, days: -1)
        }
        return current
    }
    
    func weekendItem(_ date: Date) -> [WeeklySectionItem] {
        var weekendDate = [Date]()
        var current = findSunDay(date: date)
        let nextSunday = addDays(date: current, days: 7)
        
        while current < nextSunday {
            weekendDate.append(current)
            current = addDays(date: current, days: 1)
        }
        
        return weekendDate.map { WeeklySectionItem.dateCell($0.dateToString(format: .yyyyMMdd)) }
    }
}
