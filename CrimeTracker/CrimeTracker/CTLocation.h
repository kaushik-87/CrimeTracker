#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CTLocation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_district;
    CLLocationCoordinate2D _coordinate;
    
}

@property (copy) NSString *name;
@property (copy) NSString *district;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name district:(NSString*)district coordinate:(CLLocationCoordinate2D)coordinate;



@end
