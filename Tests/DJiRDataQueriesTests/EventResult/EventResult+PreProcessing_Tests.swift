import XCTest
@testable import DJiRDataQueries
import DJiRDataTestResources

class EventResultPreProcessingTests: XCTestCase {
    
    // MARK: Teams & Drivers
    
    func testEventResult_ProcessedData_NoTeam() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_SingleClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        XCTAssertEqual(eventResult.resultsOfDrivers.count, eventResult.results.count)
        XCTAssertTrue(eventResult.resultsOfDrivers.count > 0)
        XCTAssertFalse(eventResult.isTeamEvent)
        XCTAssertEqual(eventResult.resultsOfTeams.count, 0)
    }
    
    func testEventResult_ProcessedData_Team() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        XCTAssertEqual(eventResult.resultsOfDrivers.count + eventResult.resultsOfTeams.count, eventResult.results.count)
        XCTAssertTrue(eventResult.resultsOfDrivers.count > 0)
        XCTAssertTrue(eventResult.resultsOfTeams.count > 0)
        XCTAssertTrue(eventResult.isTeamEvent)
    }
    
    
    
    
    
    // MARK: Car Classes
    
    func testEventResultResult_Query_GetCarClasses() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_Team_MultiClass_Race
            .load()
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        let expectedCarClasses: Set<EventResult.CarClass> = [
            EventResult.CarClass(
                name: "LMP1 Class",
                ID: 116,
                cars: [
                    EventResult.Car(name: "Audi R18", ID: 98, classID: 116),
                    EventResult.Car(name: "Porsche 919", ID: 100, classID: 116)
                ]
            ),
            EventResult.CarClass(
                name: "Dallara P217",
                ID: 2523,
                cars: [
                    EventResult.Car(name: "Dallara P217", ID: 128, classID: 2523)
                ]
            ),
            EventResult.CarClass(
                name: "GTE Class 3",
                ID: 2525,
                cars: [
                    EventResult.Car(name: "Ferrari 488 GTE", ID: 93, classID: 2525),
                    EventResult.Car(name: "Porsche 911 RSR", ID: 102, classID: 2525),
                    EventResult.Car(name: "Chevrolet Corvette C8.R GTE", ID: 127, classID: 2525)
                ]
            )
        ]
        
        
        let carClasses = eventResult.results.getCarClassesInSession()
        
        
        XCTAssertEqual(carClasses, expectedCarClasses)
    }
    
    func testEventResult_ProcessedData_SingleClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_SingleClass_Race
            .load()
        let expectedCars: Set<EventResult.Car> = [EventResult.Car(name: "Porsche 911 GT3 Cup (991)", ID: 88, classID: 95)]
        let expectedCarClasses: Set<EventResult.CarClass> = [EventResult.CarClass(name: "Porsche 911 GT3 Cup", ID: 95, cars: expectedCars)]
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        XCTAssertEqual(eventResult.cars, expectedCars)
        XCTAssertEqual(eventResult.carClasses, expectedCarClasses)
        XCTAssertFalse(eventResult.isMultiClassEvent)
    }
    
    func testEventResult_ProcessedData_MultiClass() {
        let data = DJiRDataTestResources
            .CSVEventResult
            .Road_NoTeam_MultiClass_Race
            .load()
        
        let dallaraP217 = EventResult.Car(name: "Dallara P217", ID: 128, classID: 2523)
        let lmp2 = EventResult.CarClass(name: "Dallara P217", ID: 2523, cars: [dallaraP217])
        
        let corvette = EventResult.Car(name: "Chevrolet Corvette C8.R GTE", ID: 127, classID: 2524)
        let ferrari = EventResult.Car(name: "Ferrari 488 GTE", ID: 93, classID: 2524)
        let bmwM8 = EventResult.Car(name: "BMW M8 GTE", ID: 109, classID: 2524)
        let porsche = EventResult.Car(name: "Porsche 911 RSR", ID: 102, classID: 2524)
        let gtlm = EventResult.CarClass(name: "GTE IMSA", ID: 2524, cars: [corvette, ferrari, bmwM8, porsche])
        
        let lambo = EventResult.Car(name: "Lamborghini Huracán GT3 EVO", ID: 133, classID: 2709)
        let bmwM4 = EventResult.Car(name: "BMW M4 GT3 - Prototype", ID: 132, classID: 2709)
        let gtd = EventResult.CarClass(name: "", ID: 2709, cars: [lambo, bmwM4])
        
        let expectedCars: Set<EventResult.Car> = [dallaraP217, corvette, ferrari, bmwM8, porsche, lambo, bmwM4]
        let expectedCarClasses: Set<EventResult.CarClass> = [lmp2, gtlm, gtd]
        
        
        let eventResult = try! IRDataQueries().createEventResultFromCSVData(data)
        
        
        XCTAssertEqual(eventResult.cars, expectedCars)
        XCTAssertEqual(eventResult.carClasses, expectedCarClasses)
        XCTAssertTrue(eventResult.isMultiClassEvent)
    }
    
}
