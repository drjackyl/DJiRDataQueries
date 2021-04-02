import XCTest
@testable import DJiRDataQueries
import DJiRDataTestResources
import Foundation

class DJiRDataQueriesEventResultTests: XCTestCase {
    
    // MARK: - Regular Data
    
    func test_Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Practice() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Practice
            .load()
        
        do {
            let eventResult = try DJiRDataQueries().createEventResultFromCSVData(data)
            XCTAssertEqual(eventResult.summary.startTime, Date(year: 2021, month: 3, day: 8, hour: 0, minute: 45, second: 0))
            XCTAssertNil(eventResult.results[0].fastestLapTime)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Qualify() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Qualify
            .load()
        
        do {
            let eventResult = try DJiRDataQueries().createEventResultFromCSVData(data)
            XCTAssertEqual(eventResult.summary.startTime, Date(year: 2021, month: 3, day: 8, hour: 0, minute: 45, second: 0))
            XCTAssertEqual(eventResult.results[1].interval.sameLap, -0.012)
            XCTAssertEqual(eventResult.results[1].interval.lapsDown, 0)
            XCTAssertEqual(eventResult.results[1].fastestLapTime, 45.594)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Race() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Oval_NoTeam_SingleClass_NoClubPoints_NoDivision_LapTimeLessThan1Minute_Unofficial_Race
            .load()
        
        do {
            let eventResult = try DJiRDataQueries().createEventResultFromCSVData(data)
            XCTAssertEqual(eventResult.summary.startTime, Date(year: 2021, month: 3, day: 8, hour: 0, minute: 45, second: 0))
            XCTAssertEqual(eventResult.results[2].interval.sameLap, -0.189)
            XCTAssertEqual(eventResult.results[2].interval.lapsDown, 0)
            XCTAssertEqual(eventResult.results[2].fastestLapTime, 43.747)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_MultiClass_Practice() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_MultiClass_Practice
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_MultiClass_Qualify() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_MultiClass_Qualify
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_MultiClass_Race() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_MultiClass_Race
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_SingleClass_Practice() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_SingleClass_Practice
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_SingleClass_Qualify() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_SingleClass_Qualify
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_NoTeam_SingleClass_Race() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_SingleClass_Race
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_MultiClass_Practice() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Practice
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_MultiClass_Qualify() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Qualify
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_MultiClass_Race() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        do {
            let eventResult = try DJiRDataQueries().createEventResultFromCSVData(data)
            XCTAssertEqual(eventResult.results[0].interval.sameLap, 0)
            XCTAssertEqual(eventResult.results[0].interval.lapsDown, 0)
            XCTAssertEqual(eventResult.results[0].averageLapTime, 3 * 60 + 15.922)
            XCTAssertEqual(eventResult.results[3].interval.sameLap, -1 * 60 - 44.948)
            XCTAssertEqual(eventResult.results[3].interval.lapsDown, 0)
            XCTAssertNil(eventResult.results[121].interval.sameLap)
            XCTAssertEqual(eventResult.results[121].interval.lapsDown, -78)
            XCTAssertNil(eventResult.results[122].interval.sameLap)
            XCTAssertNil(eventResult.results[122].interval.lapsDown)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_SingleClass_NoClubPoints_NoDivision_Practice() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_SingleClass_NoClubPoints_NoDivision_Practice
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_SingleClass_NoClubPoints_NoDivision_Qualify() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_SingleClass_NoClubPoints_NoDivision_Qualify
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }

    func test_Road_Team_SingleClass_NoClubPoints_NoDivision_Race() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_SingleClass_NoClubPoints_NoDivision_Race
            .load()
        
        do {
            _ = try DJiRDataQueries().createEventResultFromCSVData(data)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
    // MARK: - Erronous Data
    
    func testEmptyData() {
        XCTAssertThrowsError(try DJiRDataQueries().createEventResultFromCSVData(Data())) { error in
            guard case DJiRDataQueries.Error.failedToCreateEventResult = error else {
                XCTFail("Unexpected error was thrown: \(error)"); return
            }
        }
    }
    
    func testDividerOnly() {
        let data = "\n\n".data(using: .ascii)!
        
        XCTAssertThrowsError(try DJiRDataQueries().createEventResultFromCSVData(data)) { error in
            guard case DJiRDataQueries.Error.failedToCreateEventResult = error else {
                XCTFail("Unexpected error was thrown: \(error)"); return
            }
        }
    }
    
    func testInvalidSummaryData() {
        let data = DJiRDataTestResources.CSVEventResult.InvalidSummary.load()
        
        XCTAssertThrowsError(try DJiRDataQueries().createEventResultFromCSVData(data)) { error in
            guard case DJiRDataQueries.Error.failedToCreateEventResult = error else {
                XCTFail("Unexpected error was thrown: \(error)"); return
            }
        }
    }
    
    func testInvalidResultData() {
        let data = DJiRDataTestResources.CSVEventResult.InvalidResults.load()
        
        XCTAssertThrowsError(try DJiRDataQueries().createEventResultFromCSVData(data)) { error in
            guard case DJiRDataQueries.Error.failedToCreateEventResult = error else {
                XCTFail("Unexpected error was thrown: \(error)"); return
            }
        }
    }
}
