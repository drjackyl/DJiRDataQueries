import Foundation

enum Formatters {
    
    static let csvEventResultDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'.'MM'.'dd' 'h':'mm' 'a' 'zzz"
        return dateFormatter
    }()
    
}
