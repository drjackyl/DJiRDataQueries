import Foundation
import DJiRData

public struct SeriesRaceResults {
    
    // MARK: - Raw Data
    
    public let sessions: [SessionInfo]
    
    
    
    
    
    // MARK: - Processed Data
    
    public let raceWeek: ClosedRange<Date>
    public let trackID: Int
    public let raceDays: [RaceDay]
    
    
    
    
    
    // MARK: - Types
    
    public struct SessionInfo {
        public let data: DJiRData.SeriesRaceResults.SessionInfo
        
        public let startTime: Date
        public var carClassID: Int { data.carClassID }
        public var trackID: Int { data.trackID }
        public var sessionID: Int { data.sessionID }
        public var subSessionID: Int { data.subSessionID }
        public let officialSession: Bool
        public var sizeOfField: Int { data.sizeOfField }
        public var strengthOfField: Int { data.strengthOfField }
        
        init(sessionInfo: DJiRData.SeriesRaceResults.SessionInfo) {
            data = sessionInfo
            startTime = Date(millisecondsSince1970: sessionInfo.startTime)
            officialSession = sessionInfo.officialSession == 1
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
        public let sessionID: Int
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
        init(results: [SessionInfo]) {
            guard let firstResult = results.first else {
                self.init(); return
            }
            
            var subsessionToCarClassResults: [Int: [SessionInfo]] = [:]
            results.forEach {
                subsessionToCarClassResults.appendElement($0, key: $0.subSessionID)
            }
            
            let overallSizeOfField = results.reduce(0, { $0 + $1.sizeOfField })
            let overallSizeDouble = Double(overallSizeOfField)
            let weightedAverageSoF = results.reduce(0.0) {
                $0 + (Double($1.strengthOfField) / overallSizeDouble) * Double($1.sizeOfField)
            }
            
            self.init(
                sessionID: firstResult.sessionID,
                startTime: firstResult.startTime,
                isOfficial: firstResult.officialSession,
                sizeOfField: overallSizeOfField,
                weightedAverageSoF: Int(weightedAverageSoF),
                splits: subsessionToCarClassResults.map { Split(results: $0.value) }.sorted { $0.subsessionID < $1.subsessionID }
            )
        }
        
        private init(
            sessionID: Int = 0,
            startTime: Date = Date(timeIntervalSince1970: 0),
            isOfficial: Bool = false,
            sizeOfField: Int = 0,
            weightedAverageSoF: Int = 0,
            splits: [Split] = []
        ) {
            self.sessionID = sessionID
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
        init(results: [SessionInfo]) {
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
        
        init(result: SessionInfo) {
            ID = result.carClassID
            sizeOfField = result.sizeOfField
            strengthOfField = result.strengthOfField
        }
    }
    
    
    
    
    
    // MARK: - Internal API
    
    init(seriesRaceResults: DJiRData.SeriesRaceResults) throws {
        sessions = seriesRaceResults.sessions.map { SessionInfo(sessionInfo: $0) }
        
        guard sessions.count > 0 else {
            throw Error.resultsAreEmpty
        }
        
        let sortedWeek = sessions.sorted { $0.startTime < $1.startTime }
        guard let firstSession = sortedWeek.first,
              let lastSession = sortedWeek.last
        else {
            throw Error.failedToDetermineStartAndEndOfRaceWeek
        }
        
        guard sessions.allSatisfy({ $0.trackID == firstSession.trackID }) else {
            throw Error.assertionFailed(description: "All sessions are expected to have the same track-ID!")
        }
        trackID = firstSession.trackID
        
        let startOfWeek = firstSession.startTime.startOfDay()
        let endOfWeek = lastSession.startTime.endOfDay()
        raceWeek = startOfWeek...endOfWeek
        
        raceDays = SeriesRaceResults.createRaceDaysFromResults(sessions)
    }
    
    private static func createRaceDaysFromResults(_ results: [SessionInfo]) -> [RaceDay] {
        let raceDayToSessionIDs = createRaceDayToSessionIDs(results)
        
        return raceDayToSessionIDs.keys.map { raceDayDate -> RaceDay in
            guard let sessionIDs = raceDayToSessionIDs[raceDayDate] else { return RaceDay.empty() }
            let raceSessions = createRaceSessionsForSessionIDs(results: results, sessionIDs: sessionIDs)
            return RaceDay(date: raceDayDate, sessions: raceSessions)
        }.sorted { $0.date < $1.date }
    }
    
    private static func createRaceDayToSessionIDs(_ results: [SessionInfo]) -> [Date: Set<Int>] {
        var raceDayToSessionIDs: [Date: Set<Int>] = [:]
        results.forEach {
            let raceDay = $0.startTime.startOfDay()
            raceDayToSessionIDs.insertElement($0.sessionID, key: raceDay)
        }
        return raceDayToSessionIDs
    }
    
    private static func createRaceSessionsForSessionIDs(results: [SessionInfo], sessionIDs: Set<Int>) -> [RaceSession] {
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
