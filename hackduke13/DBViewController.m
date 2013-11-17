//
//  DBViewController.m
//  hackduke13
//
//  Created by Felix Xiao on 11/16/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "DBViewController.h"
#import <sqlite3.h>

@interface DBViewController ()

@end

@implementation DBViewController
{
    //private variables for accessing SQLite database
    sqlite3 *MyContent;
}

@synthesize myLiveDictionary;

- (void)pullFromOnline
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.felixxiao.com/hackduke13.php"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    (void)[myConnection initWithRequest:request delegate:self];
}

- (void)fillDatabase
{
    //use myLiveDictionary to put everything into the local database
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    
    for (NSDictionary *d in myLiveDictionary) {
        NSLog(@"%@",d);
        sqlite3_stmt *statement;
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO local (id,username,timestamp,imgURL,description,latitude,longitude,restrictions,special1,special2) VALUES (%i,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[d objectForKey:@"id"] integerValue],[d objectForKey:@"username"],[d objectForKey:@"timestamp"],[d objectForKey:@"imgURL"],[d objectForKey:@"description"],[d objectForKey:@"latitude"],[d objectForKey:@"longitude"],[d objectForKey:@"restrictions"],[d objectForKey:@"special1"],[d objectForKey:@"special2"]];
        const char *query_stmt = [querySQL UTF8String];
    
        if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
            if (sqlite3_step(statement) == SQLITE_DONE) {
                //NSLog(@"A new photo has been added to the database via SQL statement: %s",query_stmt);
            } else {
                NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
            }
        
        } else {
            NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
        }
        sqlite3_finalize(statement);
    }
    
}

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

#pragma mark NSURLConnection Delegate Methods
//TENTATIVE - WHAT HAPPENS WHEN THE CONNECTION FIRST RECEIVES DATA
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    
}

//TENTATIVE - WHAT HAPPENS AS THE CONNECTION BEGINS RECEIVING DATA
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    NSError* error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
    //NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    
    //NSLog(@"My accounts are:%@",theReply);
    myLiveDictionary = dictionary;
    [self fillDatabase];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
