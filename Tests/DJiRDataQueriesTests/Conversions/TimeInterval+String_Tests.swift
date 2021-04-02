import XCTest
@testable import DJiRDataQueries
import Foundation

class TimeIntervalStringTests: XCTestCase {
    
    // MARK: - Init With Valid Cases
    
    func testFromIRacingCSVTimeString_MilliSecondsOnly() {
        let timeString = "12" // 12 milliseconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 0.012)
    }
    
    func testFromIRacingCSVTimeString_NegativeMilliSecondsOnly() {
        let timeString = "-12" // 12 milliseconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, -0.012)
    }
    
    func testFromIRacingCSVTimeString_SingleDigitSeconds() {
        let timeString = "1.234" // 1.234 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 1.234)
    }
    
    func testFromIRacingCSVTimeString_DoubleDigitSeconds() {
        let timeString = "12.345" // 12.345 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 12.345)
    }
    
    func testFromIRacingCSVTimeString_NegativeSingleDigitSeconds() {
        let timeString = "-1.234" // -1.234 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, -1.234)
    }
    
    func testFromIRacingCSVTimeString_NegativeDoubleDigitSeconds() {
        let timeString = "-12.345" // -12.345 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, -12.345)
    }
    
    func testFromIRacingCSVTimeString_SingleDigitMinutes() {
        let timeString = "1:23.456" // 1 minute, 23.456 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 60.0 + 23.456)
    }
    
    func testFromIRacingCSVTimeString_DoubleDigitMinutes() {
        let timeString = "12:34.567" // 12 minutes, 34.567 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 12 * 60.0 + 34.567)
    }
    
    func testFromIRacingCSVTimeString_NegativeSingleDigitMinutes() {
        let timeString = "-1:23.456" // 1 minute, 23.456 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, -60.0 - 23.456)
    }
    
    func testFromIRacingCSVTimeString_NegativeDoubleDigitMinutes() {
        let timeString = "-12:34.567" // 12 minutes, 34.567 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, -12 * 60.0 - 34.567)
    }
    
    
    
    
    
    // MARK: - Init With Special Cases
    
    func testFromIRacingCSVTimeString_Zero() {
        // If no laps were driven, the averag laptime can have the string "0".
        let timeString = "0"
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval, 0)
    }
    
    
    
    
    
    // MARK: - Init With Invalid Cases
    
    func testFromIRacingCSVTimeString_MinutesWithNegativeSeconds() {
        let timeString = "1:-23.456"
        
        XCTAssertNil(TimeInterval(iRacingCSVTimeString: timeString))
    }
    
    func testFromIRacingCSVTimeString_MinutesWithMoreThan60Seconds() {
        let timeString = "1:234.567"
        
        XCTAssertNil(TimeInterval(iRacingCSVTimeString: timeString))
    }
    
    func testFromIRacingCSVTimeString_InvalidMillisSeparator() {
        let timeString = "1,234"
        
        XCTAssertNil(TimeInterval(iRacingCSVTimeString: timeString))
    }
    
    func testFromIRacingCSVTimeString_MinutesWithInvalidMillisSeparator() {
        let timeString = "1:23,456"
        
        XCTAssertNil(TimeInterval(iRacingCSVTimeString: timeString))
    }
    
    func testFromIRacingCSVTimeString_InvalidMinutesSeparator() {
        let timeString = "1m23.456"
        
        XCTAssertNil(TimeInterval(iRacingCSVTimeString: timeString))
    }
    
    
    
    
    
    // MARK: - Lap-Time-String
    
    func testLapTimeString_MilliSecondsOnly() {
        let timeString = "12" // 12 milliseconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "0.012")
    }
    
    func testLapTimeString_NegativeMilliSecondsOnly() {
        let timeString = "-12" // 12 milliseconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "-0.012")
    }
    
    func testLapTimeString_SingleDigitSeconds() {
        let timeString = "1.234" // 1.234 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "1.234")
    }
    
    func testLapTimeString_DoubleDigitSeconds() {
        let timeString = "12.345" // 12.345 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "12.345")
    }
    
    func testLapTimeString_NegativeSingleDigitSeconds() {
        let timeString = "-1.234" // -1.234 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "-1.234")
    }
    
    func testLapTimeString_NegativeDoubleDigitSeconds() {
        let timeString = "-12.345" // -12.345 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "-12.345")
    }
    
    func testLapTimeString_SingleDigitMinutes() {
        let timeString = "1:23.456" // 1 minute, 23.456 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "1:23.456")
    }
    
    func testLapTimeString_DoubleDigitMinutes() {
        let timeString = "12:34.567" // 12 minutes, 34.567 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "12:34.567")
    }
    
    func testLapTimeString_NegativeSingleDigitMinutes() {
        let timeString = "-1:23.456" // 1 minute, 23.456 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "-1:23.456")
    }
    
    func testLapTimeString_NegativeDoubleDigitMinutes() {
        let timeString = "-12:34.567" // 12 minutes, 34.567 seconds
        
        let timeInterval = TimeInterval(iRacingCSVTimeString: timeString)
        
        XCTAssertEqual(timeInterval?.lapTimeString, "-12:34.567")
    }
    
}
