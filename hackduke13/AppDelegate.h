//
//  AppDelegate.h
//  hackduke13
//
//  Created by Felix Xiao on 11/16/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <CommonCrypto/CommonDigest.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "DBViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

//SQLite database properties
@property (nonatomic) sqlite3 *MyContent;
@property (strong,nonatomic) NSString *databasePath;
@property (strong,nonatomic) NSString *docsDir;
@property (strong,nonatomic) NSArray *dirPaths;

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSMutableArray *allContent;
//SQLite database methods
- (void)openDB;
- (void)pullDB;  //
- (void)closeDB;

@end
