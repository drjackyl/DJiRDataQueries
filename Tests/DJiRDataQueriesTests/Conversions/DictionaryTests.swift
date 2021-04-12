import XCTest
@testable import DJiRDataQueries

class DictionaryTests: XCTestCase {
    
    func testAppendElement_NewElement() {
        var intToInts: [Int: [Int]] = [:]
        
        intToInts.appendElement(1, key: 1)
        
        XCTAssertEqual(intToInts[1], [1])
    }
    
    func testAppendElement_AdditionalElement() {
        var stringToStrings: [String: [String]] = [
            "Hello": ["World"]
        ]
        
        stringToStrings.appendElement("!", key: "Hello")
        
        XCTAssertEqual(stringToStrings["Hello"], ["World", "!"])
    }
    
    func testInsertElement_NewElement() {
        var intToInts: [Int: Set<Int>] = [:]
        
        intToInts.insertElement(1, key: 1)
        
        XCTAssertEqual(intToInts[1], [1])
    }
    
    func testInsertElement_AdditionalElement() {
        var stringToStrings: [String: Set<String>] = [
            "Hello": ["World"]
        ]
        
        stringToStrings.insertElement("!", key: "Hello")
        
        XCTAssertEqual(stringToStrings["Hello"], ["World", "!"])
    }
    
    func testInsertElement_ExistingElement() {
        var stringToStrings: [String: Set<String>] = [
            "Hello": ["World", "!"]
        ]
        
        stringToStrings.insertElement("!", key: "Hello")
        
        XCTAssertEqual(stringToStrings["Hello"], ["World", "!"])
    }
    
}
