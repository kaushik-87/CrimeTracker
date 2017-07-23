//
//  Location+CoreDataProperties.h
//  CrimeTracker
//
//  Created by Kaushik Thekkekere on 9/5/16.
//  Copyright © 2016 Home. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *human_address;
@property (nullable, nonatomic, retain) NSNumber *needs_recording;

@end

NS_ASSUME_NONNULL_END
