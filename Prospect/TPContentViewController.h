//
//  TPContentViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSettingsPanelViewController.h"

@interface TPContentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
//@property NSMutableArray *contentData;
@property TPSettingsPanelViewController *settingsPanelViewController;

-(void)setContentType:(NSString *)type;
-(void)refresh;

@end
