//
//  Date+Extension.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation

public extension Date {
    
    /// Helper to create a `Date` from a `String` through a desired format.
    /// - Parameters:
    ///   - dateString: The string value to format.
    ///   - dateFormat: The date format string used by the receiver.
    ///   - timeZoneIdentifier: The time zone for the receiver.
    /// - Returns: Returns a `Date` when the parsing went ok. Otherwise returns `nil`.
    static func getDate(
        from dateString: String,
        withFormat dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        andTimeZoneIdentifier timeZoneIdentifier: String = "UTC"
    ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        return formatter.date(from: dateString)
    }
    
    /// Helper to create a `String` representation from a `Date` through a desired format.
    /// - Parameters:
    ///   - date: The date to represent.
    ///   - dateFormat: The date format string used by the receiver.
    ///   - timeZoneIdentifier: The time zone for the receiver.
    /// - Returns: Returns a `String` representation of date.
    static func getDateText(
        from date: Date,
        withFormat dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        andTimeZoneIdentifier timeZoneIdentifier: String = "UTC"
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        return formatter.string(from: date)
    }
}
