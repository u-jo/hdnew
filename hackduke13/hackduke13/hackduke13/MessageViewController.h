//
//  MessageViewController.h
//  hackduke13
//
//  Created by Lee Yu Zhou on 16/11/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController<UINavigationBarDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem1;
@property (nonatomic, strong) UIImage *image;
@end
