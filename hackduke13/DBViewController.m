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

- (void)populateContent
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MyContent = [appDelegate MyContent];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM local"];
    const char *query_stmt = [querySQL UTF8String];
    
    if (sqlite3_prepare_v2(MyContent,query_stmt,-1,&statement,NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *temp;
            
            NSMutableDictionary *myDictionary = [NSMutableDictionary dictionary];
            
            //field 1: currently username
            temp = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,1)];
            [myDictionary setObject:temp forKey:@"username"];
            

            //field 2: currently: 'timestamp'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,2)];
            [myDictionary setObject:temp forKey:@"timestamp"];
            
            //field 3: currently: 'imgurl'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,3)];
            [myDictionary setObject:temp forKey:@"imgURL"];
            
            //field 4: currently: 'description'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,4)];
            [myDictionary setObject:temp forKey:@"description"];
            
            //field 5: currently: 'latitude'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,5)];
            [myDictionary setObject:temp forKey:@"latitude"];
            
            //field 6: currently: 'longitude'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,6)];
            [myDictionary setObject:temp forKey:@"longitude"];
            
            //field 7: currently: 'restrictions'
            temp = [temp initWithUTF8String:(const char*) sqlite3_column_text(statement,7)];
            [myDictionary setObject:temp forKey:@"restrictions"];
            
            [appDelegate.allContent addObject:myDictionary];
            
        }
        
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"%s SQL error '%s' (%1d)",query_stmt,sqlite3_errmsg(MyContent),sqlite3_errcode(MyContent));
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
    [self populateContent];
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
