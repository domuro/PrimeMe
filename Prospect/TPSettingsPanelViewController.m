//
//  TPSettingsPanelViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPSettingsPanelViewController.h"
#import "UIViewController+MHSemiModal.h"
#import "TPAddContentViewController.h"
#import "TPContentViewController.h"
#import "TPScheduleTableViewController.h"

@interface TPSettingsPanelViewController ()

@end

@implementation TPSettingsPanelViewController
@synthesize detailNavViewController, context;

NSArray *data;
bool isAddLocked = NO;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

UITableView *menu;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    data = [[NSArray alloc] initWithObjects:@"Schedule", @"People", @"Places", @"Activities", nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:224/255. green:180/255. blue:71/255. alpha:1]];
    int width = 320;
    int height = self.view.frame.size.width;
    
    menu = [[UITableView alloc] initWithFrame:CGRectMake(0, height/2, width, height/2)
                                        style:UITableViewStylePlain];
    [menu setScrollEnabled:NO];
    [menu setDataSource:self];
    [menu setRowHeight: menu.frame.size.height/4];
    [menu setContentInset: UIEdgeInsetsMake(-64, 0, 0 ,0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [menu addGestureRecognizer:tap];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [menu selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    [menu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(40, height/2-280, 240, 240)];
    [self setRoundedView:dateView toDiameter:240];
    [dateView setBackgroundColor:[UIColor whiteColor]];
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateView.frame.size.height/9, dateView.frame.size.width, dateView.frame.size.height/4)];
    [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
    [weekdayLabel setTextColor:[UIColor redColor]];
    [weekdayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32]];
    [weekdayLabel setText:[df weekdaySymbols][components.weekday-1]];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateView.frame.size.height/3.2, dateView.frame.size.width, dateView.frame.size.height/2)];
    [dayLabel setTextAlignment:NSTextAlignmentCenter];
    [dayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [dayLabel setTextColor:[UIColor blackColor]];
    [dayLabel setText:[NSString stringWithFormat:@"%d", (int)components.day]];
    
    UIView *whiteTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 64)];
    [whiteTop setBackgroundColor:[UIColor whiteColor]];
    
    //Import in settings panel
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleDone target:self action:@selector(importCalendar)]];
    
    [dateView addSubview: weekdayLabel];
    [dateView addSubview: dayLabel];
    [self.view addSubview:menu];
    [self.view addSubview:dateView];
    [self.view addSubview:whiteTop];
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingsTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    //Image
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    int padding = frame.size.height * 1/8;
    int height = frame.size.height - padding*2;
    int width = height;
    CGRect previewRect = CGRectMake(padding, padding, width, height);
    
    UIImageView *menuIcon = [[UIImageView alloc] initWithFrame:previewRect];
    if(indexPath.row == 0){
        [menuIcon setImage:[UIImage imageNamed:@"schedulecolor.png"]];
    }
    else if(indexPath.row == 1){
        [menuIcon setImage:[UIImage imageNamed:@"personcolor.png"]];
    }
    else if(indexPath.row == 2){
        [menuIcon setImage:[UIImage imageNamed:@"pincolor.png"]];
    }
    else{
        [menuIcon setImage:[UIImage imageNamed:@"activitycolor.png"]];
    }
    [menuIcon setContentMode:UIViewContentModeScaleAspectFill];
    [menuIcon setClipsToBounds:YES];
    [self setRoundedView:menuIcon toDiameter:width];
    [cell addSubview:menuIcon];
    
    //Label
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32]];
    int extraOffset = 10;
    [cell setSeparatorInset:UIEdgeInsetsMake(0, padding*2+width+extraOffset, 0, 0)];
    
    //Hack to complete bottom border.
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, height+padding*2-0.5, frame.size.width, 0.5)];
    [grayLine setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:grayLine];

    return cell;
}

UIBarButtonItem *rightButton;
-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    [context rollback];
    if(isAddLocked){
        [self mh_dismissSemiModalViewController:self.detailNavViewController.viewControllers[1] animated:YES];
        [self unlockAdd];
    }
    CGPoint tapLocation = [recognizer locationInView:menu];
    NSIndexPath *indexPath = [menu indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) {
        recognizer.cancelsTouchesInView = NO;
        UIViewController *temp = detailNavViewController.viewControllers[0];
        UIBarButtonItem *done = temp.navigationItem.rightBarButtonItem;
        //Schedule
        if(indexPath.row == 0){
            [detailNavViewController setViewControllers:@[[[TPScheduleTableViewController alloc] init]] animated:NO];
            TPScheduleTableViewController *vc = detailNavViewController.viewControllers[0];
            [vc setTitle:@"Schedule"];
            [vc.navigationItem setRightBarButtonItem:done];
//            rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleDone target:self action:@selector(importCalendar)];
            rightButton = nil;
            [self.view setBackgroundColor:[UIColor colorWithRed:224/255. green:180/255. blue:71/255. alpha:1]];
        }
        //Person
        else if(indexPath.row == 1){
            [detailNavViewController setViewControllers:@[[[TPContentViewController alloc] init]] animated:NO];
            TPContentViewController *vc = detailNavViewController.viewControllers[0];
            [vc setTitle:@"People"];
            [vc setSettingsPanelViewController:self];
            [vc setContentType:@"Person"];
            [vc.navigationItem setRightBarButtonItem:done];
            rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
            [self.view setBackgroundColor:[UIColor colorWithRed:102/255. green:186/255. blue:223/255. alpha:1]];
        }
        //Place
        else if(indexPath.row == 2){
            [detailNavViewController setViewControllers:@[[[TPContentViewController alloc] init]] animated:NO];
            TPContentViewController *vc = detailNavViewController.viewControllers[0];
            [vc setTitle:@"Places"];
            [vc setSettingsPanelViewController:self];
            [vc setContentType:@"Place"];
            [vc.navigationItem setRightBarButtonItem:done];
            rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlace)];
            [self.view setBackgroundColor:[UIColor colorWithRed:227/255. green:103/255. blue:129/255. alpha:1]];
        }
        //Activity
        else if(indexPath.row == 3){
            [detailNavViewController setViewControllers:@[[[TPContentViewController alloc] init]] animated:NO];
            TPContentViewController *vc = detailNavViewController.viewControllers[0];
            [vc setTitle:@"Activities"];
            [vc setSettingsPanelViewController:self];
            [vc setContentType:@"Activity"];
            [vc.navigationItem setRightBarButtonItem:done];
            rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addActivity)];
            [self.view setBackgroundColor:[UIColor colorWithRed:116/255. green:192/255. blue:84/255. alpha:1]];
        }
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
}

- (void)addPerson
{
    //Initialize from Storyboard maybe
    //TODO: Cancel and Done buttons for NavigationController; Reconnect Add button
    TPAddContentViewController *acvc = [[TPAddContentViewController alloc] init];
    acvc.sourceViewController = self;
    acvc.contentType = @"Person";
    
    //Disconnect Add button
    [self lockAdd];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:acvc];
    [self.detailNavViewController mh_presentSemiModalViewController:nav animated:YES];
}

- (void)addPlace
{
    //Initialize from Storyboard maybe
    //TODO: Cancel and Done buttons for NavigationController; Reconnect Add button
    TPAddContentViewController *acvc = [[TPAddContentViewController alloc] init];
    acvc.sourceViewController = self;
    acvc.contentType = @"Place";
    
    //Disconnect Add button
    [self lockAdd];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:acvc];
    [self.detailNavViewController mh_presentSemiModalViewController:nav animated:YES];
}

- (void)addActivity
{
    //Initialize from Storyboard maybe
    //TODO: Cancel and Done buttons for NavigationController; Reconnect Add button
    TPAddContentViewController *acvc = [[TPAddContentViewController alloc] init];
    acvc.sourceViewController = self;
    acvc.contentType = @"Activity";
    
    //Disconnect Add button
    [self lockAdd];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:acvc];
    [self.detailNavViewController mh_presentSemiModalViewController:nav animated:YES];
}

-(void)nothing{}

-(void)unlockAdd
{
    isAddLocked = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}
-(void)lockAdd
{
    isAddLocked = YES;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(nothing)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
