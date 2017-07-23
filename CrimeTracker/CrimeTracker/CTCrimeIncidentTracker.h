//
//  CTCrimeIncidentTracker.h
//  CrimeTracker
//
//  Created by Kaushik Thekkekere on 9/6/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCrimeIncidentTracker : NSObject

+ (instancetype)sharedInstance;

- (void)fetchAllIncidentsWithCompletionBlock:(void(^)(NSArray *incidents, NSError *error)) completionBlock;

- (NSDictionary*)colorCodeBasedOnCrimeRate;

@end
