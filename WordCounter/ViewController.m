//
//  ViewController.m
//  WordCounter
//
//  Created by Rescue Mission Software on 11/11/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

#import "ViewController.h"

#import "FileParserObjC.h"

#import "WordCounter-Swift.h"

@implementation ViewController

- (IBAction)runObjCParser:(id)sender {
    
    FileParserObjC *objCParser = [FileParserObjC new];
    
    [objCParser analyzeFiles];
    
}

- (IBAction)runSwiftParser:(id)sender {
    
     FileParserSwift *swiftParser = [FileParserSwift new];
    
    [swiftParser analyzeFiles];
    
}

@end
