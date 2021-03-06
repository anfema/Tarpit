//
//  tarpit_iosTests.swift
//  tarpit_iosTests
//
//  Created by Johannes Schriewer on 26/11/15.
//  Copyright © 2015 anfema. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted under the conditions of the 3-clause
// BSD license (see LICENSE.txt for full license text)

import XCTest
@testable import tarpit

class tarpitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUnpack() {
        guard let file = Bundle(for: type(of: self)).path(forResource: "readme", ofType: "tar") else {
            XCTFail("Tar file not found")
            return
        }
        
        do {
            let tar = try TarFile(fileName: file)
            while let file = try tar.extractFile() {
                XCTAssert((file.filename == "readme.md" || file.filename == "LICENSE.txt"))
                XCTAssert((file.data.count == 1481 || file.data.count == 14750))
                print(file.filename)
            }
        } catch TarFile.Errors.endOfFile {
            // ok
        } catch {
            XCTFail()
        }
    }
    
    func testStreamingUnpack() {
        guard let file = Bundle(for: type(of: self)).path(forResource: "readme", ofType: "tar") else {
            XCTFail("Tar file not found")
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file))  else {
            XCTFail("Tar file could not be read")
            return
        }
        let dataPtr = (data as NSData).bytes.bindMemory(to: CChar.self, capacity: data.count)
        
        let tar = TarFile(streamingData: nil)
        var i = 0
        while i < data.count {
            var bytes = Int(arc4random_uniform(250) + 1)
            if i + bytes >= data.count {
                bytes = data.count - i
            }
            
            let buffer = UnsafeBufferPointer<CChar>(start: dataPtr.advanced(by: i), count: bytes)
            do {
                if let file = try tar.consume(data: [CChar](buffer)) {
                    XCTAssert((file.filename == "readme.md" || file.filename == "LICENSE.txt"))
                    XCTAssert((file.data.count == 1481 || file.data.count == 14750))
                    print(file.filename)
                }
            } catch TarFile.Errors.headerParseError {
                XCTFail("Header parse error")
            } catch TarFile.Errors.endOfFile {
                // ok
            } catch {
                XCTFail("Unknown error")
            }
            
            i += bytes
        }

    }
}
