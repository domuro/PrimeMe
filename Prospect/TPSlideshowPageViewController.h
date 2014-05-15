//
//  TPSlideshowPageViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSlideshowViewController.h"
#import "TPEvent.h"

@interface TPSlideshowPageViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property TPEvent *event;
@end
