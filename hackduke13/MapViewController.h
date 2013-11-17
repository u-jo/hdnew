//
//  MapViewController.h
//  hackduke13
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 11/16/2013
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate> {
    MKMapView *mapView;
}
@property (strong,nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIPopoverController *popover;
- (void)loadMapView;
- (void)showVenueDetails:(id)sender;
@property (strong, nonatomic) NSString *currentImage;
@property (strong, nonatomic) NSString *currentMessage; 
@end
