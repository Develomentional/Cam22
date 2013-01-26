//
//  Capture_Class.h
//  Cam22
//
//  Created by Jeffry Bobb on 6/21/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import "AssetsLibrary.h"
#import "FullImageViewController.h"
#import "Date_Class.h"
@interface Capture_Class : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


-(id)init;
- (NSString *)saveBaseDir;
- (BOOL) captureView:(UIView *)aview name:(NSString *)filename;
-(void)renderView:(UIView*)view inContext:(CGContextRef)context;
-(void)captureOutput:(AVCaptureOutput*)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
