/*
     File: APLViewController.m
 Abstract: Main view controller for the application.
  Version: 2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "APLViewController.h"
#import "MessageViewController.h"
#import "UIToolbar+EEToolbarCenterButton.h"
#import "LoginViewController.h"
@interface APLViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIImageView *paws;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSMutableArray *capturedImages;

@end



@implementation APLViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSString *message = @"No camera available!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    if (self.imageView.image == NULL) {
        self.paws.image = [UIImage imageNamed:@"paw_print2.png"];
    }
    [self updateUI];
}

-(void)updateUI {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    UIViewController *selectedViewController = [navigationController topViewController];
    UIViewController *viewController;
    
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)selectedViewController;
        viewController = [navController topViewController];
    } else {
        viewController = selectedViewController;
    }
    
    if (![[viewController presentedViewController] isKindOfClass:[LoginViewController class]] && ![FBSession.activeSession isOpen]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [viewController presentViewController:loginViewController animated:NO completion:nil];
    }
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    if (self.imageView.image) {
        self.imageView.image = nil;
    }
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;

        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.toolBar.centerButtonFeatureEnabled = YES;
        NSString *imageName = @"CenterButtonIconPaw";
        NSString *highlightedImageName = @"CenterButtonIconPawHighlighted";
        NSString *disabledImageName = @"CenterButtonIconHeartDisabled";
        UIImage *centerButtonImage = [UIImage imageNamed:imageName];
        UIImage *centerButtonImageHighlighted = [UIImage imageNamed:highlightedImageName];
        UIImage *centerButtonImageDisabled = [UIImage imageNamed:disabledImageName];
        EEToolbarCenterButtonItem *centerButtonItem = [[EEToolbarCenterButtonItem alloc]
                                                       initWithImage:centerButtonImage
                                                       highlightedImage:centerButtonImageHighlighted
                                                       disabledImage:centerButtonImageDisabled
                                                       target:self
                                                       action:@selector(takePhoto:)];
        self.toolBar.centerButtonOverlay.buttonItem = centerButtonItem;

        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }

    self.imagePickerController = imagePickerController;
    
   
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    [self finishAndUpdate];
}
- (IBAction)swapCamera:(id)sender {
    self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}


- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];

    self.paws.image = NULL;
    if ([self.capturedImages count] > 0)
    {
        
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            UIImage *image = [self.capturedImages objectAtIndex:0];
            
            if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
                [self.imageView setImage:image];
            }
            if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                UIImage * flippedImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
                
                image = flippedImage;
                [self.imageView setImage:image];
            }
        }
        else
        {
            
            UIImage *image = [self.capturedImages objectAtIndex:0];
            
            if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
                [self.imageView setImage:image];
            }
            if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                UIImage * flippedImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
                
                image = flippedImage;
                [self.imageView setImage:image];
            }
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }

    self.imagePickerController = nil;
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    [self.capturedImages addObject:image];


    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sendMessage"]) {
        if ([segue.destinationViewController isKindOfClass:[MessageViewController class]]) {
            MessageViewController *mvc = (MessageViewController *)segue.destinationViewController;
            mvc.image = self.imageView.image;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                              style:UIBarButtonItemStyleBordered
                                             target:nil
                                             action:nil] ;
        }
    }
}
@end

