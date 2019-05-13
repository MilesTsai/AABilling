//
//  Project_2Tests.swift
//  Project2Tests
//
//  Created by User on 2019/5/10.
//  Copyright © 2019 Miles. All rights reserved.
//

import XCTest
import UIKit
@testable import Project_2

class Project2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func add(aaa: Int, bbb: Int) -> Int {
        
        return aaa + bbb
    }
    
    func testMiles() {
        
        // 3A - Arrange, Action, Assert
        
        // Arrange
        
        let aaa = 10
        
        let bbb = 20
        
        let expectedResult = aaa + bbb
        
        // Action
        
        let actualResult = add(aaa: aaa, bbb: bbb)
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
        print("哈哈哈")
    }
    
//    func testBack(xx: Int) -> Int {
//
//        if xx <= 1 {
//
//            return 1
//
//        } else {
//
//            return fib(x: xx - 1) + fib(x: xx - 2)
//        }
//    }
    
    func fib(nnn: Int) -> Int {
        
        if nnn <= 1 {
            return nnn
        }
        
        var fibs: [Int] = []
        
        for index in 0...nnn {
            
            if index <= 1 {
                
                fibs.append(1)
            } else {
                
                fibs.append(fibs[index - 1] + fibs[index - 2])
            }
        }
        print(fibs)
        return fibs[nnn]
    }
    
    func testFib() {
        
        let expectedResult = 8
        
        let actualResult = fib(nnn: 5)
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testCorrect() {
//        fib(nn: 10)
        let aa = fib(nnn: 11)
        let bb = fib(nnn: 12)
        
        XCTAssertEqual(aa, bb)
    }
    
    func testNegative() {
//        fib(nn: -1)
//        fib(1.5)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
            for _ in 0...3000 {
                let _ = UIView()
            }
        }
    }
}
