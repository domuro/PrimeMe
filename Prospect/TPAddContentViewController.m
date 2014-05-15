//
//  TPAddContentViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/21/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPAddContentViewController.h"
#import "TPContentViewController.h"
#import "TPAppDelegate.h"
#import "UIViewController+MHSemiModal.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"

@interface TPAddContentViewController ()

@end

@implementation TPAddContentViewController
@synthesize contentType, contentName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Person *person;
//Place *place;
//Activity *activity;
UIImageView *profile, *aux1, *aux2, *aux3;
UILabel *delete;
UITextField *name;
BOOL isNew;
NSMutableArray *entity; // array of images for entity.
NSMutableArray *auxImages;
TPAppDelegate *delegate;
NSMutableArray *tempEntity;
UIImage *placeholder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    placeholder = [UIImage imageNamed:@"squareplaceholder.png"];
    delegate = [[UIApplication sharedApplication] delegate];
    entity = [[delegate contentWithType:contentType] objectForKey:contentName];
    auxImages = nil;
    isNew = entity == nil;
    NSString *nameText;
    [self.sourceViewController lockAdd];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (entity != nil) {
        nameText = contentName;
        tempEntity = [entity mutableCopy];
        [self setTitle:[NSString stringWithFormat:@"%@", contentName]];
    }
    else{
        nameText = @"";
        tempEntity = nil;
        [self setTitle:[NSString stringWithFormat:@"New %@", contentType]];
    }
//    if(entity != nil){
//        if ([contentType isEqualToString:@"Person"]) {
//            person = (Person*)entity;
//            place = nil;
//            activity = nil;
//            nameText = person.name;
//            [self setTitle:[NSString stringWithFormat:@"%@",[person name]]];
//        }
//        else if([contentType isEqualToString:@"Place"]) {
//            place = (Place*)entity;
//            person = nil;
//            activity = nil;
//            nameText = place.name;
//            [self setTitle:[NSString stringWithFormat:@"%@",[place name]]];
//        }
//        else if([contentType isEqualToString:@"Activity"]){
//            activity = (Activity*)entity;
//            place = nil;
//            person = nil;
//            nameText = activity.name;
//            [self setTitle:[NSString stringWithFormat:@"%@",[activity name]]];
//        }
//    }
//    else{
//        person = nil;
//        place = nil;
//        activity = nil;
//        nameText = @"";
//        [self setTitle:[NSString stringWithFormat:@"New %@",contentType]];
//    }
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewAndUnlockAdd)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissAndSaveViewAndUnlockAdd)]];
    
    //Add input fields.
    int unit = (self.view.frame.size.height-320)/16;
    profile = [[UIImageView alloc] initWithFrame:CGRectMake(unit, unit*2 + 64, unit*5, unit*5)];
    [profile setBackgroundColor:[UIColor lightGrayColor]];
    [profile setImage:placeholder];
    [profile setContentMode:UIViewContentModeScaleAspectFill];
    [profile setClipsToBounds:YES];
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(unit+unit*5.5+unit/2, unit*2+64+unit*4, unit*8, unit)];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:28]];
    [name setPlaceholder:[NSString stringWithFormat:@"%@ name", contentType]];
    [name setText:nameText];
    [name setTextAlignment:NSTextAlignmentCenter];
    UIView *nameUnderline = [[UIView alloc] initWithFrame:CGRectMake(unit+unit*5.5+unit/2, unit*2+64+unit*5, unit*8, 0.5)];
    [nameUnderline setBackgroundColor:[UIColor lightGrayColor]];
    
    CGRect auxRect = CGRectMake(unit, 64+unit*3+unit*5+unit, unit*4, unit*4);
    aux1 = [[UIImageView alloc] initWithFrame:auxRect];
    auxRect.origin.x += unit+unit*4;
    aux2 = [[UIImageView alloc] initWithFrame:auxRect];
    auxRect.origin.x += unit+unit*4;
    aux3 = [[UIImageView alloc] initWithFrame:auxRect];
    [aux1 setBackgroundColor:[UIColor lightGrayColor]];
    [aux2 setBackgroundColor:[UIColor lightGrayColor]];
    [aux3 setBackgroundColor:[UIColor lightGrayColor]];
    [aux1 setImage:placeholder];
    [aux2 setImage:placeholder];
    [aux3 setImage:placeholder];
    [aux1 setContentMode:UIViewContentModeScaleAspectFill];
    [aux1 setClipsToBounds:YES];
    [aux2 setContentMode:UIViewContentModeScaleAspectFill];
    [aux2 setClipsToBounds:YES];
    [aux3 setContentMode:UIViewContentModeScaleAspectFill];
    [aux3 setClipsToBounds:YES];
    
    //Add section titles
    UIView *profileSeparator = [[UIView alloc] initWithFrame:CGRectMake(unit/2, unit*2-10+64, unit*15, 0.5)];
    [profileSeparator setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(unit, profileSeparator.frame.origin.y-unit*.8, unit*14, unit)];
    [profileLabel setText:@"Profile Information"];
    [profileLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    
    UIView *auxSeparator = [[UIView alloc] initWithFrame:CGRectMake(unit/2, auxRect.origin.y-10, unit*15, 0.5)];
    [auxSeparator setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:CGRectMake(unit, auxRect.origin.y-10-unit*.8, unit*14, unit)];
    [auxLabel setText:@"Additional Content"];
    [auxLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    
    //Add images
    if(tempEntity != nil){
        [profile setImage:[tempEntity objectAtIndex:0]];
        auxImages = [[NSMutableArray alloc] initWithArray:tempEntity];
        [auxImages removeObjectAtIndex:0];
        switch ([auxImages count]) {
            case 3:
                [aux3 setImage:auxImages[2]];
            case 2:
                [aux2 setImage:auxImages[1]];
            case 1:
                [aux1 setImage:auxImages[0]];
            default:
                break;
        }
    }
    
//    if(person != nil){
//        [profile setImage:[NSKeyedUnarchiver unarchiveObjectWithData:person.thumbnail]];
//        auxImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:person.auxiliary_images]];
//        switch ([auxImages count]) {
//            case 3:
//                [aux3 setImage:auxImages[2]];
//            case 2:
//                [aux2 setImage:auxImages[1]];
//            case 1:
//                [aux1 setImage:auxImages[0]];
//            default:
//                break;
//        }
//    }
//    else if(place != nil){
//        [profile setImage:[NSKeyedUnarchiver unarchiveObjectWithData:place.thumbnail]];
//        auxImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:place.auxiliary_images]];
//        switch ([auxImages count]) {
//            case 3:
//                [aux3 setImage:auxImages[2]];
//            case 2:
//                [aux2 setImage:auxImages[1]];
//            case 1:
//                [aux1 setImage:auxImages[0]];
//            default:
//                break;
//        }
//    }
//    else if(activity != nil){
//        [profile setImage:[NSKeyedUnarchiver unarchiveObjectWithData:activity.thumbnail]];
//        auxImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:activity.auxiliary_images]];
//        switch ([auxImages count]) {
//            case 3:
//                [aux3 setImage:auxImages[2]];
//            case 2:
//                [aux2 setImage:auxImages[1]];
//            case 1:
//                [aux1 setImage:auxImages[0]];
//            default:
//                break;
//        }
//    }
    if(auxImages == nil){
        auxImages = [[NSMutableArray alloc] init];
    }
    
    //Add touch gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    //Add delete button
    delete = [[UILabel alloc] initWithFrame:CGRectMake(unit*2, self.view.frame.size.width-unit*1.5, unit*12, unit)];
    [delete setText:[NSString stringWithFormat:@"Delete %@", contentType]];
    [delete setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
    [delete setTextColor:[UIColor redColor]];
    [delete setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    [delete setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:profile];
    [self.view addSubview:name];
    [self.view addSubview:nameUnderline];
    [self showAux];
    [self.view addSubview:profileSeparator];
    [self.view addSubview:profileLabel];
    [self.view addSubview:auxSeparator];
    [self.view addSubview:auxLabel];
    if(entity != nil){
        [self.view addSubview:delete];
    }
    else{
        //TODO CD
        tempEntity = [[NSMutableArray alloc] init];
//        if ([contentType isEqualToString:@"Person"]) {
//            person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
//            entity = person;
//        }
//        else if([contentType isEqualToString:@"Place"]) {
//            place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
//            entity = place;
//        }
//        else if([contentType isEqualToString:@"Activity"]){
//            activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:context];
//            entity = activity;
//        }
    }
}

-(void)showAux
{
    //add all to subView
    unsigned long num = [auxImages count];
    if(num == 3){
        num = 2;
    }
    switch (num+1) {
        case 3:
            if (![aux3 isDescendantOfView:self.view]) {
                [self.view addSubview:aux3];
            }
        case 2:
            if (![aux2 isDescendantOfView:self.view]) {
                [self.view addSubview:aux2];
            }
        case 1:
            if (![aux1 isDescendantOfView:self.view]) {
                [self.view addSubview:aux1];
            }
        default:
            break;
    }
}

UIImagePickerController *ipc;
UIImageView *current;
int currentInt; //Which view did user tap?
- (void)tap: (UITapGestureRecognizer*) recognizer
{
    //Profile
    //    CGPoint tapLocation = [recognizer locationInView:profile];
    if([profile pointInside:[recognizer locationInView:profile] withEvent:nil]){
        current = profile;
        currentInt = 0;
        ipc = [[UIImagePickerController alloc] init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
            [popover presentPopoverFromRect:profile.bounds inView:profile permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        } else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    else if([aux1 pointInside:[recognizer locationInView:aux1] withEvent:nil] && [aux1 isDescendantOfView:self.view]){
        current = aux1;
        currentInt = 1;
        ipc = [[UIImagePickerController alloc] init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
            [popover presentPopoverFromRect:aux1.bounds inView:aux1 permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            self.popOver = popover;
        } else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    else if([aux2 pointInside:[recognizer locationInView:aux2] withEvent:nil] && [aux2 isDescendantOfView:self.view]){
        current = aux2;
        currentInt = 2;
        ipc = [[UIImagePickerController alloc] init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
            [popover presentPopoverFromRect:aux2.bounds inView:aux2 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        } else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    else if([aux3 pointInside:[recognizer locationInView:aux3] withEvent:nil] && [aux3 isDescendantOfView:self.view]){
        current = aux3;
        currentInt = 3;
        ipc = [[UIImagePickerController alloc] init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
            [popover presentPopoverFromRect:aux3.bounds inView:aux3 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        } else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    //Delete
    if(!isNew){
        if([delete pointInside:[recognizer locationInView:delete] withEvent:nil]){
            //TODO CD
//            [context deleteObject:entity];
            [self dismissAndSaveViewAndUnlockAdd];
        }
    }
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *thumb = [self getThumbnail:selectedImage];
    [current setImage:thumb];
    
    //TODO
//    NSData *encodedImage = [NSKeyedArchiver archivedDataWithRootObject:thumb];
//    NSData *encodedThumb = [NSKeyedArchiver archivedDataWithRootObject:thumb];
//    NSData *encodedAux;
    
    switch (currentInt) {
        case 0:
            //profile
//            if (person != nil) {
//                person.profile_image = encodedImage;
//                person.thumbnail = encodedThumb;
//            }
//            else if (place != nil) {
//                place.profile_image = encodedImage;
//                place.thumbnail = encodedThumb;
//            }
//            else if (activity != nil) {
//                activity.profile_image = encodedImage;
//                activity.thumbnail = encodedThumb;
//            }
            if (tempEntity != nil){
                [tempEntity setObject:thumb atIndexedSubscript:0];
            }
            break;
        case 1:
            //aux1
            if ([auxImages count] < currentInt) {
                [auxImages addObject:selectedImage];
            }
            else{
                auxImages[currentInt-1] = selectedImage;
            }
            if (tempEntity != nil) {
                if ([tempEntity count] == 0) {
                    [tempEntity addObject:placeholder];
                }
                UIImage *temp = [tempEntity objectAtIndex:0];
                tempEntity = [[NSMutableArray alloc] init];
                [tempEntity addObject:temp];
                [tempEntity addObjectsFromArray:auxImages];
            }
            break;
        case 2:
            //aux2
            if ([auxImages count] < currentInt) {
                [auxImages addObject:selectedImage];
            }
            else{
                auxImages[currentInt-1] = selectedImage;
            }
            if (tempEntity != nil) {
                if ([tempEntity count] == 0) {
                    [tempEntity addObject:placeholder];
                }
                UIImage *temp = [tempEntity objectAtIndex:0];
                tempEntity = [[NSMutableArray alloc] init];
                [tempEntity addObject:temp];
                [tempEntity addObjectsFromArray:auxImages];
            }
            break;
        case 3:
            //aux3
            if ([auxImages count] < currentInt) {
                [auxImages addObject:selectedImage];
            }
            else{
                auxImages[currentInt-1] = selectedImage;
            }
            if (tempEntity != nil) {
                if ([tempEntity count] == 0) {
                    [tempEntity addObject:placeholder];
                }
                UIImage *temp = [tempEntity objectAtIndex:0];
                tempEntity = [[NSMutableArray alloc] init];
                [tempEntity addObject:temp];
                [tempEntity addObjectsFromArray:auxImages];
            }
            break;
        default:
            break;
    }
    [self showAux];
    [self.popOver dismissPopoverAnimated:YES];
}

- (void)dismissViewAndUnlockAdd
{
    [self.sourceViewController unlockAdd];
//    [context rollback];
    [self mh_dismissSemiModalViewController:self.navigationController animated:YES];
}

- (void)dismissAndSaveViewAndUnlockAdd
{
//    [entity setName:name.text];
    if (profile.image != placeholder) {
        [delegate writeContentWithType:contentType withName:name.text withProfile:tempEntity[0] withAuxiliary:[tempEntity subarrayWithRange:NSMakeRange(1, [tempEntity count] -1)]];
        [(TPContentViewController*)self.sourceViewController.detailNavViewController.viewControllers[0] refresh];
    }
    
    //TODO CD
//    NSError *error;
//    if (![context save:&error]) {
//        [context rollback];
//        NSLog(@"Error saving: %@", [error localizedDescription]);
//    }
    
    [self dismissViewAndUnlockAdd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)getThumbnail:(UIImage *)image // as a category (so, 'self' is the input image)
{
    // fromCleverError's original
    // http://stackoverflow.com/questions/17884555
    CGSize finalsize = CGSizeMake(200,200);
    
    CGFloat scale = MAX(
                        finalsize.width/image.size.width,
                        finalsize.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    
    CGRect rr = CGRectMake( 0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(finalsize, NO, 0);
    [image drawInRect:rr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end