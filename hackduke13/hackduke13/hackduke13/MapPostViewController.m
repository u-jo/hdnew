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
}

- (void)viewWillAppear:(BOOL)animated
{
    NSData *imageData = (UIImageJPEGRepresentation(self.image, 1.0));
    [self.jSON setObject:imageData forKey:@"image-raw"];
    [self.jSON setObject:self.message forKey:@"description"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)post:(id)sender {
    NSDate *date = [NSDate date];
    [self.jSON setObject:date forKey:@"timestamp"];
    [self.jSON setObject:@"1234" forKey:@"id"];
    [self.jSON setObject:@"ujo" forKey:@"username"];
    [self.jSON setObject:@"friends" forKey:@"restrictions"];
    
    
}

@end
