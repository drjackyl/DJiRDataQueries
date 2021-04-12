import XCTest
@testable import DJiRDataQueries
import Foundation

class DateTests: XCTestCase {
    
    func test_Init_MillisecondsSince1970() {
        // Thu Mar 18 2021 16:45:00
        let time = 1616085900000
        let expectedDate = Date(year: 2021, month: 3, day: 18, hour: 16, minute: 45, second: 0)
        
        let date = Date(millisecondsSince1970: time)
        
        XCTAssertEqual(date, expectedDate)
    }
}
