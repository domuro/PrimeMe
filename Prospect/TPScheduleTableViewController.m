//
//  TPScheduleTableViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPScheduleTableViewController.h"
#import "TPPrimerViewController.h"
#import "TPAppDelegate.h"
#import "Primer.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"
#import "TPICalEventGetter.h"

@interface TPScheduleTableViewController ()

@end

@implementation TPScheduleTableViewController
@synthesize calendarEvents;

UITableView *eventTableView;
//NSArray *primers;
TPAppDelegate *delegate;
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
    delegate = [[UIApplication sharedApplication] delegate];
    
    // TODO: Set from EventKit
    calendarEvents = [[NSMutableArray alloc] init];
    calendarEvents = [[TPICalEventGetter getCalendarEvents] mutableCopy];
    //[calendarEvents addObject:@"School"];
    //[calendarEvents addObject:@"Doctor"];
    //[calendarEvents addObject:@"Dinner"];
    
    //Create table //BUG: MultiTouch selects a row. (minor)
    int width = 1024-320;
    int height = 768;
    eventTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height) style: UITableViewStylePlain];
    [eventTableView setDataSource:self];
    [eventTableView setRowHeight: eventTableView.frame.size.height/8];
    if ([eventTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [eventTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [eventTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [eventTableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventTapped:)]];
    [eventTableView setMultipleTouchEnabled:NO];

    //Fetch primers; use dictionary instead.
//    primers = [self fetchPrimers];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleDone target:self action:@selector(importCalendar)]];
    
    [self.view addSubview:eventTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [calendarEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EventTableCell"];
    
    //TODO: maybe change this based on how EventKit events are fetched.
    NSString *eventName = ((EKEvent *)[calendarEvents objectAtIndex:indexPath.row]).title;//index out of boud error if function is called for larger values
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
//    Primer *primer;
//    for(Primer *p in primers){
//        if([p.name isEqualToString:eventName]){
//            primer = p;
//            break;
//        }
//    }
    NSArray* primer = [[delegate primers] objectForKey:eventName];
    
    //Create preview
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    
    int padding = frame.size.height * 1/9;
    int height = frame.size.height - padding*2;
    int width = height * 16/9;
    CGRect previewRect = CGRectMake(padding, padding, width, height);
    
    if(primer != nil){
        UIView *preview = [self eventPreviewWithFrame:previewRect withPrimer:primer];
        [cell addSubview:preview];
    }
    else{
        UIImageView *placeholder = [[UIImageView alloc] initWithFrame:previewRect];
        //TODO: correct image
        [placeholder setImage:[UIImage imageNamed:@"rectplaceholder.png"]];
        [placeholder setContentMode:UIViewContentModeScaleAspectFill];
        [placeholder setClipsToBounds:YES];
        [cell addSubview:placeholder];
    }
    
    //Create text
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    NSDate *start = ((EKEvent *)[calendarEvents objectAtIndex:indexPath.row]).startDate;
    NSDate *end = ((EKEvent *)[calendarEvents objectAtIndex:indexPath.row]).endDate;
    NSString *timeString = [[dateFormatter stringFromDate:start] stringByAppendingString:[@" - " stringByAppendingString: [dateFormatter stringFromDate:end]]];
    
    [cell.textLabel setText:eventName];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [cell.detailTextLabel setText: timeString];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, padding*2+width, 0, 0)];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, height+padding*2-0.5, frame.size.width, 0.5)];
    [grayLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [cell addSubview:grayLine];
    return cell;
}

-(void) eventTapped:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:eventTableView];
    NSIndexPath *indexPath = [eventTableView indexPathForRowAtPoint:tapLocation];

    if(indexPath){
        NSString *eventName = [eventTableView cellForRowAtIndexPath:indexPath].textLabel.text;
        TPPrimerViewController *pvc = [[TPPrimerViewController alloc] init];
        pvc.contentName = eventName;
        pvc.sourceViewController = self;
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

//- (UIView *)eventPreviewWithFrame:(CGRect)frame withPrimer:(Primer *)primer
- (UIView *)eventPreviewWithFrame:(CGRect)frame withPrimer:(NSArray *)primer
{
    UIView *preview = [[UIView alloc] initWithFrame:frame];
    int third = frame.size.width / 3.;
    int height = frame.size.height;

    //primer name = primer[0 (people)][0 (first person)]
    UIImage *image1 = [[delegate people] objectForKey:primer[0][0]][0];
    UIImage *image2 = [[delegate places] objectForKey:primer[1][0]][0];
    UIImage *image3 = [[delegate activities] objectForKey:primer[2][0]][0];

//    UIImage *image1 = [NSKeyedUnarchiver unarchiveObjectWithData:((Person *)[[primer people] allObjects][0]).thumbnail];
//    UIImage *image2 = [NSKeyedUnarchiver unarchiveObjectWithData:((Place *)[[primer places] allObjects][0]).thumbnail];
//    UIImage *image3 = [NSKeyedUnarchiver unarchiveObjectWithData:((Activity *)[[primer activities] allObjects][0]).thumbnail];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, third, height)];
    [imageView1 setImage:image1];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView1 setClipsToBounds:YES];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(third+1, 0, third, height)];
    [imageView2 setImage:image2];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView2 setClipsToBounds:YES];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(third*2+2, 0, third, height)];
    [imageView3 setImage:image3];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView3 setClipsToBounds:YES];
    
    [preview addSubview:imageView1];
    [preview addSubview:imageView2];
    [preview addSubview:imageView3];
    
    return preview;
}

- (void) importCalendar
{
    
}

//-(NSArray*)fetchPrimers
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Primer"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    return [context executeFetchRequest:fetchRequest error:&error];
//}

- (void) refresh
{
//    primers = [self fetchPrimers];
    [eventTableView reloadData];
}

@end
