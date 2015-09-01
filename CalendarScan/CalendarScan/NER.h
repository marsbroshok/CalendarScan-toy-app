//
//  sample.h
//  CalendarScan
//
//  Created by Alexander on 21/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NER : NSObject
- (id) initWithNERmodel: (NSString *) modelFilepath;
- (NSArray *) findNamedEntitiesForString:(NSString *) inputString;
@end
