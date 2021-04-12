import XCTest
@testable import DJiRDataQueries
import Foundation
import DJiRDataTestResources

class SeriesRaceResultsTests: XCTestCase {

    func testSeriesRaceResults() throws {
        let data = DJiRDataTestResources
            .JSONGenericModel
            .SeriesRaceResults_IMSA2021s2w1
            .load()

        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.results.count, 640)
        XCTAssertEqual(results.results[0].startTime, Date(year: 2021, month: 3, day: 18, hour: 16, minute: 45, second: 0))
        XCTAssertEqual(results.results[0].carClassID, 2523)
        XCTAssertEqual(results.results[0].trackID, 250)
        XCTAssertEqual(results.results[0].sessionID, 148558449)
        XCTAssertEqual(results.results[0].subSessionID, 37918032)
        XCTAssertEqual(results.results[0].officialSession, true)
        XCTAssertEqual(results.results[0].sizeOfField, 12)
        XCTAssertEqual(results.results[0].strengthOfField, 3986)
    }
    
    func testSeriesRaceResults_RaceWeek() throws {
        let data = DJiRDataTestResources
            .JSONGenericModel
            .SeriesRaceResults_IMSA2021s2w1
            .load()
        
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.raceWeek.lowerBound, Date(year: 2021, month: 3, day: 16, hour: 0, minute: 0, second: 0))
        XCTAssertEqual(results.raceWeek.upperBound, Date(year: 2021, month: 3, day: 22, hour: 23, minute: 59, second: 59, milliSecond: 999))
    }

    func testSeriesRaceResults_TrackID() throws {
        let data = DJiRDataTestResources
            .JSONGenericModel
            .SeriesRaceResults_IMSA2021s2w1
            .load()
        
        let results = try DJiRDataQueries().createSeriesRaceResultsFromJSONData(data)
        
        XCTAssertEqual(results.trackID, 250)
    }
    
    func testSeriesRaceResults_RaceDays() throws {
        let data = DJiRDataTestResources
            .JSONGenericModel
            .SeriesRaceResults_IMSA2021s2w1
            .load()
        
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
        
        print(
            results.raceDays.map { raceDay in
                """
                \(raceDay.date): \(raceDay.sessions.count) sessions:
                \(raceDay.sessions.map { session in
                    """
                        \(session.startTime): \(session.splits.count) splits with \(session.sizeOfField) cars (SoF: \(session.weightedAverageSoF))
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
}
