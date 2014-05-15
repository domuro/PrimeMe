//
//  TPPrimerViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPAppDelegate.h"
#import "TPPrimerViewController.h"
#import "TPSelectContentViewController.h"
#import "TMGraphCell.h"
#import "TMGraphCollectionView.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"
#import "Primer.h"

@interface TPPrimerViewController ()

@end

@implementation TPPrimerViewController
@synthesize sourceViewController, contentName;
//Primer *selectedPrimer;
NSMutableArray *primerContent;

TPAppDelegate *delegate;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        delegate = [[UIApplication sharedApplication] delegate];
//        personKeys = [[delegate people] allKeys];
//        placeKeys = [[delegate places] allKeys];
//        activityKeys = [[delegate activities] allKeys];
    }
    return self;
}

UITableView *tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor orangeColor]];
    [self setTitle:self.contentName];
    
    
    //FETCH
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Primer"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError* error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    selectedPrimer = nil;
//    for(Primer *p in fetchedObjects){
//        if([[p name] isEqualToString:self.contentName]){
//            selectedPrimer = p;
//            break;
//        }
//    }
//    
//    people = [[selectedPrimer people] allObjects];
//    places = [[selectedPrimer places] allObjects];
//    activities = [[selectedPrimer activities] allObjects];
    
    primerContent = [[delegate primers] objectForKey:contentName];
    
    int screenWidth = 768;
    int screenHeight = 1024;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; //what does this do
    [tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)]];
    [tableView setMultipleTouchEnabled:NO];
    
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"People";
            break;
        case 1:
            return @"Places";
            break;
        default:
            return @"Activities";
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    TMGraphCell *cell = (TMGraphCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[TMGraphCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TMGraphCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
}

#pragma mark - UITableViewDelegate Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned long items;
    switch (indexPath.section) {
        case 0:
            items = [primerContent[0] count];
            break;
        case 1:
            items = [primerContent[1] count];
            break;
        default:
            items = [primerContent[2] count];
            break;
    }
    if(items == 0){
        items = 1;
    }
    int rows = ceil(items/4.);
    int rowHeight = 128+40;
    return rows * rowHeight;
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)collectionView:(TMGraphCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    UITableViewCell *tableViewCell = (UITableViewCell*) collectionView.superview.superview.superview;
    UITableView *tableView = (UITableView*) collectionView.superview.superview.superview.superview.superview;
    long tSection = [tableView indexPathForCell:tableViewCell].section;
    unsigned long items;
    switch (tSection) {
        case 0:
            items = [primerContent[0] count];
            break;
        case 1:
            items = [primerContent[1] count];
            break;
        default:
            items = [primerContent[2] count];
            break;
    }
    if(items == 0){
        return 1;
    }
    return items;
}

-(UICollectionViewCell *)collectionView:(TMGraphCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    UITableView *tableView = (UITableView *)collectionView.superview.superview.superview.superview.superview;
    UITableViewCell *tableViewCell = (UITableViewCell *)collectionView.superview.superview.superview;
    long tSection = [tableView indexPathForCell:tableViewCell].section;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    UIImage *image;
    switch(tSection){
        case 0:
            if([primerContent[0] count] != 0)
                image = [[[delegate people] objectForKey:[primerContent[0] objectAtIndex:indexPath.row]] objectAtIndex:0];
            break;
        case 1:
            if([primerContent[1] count] != 0)
                image = [[[delegate places] objectForKey:[primerContent[1] objectAtIndex:indexPath.row]] objectAtIndex:0];
            break;
        default:
            if([primerContent[2] count] != 0)
                image = [[[delegate activities] objectForKey:[primerContent[2] objectAtIndex:indexPath.row]] objectAtIndex:0];
            break;
    }
    
    if(!image)
        image = [UIImage imageNamed:@"squareplaceholder.png"];
    [imageView setImage:image];
    
    [cell.contentView addSubview:imageView];
    return cell;
}

-(void) contentTapped:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:tapLocation];
    
    if(indexPath){
        TPSelectContentViewController *scvc = [[TPSelectContentViewController alloc] init];
        scvc.eventName = contentName;
        scvc.contentSelection = nil;
        NSString *contentType;
        
            switch (indexPath.section) {
            case 0:
                contentType = @"Person";
//                scvc.contentSelection = [NSMutableArray arrayWithArray:[selectedPrimer.people allObjects]];
//                scvc.contentSelection = [[[delegate primers] objectForKey:contentName] objectAtIndex:0];
                if(primerContent){
                    scvc.contentSelection = [primerContent objectAtIndex:0];
                }
                break;
            case 1:
                contentType = @"Place";
//                scvc.contentSelection = [NSMutableArray arrayWithArray:[selectedPrimer.places allObjects]];
                if(primerContent){
                    scvc.contentSelection = [primerContent objectAtIndex:1];
                }
                break;
            default:
                contentType = @"Activity";
//                scvc.contentSelection = [NSMutableArray arrayWithArray:[selectedPrimer.activities allObjects]];
                if(primerContent){
                    scvc.contentSelection = [primerContent objectAtIndex:2];
                }
                break;
        }
        if (!scvc.contentSelection) {
            scvc.contentSelection = [[NSMutableArray alloc] init];
        }

        //TODO CD
//        if(selectedPrimer == nil){
//            selectedPrimer = [NSEntityDescription insertNewObjectForEntityForName:@"Primer" inManagedObjectContext:context];
//        }
//        scvc.selectedPrimer = selectedPrimer;
        scvc.sourceViewController = self;
        scvc.contentType = contentType;
        scvc.indexPath = indexPath;
//        if([contentType isEqualToString:@"Person"]){
//            scvc.contentSelection = primerContent[0];
//        }
//        else if([contentType isEqualToString:@"Place"]){
//            scvc.contentSelection = primerContent[1];
//        }
//        else{
//            scvc.contentSelection = primerContent[2];
//        }
        [self.navigationController pushViewController:scvc animated:YES];
    }
}

-(void) didMoveToParentViewController:(UIViewController *)parent
{
    //popping this view
    if (parent == nil) {
        //refresh source
//        TODO CD
        if (!([primerContent[0] count] == 0 || [primerContent[1] count] == 0 || [primerContent[2] count] == 0)) {
            [delegate writePrimer:contentName withContent:primerContent];
            [sourceViewController refresh];
        }
//
//        //save
//        NSError *error;
//        if (![context save:&error]) {
//            NSLog(@"Error saving: %@", [error localizedDescription]);
//        }
    }
}

- (void) refreshWithIndexPath:(NSIndexPath *)indexPath withContentType:(NSString *)type withContentSelection:(NSArray *)contentSelection
{
//    primerContent = [[delegate primers] objectForKey:contentName];
    if(!primerContent){
        primerContent = [[NSMutableArray alloc] init];
        for(int i = 0; i < 3; i++){
            [primerContent addObject:[[NSMutableArray alloc] init]];
        }
    }
    primerContent = [primerContent mutableCopy];
    
    if([type isEqualToString:@"Person"]){
        primerContent[0] = contentSelection;
    }
    else if([type isEqualToString:@"Place"]){
        primerContent[1] = contentSelection;
    }
    else{
        primerContent[2] = contentSelection;
    }
    [tableView reloadData];
    TMGraphCell* cell = (TMGraphCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.collectionView reloadData];
}

@end
