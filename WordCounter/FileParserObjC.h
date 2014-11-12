//
//  FileParserObjC.h
//  WordCountWizard
//
//  Created by Rescue Mission Software on 11/6/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileParserObjC : NSObject

@property (strong, nonatomic) NSCountedSet *countedSet;
@property (strong, nonatomic) NSArray *orderedArray;

@property (strong, nonatomic) NSArray *properNameArray;

@property (strong, nonatomic) NSString *sourceDirectory;
@property (strong, nonatomic) NSString *resultsDirectory;

@property (nonatomic) NSInteger wordCount;

-(void)analyzeFiles;

@end
