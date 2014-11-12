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
        
        var lineCount = 0
        
        fileContents?.enumerateLinesUsingBlock() { (currentLine : String!, stop : UnsafeMutablePointer) in
            
            if !currentLine.isEmpty
            {
                autoreleasepool
                    {
                        let currentLineObjC = currentLine as NSString
                        
                        var currentIndex = currentLineObjC.length - 1
                        
                        var space: unichar = 32
                        
                        while currentLineObjC.characterAtIndex(currentIndex) != space {
                            
                            currentIndex--
                        }
                        
                        let dictionaryForm = currentLineObjC.substringFromIndex(currentIndex + 1)
                        
                        self.countedSet.addObject(dictionaryForm)
                        
                        lineCount = lineCount + 1
                        
                }
            }
        }
        
        NSLog("Here's how many strings \(lineCount)")
        
        wordCount = wordCount + lineCount
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
