//
//  TPSelectContentViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/21/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Primer.h"
#import "TPPrimerViewController.h"

@interface TPSelectContentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSString *contentType;
@property NSString *eventName;
//@property Primer *selectedPrimer;
@property NSMutableArray *contentSelection;
@property TPPrimerViewController *sourceViewController;
@property NSIndexPath *indexPath;
@end
