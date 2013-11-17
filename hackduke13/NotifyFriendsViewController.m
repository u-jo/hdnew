//
//  NotifyFriendsViewController.m
//  hackduke13
//
//  Created by Lee Yu Zhou on 17/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "NotifyFriendsViewController.h"
#import "MapPostViewController.h"
@interface NotifyFriendsViewController ()

@end

@implementation NotifyFriendsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"notifyFriends"]) {
        if ([segue.destinationViewController isKindOfClass:[MapPostViewController class]]) {
            MapPostViewController *mpvc = (MapPostViewController *)segue.destinationViewController;
            mpvc.image = self.image;
            mpvc.message = self.image;
            self.navigationItem.backBarButtonItem.title = @"";
        }
    }
}

@end
