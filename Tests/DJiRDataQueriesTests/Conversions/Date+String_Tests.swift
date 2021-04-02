import XCTest
@testable import DJiRDataQueries
import Foundation

class DateStringTests: XCTestCase {
    
    func testFromDateString_AtMorning() {
        let dateString = "2021.03.08 12:45 AM GMT"
        let expectedDate = Date(year: 2021, month: 3, day: 8, hour: 0, minute: 45, second: 0)
        
        let date = Date(iRacingCSVDateString: dateString)
        
        XCTAssertEqual(date, expectedDate)
    }
    
    func testFromDateString_PostMorning() {
        let dateString = "2021.03.08 12:45 PM GMT"
        let expectedDate = Date(year: 2021, month: 3, day: 8, hour: 12, minute: 45, second: 0)
        
        let date = Date(iRacingCSVDateString: dateString)
        
        XCTAssertEqual(date, expectedDate)
    }
    
    func testFromDateString_SingleDigitHour() {
        let dateString = "2021.03.08 2:45 AM GMT"
        let expectedDate = Date(year: 2021, month: 3, day: 8, hour: 2, minute: 45, second: 0)
        
        let date = Date(iRacingCSVDateString: dateString)
        
        XCTAssertEqual(date, expectedDate)
    }
    
}
