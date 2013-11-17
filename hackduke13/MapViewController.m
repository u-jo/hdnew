//
//  MapViewController.m
//  hackduke13
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 11/16/2013
//

#import "MapViewController.h"
#import "MapViewAnnotation.h"

//define useful constants
#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

//synthesize properties
@synthesize mapView,appDelegate;

- (void)viewWillAppear:(BOOL)animated { //WHAT HAPPNES BEFORE VIEW IS SHOWN
    
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [super viewDidLoad];
    //self.mapView.showsUserLocation = YES;
    NSLog(@"POSITION 1");
    [self loadMapView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
	// Add the annotation to our map view
	

}
- (IBAction)return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D newLocation = [userLocation coordinate];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(newLocation, 1500, 1500);
    [self.mapView setRegion:zoomRegion];
}

// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}

- (void)loadMapView
{
    
    NSMutableArray *venuesArray = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *d in self.appDelegate.allContent) {
        NSLog(@"POSITION 2");
        NSMutableDictionary *venue = [[NSMutableDictionary alloc] init];
        [venue setObject:[d objectForKey:@"latitude"] forKey:@"latitude"];
        [venue setObject:[d objectForKey:@"longitude"] forKey:@"longitude"];
        [venue setObject:[d objectForKey:@"username"] forKey:@"name"];
        [venue setObject:[d objectForKey:@"timestamp"] forKey:@"address"];
        [venue setObject:[d objectForKey:@"imgURL"] forKey:@"imgURL"];
        NSLog(@"hi%@",venue);
        [venuesArray addObject:venue];
    }
    
    [self plotVenues:venuesArray];
}

- (void)plotVenues:(NSMutableArray*)searchResults {
    //clear all the annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
        [mapView removeAnnotation:annotation];
        }
    }
    
    for (NSMutableDictionary *venueData in searchResults) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[venueData objectForKey:@"latitude"] floatValue];
        coordinate.longitude= [[venueData objectForKey:@"longitude"] floatValue];
        //set up other parts of the annotation
        MapViewAnnotation *venueAnnotation = [[MapViewAnnotation alloc] initWithName:[venueData objectForKey:@"name"] address:[venueData objectForKey:@"address"] coordinate:coordinate];
        venueAnnotation.imgURL = [venueData objectForKey:@"imgURL"];
        [mapView addAnnotation:venueAnnotation];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView)
        return annotationView;
    else
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"dot.png"];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showVenueDetails:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        
        UIView *leftButton = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,80)];
        UIImageView *starsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,80,80)];
        NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.felixxiao.com/uploads/%@",[((MapViewAnnotation*) annotation) imgURL]]];
        NSData *imageData = [NSData dataWithContentsOfURL:myURL];
        starsImageView.image = [UIImage imageWithData:imageData];
        [leftButton addSubview:starsImageView];
        
        //set tag equal to venueID
        annotationView.leftCalloutAccessoryView = leftButton;
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void)showVenueDetails:(id)sender
{
    NSLog(@"show popup here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
