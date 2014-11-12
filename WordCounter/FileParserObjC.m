//
//  FileParserObjC.m
//  WordCountWizard
//
//  Created by Rescue Mission Software on 11/6/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

#import "FileParserObjC.h"


@implementation FileParserObjC

-(void)analyzeFiles
{
    NSDate *startTime = [NSDate new];
    
    NSLog(@"Beginning File Parser operations");
    
    self.countedSet = [[NSCountedSet alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    
    self.sourceDirectory = [bundlePath stringByAppendingString:@"/WordFiles/"];
    
    NSArray *filesInSourceDirectory = [fileManager contentsOfDirectoryAtPath:self.sourceDirectory
                                                                       error:nil];
    
    NSLog(@"Beginning to process files into NSCountedSet");
    
    for (NSString *eachFileName in filesInSourceDirectory)
    {
        @autoreleasepool
        {
            [self processFile:eachFileName];
        }
    }
    
    NSDate *doneCountedSetTime = [NSDate new];
    
    NSLog(@"Finished processing files into NSCountedSet. %ld words processed.", (long)self.wordCount);
    
    self.orderedArray = [self orderedArrayFromCountedSet:self.countedSet];
    
    NSDate *doneOrderedArrayTime = [NSDate new];
    
    NSLog(@"Created sorted array of %ld unique words", (unsigned long)[self.orderedArray count]);
    
    self.properNameArray = [self properNamesFromOrderedArray:self.orderedArray];
    
    NSDate *doneProperNameArrayTime = [NSDate new];
    
    NSLog(@"Created array of %ld proper names", (unsigned long)[self.properNameArray count]);
    
    [self writeArray:self.orderedArray toFile:@"AllWords"];
    
    [self writeArray:self.properNameArray toFile:@"ProperNames"];
    
    NSDate *doneWritingTime = [NSDate new];
    
    NSLog(@"Done writing files");
    
    NSTimeInterval parsingIntoCountedSetTime = [doneCountedSetTime timeIntervalSinceDate:startTime];
    
    NSLog(@"Time to read in data and parse into Counted Set was %f", parsingIntoCountedSetTime);
    
    NSTimeInterval orderedArrayElapsedTime = [doneOrderedArrayTime timeIntervalSinceDate:doneCountedSetTime];
    
    NSLog(@"Time to extract and sort ordered Array was %f", orderedArrayElapsedTime);
    
    NSTimeInterval properNamesElapsedTime = [doneProperNameArrayTime timeIntervalSinceDate:doneOrderedArrayTime];
    
    NSLog(@"Time to extract and sort Proper Name Array was %f", properNamesElapsedTime);
    
    NSTimeInterval fileWritingElapsedTime = [doneWritingTime timeIntervalSinceDate:doneProperNameArrayTime];
    
    NSLog(@"File Writing Time was %f", fileWritingElapsedTime);
    
    NSTimeInterval totalElapsedTime = [doneWritingTime timeIntervalSinceDate:startTime];
    
    NSLog(@"ObjC Total Elapsed Time was %f", totalElapsedTime);
}

-(void)processFile:(NSString *)fileName
{
    NSError *fileReadError = nil;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:[self.sourceDirectory stringByAppendingString:fileName]
                                                       encoding:NSUTF8StringEncoding
                                                          error:&fileReadError];
    
    
    NSArray *strings = [fileContents componentsSeparatedByString:@"\n"];
    
    NSLog(@"Here's how many strings %ld", (unsigned long)[strings count]);
    
    int loopCounter = 0;
    
    int fileWordCount = 0;
    
    for (NSString *eachLine in strings)
    {
        loopCounter ++;
        
        if ([eachLine length] > 19)
        {
            @autoreleasepool
            {
                NSString *words = [eachLine substringFromIndex:19];
                
                NSArray *parsedWords = [words componentsSeparatedByString:@" "];
                
                NSString *dictionaryForm = [parsedWords objectAtIndex:3];
                
                fileWordCount++;
                
                [self.countedSet addObject:dictionaryForm];
            }
            
        }
        else
        {
            if (loopCounter != [strings count])
            {
                NSLog(@"Line %d is shorter than expected: '%@'", loopCounter, eachLine);
            }
        }
    }
    
    self.wordCount += fileWordCount;
}

-(NSArray *)orderedArrayFromCountedSet:(NSCountedSet *)sourceSet
{
    NSArray *unsortedWordArray = [self.countedSet allObjects];
    
    return [unsortedWordArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                NSUInteger count1 = [self.countedSet countForObject:obj1];
                NSUInteger count2 = [self.countedSet countForObject:obj2];
                
                if (count1 > count2)
                {
                    return NSOrderedAscending;
                }
                else if (count1 < count2)
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedSame;
                }
            }];
}

-(NSArray *)properNamesFromOrderedArray:(NSArray *)wordArray
{
    NSMutableArray *returnArray = [NSMutableArray new];
    
    for (NSString *eachString in wordArray)
    {
        NSString *initialCharacter = [eachString substringToIndex:1];
        
        if ([initialCharacter isEqualToString:[initialCharacter uppercaseString]])
        {
            [returnArray addObject:eachString];
        }
    }
    
    return returnArray;
}

-(void)writeArray:(NSArray *)sourceArray
           toFile:(NSString *)fileName
{
    NSMutableData *fileData = [NSMutableData data];
    
    for (id eachUniqueWord in sourceArray)
    {
        NSString *outputString = [NSString stringWithFormat:@"%@,%ld\r",eachUniqueWord, (unsigned long)[self.countedSet countForObject:eachUniqueWord]];
        [fileData appendData:[outputString dataUsingEncoding:NSUnicodeStringEncoding]];
    }
    
    if (!self.resultsDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        self.resultsDirectory = [paths objectAtIndex:0];
    }
    
    NSString *filePath = [self.resultsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [fileData writeToFile:filePath atomically:YES];
}


@end
