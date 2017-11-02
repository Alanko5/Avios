//
//  StreamParserTests.swift
//  SwiftlakePoC
//
//  Created by Aviad Sachs on 23/10/2017.
//  Copyright © 2017 Intel FlexIT. All rights reserved.
//

import XCTest
@testable import SwiftlakePoC


class StreamParserTests: XCTestCase {
    
    var mockData = H264MockData()
    var streamParser = StreamParser(startCode: .FourBytes)
    
    override func setUp() {
        self.continueAfterFailure = false
    }
    
    override func tearDown() {
        
    }
    
    func testParse_4Bytes_DataIntoRawNALUInCorrectCountAndSize() {
        
        var parsedUnits = try? streamParser.parse(data: mockData.sample_data_1unit_1024)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 1)
        XCTAssertEqual(parsedUnits![0].length, 1024)
        
        parsedUnits = try? streamParser.parse(data: mockData.sample_data_2units_24_18)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 2)
        XCTAssertEqual(parsedUnits![0].length, 24)
        XCTAssertEqual(parsedUnits![1].length, 18)
        
        parsedUnits = try? streamParser.parse(data: mockData.sample_data_3units_24_36_1024)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 3)
        XCTAssertEqual(parsedUnits![0].length, 24)
        XCTAssertEqual(parsedUnits![1].length, 36)
        XCTAssertEqual(parsedUnits![2].length, 1024)
        
    }
    
    func testParse_3Bytes_DataIntoRawNALUInCorrectCountAndSize() {
        
        streamParser = StreamParser(startCode: .ThreeBytes)
        mockData = H264MockData(startCode: .ThreeBytes)
        
        var parsedUnits = try? streamParser.parse(data: mockData.sample_data_1unit_1024)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 1)
        XCTAssertEqual(parsedUnits![0].length, 1024)
        
        parsedUnits = try? streamParser.parse(data: mockData.sample_data_2units_24_18)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 2)
        XCTAssertEqual(parsedUnits![0].length, 24)
        XCTAssertEqual(parsedUnits![1].length, 18)
        
        parsedUnits = try? streamParser.parse(data: mockData.sample_data_3units_24_36_1024)
        XCTAssertNotNil(parsedUnits, "parse method should return non-nil result")
        XCTAssertEqual(parsedUnits!.count, 3)
        XCTAssertEqual(parsedUnits![0].length, 24)
        XCTAssertEqual(parsedUnits![1].length, 36)
        XCTAssertEqual(parsedUnits![2].length, 1024)
        
    }
    
    
        
    
    
}
  
