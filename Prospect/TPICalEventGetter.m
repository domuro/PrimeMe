//
//  TPICalEventGetter.m
//  Prospect
//
//  Created by Derek Omuro on 4/23/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPICalEventGetter.h"

@implementation TPICalEventGetter


+(NSArray *) getCalendarEvents
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
    }];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:[self beginningOfDay:[NSDate date]] endDate:
                                                                     [self endOfDay:[NSDate date]]
                                                                          calendars:nil];
    NSArray *events = [store eventsMatchingPredicate:predicate];
    return events;
}

+(NSDate *)beginningOfDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}

+(NSDate *)endOfDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
   NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [cal dateFromComponents:components];
    
}

@end