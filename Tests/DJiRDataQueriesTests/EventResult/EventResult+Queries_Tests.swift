import XCTest
@testable import DJiRDataQueries
import DJiRDataTestResources

class EventResultQueriesTests: XCTestCase {
    
    private lazy var _lmp1ClassID: Int = { 116 }()
    private lazy var _lmp1Class = EventResult.CarClass(name: "", ID: _lmp1ClassID, cars: []) // Only ID should be relevant
    
    private lazy var _lmp2ClassID = { 2523 }()
    private lazy var _lmp2Class = EventResult.CarClass(name: "", ID: _lmp2ClassID, cars: []) // Only ID should be relevant
    
    private lazy var _gteClassID = { 2525 }()
    private lazy var _gteClass = EventResult.CarClass(name: "", ID: _gteClassID, cars: []) // Only ID should be relevant
    
    private let _driver1Name = "Alex Salmon"
    private let _driver2Name = "Taylor Mills"
    private let _teamCar = "Audi R18"
    private let _teamName = "Audi Sport Team Joest #7"
    
    // MARK: - Get Drivers
    
    func test_EventResult_Query_GetDriver_WithName() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let driver = eventResult.getDriver(_driver1Name)
        
        XCTAssertEqual(driver?.name, _driver1Name)
    }
    
    func test_EventResult_Query_GetDriver_WithNameOfTeamIsNil() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let driver = eventResult.getDriver(_teamName)
        
        XCTAssertNil(driver)
    }
    
    func test_EventResult_Query_GetDriversOfTeam() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let team = eventResult.resultsOfTeams.first { $0.name == _teamName }!
        let drivers = eventResult.getDriversOfTeam(team)
        
        XCTAssertTrue(team.isTeamEntry)
        XCTAssertEqual(drivers.count, 2)
        XCTAssertEqual(drivers.map { $0.name }, [_driver1Name, _driver2Name])
    }
    
    func test_EventResult_Query_GetDriversOfTeam_WithDriverEntryIsEmpty() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let driver = eventResult.resultsOfDrivers.first!
        let drivers = eventResult.getDriversOfTeam(driver)
        
        XCTAssertTrue(driver.isDriverEntry)
        XCTAssertEqual(drivers.count, 0)
    }
    
    func test_EventResult_Query_GetDriversInClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let lmp1Drivers = eventResult.getDriversInClass(_lmp1Class)
        XCTAssertEqual(lmp1Drivers.count, 30)
        
        let lmp2Drivers = eventResult.getDriversInClass(_lmp2Class)
        XCTAssertEqual(lmp2Drivers.count, 34)
        
        let gteDrivers = eventResult.getDriversInClass(_gteClass)
        XCTAssertEqual(gteDrivers.count, 44)
    }
    
    func test_EventResult_Query_GetDriverOfFastestLap() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let driver = eventResult.getDriverOfFastestLap()
        
        XCTAssertEqual(driver!.name, "Lewis Woods")
        XCTAssertEqual(driver!.fastestLapTime, 3 * 60 + 9.344)
    }
    
    func test_EventResult_Query_GetDriverOfFastestLap_InClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        XCTAssertEqual(eventResult.carClasses.count, 3)
        let fastestLaps = eventResult.carClasses.compactMap { eventResult.getDriverOfFastestLap(inClass: $0) }
        
        let fastestLMP1 = fastestLaps.first { $0.name == "Lewis Woods" }
        XCTAssertEqual(fastestLMP1?.fastestLapTime, 60 * 3 + 9.344)
        
        let fastestLMP2 = fastestLaps.first { $0.name == "Paulo Munoz" }
        XCTAssertEqual(fastestLMP2?.fastestLapTime, 60 * 3 + 27.324)
        
        let fastestGTE = fastestLaps.first { $0.name == "Christopher Lulham" }
        XCTAssertEqual(fastestGTE?.fastestLapTime, 60 * 3 + 43.883)
    }
    
    
    
    
    
    // MARK: - Get Teams
    
    func test_EventResult_Query_GetTeam_WithName() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let team = eventResult.getTeam(_teamName)
        
        XCTAssertEqual(team?.name, _teamName)
    }
    
    func test_EventResult_Query_GetTeamOfDriver() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let driver = eventResult.resultsOfDrivers.first { $0.name == _driver1Name }!
        let team = eventResult.getTeamOfDriver(driver)
        
        XCTAssertTrue(driver.isDriverEntry)
        XCTAssertTrue(team!.isTeamEntry)
        XCTAssertEqual(team!.name, _teamName)
    }
    
    func test_EventResult_Query_GetTeamOfDriver_FromTeamEntryIsNil() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let teamEntry = eventResult.resultsOfTeams.first { $0.name == _teamName }!
        let team = eventResult.getTeamOfDriver(teamEntry)
        
        XCTAssertTrue(teamEntry.isTeamEntry)
        XCTAssertNil(team)
    }
    
    func test_EventResult_Query_GetTeamOfDriver_WithName() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let team = eventResult.getTeamOfDriver(_driver1Name)
        
        XCTAssertEqual(team?.name, _teamName)
    }
    
    func test_EventResult_Query_GetTeamsInClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let lmp1Teams = eventResult.getTeamsInClass(_lmp1Class)
        XCTAssertEqual(lmp1Teams.count, 15)
        
        let lmp2Teams = eventResult.getTeamsInClass(_lmp2Class)
        XCTAssertEqual(lmp2Teams.count, 15)
        
        let gteTeams = eventResult.getTeamsInClass(_gteClass)
        XCTAssertEqual(gteTeams.count, 19)
    }
    
    
    
    
    
    // MARK: - Car Classes
    
    func test_EventResult_Query_GetCarClassOfDriver_WithName() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let carClass = eventResult.getCarClassOfDriver(_driver1Name)
        
        XCTAssertEqual(carClass?.ID, _lmp1ClassID)
    }
    
    func test_EventResult_Query_GetStartPositionOfTeamInItsClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let lmp1StartPos = eventResult.getStartPositionOfTeamInItsClass(_teamName)
        let lmp2StartPos = eventResult.getStartPositionOfTeamInItsClass("UNIQUE Simracing BLUE")
        let gteStartPos = eventResult.getStartPositionOfTeamInItsClass("Gericke Motorsport Team AMBIBACK.DE")
        
        XCTAssertEqual(lmp1StartPos, 3)
        XCTAssertEqual(lmp2StartPos, 5)
        XCTAssertEqual(gteStartPos, 10)
    }
    
    func test_EventResult_Query_GetStartPositionOfDriversTeamInItsClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let lmp1StartPos = eventResult.getStartPositionOfDriversTeamInItsClass(_driver1Name)
        let lmp2StartPos = eventResult.getStartPositionOfDriversTeamInItsClass("René Aures")
        let gteStartPos = eventResult.getStartPositionOfDriversTeamInItsClass("Adrian Gericke")
        
        XCTAssertEqual(lmp1StartPos, 3)
        XCTAssertEqual(lmp2StartPos, 5)
        XCTAssertEqual(gteStartPos, 10)
    }
    
}
