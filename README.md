
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
