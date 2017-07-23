#import "CTLocation.h"

@implementation CTLocation
@synthesize name = _name;
@synthesize district = _district;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name district:(NSString*)district coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        _name = [name copy];
        _district = [district copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

//- (NSString *)subtitle {
//    return _count;
//}



@end