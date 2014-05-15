//
//  Person.h
//  Prospect
//
//  Created by Derek Omuro on 4/20/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Primer;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSData * profile_image;
@property (nonatomic, retain) NSData * auxiliary_images;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *primer;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPrimerObject:(Primer *)value;
- (void)removePrimerObject:(Primer *)value;
- (void)addPrimer:(NSSet *)values;
- (void)removePrimer:(NSSet *)values;

@end
