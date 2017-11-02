//
//  NALUTests.swift
//  SwiftlakePoC
//
//  Created by Aviad Sachs on 23/10/2017.
//  Copyright © 2017 Intel FlexIT. All rights reserved.
//

import XCTest
import CoreMedia
@testable import SwiftlakePoC


public class H264Tests : XCTestCase {

    var mockData = H264MockData()
    var streamParser = StreamParser(startCode: .FourBytes)
    var decoder = try? H264Decoder()
    
    func testH2s6Decoder_createSampleBuffer() {
        let rawUnit = (try? streamParser.parse(data: mockData.sample_data_3units_24_36_1024))
        
        if let decoder = decoder, let rawUnit = rawUnit {
        
            try? decoder.decode(rawUnit[0].buffer, length: rawUnit[0].length)
            try? decoder.decode(rawUnit[1].buffer, length: rawUnit[1].length)
            
            let sample = try?  decoder.getCMSampleBuffer(rawUnit[2].buffer, length: rawUnit[2].length)
            if let sample = sample {
                var x = 5
                
                
            } else { XCTFail() }
            
            

        } else { XCTFail() }
    }
    
    func testNALU_createCorrectType() {
    
        var rawUnit = (try? streamParser.parse(data: mockData.sample_data_sps_24))
        var typedUnit = NALU(rawUnit![0].buffer, length: rawUnit![0].length)
        XCTAssertEqual(typedUnit.type, .sps)
        
        rawUnit = (try? streamParser.parse(data: mockData.sample_data_pps_24))
        typedUnit = NALU(rawUnit![0].buffer, length: rawUnit![0].length)
        XCTAssertEqual(typedUnit.type, .pps)
        
        rawUnit = (try? streamParser.parse(data: mockData.sample_data_idr_512))
        typedUnit = NALU(rawUnit![0].buffer, length: rawUnit![0].length)
        XCTAssertEqual(typedUnit.type, .idr)
        
        rawUnit = (try? streamParser.parse(data: mockData.sample_data_codedSlice_512))
        typedUnit = NALU(rawUnit![0].buffer, length: rawUnit![0].length)
        XCTAssertEqual(typedUnit.type, .codedSlice)
        
        rawUnit = (try? streamParser.parse(data: mockData.sample_data_3units_24_36_1024))
        typedUnit = NALU(rawUnit![0].buffer, length: rawUnit![0].length)
        let typedUnit1 = NALU(rawUnit![1].buffer, length: rawUnit![1].length)
        let typedUnit2 = NALU(rawUnit![2].buffer, length: rawUnit![2].length)
        XCTAssertEqual(typedUnit.type, .sps)
        XCTAssertEqual(typedUnit1.type, .pps)
        XCTAssertEqual(typedUnit2.type, .idr)
        
    }
}
