//
//  WordCounterTestsSwift.swift
//  WordCounter
//
//  Created by Rescue Mission Software on 11/11/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

import UIKit
import XCTest

import WordCounter

class WordCounterTestsSwift: XCTestCase {
    
    var fileParser: FileParserSwift!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        fileParser = FileParserSwift()
        
        fileParser.analyzeFiles()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        fileParser = nil
    }
    
    // MARK: - Test word counts
    
    func testWordCount() {
    
        XCTAssertEqual(self.fileParser.wordCount, 137554, "Total processed words")
    }
    
    func testUniqueWordCount() {
    
        XCTAssertEqual(self.fileParser.orderedArray.count, 5465, "Unique word count")
    
    }
    
    func testProperNameCount() {
    
        XCTAssertEqual(self.fileParser.properNameArray.count, 597, "Proper name count")
    
    }

    // MARK: - Test counts for individual words in counted set
    
    func testCountForAbraham() {
    
        XCTAssertEqual(fileParser.countedSet.countForObject("Ἀβραάμ"), 73, "Occurances of Abraham")
    
    }
    
    func testCountForThe() {
    
        XCTAssertEqual(fileParser.countedSet.countForObject("ὁ"), 19769, "Occurances of 'the'")
    
    }
    
    func testCountForToBe() {
    
        XCTAssertEqual(fileParser.countedSet.countForObject("εἰμί"), 2456, "Occurances of 'to be'")
    
    }
    
    // MARK: - Test first and last words in ordered array
    
    func testFirstItemInOrderedArray() {
    
        XCTAssertEqual(fileParser.orderedArray[0], "ὁ", "First item in ordered array")
    
    }
    
    func testLastItemInOrderedArray() {
    
        XCTAssertEqual(fileParser.orderedArray[fileParser.orderedArray.count - 1], "φιλότεκνος", "Last item in ordered array")
    
    }
    
    // MARK: - Test first and last words in proper names
    
    func testFirstItemInProperNameArray() {
    
        XCTAssertEqual(fileParser.properNameArray[0], "Ἰησοῦς", "First item in proper name array")
    
    }
    
    func testLastItemInProperNameArray() {
    
        XCTAssertEqual(fileParser.properNameArray[fileParser.properNameArray.count - 1], "Τέρτιος", "Last item in proper name array")
    
    }
    
    
}




