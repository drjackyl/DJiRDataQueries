import Foundation
import DJiRData

public struct EventResult {
    
    // MARK: - Raw Data
    
    public let summary: Summary
    public let results: [Result]
    
    
    
    
    
    // MARK: - Processed Data
    
    public let resultsOfDrivers: [Result]
    public let resultsOfTeams: [Result]
    public let isTeamEvent: Bool
    
    /**
     A list of car-classes in the session.
     
     This list might not contain all car-classes in the series. It only reflects the car-classes, that were present in the session.
     */
    public let carClasses: Set<CarClass>
    
    /**
     A list of cars in the session.
     
     This list might not contain all cars in the series. It only reflects the cars, that were present in the session.
     */
    public let cars: Set<Car>
    
    /**
     Based on the number of car-classes in the session.
     
     The value could be `false` for a multi-class-event, if only one car-class was present in the session.
     */
    public let isMultiClassEvent: Bool
    
    
    
    
    
    
    // MARK: - Types
    
    public struct Summary {
        init(summary: CSVEventResult.Summary) throws {
            csv = summary
            
            guard let startTime = Date(iRacingCSVDateString: summary.startTime) else {
                throw Error.failedToConvertSummaryStartDate(csvValue: summary.startTime)
            }
            self.startTime = startTime
        }
        
        public let csv: CSVEventResult.Summary
        
        public var startTime: Date
        public var track: String { csv.track }
        public var series: String { csv.series }
        public var seasonYear: Int { csv.seasonYear }
        public var seasonQuarter: Int { csv.seasonQuarter }
        public var rookieSeason: String { csv.rookieSeason }
        public var raceWeek: Int { csv.raceWeek }
        public var strengthOfField: Int { csv.strengthOfField }
        public var specialEventType: String? { csv.specialEventType }
    }
    
    public struct Result {
        init(result: CSVEventResult.Result, overallLaps: Int) {
            self.csv = result
            
            interval = Interval(result: result, overallLaps: overallLaps)
            qualifyTime = TimeInterval(iRacingCSVTimeString: result.qualifyTime)
            // When no laps were driven, averageLapTime is "0".
            averageLapTime = result.averageLapTime != "0" ? TimeInterval(iRacingCSVTimeString: result.averageLapTime) : nil
            fastestLapTime = TimeInterval(iRacingCSVTimeString: result.fastestLapTime)
            
            iRatingDifference = (csv.newiRating ?? 0) - (csv.oldiRating ?? 0)
            licenseSubLevelDifference = (csv.newLicenseSubLevel ?? 0) - (csv.oldLicenseSubLevel ?? 0)
        }
        
        public let csv: CSVEventResult.Result
        
        public var finPos: Int { csv.finPos }
        public var carID: Int { csv.carID }
        public var car: String { csv.car }
        public var carClassID: Int { csv.carClassID }
        public var carClass: String { csv.carClass }
        public var teamID: Int { csv.teamID }
        public var customerID: Int { csv.customerID }
        public var name: String { csv.name }
        public var startPos: Int { csv.startPos }
        public var carNo: Int { csv.carNo }
        public var outID: Int { csv.outID }
        public var out: String { csv.out }
        public let interval: Interval
        public var lapsLed: Int { csv.lapsLed }
        public let qualifyTime: TimeInterval?
        public let averageLapTime: TimeInterval?
        public let fastestLapTime: TimeInterval?
        public var fastestLapNo: Int? { csv.fastestLapNo }
        public var lapsCompleted: Int { csv.lapsCompleted }
        public var inc: Int { csv.inc }
        public var pts: Int { csv.pts }
        public var clubPts: Int { csv.clubPts }
        public var div: Int { csv.div }
        public var clubID: Int? { csv.clubID }
        public var club: String { csv.club }
        public var oldiRating: Int? { csv.oldiRating }
        public var newiRating: Int? { csv.newiRating }
        public let iRatingDifference: Int
        public var oldLicenseLevel: Int? { csv.oldLicenseLevel }
        public var oldLicenseSubLevel: Int? { csv.oldLicenseSubLevel }
        public var newLicenseLevel: Int? { csv.newLicenseLevel }
        public var newLicenseSubLevel: Int? { csv.newLicenseSubLevel }
        public let licenseSubLevelDifference: Int
        public var seriesName: String { csv.seriesName }
        public var maxFuelFillPercentage: Int { csv.maxFuelFillPercentage }
        public var weightPenaltyInKg: Int { csv.weightPenaltyInKg }
        public var aggPts: Int { csv.aggPts }
        
        public struct Interval {
            init(result: CSVEventResult.Result, overallLaps: Int) {
                sameLap = TimeInterval(iRacingCSVTimeString: result.interval)
                
                // In case of team-results, the interval-field in the CSV contains a "-" for a driver's result. As,
                // in a driver's result, lapsCompleted reflects the number of laps the driver completed, the calculation
                // would be wrong.
                if result.interval == "-" {
                    lapsDown = nil
                } else {
                    lapsDown = result.lapsCompleted - overallLaps
                }
            }
            
            let sameLap: TimeInterval?
            let lapsDown: Int?
        }
    }
    
    public struct Car: Hashable {
        public let name: String
        public let ID: Int
        public let classID: Int
        
        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.ID == rhs.ID && lhs.classID == rhs.classID
        }
        
        public static func !=(lhs: Self, rhs: Self) -> Bool {
            lhs.ID != rhs.ID || lhs.classID != rhs.classID
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ID)
            hasher.combine(classID)
        }
        
        init(name: String, ID: Int, classID: Int) {
            self.name = name
            self.ID = ID
            self.classID = classID
        }
        
        init(_ result: Result) {
            name = result.car
            ID = result.carID
            classID = result.carClassID
        }
    }
    
    /**
     Hashable and Equatable are limited to the ID, since the cars in the class are considered static for an ID.
     */
    public struct CarClass: Hashable {
        public let name: String
        public let ID: Int
        public let cars: Set<Car>
        
        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.ID == rhs.ID
        }
        
        public static func !=(lhs: Self, rhs: Self) -> Bool {
            lhs.ID != rhs.ID
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ID)
        }
    }
    
    
    
    
    
    // MARK: Internal API
    
    init(csvEventResult: CSVEventResult) throws {
        // Raw Data
        summary = try Summary(summary: csvEventResult.summary)
        let overallLaps = csvEventResult.results[0].lapsCompleted
        results = csvEventResult.results.map {
            Result(result: $0, overallLaps: overallLaps)
        }
        
        // Processed Data
        resultsOfTeams = results.filter { $0.isTeamEntry }
        resultsOfDrivers = results.filter { $0.isDriverEntry }
        isTeamEvent = !resultsOfTeams.isEmpty
        carClasses = results.getCarClassesInSession()
        cars = carClasses.flatMap { $0.cars }.toSet()
        isMultiClassEvent = carClasses.count > 1
    }
    
    enum Error: Swift.Error {
        case failedToConvertSummaryStartDate(csvValue: String)
    }
    
}
