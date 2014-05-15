//
//  TPSettingsPanelViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPSettingsPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property UINavigationController *detailNavViewController;
@property NSManagedObjectContext *context;

-(void)lockAdd;
-(void)unlockAdd;

@end
