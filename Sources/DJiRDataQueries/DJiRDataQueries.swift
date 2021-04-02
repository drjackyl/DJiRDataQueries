import Foundation
import DJiRData

public class DJiRDataQueries {
    
    public init() {}
    
    public func createEventResultFromCSVData(_ data: Data) throws -> EventResult {
        do {
            let csvEventResult = try djIRData.createCSVEventResultFromData(data)
            return try EventResult(csvEventResult: csvEventResult)
        } catch let error {
            throw Error.failedToCreateEventResult(underlyingError: error)
        }
    }
    
    public enum Error: Swift.Error {
        case failedToCreateEventResult(underlyingError: Swift.Error)
    }
    
    
    
    
    
    // MARK: - Private
    
    private let djIRData: DJiRData = .init()
}
