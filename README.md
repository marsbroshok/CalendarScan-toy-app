# Custom Named Entity Recognizer (NER) in iOS with Swift and MITIE library (Toy App) 
Named Entity Extraction is one of Natural Language Processing tasks. This project demonstrates tools for performing Named Entity Extraction (NER) on iOS with built-in API and with MITIE library on iOS. In the last case it relies on trained model for English language included with MITIE. Read more about [MITIE](https://github.com/mit-nlp/MITIE).

## Technical Notes
* All MITIE code is C++, used as is without any modifications
* All Xcode models' and view controllers' code is Swift 2.0
* There is a bridge Obj-C code between Xcode NER model and MITIE

## Requirements

* Xcode 7 beta 6 (other versions may require minor code changes)
* MITIE and dlib library 
* NER model file from MITIE (English language 'ner_model.dat' from [MITIE-models-v0.2](http://sourceforge.net/projects/mitie/files/binaries/MITIE-models-v0.2.tar.bz2))

## Basic Idea
This demo CalendarScan app fetchs user's calendar and parse all text info from upcoming Today's events. Then it shows all found named entities for current day in a table view list.

## How To
Download and extract model *'ner_model.dat'* from [MITIE-models-v0.2](http://sourceforge.net/projects/mitie/files/binaries/MITIE-models-v0.2.tar.bz2). Put it to *./CalendarScan/CalendarScan/ner_model.dat*

Open project in Xcode. Compile and run using standard tools. 

Tested in iOS iPhone 6 Simulator with iOS 9.

## Screenshots
Test calendar event:

![Test calendar event](https://raw.githubusercontent.com/marsbroshok/CalendarScan-toy-app/master/Screenshots/EVENT-SAMPLE.png)

Results of iOS built-in NER:

![iOS built-in NER](https://raw.githubusercontent.com/marsbroshok/CalendarScan-toy-app/master/Screenshots/iOS-NER-1.png)

Results of MITIE NER:

![MITIE NER](https://raw.githubusercontent.com/marsbroshok/CalendarScan-toy-app/master/Screenshots/MITIE-NER.png)

