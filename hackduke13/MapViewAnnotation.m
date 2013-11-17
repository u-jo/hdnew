//
//  MapViewAnnotation.h
//  hackduke13
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 11/16/2013
//

#import "MapViewAnnotation.h"
#import <AddressBook/AddressBook.h>

@interface MapViewAnnotation ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end
@implementation MapViewAnnotation

@synthesize imgURL;

//synthesize properties

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.address = [self convertTimeStamp:address];
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)convertTimeStamp:(NSString *)timeStamp {
    float value = [timeStamp floatValue];
    int v = (int)value;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:v];
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    int weekday = [weekdayComponents weekday];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}
- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
