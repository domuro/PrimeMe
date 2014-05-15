//
//  TPContentViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "UIViewController+MHSemiModal.h"
#import "TPContentViewController.h"
#import "TPAddContentViewController.h"
#import "TPAppDelegate.h"
#import "Primer.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"

@interface TPContentViewController ()

@end

@implementation TPContentViewController
//@synthesize contentData, context;

UICollectionView *contentCollectionView;
NSString *contentType;
NSMutableDictionary *contentData;
NSArray *contentDataKeys;
TPAppDelegate *delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        delegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

//FETCH
-(void)setContentType:(NSString *)type
{
    contentType = type;
    contentData = [delegate contentWithType:type];
    contentDataKeys = [contentData allKeys];
    
//    //CoreData fetch for type
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:type
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    
//    //TODO: reformat model to have abstract Content...
//    NSMutableArray *tempContentData = [[NSMutableArray alloc] init];
//    for (id i in fetchedObjects) {
//        if([type isEqualToString:@"Person"]){
//            [tempContentData addObject:(Person *)i];
//        }
//        else if ([type isEqualToString:@"Place"]){
//            [tempContentData addObject:(Place *)i];
//        }
//        else if ([type isEqualToString:@"Activity"]){
//            [tempContentData addObject:(Activity *)i];
//        }
//    }
//    contentData = [tempContentData copy];
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
//    UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:[[contentData objectAtIndex:indexPath.row] thumbnail]];
    NSString *key = [contentDataKeys objectAtIndex:indexPath.row];
    UIImage *image = [[contentData objectForKey:key] objectAtIndex:0];
    [imageView setImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)contentTapped:(UIGestureRecognizer *) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:contentCollectionView];
    NSIndexPath *indexPath = [contentCollectionView indexPathForItemAtPoint:tapLocation];
    
    if(indexPath){
        TPAddContentViewController *acvc = [[TPAddContentViewController alloc] init];
        [acvc setContentType:contentType];
//        [acvc setEntity:[contentData objectAtIndex:indexPath.row]];
        [acvc setContentName:[contentDataKeys objectAtIndex:indexPath.row]];
        [acvc setSourceViewController:self.settingsPanelViewController];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:acvc];
        [self.settingsPanelViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(nothing)]];
        [self.navigationController mh_presentSemiModalViewController:nav animated:YES];
    }
}

- (void)nothing{}

//FETCH
- (void)refresh
{
    [self setContentType:contentType];
    [contentCollectionView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [contentCollectionView setBackgroundColor:[UIColor whiteColor ]];
    [contentCollectionView setDataSource:self];
    [contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ContentCollectionItem"];
    [contentCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)]];
    [contentCollectionView setMultipleTouchEnabled:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:contentCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
