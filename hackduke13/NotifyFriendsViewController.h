//
//  NotifyFriendsViewController.h
//  hackduke13
//
//  Created by Lee Yu Zhou on 17/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *message;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
