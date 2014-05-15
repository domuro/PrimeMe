//
//  TPEvent.h
//  Prospect
//
//  Created by Derek Omuro on 4/23/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Primer.h"

@interface TPEvent : NSObject
@property Primer *primer;
@property NSString *name;
@property NSDate *startDate;
@property NSDate *endDate;

//array of content; content is array of images (profile, aux)
@property NSArray *images;
@end
