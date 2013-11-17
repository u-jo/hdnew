//
//  MapPostViewController.m
//  hackduke13
//
//  Created by Lee Yu Zhou on 16/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MapPostViewController.h"

@interface MapPostViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableDictionary *jSON;

@end

@implementation MapPostViewController
@synthesize mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.jSON = [[NSMutableDictionary alloc]init];
    self.mapView.showsUserLocation = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];

}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"called");
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:touchMapCoordinate];
    [self.jSON setObject:[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude] forKey:@"latitude"];
    [self.jSON setObject:[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude] forKey:@"longitude"];
    [annotation setTitle:@"New Post"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.jSON setObject:self.message forKey:@"description"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)post:(id)sender {
    NSDate *date = [NSDate date];
    [self.jSON setObject:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] forKey:@"timestamp"];
    [self.jSON setObject:@"Yu Zhou" forKey:@"username"];
    [self.jSON setObject:@"none" forKey:@"restrictions"];
    
    //NSData *imageData = UIImagePNGRepresentation(self.image);
    NSData *imageData = UIImageJPEGRepresentation(self.image,0.9);
    NSString *urlString = @"http://www.felixxiao.com/hackduke13post.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in self.jSON) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [self.jSON objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@.jpg\"\r\n",[self.jSON objectForKey:@"timestamp"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    (void)[myConnection initWithRequest:request delegate:self];
    
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"Image Return String: %@", returnString]);
    
    
}

#pragma mark NSURLConnection Delegate Methods
//TENTATIVE - WHAT HAPPENS WHEN THE CONNECTION FIRST RECEIVES DATA
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    
}

//TENTATIVE - WHAT HAPPENS AS THE CONNECTION BEGINS RECEIVING DATA
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSError* error;
    //NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    
    NSLog(@"My reply was:%@",theReply);
    //now, refresh everything
    DBViewController *testDBVC = [[DBViewController alloc] init];
    [testDBVC pullFromOnline];
    
}

//EMPTY - WHAT HAPPENS WHEN A RESPONSE IS CACHED
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//TENTATIVE - WHAT HAPPENS AFTER THE CONNECTION SUCCEEDS
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
}

//TENTATIVE - WHAT HAPPENS IF THE CONNECTION FAILS
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"A connection has failed with the error %@",error);
}



@end
