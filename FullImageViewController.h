//
//  FullImageViewController.h
//  Cam22
//
//  Created by jeffry Bobb on 3/11/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capture_Class.h"
#import "Date_Class.h"


@protocol FullImageViewDelegetePotocol <NSObject>
@property (nonatomic, strong)IBOutlet UIImageView  *fullScreenImage;

@end

@interface FullImageViewController : UIViewController
{
     UIImage   *_imageF;
}
- (IBAction)takeJPeg:(id)sender;
- (IBAction)takePNG:(id)sender;
@property (nonatomic, strong) UIImage   *imageF;
@property (nonatomic, strong)IBOutlet UIImageView  *fullScreenImage;
@end
