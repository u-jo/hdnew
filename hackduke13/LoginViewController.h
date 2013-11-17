//
//  LoginViewController.h
//  hackduke13
//
//  Created by Lee Yu Zhou on 17/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
@interface LoginViewController : UIViewController<FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@end
