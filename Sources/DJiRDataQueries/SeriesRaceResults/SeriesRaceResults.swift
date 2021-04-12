import Foundation
import DJiRData

public struct SeriesRaceResults {
    
    // MARK: - Raw Data
    
    public let results: [Result]
    
    
    
    
    
    // MARK: - Processed Data
    
    public let raceWeek: ClosedRange<Date>
    public let trackID: Int
    public let raceDays: [RaceDay]
    
    
    
    
    
    // MARK: - Types
    
    public struct Result {
        public let startTime: Date
        public let carClassID: Int
        public let trackID: Int
        public let sessionID: Int
        public let subSessionID: Int
        public let officialSession: Bool
        public let sizeOfField: Int
        public let strengthOfField: Int
        
        // TODO: Create Decoder for decoding dictionaries to models
        
        enum CodingKeys: String, CodingKey {
            case startTime = "1"
            case carClassID = "2"
            case trackID = "3"
            case sessionID = "4"
            case subSessionID = "5"
            case officialSession = "6"
            case sizeOfField = "7"
            case strengthOfField = "8"
        }
        
        init(result: [String: JSONGenericModel.Value]) throws {
            guard let startTimeValue = result["1"],
                  let startTimeIntegerValue = startTimeValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "1")
            }
            startTime = Date(millisecondsSince1970: startTimeIntegerValue)
            
            guard let carClassIDValue = result["2"],
                  let carClassIDIntegerValue = carClassIDValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "2")
            }
            carClassID = carClassIDIntegerValue
            
            guard let trackIDValue = result["3"],
                  let trackIDIntegerValue = trackIDValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "3")
            }
            trackID = trackIDIntegerValue
            
            guard let sessionIDValue = result["4"],
                  let sessionIDIntegerValue = sessionIDValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "4")
            }
            sessionID = sessionIDIntegerValue
            
            guard let subSessionIDValue = result["5"],
                  let subSessionIDIntegerValue = subSessionIDValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "5")
            }
            subSessionID = subSessionIDIntegerValue
            
            guard let officialSessionValue = result["6"],
                  let officialSessionIntegerValue = officialSessionValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "6")
            }
            officialSession = officialSessionIntegerValue != 0
            
            guard let sizeOfFieldValue = result["7"],
                  let sizeOfFieldIntegerValue = sizeOfFieldValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "7")
            }
            sizeOfField = sizeOfFieldIntegerValue
            
            guard let strengthOfFieldValue = result["8"],
                  let strengthOfFieldIntegerValue = strengthOfFieldValue.intValue else {
                throw Error.failedToConvertValueForKey(key: "8")
            }
            strengthOfField = strengthOfFieldIntegerValue
        }
    }
    
    public struct RaceDay {
        public let date: Date
        public let sessions: [RaceSession]
        
        static func empty() -> RaceDay {
            RaceDay(date: Date(timeIntervalSince1970: 0), sessions: [])
        }
    }
    
    public struct RaceSession {
        public let startTime: Date
        public let isOfficial: Bool
        public let sizeOfField: Int
        public let weightedAverageSoF: Int
        public let splits: [Split]
        
        /**
         Initializes a RaceSession with the results for each class of all sub-sessions
         
         - Parameter results: An array of Result, one for each car-class of all sub-sessions.
         
         - Instead of throwing errors, reasonable fallbacks are chosen in case of an empty array as argument.
         - The start-time and whether the session was official is taken from the first result.
         - The overall strength of field is a weighted average according to participation and SoF in each class.
         */
        init(results: [Result]) {
            guard let firstResult = results.first else {
                self.init(); return
            }
            
            var subsessionToCarClassResults: [Int: [Result]] = [:]
            results.forEach {
                subsessionToCarClassResults.appendElement($0, key: $0.subSessionID)
            }
            
            let overallSizeOfField = results.reduce(0, { $0 + $1.sizeOfField })
            let overallSizeDouble = Double(overallSizeOfField)
            let weightedAverageSoF = results.reduce(0.0) {
                $0 + (Double($1.strengthOfField) / overallSizeDouble) * Double($1.sizeOfField)
            }
            
            self.init(
                startTime: firstResult.startTime,
                isOfficial: firstResult.officialSession,
                sizeOfField: overallSizeOfField,
                weightedAverageSoF: Int(weightedAverageSoF),
                splits: subsessionToCarClassResults.map { Split(results: $0.value) }.sorted { $0.subsessionID < $1.subsessionID }
            )
        }
        
        private init(
            startTime: Date = Date(timeIntervalSince1970: 0),
            isOfficial: Bool = false,
            sizeOfField: Int = 0,
            weightedAverageSoF: Int = 0,
            splits: [Split] = []
        ) {
            self.startTime = startTime
            self.isOfficial = isOfficial
            self.sizeOfField = sizeOfField
            self.weightedAverageSoF = weightedAverageSoF
            self.splits = splits
        }
    }
    
    public struct Split {
        public let subsessionID: Int
        public let sizeOfField: Int
        public let weightedAverageSoF: Int
        public let classes: Set<CarClass>
        
        /**
         Initializes a Split with the results for each car-class
         
         - Parameter results: An array of Result, one for each car-class.
         
         - Instead of throwing errors, reasonable fallbacks are chosen in case of an empty array as argument.
         */
        init(results: [Result]) {
            guard let firstResult = results.first else {
                self.init(); return
            }
            
            let overallSizeOfField = results.reduce(0, { $0 + $1.sizeOfField })
            let overallSizeDouble = Double(overallSizeOfField)
            let weightedAverageSoF = results.reduce(0.0) {
                $0 + (Double($1.strengthOfField) / overallSizeDouble) * Double($1.sizeOfField)
            }
            
            self.init(
                subsessionID: firstResult.subSessionID,
                sizeOfField: overallSizeOfField,
                weightedAverageSoF: Int(weightedAverageSoF),
                classes: Set(results.map { CarClass(result: $0) })
            )
        }
        
        private init(
            subsessionID: Int = 0,
            sizeOfField: Int = 0,
            weightedAverageSoF: Int = 0,
            classes: Set<CarClass> = []
        ) {
            self.subsessionID = subsessionID
            self.sizeOfField = sizeOfField
            self.weightedAverageSoF = weightedAverageSoF
            self.classes = classes
        }
    }
    
    /**
     Hashable and Equatable are limited to the ID. So 2 CarClass-values from different sessions, which have the same ID
     are considered the same.
     */
    public struct CarClass: Hashable {
        public let ID: Int
        public let sizeOfField: Int
        public let strengthOfField: Int
        
        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.ID == rhs.ID
        }
        
        public static func !=(lhs: Self, rhs: Self) -> Bool {
            lhs.ID != rhs.ID
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ID)
        }
        
        init(result: Result) {
            ID = result.carClassID
            sizeOfField = result.sizeOfField
            strengthOfField = result.strengthOfField
        }
    }
    
    
    
    
    
    // MARK: - Internal API
    
    init(jsonGeneric: JSONGenericModel) throws {
        results = try jsonGeneric.d.map {
            try Result(result: $0)
        }
        
        guard results.count > 0 else {
            throw Error.resultsAreEmpty
        }
        
        let sortedWeek = results.sorted { $0.startTime < $1.startTime }
        guard let firstSession = sortedWeek.first,
              let lastSession = sortedWeek.last
        else {
            throw Error.failedToDetermineStartAndEndOfRaceWeek
        }
        
        guard results.allSatisfy({ $0.trackID == firstSession.trackID }) else {
            throw Error.assertionFailed(description: "All sessions are expected to have the same track-ID!")
        }
        trackID = firstSession.trackID
        
        let startOfWeek = firstSession.startTime.startOfDay()
        let endOfWeek = lastSession.startTime.endOfDay()
        raceWeek = startOfWeek...endOfWeek
        
        raceDays = SeriesRaceResults.createRaceDaysFromResults(results)
    }
    
    private static func createRaceDaysFromResults(_ results: [Result]) -> [RaceDay] {
        let raceDayToSessionIDs = createRaceDayToSessionIDs(results)
        
        return raceDayToSessionIDs.keys.map { raceDayDate -> RaceDay in
            guard let sessionIDs = raceDayToSessionIDs[raceDayDate] else { return RaceDay.empty() }
            let raceSessions = createRaceSessionsForSessionIDs(results: results, sessionIDs: sessionIDs)
            return RaceDay(date: raceDayDate, sessions: raceSessions)
        }.sorted { $0.date < $1.date }
    }
    
    private static func createRaceDayToSessionIDs(_ results: [Result]) -> [Date: Set<Int>] {
        var raceDayToSessionIDs: [Date: Set<Int>] = [:]
        results.forEach {
            let raceDay = $0.startTime.startOfDay()
            raceDayToSessionIDs.insertElement($0.sessionID, key: raceDay)
        }
        return raceDayToSessionIDs
    }
    
    private static func createRaceSessionsForSessionIDs(results: [Result], sessionIDs: Set<Int>) -> [RaceSession] {
        return sessionIDs.map { sessionID -> RaceSession in
            let subSessions = results.filter { result in result.sessionID == sessionID }
            return RaceSession(results: subSessions)
        }.sorted { $0.startTime < $1.startTime }
    }
    
    enum Error: Swift.Error {
        case failedToConvertValueForKey(key: String)
        case resultsAreEmpty
        case failedToDetermineStartAndEndOfRaceWeek
        case assertionFailed(description: String)
    }
    
}
