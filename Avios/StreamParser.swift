//
//  StreamParser.swift
//  SwiftlakePoC
//
//  Created by Aviad Sachs on 19/10/2017.
//  Copyright © 2017 Intel FlexIT. All rights reserved.
//

import Foundation


public enum StartCodeType : Int {
    case ThreeBytes = 3
    case FourBytes = 4
}

public struct RawNALU {
    public var buffer : UnsafePointer<UInt8>
    public var length : Int
    public init(_ buffer : UnsafePointer<UInt8>, _ length : Int) {
        self.buffer = buffer
        self.length = length
    }
    
    public static func stripped(_ buffer : UnsafePointer<UInt8>, _ length : Int, skipAtStart: Int) -> RawNALU {
        return RawNALU((buffer + skipAtStart), (length - skipAtStart))
    }
    
}

public class StreamParser {
    
    fileprivate let maxMetaSize = 40
    fileprivate let startCode : StartCodeType
    
    
    public init(startCode: StartCodeType) {
        self.startCode = startCode
        
    }
    
    public func parse(data: Data) throws -> [RawNALU] {
        var rawNALUs : [RawNALU] = []
        let dataPointer = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
        let dataBuffer = UnsafeBufferPointer<UInt8>(start: dataPointer, count: data.count)
        
        guard isStartCodeIn(dataBuffer, at: 0) else {
            throw H264Error.invalidNALUType
        }

        var rawUnitBegin = 0
        var rawUnitEnd = findNextStartCode(dataBuffer, from: 0)
        repeat {
            
            let pointer = dataPointer + rawUnitBegin
            let length = dataBuffer.distance(from: rawUnitBegin, to: rawUnitEnd)
            rawNALUs.append(RawNALU.stripped(pointer, length, skipAtStart: startCode.rawValue))
            
            //  --- Print debug data ---
            print("rawBegin: \(rawUnitBegin)  rawEnd: \(rawUnitEnd) length: \(length) rawNALU length: \(rawNALUs.last!.length) ")
            //--------------------------
            
            rawUnitBegin = rawUnitEnd
            rawUnitEnd = findNextStartCode(dataBuffer, from: rawUnitBegin)
        } while (rawUnitBegin != dataBuffer.count)
        
        
        return rawNALUs
    }
    
    
    fileprivate func findNextStartCode(_ dataBuffer: UnsafeBufferPointer<UInt8>, from index : Int) -> Int {
        guard index >= 0 && index < (dataBuffer.count - self.startCode) else { return dataBuffer.count }
        
        var i = index + 1
        while !isStartCodeIn(dataBuffer, at: i) {
            i += 1
            
            if (i + startCode.rawValue >= dataBuffer.count) {
                return dataBuffer.count
            }
        }
        return i
    }
    
    
    fileprivate func isStartCodeIn(_ dataBuffer: UnsafeBufferPointer<UInt8>, at index : Int) -> Bool {
        guard index < dataBuffer.count - self.startCode else { return false }
        
        if dataBuffer[index] == 0x00 && dataBuffer[index+1] == 0x00 {
            switch self.startCode {
            case .ThreeBytes:
                if dataBuffer[index+2] == 0x01 { return true }
                break
                
            case .FourBytes:
                if dataBuffer[index+2] == 0x00 && dataBuffer[index+3] == 0x01 { return true }
                break
            }
        }
        return false
    }
}
