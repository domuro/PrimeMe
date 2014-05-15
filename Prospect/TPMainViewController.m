//
//  TPMainViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/17/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//
// CoreData

#import <QuartzCore/QuartzCore.h>
#import "TPMainViewController.h"
#import "TPAppDelegate.h"
#import "TPEvent.h"

#import "Primer.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"
#import "TPICalEventGetter.h"

@interface TPMainViewController ()
@end

@implementation TPMainViewController

@synthesize background, eventScrollView, splitViewController, masterNavViewController, detailNavViewController;

// grabbed from the scroll view;
double time_min = 0;
double width;
double height;
UIColor *color1;
UIColor *color2;
UIColor *sun_color;
int sun_radius = 50;
CAGradientLayer *gradient;
int Sun_X_pos;
int Sun_Y_pos;
int Moon_X_pos;
int Moon_Y_pos;
int ground_height1 = (int) 768*(1./6);//update if nessasary
int ground_height2 = (int) 768/9;
int city_height = (int) (2*768)/9;
int screen_height = 768;
int screen_width = 1024;
float pi = 3.14159;
UIImageView *skyView;
UIImageView *groundView;
UIImageView *townDayView;
UIImageView *townNightView;
UIImageView *starview;
UIImageView *moonView;
UIImageView *sunView;
int eventIndex = 0;

//of TPEvents
NSMutableArray *events;
TPAppDelegate *delegate;
int testtime= 10*60;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        [[UIApplication sharedApplication] delegate];
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        delegate = [[UIApplication sharedApplication] delegate];
        [delegate fetchContent];
        
        [self getEvents];
        skyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"skynight.png"]]];
        starview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8bitstars.png"]];
        moonView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Moon.png"]]];
        townDayView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"DayTransFinal"]]];
        townDayView.frame = CGRectMake(0, screen_height-city_height-ground_height1 +20, screen_width, city_height);
        townNightView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"NightTransFinal.png"]]];
        townNightView.frame = CGRectMake(0, screen_height-city_height-ground_height1 +20, screen_width, city_height);
        groundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mountains.png"]];
        groundView.frame = CGRectMake(0, screen_height /2 + 11, screen_width, screen_height/2);
        sunView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sun_radius*2, sun_radius*2)];
        [sunView setBackgroundColor:[UIColor yellowColor]];
        [self setRoundedView:sunView toDiameter:sun_radius*2 xCord:0 yCord:0];
        townNightView.alpha = 0.0;
        
        [self.view addSubview:skyView];
        [self.view addSubview:starview];
        [self.view addSubview:sunView];
        [self.view addSubview:moonView];
        [self.view addSubview:groundView];
        [self.view addSubview:townDayView];
        [self.view addSubview:townNightView];
        //NSLog(@"y: %f", sunView.center.y);
        [self showPicture:9*60];
        [self moveSunAndMoon:9*60];
        
        //[self animateBackground:20 withTime:20*60 withDuration:4];
        
        // Custom initialization
        width = self.view.frame.size.height;
        height = self.view.frame.size.width;
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        
        //Create gear
        UIImageView *gearButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whitegear.png"]];
        gearButton.frame = CGRectMake(width - 80, 40, 40, 40);
        gearButton.alpha = .4;
        UITapGestureRecognizer *gearTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(gearTapped)];
        [gearButton addGestureRecognizer:gearTap];
        [gearButton setUserInteractionEnabled:YES];
        
        eventScrollView = [[TPPagedPreviewScrollView alloc] initWithFrame:CGRectMake(width*4/16, height*2/9-20, width*10/16, height*4/9+20)];
        [eventScrollView setShowsHorizontalScrollIndicator:NO];
        [eventScrollView setPagingEnabled:YES];
        [eventScrollView setCanCancelContentTouches:NO]; //Change this to YES to accept touches on picture
        [eventScrollView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
        [eventScrollView setClipsToBounds:NO]; //Clip picture to be in scroll view.
        [eventScrollView setScrollEnabled:YES];
        [eventScrollView setPagingEnabled:YES];
        [eventScrollView setDelegate:self];
        
        //Load event previews into eventScrollView (TODO)
//        int i;
//        for (i = 1; i <= 5; i++)
//        {
//            NSString *imageName = [NSString stringWithFormat:@"event_preview%d.jpg", i];
//            UIImage *image = [UIImage imageNamed:imageName];
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//            
//            // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
//            CGRect rect = imageView.frame;
//            rect.size.height = eventScrollView.frame.size.height;
//            rect.size.width = width*8/16;
//            imageView.frame = rect;
//            imageView.tag = i;	// tag our images for later use when we place them in serial fashion

//            [imageView addGestureRecognizer:eventPreviewTap];
//            [imageView setUserInteractionEnabled:YES];
//            [eventScrollView addSubview:imageView];
//        }

//        todo tap to scroll
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToScroll:)]];

        //first refresh
        [self refreshEvents];
        
        //Add views
        [self.view addSubview:eventScrollView];
        [self.view addSubview:gearButton];
//        [self.view addSubview:coreDataButton];
        
        [self transition: 0];
    }
    return self;

}

-(void)setcurrentIndex
{
    for(int i = 0; i < [events count]; i++)
    {
        NSDate *temp = ((EKEvent*) events[i]).startDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit) fromDate:temp];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        
        if(hour*60 + minute == time_min)
        {
            eventIndex = i;
            //NSLog(@"index: %d", i);
        }
    }
}

//asdf
-(void)transition: (int) duration
{
    int pageWidth = 1024/2+1024/8;
    CGPoint currentPage = eventScrollView.contentOffset;
    int page = ((int)currentPage.x)/pageWidth;
    //eventIndex = page;
    [self animateBackgroundToIndex:20 withIndex:page withDuration:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self transition: 1];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self transition: 1];
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (decelerate) {
//        [self transition];
//    }
//}

-(void)tapToScroll:(UIGestureRecognizer *)recognizer
{

    if([recognizer locationInView:self.view].x < self.view.bounds.size.width/2){
        [self scrollLeft];
    }
    else if([recognizer locationInView:self.view].x > self.view.bounds.size.width/2)
    {
        [self scrollRight];
    }
    
    NSLog(@"index: %i", eventIndex);
}

- (void) scrollRight
{
    int pageWidth = 1024/2+1024/8;
    CGPoint nextPage = eventScrollView.contentOffset;
    if ((int)nextPage.x%pageWidth == 0) {
        nextPage.x += pageWidth;
        if(eventScrollView.contentSize.width > nextPage.x){
            [eventScrollView setContentOffset:nextPage animated:YES];
        }
    }
//    [self animateBackgroundToIndex:20 withIndex:eventIndex+1 withDuration:1];
    
//    if(0 < eventIndex )
//    {
//        NSDate *date = ((EKEvent *)events[eventIndex - 1]).startDate;
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
//        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
//        
//        [self animateBackground:20 withTime: 60*hour + minute withDuration:1];
//    }
}

- (void) scrollLeft
{
    int pageWidth = 1024/2+1024/8;
    CGPoint nextPage = eventScrollView.contentOffset;
    if ((int)nextPage.x%pageWidth == 0) {
        nextPage.x -= pageWidth;
        if(nextPage.x >= 0){
            [eventScrollView setContentOffset:nextPage animated:YES];
        }
    }
    
    
//    [self animateBackgroundToIndex:20 withIndex:eventIndex-1 withDuration:1];
    
   /* if([events count] > eventIndex + 1)
    {
        NSDate *date = ((EKEvent *)events[eventIndex + 1]).startDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        
        [self animateBackground:20 withTime: 60*hour + minute withDuration:1];
    }*/
//    [self transition:0];
}

-(void) getEvents
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    NSArray *events= [TPICalEventGetter getCalendarEvents];
    for (int i = 0; i<[events count]; i++) {
        //NSLog(@"here");
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        //NSLog(@"time of event: %@ - %@", [dateFormatter stringFromDate:start], [dateFormatter stringFromDate:end]);
    }
}

//- (void)updateBackground: (int) time //time in minutes after midnight
- (void)showPicture: (int) time
{
    int lop = skyView.frame.size.width;
    float portionOfDay = fmod(24*60 + time, 24*60)/(24 * 60.);
    float XCenterPosition = portionOfDay*lop;
    float XOriginPosition = XCenterPosition - screen_width/2;
    
    if(XOriginPosition < 0)
    {
        XOriginPosition = 0;
    }
    
    if(XOriginPosition >(lop-screen_width))
    {
        XOriginPosition = lop - screen_width;
    }
    
    //NSLog(@"xop %f",XOriginPosition);
    skyView.frame = CGRectMake(-XOriginPosition, 0, lop, screen_height);
    //[self.view addSubview:skyView];
    float starLightAlpha = 0.0;
    
    if(fmod(24*60 + time, 24*60) < 18*60 && fmod(24*60 + time, 24*60)> 7*60)
    {
        starLightAlpha = 0.0;
    }
   
    else if(fmod(24*60 + time, 24*60) > 20*60 || fmod(24*60 + time, 24*60)< 5*60)
    {
        starLightAlpha = 1.0;
    }
    else if(fmod(24*60 + time, 24*60) > 18*60)
    {
        starLightAlpha = (time - 18*60.0)/120.;
    }
    
    else if(fmod(24*60 + time, 24*60) < 7*60)
    {
        starLightAlpha = 1 - (time - 5*60.0)/120.;
    }
    starview.alpha = starLightAlpha;
    
    if(fmod(24*60 + time, 24*60) < 20*60 && fmod(24*60 + time, 24*60)> 18*60)
    {
        townNightView.alpha = (time - 18*60.0)/120;
    }
    
    if(fmod(24*60 + time, 24*60) < 7*60 && fmod(24*60 + time, 24*60)> 5*60)
    {
        townNightView.alpha = 1 - (time - 5*60.0)/120.;
    }
    
    //townNightView.alpha = townNightAlpha;
    //[self.view addSubview:starview];
    
    //ground
    //[self.view addSubview:groundView];
    //[self.view addSubview:townView];
}

- (void)animateBackgroundToIndex: (float) numOfSteps withIndex:(int)index withDuration:(float)d
{
    double targetTime;
    
    if(index >= 0 && index < [events count])
    {
        NSDate *date = ((EKEvent *)events[index]).startDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        targetTime = minute + 60*hour;
        
        [self animateBackground:numOfSteps withTime:targetTime withDuration:d];
    }
}


- (void)animateBackground: (float) numOfSteps withTime:(float)t withDuration:(float)d
{
    float numberOfSteps = numOfSteps;
    float timeForNextCall;
    
    if(t > time_min)
    {
        timeForNextCall =  time_min+(t-time_min)/(numOfSteps);
    }
    else
    {
        timeForNextCall =  time_min-(time_min - t)/(numOfSteps);
    }
    if(numberOfSteps > 0)
    {
        [UIView animateWithDuration:d/numOfSteps
                        delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                        animations:^{[self moveSunAndMoon:timeForNextCall]; [self showPicture:timeForNextCall];}
                        completion:^(BOOL finished){[self animateBackground:numberOfSteps-1 withTime:t withDuration:(d - d/numOfSteps)];}];
    }
    
    else{
        time_min = fmod(time_min + 24*60, 1440);
        testtime = fmod(testtime + 24*60, 1440);
        [self setcurrentIndex];
    }
}

-(void)moveSunAndMoon: (int) time
{
    float normalizedTime = 2*pi*(time/(24*60.));
    Sun_Y_pos = (screen_height - ground_height1) + (screen_width/2)*cos(normalizedTime);
    Sun_X_pos = ((screen_width / 2) + (screen_width/2)*sin(normalizedTime));
    Moon_X_pos = ((screen_width / 2) - (screen_width/2)*sin(normalizedTime));
    Moon_Y_pos = (screen_height - ground_height1) - (screen_width/2)*cos(normalizedTime);
//    NSLog(@"time: %d, sun x: %d, sun y:%d", time, Sun_X_pos, Sun_Y_pos);
    moonView.center = CGPointMake(Moon_X_pos, Moon_Y_pos);
    sunView.center = CGPointMake(Sun_X_pos, Sun_Y_pos);
    time_min = time;
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize xCord:(float) x yCord:(float) y;
{
    CGPoint saveCenter = CGPointMake(x, y);
    CGRect newFrame = CGRectMake(x-sun_radius, y - sun_radius, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)gearTapped
{    
    splitViewController = [[TPSplitViewController alloc] init];
    [self presentViewController:splitViewController animated:YES completion:nil];
}

- (void)dismissParentView
{
    [splitViewController dismissViewControllerAnimated:YES completion:nil];
}


//TODO: smoother transition... (set size to 16:9; add transition to center while zooming; crossfade to preview image)
- (void)eventPreviewTapped:(UITapGestureRecognizer *)recognizer
{
    int pageWidth = 1024/2+1024/8;
    CGPoint location = [recognizer locationInView:eventScrollView];
    self.transitioningDelegate = ((TPAppDelegate *)[[UIApplication sharedApplication] delegate]).transitioningDelegate;
    TPSlideshowPageViewController *spvc = [[TPSlideshowPageViewController alloc] init];
    spvc.transitioningDelegate = self.transitioningDelegate;
    spvc.event = events[(int)location.x/pageWidth];
    
    [self presentViewController:spvc animated:YES completion:NULL];
}

- (void)layoutScrollImages
{
    UIView *view = nil;
    NSArray *subviews = [eventScrollView subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        CGRect frame = view.frame;
        frame.origin = CGPointMake(curXLoc, 0);
        view.frame = frame;
        curXLoc += (width*10/16);
    }
    
    // set the content size so it can be scrollable
    [eventScrollView setContentSize:CGSizeMake(([subviews count] * width*10/16), [eventScrollView bounds].size.height)];
}

//FETCH
//Reload calendar events and match primers.
-(void)refreshEvents
{
    //Todo: fetch calendar events for today; store name and start time.
    events = [[NSMutableArray alloc] init];
    NSMutableArray *eventNames = [[NSMutableArray alloc] init];
    NSArray *EKEventsList= [TPICalEventGetter getCalendarEvents];
    
    
    //Clear scrollview
    [[eventScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //test write code to fill correctly
    //create another array of EKEvents
    for(int i = 0; i < [EKEventsList count]; i++)
    {
        [eventNames addObject:((EKEvent *) EKEventsList[i]).title];
    }
     //NSLog(eventNames[0]);
    
    //fetch all entities matching eventnames
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Primer" inManagedObjectContext:context];
//    
//    [fetchRequest setEntity:entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name IN %@", eventNames];
//    [fetchRequest setPredicate:predicate];
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    
//    for(int i = 0; i < [eventNames count]; i++){
//        for (int j = 0; j < [fetchedObjects count]; j++) {
//            if ([eventNames[i] isEqualToString:[fetchedObjects[j]]]) {
//                TPEvent *event = [[TPEvent alloc] init];
//                //set startdate correctly
//                event.startDate = ((EKEvent *) EKEventsList[i]).startDate;
//                
//                //todo setenddate correctly!!
//                //event.endDate = ???
//                
//                event.primer = fetchedObjects[j];
//                event.images = [self imagesForPrimer:fetchedObjects[j]];
//                [events addObject:event];
//                break;
//            }
//        }
//    }
    
    for(int i = 0; i < [eventNames count]; i++){
        NSArray *ppa = [[delegate primers] objectForKey:eventNames[i]];
        if(ppa != nil){
            //set startdate correctly
            TPEvent *event = [[TPEvent alloc] init];
            event.startDate = ((EKEvent *) EKEventsList[i]).startDate;
            event.name = eventNames[i];
            //todo setenddate correctly!!
            event.endDate = ((EKEvent *) EKEventsList[i]).endDate;
//            event.images = ;
            
            //Array of page arrays (of images)
            NSMutableArray *pages = [[NSMutableArray alloc] init];
//            NSArray *page;
            for(NSString *name in ppa[0])
            {
                NSArray *page = [[delegate people] objectForKey:name];
                if(page != nil){
                    [pages addObject:page];
                }
                else{
                    NSLog(@"IMPORTANT: Person not found with name %@", name);
                }
            }
            for(NSString *name in ppa[1])
            {
                NSArray *page = [[delegate places] objectForKey:name];
                if(page != nil){
                    [pages addObject:page];
                }
                else{
                    NSLog(@"IMPORTANT: Place not found with name %@", name);
                }
            }
            for(NSString *name in ppa[2])
            {
                NSArray *page = [[delegate activities] objectForKey:name];
                if(page != nil){
                    [pages addObject:page];
                }
                else{
                    NSLog(@"IMPORTANT: Activity not found with name %@", name);
                }
            }
            event.images = pages;
            [events addObject:event];
        }
    }
    
    for(int i = 0; i < [events count]; i++){
        UITapGestureRecognizer *eventPreviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventPreviewTapped:)];
        UIView *previewPanel = [self eventPreviewWithFrame:CGRectMake(0, 0, width*8/16, eventScrollView.frame.size.height) withEvent:events[i]];
        [previewPanel addGestureRecognizer:eventPreviewTap];
        [previewPanel setTag:i];
        [eventScrollView addSubview:previewPanel];
    }
    [self layoutScrollImages];
}

//TODO: YES, but don't break splitViewController animation
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [self refreshEvents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIView *)eventPreviewWithFrame:(CGRect)frame withPrimer:(Primer *)primer

//TODO different layout?
//- (UIView *)eventPreviewWithFrame:(CGRect)frame withEvent:(TPEvent *)event

- (UIView *)eventPreviewWithFrame:(CGRect)frame withEvent:(TPEvent *)event
{
    //NSArray *EKEventsList= [TPICalEventGetter getCalendarEvents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    NSDate *start = event.startDate;
    NSDate *end = event.endDate;
    
    UIView *preview = [[UIView alloc] initWithFrame:frame];
    [preview setBackgroundColor:[UIColor clearColor]];
    int third = frame.size.width / 3.;
    int height = frame.size.height;
    
    UIImage *image1 = event.images[0][0];
    UIImage *image2 = event.images[1][0];
    UIImage *image3 = event.images[2][0];
    
    //FETCH look up.
//    UIImage *image1 = [NSKeyedUnarchiver unarchiveObjectWithData:((Person *)[[primer people] allObjects][0]).thumbnail];
//    UIImage *image2 = [NSKeyedUnarchiver unarchiveObjectWithData:((Place *)[[primer places] allObjects][0]).thumbnail];
//    UIImage *image3 = [NSKeyedUnarchiver unarchiveObjectWithData:((Activity *)[[primer activities] allObjects][0]).thumbnail];
    
    int overlap = 7;
    UILabel *headerStart = [[UILabel alloc] initWithFrame:CGRectMake(-1*overlap, 12, frame.size.width, height/8)];
    [headerStart setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [headerStart setText:[dateFormatter stringFromDate:start]];
    [headerStart setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:14]];
    [headerStart setTextAlignment:NSTextAlignmentLeft];
    [headerStart setTextColor:[UIColor whiteColor]];
    
    UILabel *headerEnd = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, frame.size.width+overlap, height/8)];
    [headerEnd setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [headerEnd setText:[dateFormatter stringFromDate:end]];
    [headerEnd setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:14]];
    [headerEnd setTextAlignment:NSTextAlignmentRight];
    [headerEnd setTextColor:[UIColor whiteColor]];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, height/8, third, height*7/8)];
    [imageView1 setImage:image1];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView1 setClipsToBounds:YES];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(third+1, height/8, third, height*7/8)];
    [imageView2 setImage:image2];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView2 setClipsToBounds:YES];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(third*2+2, height/8, third, height*7/8)];
    [imageView3 setImage:image3];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView3 setClipsToBounds:YES];
    
//    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, third, height)];
//    [imageView1 setImage:image1];
//    [imageView1 setContentMode:UIViewContentModeScaleAspectFill];
//    [imageView1 setClipsToBounds:YES];
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(third+1, 0, third, height)];
//    [imageView2 setImage:image2];
//    [imageView2 setContentMode:UIViewContentModeScaleAspectFill];
//    [imageView2 setClipsToBounds:YES];
//    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(third*2+2, 0, third, height)];
//    [imageView3 setImage:image3];
//    [imageView3 setContentMode:UIViewContentModeScaleAspectFill];
//    [imageView3 setClipsToBounds:YES];
    
    [preview addSubview:imageView1];
    [preview addSubview:imageView2];
    [preview addSubview:imageView3];
    [preview addSubview:headerStart];
    [preview addSubview:headerEnd];
    
    return preview;
}

//FETCH
- (NSArray*)imagesForPrimer:(Primer*)primer{
    NSArray *people = [[primer people] allObjects];
    NSArray *places = [[primer places] allObjects];
    NSArray *activities = [[primer activities] allObjects];
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:[people count] + [places count] + [activities count]];
    for(int i = 0; i < [people count]; i++){
        NSMutableArray *page = [[NSMutableArray alloc] initWithCapacity:[people count]];
        [page addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[[people objectAtIndex:i] profile_image]]];
        [page addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[people objectAtIndex:i] auxiliary_images]]];
        [pages addObject:[NSArray arrayWithArray:page]];
    }
    for(int i = 0; i < [places count]; i++){
        NSMutableArray *page = [[NSMutableArray alloc] initWithCapacity:[places count]];
        [page addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[[places objectAtIndex:i] profile_image]]];
        [page addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[places objectAtIndex:i] auxiliary_images]]];
        [pages addObject:[NSArray arrayWithArray:page]];
    }
    for(int i = 0; i < [activities count]; i++){
        NSMutableArray *page = [[NSMutableArray alloc] initWithCapacity:[activities count]];
        [page addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[[activities objectAtIndex:i] profile_image]]];
        [page addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[activities objectAtIndex:i] auxiliary_images]]];
        [pages addObject:[NSArray arrayWithArray:page]];
    }
    return [NSArray arrayWithArray:pages];
}

@end
