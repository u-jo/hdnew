//
//  MapViewAnnotation.h
//  hackduke13
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 11/16/2013
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//properties
@interface MapViewAnnotation : NSObject <MKAnnotation> 
//methods

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
