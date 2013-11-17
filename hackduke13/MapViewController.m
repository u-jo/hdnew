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
@synthesize mapView;

- (void)viewWillAppear:(BOOL)animated { //WHAT HAPPNES BEFORE VIEW IS SHOWN
    
}

- (void)viewDidLoad //WHAT HAPPENS AFTER VIEW IS SHOWN
{
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
	// Add the annotation to our map view
	

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

- (IBAction)loadMapView:(id)sender
{
    
    
    
    NSMutableArray *venuesArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *venue1 = [[NSMutableDictionary alloc] init];
    [venue1 setObject:@"44.4758" forKey:@"latitude"];
    [venue1 setObject:@"-73.2110" forKey:@"longitude"];
    
    [venue1 setObject:@"Venue 1" forKey:@"name"];
    [venue1 setObject:@"Buckingham Palace" forKey:@"address"];
    
    NSMutableDictionary *venue2 = [[NSMutableDictionary alloc] init];
    [venue2 setObject:@"44.4758" forKey:@"latitude"];
    [venue2 setObject:@"-73.2125" forKey:@"longitude"];
    [venue2 setObject:@"Venue 2" forKey:@"name"];
    [venue2 setObject:@"Near Buckingham Palace" forKey:@"address"];
    
    NSMutableDictionary *venue3 = [[NSMutableDictionary alloc] init];
    [venue3 setObject:@"44.4768" forKey:@"latitude"];
    [venue3 setObject:@"-73.2145" forKey:@"longitude"];
    [venue3 setObject:@"Venue 2" forKey:@"name"];
    [venue3 setObject:@"Near Buckingham Palace 2" forKey:@"address"];
    
    NSMutableDictionary *venue4 = [[NSMutableDictionary alloc] init];
    [venue4 setObject:@"44.4738" forKey:@"latitude"];
    [venue4 setObject:@"-73.2156" forKey:@"longitude"];
    [venue4 setObject:@"Billy's Burgers" forKey:@"name"];
    [venue4 setObject:@"113 Maple Street" forKey:@"address"];
    
    [venuesArray addObject:venue1];
    [venuesArray addObject:venue2];
    [venuesArray addObject:venue3];
    [venuesArray addObject:venue4];
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
        annotationView.canShowCallout = YES;
        if (arc4random() % 2 == 1)
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pin_1234.png"]];
        else if (arc4random() % 2 ==1)
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pin_23.png"]];
        else
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pin_4.png"]];
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showVenueDetails:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        
        UIView *leftButton = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,32)];
        UIImageView *starsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,16)];
        starsImageView.image = [UIImage imageNamed:@"stars4wide.png"];
        UIImageView *moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,16,40,16)];
        moneyImageView.image = [UIImage imageNamed:@"money4_wide.png"];
        [leftButton addSubview:starsImageView];
        [leftButton addSubview:moneyImageView];
        
        //set tag equal to venueID
        annotationView.leftCalloutAccessoryView = leftButton;
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = YES;
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
