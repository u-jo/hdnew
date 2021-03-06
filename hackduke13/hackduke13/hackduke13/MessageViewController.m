//
//  MessageViewController.m
//  hackduke13
//
//  Created by Lee Yu Zhou on 16/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MessageViewController.h"
#import "NotifyFriendsViewController.h"
#import "DALinedTextView.h"
#import "MapViewController.h"
@interface MessageViewController ()
@property (strong, nonatomic) IBOutlet DALinedTextView *textView;

@property (nonatomic, strong) NSString *message;

@end

@implementation MessageViewController
- (IBAction)flipView:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NULL];
    MapViewController *mvc = [sb instantiateViewControllerWithIdentifier:@"mapViewController"];
    mvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:mvc animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (IBAction)done:(id)sender {
    NSLog(@"yes");
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"yes");
    if ([textView.text isEqualToString:@"Create a message!"]) {
        self.textView.text = @"";
        [self.view setNeedsDisplay];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.text =@"Create a message!";
    self.textView.delegate = self;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next:(id)sender {
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"notifyFriends"]) {
        if ([segue.destinationViewController isKindOfClass:[NotifyFriendsViewController class]]) {
            NotifyFriendsViewController *mpvc = (NotifyFriendsViewController *)segue.destinationViewController;
            mpvc.image = self.image;
            mpvc.message = self.textView.text;
            self.navigationItem.backBarButtonItem.title = @"";
            NSLog(@"%@",mpvc.message );
        }
    }
}

@end
