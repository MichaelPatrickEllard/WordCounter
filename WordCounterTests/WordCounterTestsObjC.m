//
//  WordCounterTests.m
//  WordCounterTests
//
//  Created by Rescue Mission Software on 11/11/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "FileParserObjC.h"

@interface WordCounterTests : XCTestCase

@property (nonatomic, strong) FileParserObjC *fileParser;

@end

@implementation WordCounterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.fileParser = [FileParserObjC new];
    
    [self.fileParser analyzeFiles];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.fileParser = nil;
}

#pragma mark - Test word counts

- (void)testWordCount {

    XCTAssertEqual(self.fileParser.wordCount, 137554, "Total processed words");
}

- (void)testUniqueWordCount {
    
    XCTAssertEqual([self.fileParser.orderedArray count], 5465, "Unique word count");
    
}

- (void)testProperNameCount {
    
    XCTAssertEqual([self.fileParser.properNameArray count], 597, "Proper name count");
    
}

#pragma mark - Test counts for individual words in counted set

- (void)testCountForAbraham {
    
    XCTAssertEqual([self.fileParser.countedSet countForObject:@"Ἀβραάμ"], 73, "Occurances of Abraham");
    
}

- (void)testCountForThe {
    
    XCTAssertEqual([self.fileParser.countedSet countForObject:@"ὁ"], 19769, "Occurances of 'the'");
    
}

- (void)testCountForToBe {
    
    XCTAssertEqual([self.fileParser.countedSet countForObject:@"εἰμί"], 2456, "Occurances of 'to be'");
    
}

#pragma mark - Test first and last words in ordered array

- (void)testFirstItemInOrderedArray {
    
    XCTAssertEqualObjects([self.fileParser.orderedArray firstObject], @"ὁ", "First item in ordered array");
    
}

- (void)testLastItemInOrderedArray {
    
    XCTAssertEqualObjects([self.fileParser.orderedArray lastObject], @"φιλότεκνος", "Last item in ordered array");
    
}

#pragma mark - Test first and last words in proper names

- (void)testFirstItemInProperNameArray {
    
    XCTAssertEqualObjects([self.fileParser.properNameArray firstObject], @"Ἰησοῦς", "First item in proper name array");
    
}

- (void)testLastItemInProperNameArray {
    
    XCTAssertEqualObjects([self.fileParser.properNameArray lastObject], @"Τέρτιος", "Last item in proper name array");
    
}


@end
