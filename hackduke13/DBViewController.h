//
//  DBViewController.h
//  hackduke13
//
//  Created by Felix Xiao on 11/16/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DBViewController : UIViewController

@property (strong,nonatomic) NSDictionary *myLiveDictionary;
- (void)pullFromOnline;
- (void)fillDatabase;

@end
