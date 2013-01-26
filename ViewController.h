//
//  ViewController.h
//  Cam22
//
//  Created by jeffry Bobb on 3/8/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import "FullImageViewController.h"

    //#import "AssetsLibrary.h"
    //#import "ALAssetsLibrary.h"
    //#import "ALAssetRepresentation.h"

@interface ViewController : UIViewController{
    
    
}

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureDevice *videoDevice;
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong)AVCaptureVideoDataOutput *frameOutput;
@property (nonatomic, strong)IBOutlet UIImageView *imageView;
@property (nonatomic, strong)CIContext *context;
@property (nonatomic, strong)IBOutlet UIImageView *imageView2;
- (IBAction)FullImageBottom:(id)sender;
- (IBAction)FullView:(id)sender;
- (IBAction)takePic:(UIButton *)sender;


@end
