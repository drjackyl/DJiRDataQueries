extension EventResult {
    
    // MARK: - Get Drivers
    
    public func getDriver(_ name: String) -> EventResult.Result? {
        resultsOfDrivers.first { $0.name == name }
    }
    
    public func getDriversOfTeam(_ team: EventResult.Result) -> [EventResult.Result] {
        guard team.isTeamEntry else { return [] }
        return resultsOfDrivers.filter { $0.teamID == team.teamID }
    }
    
    public func getDriversInClass(_ carClass: EventResult.CarClass) -> [EventResult.Result] {
        resultsOfDrivers.filter {
            $0.carClassID == carClass.ID
        }
    }
    
    public func getDriverOfFastestLap(inClass carClass: EventResult.CarClass? = nil) -> EventResult.Result? {
        let drivers: [EventResult.Result]
        if let carClass = carClass {
            drivers = getDriversInClass(carClass)
        } else {
            drivers = resultsOfDrivers
        }
        
        return drivers.sorted { l, r in
            guard let left = l.fastestLapTime,
                  let right = r.fastestLapTime
            else { return false }
            return left < right
        }.first
    }
    
    
    
    
    
    // MARK: Get Teams
    
    public func getTeam(_ name: String) -> EventResult.Result? {
        resultsOfTeams.first { $0.name == name }
    }
    
    public func getTeamOfDriver(_ driver: EventResult.Result) -> EventResult.Result? {
        guard driver.isDriverEntry else { return nil }
        return resultsOfTeams.first(where: { $0.teamID == driver.teamID })
    }
    
    public func getTeamOfDriver(_ name: String) -> EventResult.Result? {
        guard let driver = getDriver(name) else { return nil }
        return getTeamOfDriver(driver)
    }
    
    public func getTeamsInClass(_ carClass: EventResult.CarClass) -> [EventResult.Result] {
        resultsOfTeams.filter { $0.carClassID == carClass.ID }
    }
    
    
    
    
    
    // MARK: - Get Classes
    
    public func getCarClassOfDriver(_ name: String) -> EventResult.CarClass? {
        guard let driver = getDriver(name) else { return nil }
        return EventResult.CarClass(name: driver.carClass, ID: driver.carClassID, cars: [])
    }
    
    public func getStartPositionOfTeamInItsClass(_ teamName: String) -> Int? {
        guard let team = getTeam(teamName) else { return nil }
        
        let sortedTeamsInClass = resultsOfTeams
            .filter { $0.carClassID == team.carClassID }
            .sorted { $0.startPos < $1.startPos }
        
        guard let index = sortedTeamsInClass.firstIndex(where: { $0.name == teamName }) else { return nil }
        return index + 1
    }
    
    public func getStartPositionOfDriversTeamInItsClass(_ driverName: String) -> Int? {
        guard let teamOfDriver = getTeamOfDriver(driverName) else { return nil }
        return getStartPositionOfTeamInItsClass(teamOfDriver.name)
    }
    
}
