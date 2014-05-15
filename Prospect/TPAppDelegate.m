//
//  TPAppDelegate.m
//  Prospect
//
//  Created by Derek Omuro on 4/17/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPAppDelegate.h"
#import "Primer.h"
#import "Person.h"
#import "Place.h"
#import "Activity.h"

@interface TPAppDelegate ()
@end

@implementation TPAppDelegate
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize people, places, activities, primers;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    people = [[NSMutableDictionary alloc] init];
    places = [[NSMutableDictionary alloc] init];
    activities = [[NSMutableDictionary alloc] init];
    primers = [[NSMutableDictionary alloc] init];
    
    TPMainViewController *mvc = [[TPMainViewController alloc] init];
    
    [self.window setBackgroundColor:[UIColor greenColor]];
    [self.window setRootViewController:mvc];
    self.transitioningDelegate = [TPZoomTransitionDelegate new];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//run once at application launch.
- (void)fetchContent
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Primer" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for(Primer *primer in fetchedObjects)
    {
        //Temporary storage for ppa names of this primer.
        NSMutableSet *peopleNames = [[NSMutableSet alloc] initWithCapacity:[[primer people] count]];
        NSMutableSet *placeNames = [[NSMutableSet alloc] initWithCapacity:[[primer places] count]];
        NSMutableSet *activityNames = [[NSMutableSet alloc] initWithCapacity:[[primer activities] count]];
        
        for(Person *person in [primer people])
        {
            [peopleNames addObject:[person name]];
        }
        for(Place *place in [primer places])
        {
            [placeNames addObject:[place name]];
        }
        for(Activity *activity in [primer activities])
        {
            [activityNames addObject:[activity name]];
        }
        
        //Add array of array of names to primer.
        NSArray *ppa = [NSArray arrayWithObjects:[peopleNames allObjects], [placeNames allObjects], [activityNames allObjects], nil];
        [primers setObject:ppa forKey:[primer name]];
    }
    
    //Temporary storage for image content of ppa; 1 profile + 3 aux = 4 images
    
    //Fetch people
    entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Person *p in fetchedObjects){
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:4];
        [images addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[p profile_image]]];
        NSArray *aux = [NSKeyedUnarchiver unarchiveObjectWithData:[p auxiliary_images]];
        [images addObjectsFromArray:aux];
        [people setObject:images forKey:[p name]];
    }
    
    //Fetch places
    entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Place *p in fetchedObjects){
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:4];
        [images addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[p profile_image]]];
        NSArray *aux = [NSKeyedUnarchiver unarchiveObjectWithData:[p auxiliary_images]];
        [images addObjectsFromArray:aux];
        [places setObject:images forKey:[p name]];
    }
    
    //Fetch activites
    entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Activity *p in fetchedObjects){
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:4];
        [images addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[p profile_image]]];
        NSArray *aux = [NSKeyedUnarchiver unarchiveObjectWithData:[p auxiliary_images]];
        [images addObjectsFromArray:aux];
        [activities setObject:images forKey:[p name]];
    }
}

- (NSMutableDictionary *)contentWithType:(NSString *)type
{
    if([type isEqualToString:@"Person"]){
        return people;
    }
    else if([type isEqualToString:@"Place"]){
        return places;
    }
    else if([type isEqualToString:@"Activity"]){
        return activities;
    }
    else{
        NSLog(@"Unrecognized type: %@", type);
        return nil;
    }
}
- (void)writeContentWithType:(NSString *)type withName:(NSString *)name withProfile:(UIImage *)profile withAuxiliary:(NSArray *)auxiliary
{
    if(name != nil && ![name isEqualToString:@""] && profile != nil){
        //update dictionary
        NSMutableArray *images = [NSMutableArray arrayWithObject:profile];
        [images addObjectsFromArray:auxiliary];
        [[self contentWithType:type] setObject:images forKey:name];
        
        //update core data
        id entity = [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:__managedObjectContext];
        [entity setName:name];
        [entity setProfile_image:[NSKeyedArchiver archivedDataWithRootObject:profile]];
        [entity setAuxiliary_images:[NSKeyedArchiver archivedDataWithRootObject:auxiliary]];
        [self saveContext];
    }
}
- (void) writePrimer:(NSString*)name withContent:(NSArray *)content
{
    //update dictionary
    [[self primers] setObject:content forKey:name];

    //update core data
    Primer *primer = [NSEntityDescription insertNewObjectForEntityForName:@"Primer" inManagedObjectContext:__managedObjectContext];
    [primer setName:name];
//    for(Person* p in content[0]){
//        [primer addPeopleObject:p];
//    }
//    for(Place* p in content[1]){
//        [primer addPlacesObject:p];
//    }
//    for(Activity* a in content[2]){
//        [primer addActivitiesObject:a];
//    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name IN %@", content[0]];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [primer setPeople:[NSSet setWithArray:fetchedObjects]];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    predicate = [NSPredicate predicateWithFormat:@"name IN %@", content[1]];
    [fetchRequest setPredicate:predicate];
    fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [primer setPlaces:[NSSet setWithArray:fetchedObjects]];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    predicate = [NSPredicate predicateWithFormat:@"name IN %@", content[2]];
    [fetchRequest setPredicate:predicate];
    fetchedObjects = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [primer setActivities:[NSSet setWithArray:fetchedObjects]];
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSLog(@"%d", [managedObjectContext hasChanges]);
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
