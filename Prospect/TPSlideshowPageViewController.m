//
//  TPSlideshowPageViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPAppDelegate.h"
#import "TPSlideshowPageViewController.h"

@interface TPSlideshowPageViewController ()

@end

@implementation TPSlideshowPageViewController
@synthesize event;

unsigned long numEvents;
//int currentPage;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    numEvents = [event.primer.people count] + [event.primer.places count] + [event.primer.activities count];
    TPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *primerArray = [[delegate primers] objectForKey:[event name]];
    numEvents = [primerArray[0] count] + [primerArray[1] count] + [primerArray[2] count];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    TPSlideshowViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    //        currentPage = 0;
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)tapRecognized:(UIGestureRecognizer *) recognizer
{
//    CGPoint location = [recognizer locationInView:self.view];
//    if(location.x < self.view.frame.size.width/6){
//        //try move back
//        if(currentPage>0){
//            NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:currentPage-1]];
//            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
//        }
//    }
//    else if(location.x > self.view.frame.size.width*5/6){
//        //try move forward
//        if(currentPage<numEvents-1){
//            NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:currentPage+1]];
//            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//        }
//    }
//    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TPSlideshowViewController *)viewControllerAtIndex:(NSUInteger)index
{
    TPSlideshowViewController *svc = [[TPSlideshowViewController alloc] init];
    svc.index = index;
    svc.event = event;
    
    return svc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(TPSlideshowViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
//    currentPage = index;
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(TPSlideshowViewController *)viewController index];
    index++;
    if (index == numEvents) {
        return nil;
    }
//    currentPage = index;
    return [self viewControllerAtIndex:index];
}

//add dots
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return numEvents;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
