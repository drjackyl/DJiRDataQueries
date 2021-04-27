import XCTest
@testable import DJiRDataQueries
import Foundation
import DJiRDataTestResources

class SeriesRaceResultsTests: XCTestCase {
    
    let data: Data = {
        DJiRDataTestResources
            .JSONGenericModel
            .SeriesRaceResults_IMSA2021s2w1
            .load()
    }()

    func testSeriesRaceResults() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.sessions.count, 640)
        XCTAssertEqual(results.sessions[0].startTime, Date(year: 2021, month: 3, day: 18, hour: 16, minute: 45, second: 0))
        XCTAssertEqual(results.sessions[0].carClassID, 2523)
        XCTAssertEqual(results.sessions[0].trackID, 250)
        XCTAssertEqual(results.sessions[0].sessionID, 148558449)
        XCTAssertEqual(results.sessions[0].subSessionID, 37918032)
        XCTAssertEqual(results.sessions[0].officialSession, true)
        XCTAssertEqual(results.sessions[0].sizeOfField, 12)
        XCTAssertEqual(results.sessions[0].strengthOfField, 3986)
    }
    
    func testSeriesRaceResults_RaceWeek() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.raceWeek.lowerBound, Date(year: 2021, month: 3, day: 16, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceWeek.upperBound, Date(year: 2021, month: 3, day: 22, hour: 23, minute: 59, second: 59, milliSecond: 999))
    }

    func testSeriesRaceResults_TrackID() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.trackID, 250)
    }
    
    func testSeriesRaceResults_RaceDays() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.raceDays.count, 7)
        guard results.raceDays.count == 7 else { return }
        
        XCTAssertEqual(results.raceDays[0].date, Date(year: 2021, month: 3, day: 16, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[1].date, Date(year: 2021, month: 3, day: 17, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[2].date, Date(year: 2021, month: 3, day: 18, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[3].date, Date(year: 2021, month: 3, day: 19, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[4].date, Date(year: 2021, month: 3, day: 20, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[5].date, Date(year: 2021, month: 3, day: 21, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceDays[6].date, Date(year: 2021, month: 3, day: 22, hour: 0, minute: 0, second: 0))
        
        XCTAssertEqual(results.raceDays[0].sessions.count, 12)
        XCTAssertEqual(results.raceDays[0].sessions[0].sizeOfField, 104)
        
        XCTAssertEqual(results.raceDays[0].sessions[0].splits.count, 3)
        XCTAssertEqual(results.raceDays[0].sessions[0].splits[0].sizeOfField, 35)
        
        XCTAssertEqual(results.raceDays[0].sessions[0].splits[0].classes.count, 3)
        
        // For keepsies
        print(
            results.raceDays.map { raceDay in
                """
                \(raceDay.date): \(raceDay.sessions.count) sessions:
                \(raceDay.sessions.map { session in
                    """
                        \(session.startTime): \(session.splits.count) splits with \(session.sizeOfField) cars (SoF: \(session.weightedAverageSoF), ID: \(session.sessionID))
                    \(session.splits.map { split in
                            """
                                    \(split.subsessionID) (\(split.weightedAverageSoF)): \(split.classes.map { carClass in "Class \(carClass.ID): \(carClass.sizeOfField) cars (SoF: \(carClass.strengthOfField))" }.joined(separator: ", "))
                            """
                        }.joined(separator: "\n"))
                    """
                }.joined(separator: "\n"))
                """
            }.joined(separator: "\n")
        )
    }
    
    func testSeriesRaceResults_RaceSession() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        guard let session = results.raceDays.last?.sessions.first else {
            XCTFail("Expected session was not present in data"); return
        }
        
        XCTAssertEqual(session.sessionID, 148778903)
        XCTAssertEqual(session.startTime, Date(year: 2021, month: 3, day: 22, hour: 0, minute: 45, second: 0, hoursFromUTC: 0))
        XCTAssertEqual(session.isOfficial, true)
        
        let expectedNumberOfCars = 12 + 6 + 12 + 12 + 5 + 12 + 29
        XCTAssertEqual(session.sizeOfField, expectedNumberOfCars)
        
        let numberOfCars = Double(expectedNumberOfCars)
        var expectedAverage = 2848.0 * (12.0 / numberOfCars)
        expectedAverage += 2390.0 * (6.0 / numberOfCars)
        expectedAverage += 2879.0 * (12.0 / numberOfCars)
        expectedAverage += 1832 * (12.0 / numberOfCars)
        expectedAverage += 1044 * (5.0 / numberOfCars)
        expectedAverage += 1480 * (12.0 / numberOfCars)
        expectedAverage += 1178 * (29.0 / numberOfCars)
        XCTAssertEqual(session.weightedAverageSoF, Int(expectedAverage))
        
        XCTAssertEqual(session.splits.count, 3)
    }
    
    func testSeriesRaceResults_Split() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        guard let split = results.raceDays.last?.sessions.first?.splits.first else {
            XCTFail("Expected split was not present in data"); return
        }
        
        XCTAssertEqual(split.subsessionID, 37972293)
        
        let expectedNumberOfCars = 6 + 12 + 12
        XCTAssertEqual(split.sizeOfField, expectedNumberOfCars)
        
        let numberOfCars = Double(expectedNumberOfCars)
        var expectedAverage = 2390 * (6.0 / numberOfCars)
        expectedAverage += 2879 * (12.0 / numberOfCars)
        expectedAverage += 2848 * (12.0 / numberOfCars)
        XCTAssertEqual(split.weightedAverageSoF, Int(expectedAverage))
        
        XCTAssertEqual(split.classes.count, 3)
    }
    
    func testSeriesRaceResults_CarClass() throws {
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        guard let split = results.raceDays.last?.sessions.first?.splits.first else {
            XCTFail("Expected split was not present in data"); return
        }
        
        guard let lmp2 = split.classes.filter({ $0.ID == 2523 }).first,
              let gtlm = split.classes.filter({ $0.ID == 2524 }).first,
              let gtd = split.classes.filter({ $0.ID == 2709 }).first
        else {
            XCTFail("Expected classes were not present in data"); return
        }
        
        XCTAssertEqual(lmp2.sizeOfField, 12)
        XCTAssertEqual(lmp2.strengthOfField, 2879)
        
        XCTAssertEqual(gtlm.sizeOfField, 12)
        XCTAssertEqual(gtlm.strengthOfField, 2848)
        
        XCTAssertEqual(gtd.sizeOfField, 6)
        XCTAssertEqual(gtd.strengthOfField, 2390)
    }
}
