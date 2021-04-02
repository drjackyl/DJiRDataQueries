import Foundation

extension Date {
    
    private static let gregorianCalendar = Calendar(identifier: .gregorian)
    private static let utcTimeZone = TimeZone(secondsFromGMT: 0)
    
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, hoursFromUTC: Int = 0) {
        self = DateComponents(
            calendar: Date.gregorianCalendar,
            timeZone: Date.utcTimeZone,
            year: year, month: month, day: day,
            hour: hour, minute: minute, second: second
        ).date!
    }
    
}
