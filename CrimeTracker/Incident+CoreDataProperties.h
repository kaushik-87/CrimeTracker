//
//  Incident+CoreDataProperties.h
//  CrimeTracker
//
//  Created by Kaushik Thekkekere on 9/5/16.
//  Copyright © 2016 Home. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Incident.h"

NS_ASSUME_NONNULL_BEGIN

@interface Incident (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *resolution;
@property (nullable, nonatomic, retain) NSString *pddistrict;
@property (nullable, nonatomic, retain) NSString *incidntnum;
@property (nullable, nonatomic, retain) NSString *x;
@property (nullable, nonatomic, retain) NSString *y;
@property (nullable, nonatomic, retain) NSString *dayofweek;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *pdid;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *descript;
@property (nullable, nonatomic, retain) id location;

@end

NS_ASSUME_NONNULL_END
