
Project Notes
=============

This project demonstrates the conversion of some code from Objective-C to Swift.

It was created by Michael Patrick Ellard for a November 12, 2014 talk at the [SFBay Association of C and C++ Users](http://www.meetup.com/SFBay-Association-of-C-C-Users/).

The project:

- Reads in 9MB of containing morphological analyses of every word in the Greek New Testament. 
- Compiles a list of unique words in their dictionary form
- Keeps track of how many times each word appears
- Creates a set of unique proper names
- Writes out the list of unique words with the count of the times that each word appears
- Writes out the list of unique proper names with the count of the times that each name appears

The original Objective-C version of the project was designed to show the value of autorelease pools. As such, it creates more than 800,000 temporary objects in the course of doing this work.  


Licensing Information
=====================

The SBLGNT text used in the morphological analysis files is governed by the [SBLGNT EULA](http://sblgnt.com/license/).

The morphological analysis files themselves were created by James Tauber and are governed by the [CC-BY-SA License](http://creativecommons.org/licenses/by-sa/3.0/).  James Tauber's morphgnt project can be found [on github](https://github.com/morphgnt/sblgnt).

The remainder of this project was created by Michael Patrick Ellard.  It can be found [on github](https://github.com/MichaelPatrickEllard/WordCounter). It is governed by the [CC-BY-SA License](http://creativecommons.org/licenses/by-sa/3.0/).


Commit Information
==================

Each commit represents a different stage of the project. 

Starting Objective-C Project
--------

This is a version of the project with only Objective-C code.  

This project was originally used to demonstrate the value of autorelease pools.  As such, it intentionally creates a large number of temporary objects.  

Naive Swift Implementation
--------

This adds a "Naive" Swift version of the file parser class: FileParserSwift. The intent of this code is to as closely as possible replicate the code from FileParseObjC. It also adds SwiftCountedSet, a Swift alternative to NSCountedSet.

This naive conversion results in Swift code that does everything that the Objective-C code does, but which is much slower than the Objective-C original.

Step 1
--------

This changes debugging optimization from -ONone to -O.  -O is better for performance testing.  Use -ONone for other debugging. 

Step 2
--------

Use of SwiftCountedSet is eliminated.  While it's cool to be able to implement a Swift version of NSCountedSet using generics, NSCountedSet has a lot of optimizations in it that make it a better choice.

Step 3
--------

Elimination of an expensive test using countElements.  As per the Swift Language Guide, using countElements can be expensive when dealing with a large string.  In this case, countElements is essentially used to analyze the grapheme clusters in 9MB of String data, which is rather expensive. Use of the Swift String isEmpty property is a much more efficient way of doing the needed test.  

Step 4
--------

Removing unnecessary type conversion of an NSArray of NSStrings to a Swift Array of Swift Strings.  While conversions like this are inexpensive on an individual basis, the cumulative cost can become significant when dealing with arrays containing more than 100,000 objects.

Step 5
--------

Rewriting some of the code to be more efficient. One of the goals of the original project was to create lots of temporary objects in order to demonstrate the value of autorelease pools. This version of the code discards that goal, instead focusing on making the code faster and more efficient.  

Step ?: Your Name Here!
--------

Can you find a way to make the Swift code even faster and more efficient?  Please share it! I welcome your contributions to this project.