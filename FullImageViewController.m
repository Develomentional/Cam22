//
//  FullImageViewController.m
//  Cam22
//
//  Created by jeffry Bobb on 3/11/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import "FullImageViewController.h"
#import "ViewController.h"

@interface FullImageViewController ()
@property (nonatomic, strong)Date_Class *DDdate_Class;
@property (nonatomic, strong)Capture_Class *captureFunc;
@end

@implementation FullImageViewController
@synthesize fullScreenImage = _fullScreenImage;
@synthesize DDdate_Class =  _DDdate_Class;
@synthesize captureFunc = _captureFunc;
@synthesize imageF = _imageF;

- (IBAction)takeJPeg:(id)sender
{
    [self.captureFunc captureView:self.fullScreenImage name:[self.DDdate_Class Todays_Date]];
       [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)takePNG:(id)sender
{
    
    [self.captureFunc captureView:self.fullScreenImage.viewForBaselineLayout name:[self.DDdate_Class Todays_Date]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImageView *)fullScreenImage{
if (!_fullScreenImage) {
  _fullScreenImage  = [[UIImageView alloc]init];
}


return _fullScreenImage;
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
    self.fullScreenImage.image = self.imageF;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
