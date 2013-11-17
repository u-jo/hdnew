//
//  DetailedViewController.m
//  hackduke13
//
//  Created by Lee Yu Zhou on 17/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "DetailedViewController.h"

@interface DetailedViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet DALinedTextView *textView;

@end

@implementation DetailedViewController
- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES
 completion:^{
     
 }];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = self.image;
    NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.felixxiao.com/uploads/%@",self.myURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:myURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.imageView.image = image;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
