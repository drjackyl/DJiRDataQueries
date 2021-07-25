import Foundation
import DJiRData

public class IRDataQueries {
    
    public init() {}
    
    public func createEventResultFromCSVData(_ data: Data) throws -> EventResult {
        do {
            let csvEventResult = try iRData.createCSVEventResultFromData(data)
            return try EventResult(csvEventResult: csvEventResult)
        } catch let error {
            throw Error.failedToCreateEventResult(underlyingError: error)
        }
    }
    
    public func createSeriesRaceResultsFromJSONData(_ data: Data) throws -> SeriesRaceResults {
        do {
            let seriesRaceResults = try iRData.createSeriesRaceResultsFromData(data)
            return try SeriesRaceResults(seriesRaceResults: seriesRaceResults)
        } catch let error {
            throw Error.failedToCreateSeriesRaceResults(underlyingError: error)
        }
    }
    
    public enum Error: Swift.Error {
        case failedToCreateEventResult(underlyingError: Swift.Error)
        case failedToCreateSeriesRaceResults(underlyingError: Swift.Error)
    }
    
    
    
    
    
    // MARK: - Private
    
    private let iRData: IRData = .init()
}
