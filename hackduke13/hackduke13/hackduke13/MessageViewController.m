//
//  MessageViewController.m
//  hackduke13
//
//  Created by Lee Yu Zhou on 16/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MessageViewController.h"
#import "MapPostViewController.h"
#import "DALinedTextView.h"
@interface MessageViewController ()
@property (strong, nonatomic) IBOutlet DALinedTextView *textView;

@property (nonatomic, strong) NSString *message;

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}
- (IBAction)done:(id)sender {
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView = [[DALinedTextView alloc] init];
    self.textView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.view addSubview:self.textView];
    

    self.textView.delegate = self;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"yes");
    if ([self.textView.text isEqualToString:@"Create a message!"]) {
        self.textView.text = @"";
        [self.view setNeedsDisplay];
    }
}
- (IBAction)endEditting:(id)sender {
    [self.textView resignFirstResponder];
    [self.view becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.text =@"";
    self.textView.delegate = self;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
    [self.view becomeFirstResponder];
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
    if ([segue.identifier isEqualToString:@"postToMap"]) {
        if ([segue.destinationViewController isKindOfClass:[MapPostViewController class]]) {
            MapPostViewController *mpvc = (MapPostViewController *)segue.destinationViewController;
            mpvc.image = self.image;
            mpvc.message = self.textView.text;
            self.navigationItem1.backBarButtonItem.title = @"";
        }
    }
}

@end
