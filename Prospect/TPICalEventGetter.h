//
//  TPICalEventGetter.h
//  Prospect
//
//  Created by Derek Omuro on 4/23/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface TPICalEventGetter : NSObject

+(NSArray *) getCalendarEvents;

@end
