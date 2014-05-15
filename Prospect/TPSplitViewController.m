//
//  TPSplitViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/21/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPAppDelegate.h"
#import "TPSplitViewController.h"
#import "TPSettingsPanelViewController.h"
#import "TPScheduleTableViewController.h"

@interface TPSplitViewController ()

@end

@implementation TPSplitViewController
//@synthesize masterViewController, detailViewController;
@synthesize context;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self.view setMultipleTouchEnabled:NO];
    int height = 768;
    int width = 1024;
    int sidebar = 320;
    TPSettingsPanelViewController *masterViewController = [[TPSettingsPanelViewController alloc] init];
    [masterViewController setContext:context];
    
    TPScheduleTableViewController *detailViewController = [[TPScheduleTableViewController alloc] init];
    
    UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [masterViewController setTitle:@"Settings"];
    
    UINavigationController *detailNavViewController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [detailViewController setTitle:@"Schedule"];
    [detailViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)]];
    
    [masterViewController setDetailNavViewController:detailNavViewController];
    
    //Add ChildVCs
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sidebar, height)];
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(sidebar, 0, width-sidebar, height)];
    
    [self addChildViewController:masterNavViewController];
    masterNavViewController.view.frame = left.frame;
    [left addSubview:masterNavViewController.view];
    [masterNavViewController didMoveToParentViewController:self];
    
    [self addChildViewController:detailNavViewController];
    detailNavViewController.view.frame = CGRectMake(0, 0, width-sidebar, height);
    [right addSubview:detailNavViewController.view];
    [detailNavViewController didMoveToParentViewController:self];
    
    //Separator view
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(sidebar, 0, 0.5, height)];
    [separator setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:right];
    [self.view addSubview:left];
    [self.view addSubview:separator];
}

- (void)dismissView
{
    [(TPAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
