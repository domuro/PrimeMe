//
//  TPAppDelegate.h
//  Prospect
//
//  Created by Derek Omuro on 4/17/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPMainViewController.h"
#import "TPEvent.h"

@interface TPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TPZoomTransitionDelegate *transitioningDelegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// NSString *name -> NSArray(NSArray(NSString* personName), NSArray(NSString* placeName), NSArray(NSString* activityName))
@property NSMutableDictionary *primers;

// NSString *name -> NSArray(UIImage *profile, aux)
@property NSMutableDictionary *people;
@property NSMutableDictionary *places;
@property NSMutableDictionary *activities;

- (NSMutableDictionary *)contentWithType:(NSString *)type;

//insert of update based on content name. of type Person, Place, Activity, Primer.
//writecontentwithtype withname withprofile withauxiliary
- (void)writeContentWithType:(NSString *)type withName:(NSString *)name withProfile:(UIImage *)profile withAuxiliary:(NSArray *)auxiliary;

//update primer entry with content.
- (void) writePrimer:(NSString*)name withContent:(NSArray *)content;

- (void)fetchContent;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
