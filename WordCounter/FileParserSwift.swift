//
//  FileParserSwift.swift
//  WordCountWizard
//
//  Created by Rescue Mission Software on 11/6/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

import UIKit

public class FileParserSwift: NSObject {
    
    var countedSet: NSCountedSet!
    var orderedArray: [String]!
    
    var properNameArray: [String]!
    
    let sourceDirectory : String
    let resultsDirectory : String
    
    var wordCount : Int!
    
    
    override init() {
        
        let bundlePath = NSBundle.mainBundle().bundlePath
        
        sourceDirectory = bundlePath.stringByAppendingString("/WordFiles/")
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        resultsDirectory = paths[0] as String
        
    }
    
    
    func analyzeFiles() {
        
        let startCountedSetTime = NSDate()
        
        NSLog("Beginning File Parser operations")
        
        countedSet = NSCountedSet()
        
        let fileManager = NSFileManager()
        
        let filesInSourceDirectory = fileManager.contentsOfDirectoryAtPath(sourceDirectory, error:nil) as [String]
        
        NSLog("Beginning to process files into NSCountedSet");
        
        wordCount = 0
        
        for eachFileName in filesInSourceDirectory {
            
            autoreleasepool
            {
                self.processFile(eachFileName)
            }
        }
        
        let doneCountedSetTime = NSDate()
        
        NSLog("Finished processing files into NSCountedSet. %ld words processed.", self.wordCount)
        
        orderedArray = orderedArrayFromCountedSet(countedSet)
        
        let doneOrderedArrayTime = NSDate()
        
        NSLog("Created sorted array of %ld unique words", self.orderedArray.count)
        
        properNameArray = properNamesFromOrderedArray(orderedArray)
        
        let doneProperNameArrayTime = NSDate()
        
        NSLog("Created array of %ld proper names", properNameArray.count)
        
        writeArray(orderedArray, fileName:"AllWords")
        
        writeArray(properNameArray, fileName:"ProperNames")
        
        let doneWritingTime = NSDate()
        
        NSLog("Done writing files");
        
        let parsingIntoCountedSetTime = doneCountedSetTime.timeIntervalSinceDate(startCountedSetTime)
        
        NSLog("Time to read in data and parse into Counted Set was %f", parsingIntoCountedSetTime)
        
        let orderedArrayElapsedTime = doneOrderedArrayTime.timeIntervalSinceDate(doneCountedSetTime)
        
        NSLog("Time to extract and sort ordered Array was %f", orderedArrayElapsedTime)
        
        let properNamesElapsedTime = doneProperNameArrayTime.timeIntervalSinceDate(doneOrderedArrayTime)
        
        NSLog("Time to extract and sort Proper Name Array was %f", properNamesElapsedTime)
        
        let fileWritingElapsedTime = doneWritingTime.timeIntervalSinceDate(doneProperNameArrayTime)
        
        NSLog("File Writing Time was %f", fileWritingElapsedTime)
        
        let totalElapsedTime = doneWritingTime.timeIntervalSinceDate(startCountedSetTime)
        
        NSLog("Swift Total Elapsed Time was %f", totalElapsedTime)
    }
    
    
    func processFile(fileName : String)
    {
        var fileReadError : NSError?
        
        let filePath = sourceDirectory.stringByAppendingPathComponent(fileName)
        
        let fileContents = NSString(contentsOfFile: filePath, encoding: 4, error: &fileReadError)
        
        
        let strings = fileContents!.componentsSeparatedByString("\n") as [String]
        
        NSLog("Here's how many strings \(strings.count)")
        
        let lastStringIndex = strings.count - 1
        
        for (loopCounter, eachLine) in enumerate(strings) {
            
            if (!eachLine.isEmpty)
            {
                autoreleasepool
                {
                    var wordStart = advance(eachLine.startIndex, 19)
                    
                    let wordsRange = Range(start: wordStart, end: eachLine.endIndex)
                    
                    let words = eachLine[wordsRange]
                    
                    let parsedWords = words.componentsSeparatedByString(" ")
                    
                    let dictionaryForm = parsedWords[3]
                    
                    self.countedSet.addObject(dictionaryForm)
                }
            }
            else
            {
                if (loopCounter != lastStringIndex) {
                    
                    NSLog("Line %ld is shorter than expected: '%@'", loopCounter, eachLine);
                    
                }
            }
        }
        
        wordCount = wordCount + Int(lastStringIndex)
    }
    
    func orderedArrayFromCountedSet(sourceSet: NSCountedSet) -> [String] {
    
        var words = countedSet.allObjects
        
        words.sort {
            
            let count1 = sourceSet.countForObject($0)
            let count2 = sourceSet.countForObject($1)
            
            return count1 > count2
        }
        
        return words as [String]
    }
    
    func properNamesFromOrderedArray(wordArray: [String]) -> [String]
    {
        var returnArray = [String]()
        
        for eachString in wordArray
        {
            let initialCharacter = eachString[eachString.startIndex...eachString.startIndex]
            
            if (initialCharacter == initialCharacter.uppercaseString)
            {
                returnArray.append(eachString)
            }
        }
        
        return returnArray;
    }
    
    func writeArray(sourceArray: [String], fileName: String)
    {
        let fileData = NSMutableData()
        
        for eachUniqueWord in sourceArray
        {
            let outputString = "\(eachUniqueWord),\(countedSet.countForObject(eachUniqueWord))\r"
            fileData.appendData(outputString.dataUsingEncoding(4)!)
        }
        
        let filePath = resultsDirectory.stringByAppendingPathComponent(fileName)
        
        
        let fileManager = NSFileManager()
        
        if (fileManager.fileExistsAtPath(filePath))
        {
            fileManager.removeItemAtPath(filePath, error:nil)
        }
        
        fileData.writeToFile(filePath, atomically: true)
    }

}
