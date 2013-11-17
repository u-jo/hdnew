//
//  MapViewController.h
//  hackduke13
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 11/16/2013
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}
@property (strong,nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) AppDelegate *appDelegate;
- (void)loadMapView;
- (void)showVenueDetails:(id)sender;
@end
