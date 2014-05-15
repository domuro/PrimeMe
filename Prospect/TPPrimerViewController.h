//
//  TPPrimerViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Primer.h"
#import "TPScheduleTableViewController.h"

@interface TPPrimerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property NSString *contentName;
@property TPScheduleTableViewController *sourceViewController;

- (void) refreshWithIndexPath:(NSIndexPath *)indexPath withContentType:(NSString*)type withContentSelection:(NSArray*)contentSelection;
@end
