//
//  CTCrimeIncidentTracker.m
//  CrimeTracker
//
//  Created by Kaushik Thekkekere on 9/6/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "CTCrimeIncidentTracker.h"
#import "CTLocation.h"
#import "AppDelegate.h"
#import "Incident+CoreDataProperties.h"
#define kSimpleFetchRequestURL @"https://data.sfgov.org/resource/ritf-b9ki.json?date=2015-12-29T00:00:00"


@interface CTCrimeIncidentTracker()
@property (nonatomic,copy) NSMutableDictionary *colorCode;

@end

@implementation CTCrimeIncidentTracker
@synthesize colorCode;
+ (instancetype)sharedInstance
{
    static CTCrimeIncidentTracker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTCrimeIncidentTracker alloc] init];
        sharedInstance->colorCode = [[NSMutableDictionary alloc]init];
        
    });
    return sharedInstance;
}

- (void)fetchAllIncidentsWithCompletionBlock:(void(^)(NSArray *incidents, NSError *error)) completionBlock
{
    
    __weak CTCrimeIncidentTracker *weakReference = self;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *fetchIncidentsTask = [session dataTaskWithURL:[NSURL URLWithString:kSimpleFetchRequestURL]
                                                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                          
                                                          NSMutableArray *incidents = [[NSMutableArray alloc]init];
                                                          
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                          if (httpResponse.statusCode == 200) {
                                                              
                                                              if (data.length>0) {
                                                                  NSError *error;
                                                                  id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                                  
                                                                  if (error) {
                                                                      //NSError
                                                                      //NSError
                                                                      
                                                                      if (completionBlock) {
                                                                          completionBlock(nil,error);
                                                                      }
                                                                      return;
                                                                      
                                                                  }
                                                                  
                                                                  
                                                                  if ([responseObject isKindOfClass:[NSArray class]]) {
                                                                      if (responseObject) {
                                                                          NSMutableArray *incidentsArray = [NSMutableArray arrayWithArray:responseObject];
                                                                          NSLog(@"Response object contains %@",responseObject);
                                                                          
                                                                          
                                                                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                                          
                                                                          
                                                                          NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                                                          
                                                                          for (NSDictionary *incidentDict in incidentsArray) {
                                                                              
                                                                              Incident *incident = [NSEntityDescription insertNewObjectForEntityForName:@"Incident" inManagedObjectContext:context];
                                                                              [incident setValue:[incidentDict objectForKey:@"date"] forKey:@"date"];
                                                                              [incident setValue:[incidentDict objectForKey:@"address"] forKey:@"address"];
                                                                              [incident setValue:[incidentDict objectForKey:@"resolution"] forKey:@"resolution"];
                                                                              [incident setValue:[incidentDict objectForKey:@"pddistrict"] forKey:@"pddistrict"];
                                                                              [incident setValue:[incidentDict objectForKey:@"incidntnum"] forKey:@"incidntnum"];
                                                                              [incident setValue:[incidentDict objectForKey:@"x"] forKey:@"x"];
                                                                              [incident setValue:[incidentDict objectForKey:@"y"] forKey:@"y"];
                                                                              [incident setValue:[incidentDict objectForKey:@"dayofweek"] forKey:@"dayofweek"];
                                                                              [incident setValue:[incidentDict objectForKey:@"time"] forKey:@"time"];
                                                                              [incident setValue:[incidentDict objectForKey:@"pdid"] forKey:@"pdid"];
                                                                              [incident setValue:[incidentDict objectForKey:@"category"] forKey:@"category"];
                                                                              [incident setValue:[incidentDict objectForKey:@"descript"] forKey:@"descript"];
                                                                              [incident setValue:[incidentDict objectForKey:@"location"] forKey:@"location"];
                                                                              
                                                                              CTLocation *location = [[CTLocation alloc]initWithName:[incidentDict objectForKey:@"descript"] district:[incidentDict objectForKey:@"pddistrict"] coordinate:CLLocationCoordinate2DMake([[incidentDict objectForKey:@"y"] doubleValue],[[incidentDict objectForKey:@"x"] doubleValue])];
                                                                              
                                                                              [incidents addObject:location];
                                                                              
                                                                              
                                                                              NSError *error = nil;
                                                                              // Save the object to persistent store
                                                                              if (![context save:&error]) {
                                                                                  NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                                                                              }
                                                                              else
                                                                              {
                                                                                  NSLog(@"Saved Successfully");
                                                                              }
                                                                          }
                                                                          
                                                                          
                                                                          [weakReference groupByCrimeRate];
                                                                          
                                                                          if (completionBlock) {
                                                                              completionBlock(incidents,nil);
                                                                          }
                                                                          
                                                                          return;
                                                                      }
                                                                      
                                                                  }
                                                                  
                                                              }
                                                              
                                                              if (error) {
                                                                  
                                                                  if (completionBlock) {
                                                                      completionBlock(nil,error);
                                                                  }
                                                                  
                                                                  return;
                                                              }
                                                              
                                                          }
                                                      }];
    
    [fetchIncidentsTask resume];
}


- (NSDictionary*)colorCodeBasedOnCrimeRate
{
    
    return [[CTCrimeIncidentTracker sharedInstance]colorCode];
}

- (void)groupByCrimeRate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Incident"
                                              inManagedObjectContext:[appDelegate managedObjectContext]];
    NSAttributeDescription* district = [entity.attributesByName objectForKey:@"pddistrict"];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"pddistrict"];
    NSExpression *countExpression = [NSExpression expressionForFunction: @"count:"
                                                              arguments: [NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"count"];
    [expressionDescription setExpression: countExpression];
    [expressionDescription setExpressionResultType: NSInteger32AttributeType];
    
    [request setEntity:entity];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:district, expressionDescription, nil]];
    [request setPropertiesToGroupBy:[NSArray arrayWithObjects:district,nil]];
    
    [request setResultType:NSDictionaryResultType];
    
    NSError* error = nil;
    NSArray *results = [[appDelegate managedObjectContext] executeFetchRequest:request
                                                                         error:&error];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    NSLog(@"Result %@",[results sortedArrayUsingDescriptors:sortDescriptors]);
    
    NSArray *resultsArray = [results sortedArrayUsingDescriptors:sortDescriptors];
    for (int i=0; i< resultsArray.count; i++) {
        NSDictionary *dictionary = [resultsArray objectAtIndex:i];
        UIColor *color;
        switch (i) {
            case 0:
            {
                color = [UIColor colorWithRed:255.00/255.00 green:0/255.00 blue:0/255.00 alpha:1];
            }
                break;
                
            case 1:
            {
                color = [UIColor colorWithRed:235.00/255.00 green:54.00/255.00 blue:0/255.00 alpha:1];
            }
                break;
            case 2:
            {
                color = [UIColor colorWithRed:229.00/255.00 green:72.00/255.00 blue:0/255.00 alpha:1];
                
            }
                break;
            case 3:
            {
                color = [UIColor colorWithRed:216.00/255.00 green:109.00/255.00 blue:0/255.00 alpha:1];
                
            }
                break;
            case 4:
            {
                color = [UIColor colorWithRed:210.00/255.00 green:127.00/255.00 blue:0/255.00 alpha:1];
                
            }
                break;
            case 5:
            {
                color = [UIColor colorWithRed:197.00/255.00 green:163.00/255.00 blue:0/255.00 alpha:1];
                
            }
                break;
            case 6:
            {
                color = [UIColor colorWithRed:185.00/255.00 green:200.00/255.00 blue:0/255.00 alpha:1];
                
            }
                break;
                
                
            default:
            {
                color = [UIColor colorWithRed:166.00/255.00 green:265.00/255.00 blue:0/255.00 alpha:1];
            }
                break;
        }
        [[[CTCrimeIncidentTracker sharedInstance] colorCode] setObject:color forKey:[dictionary objectForKey:@"pddistrict"]];
    }
}

@end
