import Foundation

extension Date {
    
    /**
     Initializes a Date with a date-string of the format "yyyy.MM.dd h:mm a zzz"
     
     ## Format
     
     This format is used for the CSV-exports of event-results:
     
     - The hour is not zero-padded.
     - Example: "2021.03.08 2:45 PM GMT"
     */
    init?(iRacingCSVDateString: String) {
        guard let date = Formatters.csvEventResultDate.date(from: iRacingCSVDateString) else { return nil }
        self = date
    }
    
}
