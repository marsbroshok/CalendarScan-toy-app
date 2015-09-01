//
//  NER.m
//  CalendarScan
//
//  Created by Alexander on 21/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//


#include <mitie/named_entity_extractor.h>
#include <mitie/conll_tokenizer.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstdlib>
#include <iosfwd>
#import "NER.h"
#import "ner_file.h"

using namespace std;
using namespace mitie;

@interface NER()


@end

@implementation NER
named_entity_extractor _ner;


//named_entity_extractor _ner;

- (id) initWithNERmodel: (NSString *) modelFilepath {
    self = [super init];
    if (self) {
        // Load MITIE's named entity extractor from disk in background
//        dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//        dispatch_async(queue, ^{
            string classname;
            dlib::deserialize([modelFilepath UTF8String]) >> classname >> _ner;
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSNotification *modelLoadedNotification = [NSNotification notificationWithName:@"NERModelLoaded" object:self];
//                [[NSNotificationCenter defaultCenter] postNotification:modelLoadedNotification];
//            });
       // });
    }
    return self;
}

vector<string> tokenize_string (
                              const char *input_string
                              )
{
    // The conll_tokenizer splits the contents of an istream into a bunch of words and is
    // MITIE's default tokenization method.
    std::istringstream strstream(input_string);
    conll_tokenizer tok(strstream);
    vector<string> tokens;
    string token;
    // Read the tokens out of the file one at a time and store into tokens.
    while(tok(token))
    tokens.push_back(token);
    
    return tokens;
}

- (NSArray *) findNamedEntitiesForString:(NSString *) inputString
{
    // Obj-C bridge
    NSMutableArray *arrayOfTokens = [@[] mutableCopy];
    const char *input_str = [inputString UTF8String];
    
    try
    {
        // Print out what kind of tags this tagger can predict.
        const vector<string> tagstr = _ner.get_tag_name_strings();
        cout << "The tagger supports "<< tagstr.size() <<" tags:" << endl;
        for (unsigned int i = 0; i < tagstr.size(); ++i)
            cout << "   " << tagstr[i] << endl;
        
        
        // Before we can try out the tagger we need to load some data.
        vector<string> tokens = tokenize_string(input_str);
        
        vector<pair<unsigned long, unsigned long> > chunks;
        vector<unsigned long> chunk_tags;
        vector<double> chunk_scores;
        vector< vector<string> > found_entities;
        
        // Obj-C bridge
        NSString *entityCat;
        NSMutableString *token;
        NSNumber *entityScore;
        
        // Now detect all the entities in the text
        _ner.predict(tokens, chunks, chunk_tags, chunk_scores);
        
        cout << "\nNumber of named entities detected: " << chunks.size() << endl;
        for (unsigned int i = 0; i < chunks.size(); ++i)
        {
            cout << "   Tag " << chunk_tags[i] << ": ";
            cout << "Score: " << fixed << setprecision(3) << chunk_scores[i] << ": ";
            cout << tagstr[chunk_tags[i]] << ": ";
            entityCat = [NSString stringWithUTF8String:tagstr[chunk_tags[i]].c_str()]; // Obj-C bridge
            entityScore = [NSNumber numberWithFloat:chunk_scores[i]]; // Obj-C bridge
            token = [@"" mutableCopy]; // Obj-C bridge
            // chunks[i] defines a half open range in tokens that contains the entity.
            for (unsigned long j = chunks[i].first; j < chunks[i].second; ++j)
            {
                cout << tokens[j] << " ";
                [token appendString:[NSString stringWithUTF8String:tokens[j].c_str()]]; [token appendString:@" "]; // Obj-C bridge
            }
            
            cout << endl;
            
            // Obj-C bridge
            [arrayOfTokens addObject:@{@"Tag":entityCat, @"Score":entityScore, @"Token":token}];
        }
        
        return [arrayOfTokens copy];
    }
    catch (std::exception& e)
    {
        cout << e.what() << endl;
        return [arrayOfTokens copy];    }
}


@end
