//
//  TPSelectContentViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/21/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPSelectContentViewController.h"
#import "UIViewController+MHSemiModal.h"
#import "TPAppDelegate.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"

@interface TPSelectContentViewController ()

@end

@implementation TPSelectContentViewController
@synthesize eventName, contentType, contentSelection, sourceViewController;

UICollectionView *contentCollectionView;
NSArray *contentData; //keys of current contentType dictionary

//NSManagedObjectContext *context;
TPAppDelegate* delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = [[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *plural;
    if([contentType isEqualToString:@"Person"]){
        plural = @"People";
    }
    else if([contentType isEqualToString:@"Place"]){
        plural = @"Places";
    }
    else{
        plural = @"Activities";
    }

    [self setTitle:[NSString stringWithFormat:@"Select %@", plural]];
    
    //CollectionView
    int sideBarSize = 320;
    int width = self.view.frame.size.height - sideBarSize;
    int height = self.view.frame.size.width;
    int unit = width/21;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset: UIEdgeInsetsMake(unit, unit, unit, unit)];
    [layout setItemSize: CGSizeMake(4*unit, 4*unit)];
    [layout setMinimumInteritemSpacing: unit];
    [layout setMinimumLineSpacing: unit];
    [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
    
    contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:layout];
    [contentCollectionView setBackgroundColor:[UIColor whiteColor]];
    [contentCollectionView setDataSource:self];
    [contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ContentCollectionItem"];
    [contentCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)]];
    [contentCollectionView setMultipleTouchEnabled:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:contentCollectionView];
    
    //fetch all content
//    context = [(TPAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    [self fetchContentData];
    contentData = [[delegate contentWithType:contentType] allKeys];
}

//FETCH
//-(void)fetchContentData
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:contentType
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    contentData = [context executeFetchRequest:fetchRequest error:&error];
//
//}

- (void)contentTapped:(UIGestureRecognizer *) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:contentCollectionView];
    NSIndexPath *indexPath = [contentCollectionView indexPathForItemAtPoint:tapLocation];
    
    if(indexPath){
//        if([contentSelection containsObject:[contentData objectAtIndex:indexPath.row]]){
        BOOL flag = false;
        for (NSString *s in contentSelection){
            if ([s isEqualToString:[contentData objectAtIndex:indexPath.row]]) {
                contentSelection = [contentSelection mutableCopy];
                [contentSelection removeObject:s];
                [[contentCollectionView cellForItemAtIndexPath:indexPath] setAlpha:1];
                ((UIView *)[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews objectAtIndex:[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews count] - 1]).alpha = .0;
                flag = true;
            }
        }
            //deselect content
//            [contentSelection removeObject:[contentData objectAtIndex:indexPath.row]];
//            [[contentCollectionView cellForItemAtIndexPath:indexPath] setAlpha:1];
//            NSLog(@"%@", [[contentCollectionView cellForItemAtIndexPath:indexPath] class]);
        if(!flag){
            //select content
            contentSelection = [contentSelection mutableCopy];
            [contentSelection addObject:[contentData objectAtIndex:indexPath.row]];
            [[contentCollectionView cellForItemAtIndexPath:indexPath] setAlpha:1.0];
                       ((UIView *)[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews objectAtIndex:[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews count] - 1]).frame =  ((UIView *)[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews objectAtIndex:[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews count] - 2]).frame;
            ((UIView *)[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews objectAtIndex:[[contentCollectionView cellForItemAtIndexPath:indexPath].contentView.subviews count] - 1]).alpha = 1.0;
            
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [contentData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContentCollectionItem";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    UIImage *image;
    if([contentType isEqualToString:@"Person"]){
//        image = [NSKeyedUnarchiver unarchiveObjectWithData:[(Person*)[contentData objectAtIndex:indexPath.row] thumbnail]];
        image = [[[delegate people] objectForKey:[contentData objectAtIndex:indexPath.row]] objectAtIndex:0];
    }
    else if([contentType isEqualToString:@"Place"]){
        image = [[[delegate places] objectForKey:[contentData objectAtIndex:indexPath.row]] objectAtIndex:0];
    }
    else{
        image = [[[delegate activities] objectForKey:[contentData objectAtIndex:indexPath.row]] objectAtIndex:0];
    }
    
    [imageView setImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    if([contentType isEqualToString:@"Person"] || [contentType isEqualToString:@"Place"] || [contentType isEqualToString:@"Activity"])
    {
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]]];
        ((UIView*)[cell.contentView.subviews objectAtIndex:[cell.contentView.subviews count]-1]).frame = ((UIView*)[cell.contentView.subviews objectAtIndex:[cell.contentView.subviews count]-2]).frame;
        ((UIView*)[cell.contentView.subviews objectAtIndex:[cell.contentView.subviews count]-1]).alpha = .0;
        
        if([contentSelection containsObject:[contentData objectAtIndex:indexPath.row]]){
            ((UIView*)[cell.contentView.subviews objectAtIndex:[cell.contentView.subviews count]-1]).alpha = 1.0;
        }
    }
    
    return cell;
}

//User goes back.
- (void)viewWillDisappear:(BOOL)animated
{
//    if (selectedPrimer == nil){
//        //instert new
//        selectedPrimer = [NSEntityDescription insertNewObjectForEntityForName:@"Primer" inManagedObjectContext:context];
//    }
//    if([contentType isEqualToString:@"Person"]){
//        selectedPrimer.people = [NSSet setWithArray:contentSelection];
//    }
//    else if([contentType isEqualToString:@"Place"]){
//        selectedPrimer.places = [NSSet setWithArray:contentSelection];
//    }
//    else{
//        selectedPrimer.activities = [NSSet setWithArray:contentSelection];
//    }
//    [selectedPrimer setName:eventName];
    
//    write to core data
//    if () {
//        [delegate writePrimer:eventName withType:contentType withContent:contentSelection];
//    }
    
    //refresh
    [sourceViewController refreshWithIndexPath:self.indexPath withContentType:contentType withContentSelection:contentSelection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
