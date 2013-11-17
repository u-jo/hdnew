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
@property (nonatomic,strong) NSMutableArray *arrayOfFriends;
@property (nonatomic)NSInteger *count;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfFriends count];
}

@synthesize arrayOfFriends = _arrayOfFriends;
-(void)setArrayOfFriends:(NSMutableArray *)arrayOfFriends
{
    _arrayOfFriends = arrayOfFriends;
}

- (NSMutableArray *)arrayOfFriends
{
    if (!_arrayOfFriends) {
        _arrayOfFriends = [[NSMutableArray alloc]init];
    }
    return _arrayOfFriends;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [FBSession.activeSession requestNewReadPermissions:@[@"user_groups",@"email", @"user_photos", @"friends_photos",@"read_friendlists"] completionHandler:^(FBSession *session, NSError *error) {
        if (!error) {
            [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions", @"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                [self requestForFeed];
            }];
        }
    }];
}

- (void)requestForFeed
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self createGraphObject];
    [self.tableView reloadData];
    
}

- (void)createGraphObject
{
    NSString *request = @"/me/friendlists";
    NSString *accessToken = [FBSession.activeSession accessToken];
    NSDictionary *params = @{@"access_token" : accessToken, @"limit":[NSString stringWithFormat:@"%d",self.count] };
    [FBRequestConnection startWithGraphPath:request parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            FBGraphObject *graphObject = result[@"data"];
            NSString *ids;
            
            for (id objects in graphObject) {
                if ([objects[@"name"] isEqualToString:@"Close Friends"]) {
                    ids = objects[@"id"];
                }
            }
            NSString *request = [NSString stringWithFormat:@"/%@?fields=members",ids];
            NSLog(@"%@",request);
            [FBRequestConnection startWithGraphPath:request parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                for (id objecter in result[@"members"][@"data"]) {
                    NSLog(@"%@",objecter);
                    [self.arrayOfFriends addObject:objecter];
                }
                [self.tableView reloadData];
            }];

            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"We could not access Fix My Campus" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"error");
        }
    }];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *name = [self.arrayOfFriends objectAtIndex:indexPath.row][@"name"];
    cell.textLabel.text = name;
    // Configure the cell...
    
    return cell;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"ya");
    if ([segue.identifier isEqualToString:@"postToMap"]) {
        if ([segue.destinationViewController isKindOfClass:[MapPostViewController class]]) {
            MapPostViewController *mpvc = (MapPostViewController *)segue.destinationViewController;
            mpvc.image = self.image;
            mpvc.message = self.message;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil] ;
            
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.count = 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
