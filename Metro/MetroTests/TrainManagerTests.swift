//
//  TrainManagerTests.swift
//  Metro
//
//  Created by yokota on 2014/10/18.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import XCTest
import MapKit

class TrainManagerTests: XCTestCase {
    let tm
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tm = TrainManager(location:CLLocationCoordinate2DMake(35.6653784,139.7304807))
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(tm.getNearTrains(), "Pass")
    }
    
    
}
