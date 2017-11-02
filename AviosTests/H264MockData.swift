//
//  H264MockData.swift
//  SwiftlakePoC
//
//  Created by Aviad Sachs on 23/10/2017.
//  Copyright © 2017 Intel FlexIT. All rights reserved.
//

import Foundation

import SwiftlakePoC

public class H264MockData {
    
    public var startCode: StartCodeType
    public var sample_data_sps_24 = Data()
    public var sample_data_pps_24 = Data()
    public var sample_data_idr_512 = Data()
    public var sample_data_codedSlice_512 = Data()
    public var sample_data_1unit_1024 = Data()
    public var sample_data_2units_24_18 = Data()
    public var sample_data_3units_24_36_1024 = Data()

    init(startCode : StartCodeType = .FourBytes) {
        self.startCode = startCode
        setupSampleData()
    }
    
    // Sample Data
    func setupSampleData() {
        
        sample_data_sps_24 = Data(bytes: StartCodeBytes())
        sample_data_sps_24.append(contentsOf: [NALUType.sps.rawValue])
        sample_data_sps_24.append(contentsOf: Data(bytes: randomUInt8Array(count: 23)))
        
        sample_data_pps_24 = Data(bytes: StartCodeBytes())
        sample_data_pps_24.append(contentsOf: [NALUType.pps.rawValue])
        sample_data_pps_24.append(contentsOf: Data(bytes: randomUInt8Array(count: 23)))
        
        sample_data_idr_512 = Data(bytes: StartCodeBytes())
        sample_data_idr_512.append(contentsOf: [NALUType.idr.rawValue])
        sample_data_idr_512.append(contentsOf: Data(bytes: randomUInt8Array(count: 511)))
        
        sample_data_codedSlice_512 = Data(bytes: StartCodeBytes())
        sample_data_codedSlice_512.append(contentsOf: [NALUType.codedSlice.rawValue])
        sample_data_codedSlice_512.append(contentsOf: Data(bytes: randomUInt8Array(count: 511)))
        
        sample_data_1unit_1024 = Data(bytes: StartCodeBytes())
        sample_data_1unit_1024.append(contentsOf: [NALUType.sps.rawValue])
        sample_data_1unit_1024.append(contentsOf: Data(bytes: randomUInt8Array(count: 1023)))
        
        sample_data_2units_24_18 = Data(bytes: StartCodeBytes())
        sample_data_2units_24_18.append(contentsOf: [NALUType.sps.rawValue])
        sample_data_2units_24_18.append(contentsOf: Data(bytes: randomUInt8Array(count: 23)))
        sample_data_2units_24_18.append(contentsOf: StartCodeBytes())
        sample_data_2units_24_18.append(contentsOf: [NALUType.pps.rawValue])
        sample_data_2units_24_18.append(contentsOf: Data(bytes: randomUInt8Array(count: 17)))
        
        
        sample_data_3units_24_36_1024 = Data(bytes: StartCodeBytes())
        sample_data_3units_24_36_1024.append(contentsOf: [NALUType.sps.rawValue])
        sample_data_3units_24_36_1024.append(contentsOf: Data(bytes: randomUInt8Array(count: 23)))
        sample_data_3units_24_36_1024.append(contentsOf: StartCodeBytes())
        sample_data_3units_24_36_1024.append(contentsOf: [NALUType.pps.rawValue])
        sample_data_3units_24_36_1024.append(contentsOf: Data(bytes: randomUInt8Array(count: 35)))
        sample_data_3units_24_36_1024.append(contentsOf: StartCodeBytes())
        sample_data_3units_24_36_1024.append(contentsOf: [NALUType.idr.rawValue])
        sample_data_3units_24_36_1024.append(contentsOf: Data(bytes: randomUInt8Array(count: 1023)))
    }
    
    public func randomUInt8Array(count : Int) -> [UInt8] {
        return H264MockData.randomUInt8Array(count: count)
    }
    
    func StartCodeBytes()->[UInt8]{
        return H264MockData.StartCodeBytes(self.startCode)
    }
    
    
    // MARK -- Public Static Methods
    public static func randomUInt8Array(count : Int) -> [UInt8] {
        return [UInt8](repeating: 0, count: count).map { _ in UInt8(truncatingBitPattern: arc4random()) }
    }
 
    public static func StartCodeBytes(_ startCode : StartCodeType)->[UInt8]{
        switch startCode {
        case .ThreeBytes:
            return [UInt8](arrayLiteral: 0x00, 0x00, 0x01)
        case .FourBytes:
            return [UInt8](arrayLiteral: 0x00, 0x00, 0x00, 0x01)
        }
    }

}
