//
//  TPAddContentViewController.h
//  Prospect
//
//  Created by Derek Omuro on 4/21/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSettingsPanelViewController.h"

@interface TPAddContentViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property TPSettingsPanelViewController *sourceViewController;
@property NSString *contentType;
@property (nonatomic, strong) UIPopoverController *popOver;
@property NSString *contentName;

@end
