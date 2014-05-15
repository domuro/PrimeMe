//
//  TPScheduleTableViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPScheduleTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *calendarEvents;

-(void) refresh;
@end
