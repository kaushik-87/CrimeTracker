//
//  ViewController.m
//  CrimeTracker
//
//  Created by Kaushik Thekkekere on 9/5/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "ViewController.h"
#import "Incident+CoreDataProperties.h"
#import "AppDelegate.h"
#import "CTLocation.h"
#import "CTCrimeIncidentTracker.h"
#define METERS_PER_MILE 1609.344

#define kIncidentsFetchRequestURL @"https://data.sfgov.org/resource/ritf-b9ki.json"
//#define kSimpleFetchRequestURL @"https://data.sfgov.org/resource/ritf-b9ki.json?$where=date between '2015-12-01T12:00:00' and '2015-12-31T14:00:00'"
#define kSimpleFetchRequestURL @"https://data.sfgov.org/resource/ritf-b9ki.json?date=2015-12-29T00:00:00"


#define kMapViewTitle @"Crime Tracker"
#define kMKAnnotationIdentifier @"CTLocation"

@interface ViewController ()

@property (nonatomic,copy) NSMutableArray *incidentLocations;
@property (nonatomic,copy) NSMutableDictionary *colorCode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[CTCrimeIncidentTracker sharedInstance]fetchAllIncidentsWithCompletionBlock:^(NSArray *incidents, NSError *error) {
        NSLog(@"RESULTS %@",incidents);
        
        __weak ViewController *weakObject = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (CTLocation *location in incidents) {
                
                [weakObject.mapView addAnnotation:location];
            }
        });
        
        
    }];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = kMapViewTitle;
    CLLocationCoordinate2D zoomLocation;

    zoomLocation.latitude = 37.762963;
    zoomLocation.longitude= -122.439537;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10*METERS_PER_MILE, 10*METERS_PER_MILE);

    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];

    [_mapView setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = kMKAnnotationIdentifier;
    if ([annotation isKindOfClass:[CTLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        CTLocation *loc = annotation;
        NSString *key = loc.district;
        annotationView.pinTintColor = [[[CTCrimeIncidentTracker sharedInstance] colorCodeBasedOnCrimeRate] objectForKey:key];
        return annotationView;
    }
    
    return nil;
}

@end
