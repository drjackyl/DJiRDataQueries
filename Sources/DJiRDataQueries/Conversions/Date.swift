import Foundation

extension Date {
    
    private static let gregorianCalendar = Calendar(identifier: .gregorian)
    private static let utcTimeZone = TimeZone(secondsFromGMT: 0)!
    
    init(year: Int = 0, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0, milliSecond: Int = 0, hoursFromUTC: Int = 0) {
        self = DateComponents(
            calendar: Date.gregorianCalendar,
            timeZone: TimeZone(secondsFromGMT: hoursFromUTC * 60 * 60),
            year: year, month: month, day: day,
            hour: hour, minute: minute, second: second,
            nanosecond: milliSecond * 1000 * 1000
        ).date!
    }
    
    init(millisecondsSince1970: Int) {
        let timeInterval = Double(millisecondsSince1970 / 1000) + Double(millisecondsSince1970 % 1000)
        self.init(timeIntervalSince1970: timeInterval)
    }
    
    func startOfDay() -> Date {
        var components = Date.gregorianCalendar.dateComponents(in: Date.utcTimeZone, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return components.date!
    }
    
    /**
     The latest time of a day in millisecond-precision, ie. 23:59:59.999.
     */
    func endOfDay() -> Date {
        var components = Date.gregorianCalendar.dateComponents(in: Date.utcTimeZone, from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        components.nanosecond = 999000000
        return components.date!
    }
    
}
