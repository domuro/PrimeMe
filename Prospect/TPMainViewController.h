//
//  TPMainViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/17/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "TPSlideshowPageViewController.h"
#import "TPZoomTransitionDelegate.h"
#import "TPPagedPreviewScrollView.h"
#import "TPSplitViewController.h"
#import "TPSettingsPanelViewController.h"

@interface TPMainViewController : UIViewController <UISplitViewControllerDelegate, UIScrollViewDelegate>

@property TPPagedPreviewScrollView *eventScrollView;
@property UIImage *background;
@property TPSplitViewController *splitViewController;
@property UINavigationController *masterNavViewController;
@property UINavigationController *detailNavViewController;

@end
