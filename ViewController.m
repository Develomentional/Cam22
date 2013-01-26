//
//  ViewController.m
//  Cam22
//
//  Created by jeffry Bobb on 3/8/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import "AssetsLibrary.h"
#import "FullImageViewController.h"
#import "Date_Class.h"
#import "Capture_Class.h"
@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, FullImageViewDelegetePotocol>
{
    CIFilter* _invertF;
    AVCaptureStillImageOutput  *_StillPicture;

}
@property (nonatomic, strong)FullImageViewController *FullViewController;
@property (nonatomic, strong)NSDictionary *contextDic;
@property (nonatomic, strong)ALAssetsLibrary *photoLibrary;
@property (nonatomic, strong)CIImage *ciImageStill;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
@property (nonatomic, strong)UIImage *capturedimage;
@property (nonatomic, strong)NSNumber *picCounter;
@property (nonatomic, strong)NSString *saveBaseDir;
@property (nonatomic, strong)Date_Class *DDdate_Class;
@property (nonatomic, strong)Capture_Class *captureFunc;
@property (nonatomic, strong)CIFilter* invertF;
@property (nonatomic, strong)   AVCaptureStillImageOutput  *StillPicture;
  
-(void)handleSingleTap;

@end

@implementation ViewController
@synthesize previewLayer = _previewLayer;
@synthesize context = _context;
@synthesize imageView = _imageView;
@synthesize imageView2 =_imageView2;
@synthesize frameOutput = _frameOutput;
@synthesize videoInput =_videoInput;
@synthesize videoDevice = _videoDevice;
@synthesize session =_session;
@synthesize contextDic = _contextDic;
@synthesize ciImageStill = _ciImageStill;
@synthesize photoLibrary = _photoLibrary;
@synthesize orientation = _orientation;
@synthesize capturedimage = _capturedimage;
@synthesize saveBaseDir;
@synthesize picCounter = _picCounter;
@synthesize DDdate_Class = _DDdate_Class;
@synthesize captureFunc = _captureFunc;
@synthesize FullViewController =_FullViewController;
@synthesize fullScreenImage;
-(FullImageViewController *)FullViewController{
    if (!_FullViewController) {
        _FullViewController = [[FullImageViewController alloc]init];
        
    }
    return _FullViewController;
}

-(Date_Class *)DDdate_Class{
    if (!_DDdate_Class) {
        _DDdate_Class = [[Date_Class alloc]init];
    } 
    
    return _DDdate_Class;
}
-(Capture_Class *)captureFunc{
    if (!_captureFunc) {
        _captureFunc = [[Capture_Class alloc]init];
    } 
    
    return _captureFunc;
}
-(NSNumber *)picCounter{
   if (!_picCounter) _picCounter = [[NSNumber alloc]initWithInt:0];
    return _picCounter;
}

-(CIImage*)ciImageStill{
if (!_ciImageStill) {
  _ciImageStill  = [[CIImage alloc]init];
}


return _ciImageStill;
}


#pragma mark - CIFilters
-(CIImage*)CIHueAdjust:(CIImage*)inputImage{
    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    [hueAdjust setDefaults];
    [hueAdjust setValue:inputImage forKey:kCIInputImageKey];
    [hueAdjust setValue:[NSNumber numberWithFloat:8.094] forKey: @"inputAngle"];
    return  hueAdjust.outputImage;

}

-(CIImage*)CIGradient:(CIImage*)inputImage{
    CIFilter *gradient= [CIFilter filterWithName:@"CIRadialGradient"];
                    [gradient setDefaults];
                    [gradient setValue:inputImage forKey:kCIInputImageKey];
                    [gradient setValue:[NSNumber numberWithInt:100] forKey:@"inputRadius0"];
                    [gradient setValue:[NSNumber numberWithInt:600] forKey:@"inputRadius1"];
    
                    [gradient setValue:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f] forKey:@"inputColor0"];
                    [gradient setValue:[UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f] forKey:@"inputColor1"];
    
    
        //   [self printFilterInfo:gradient];
    return  gradient.outputImage;

}
-(CIImage*)CIBlur:(CIImage*)inputImage{
    CIFilter* blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blur setValue:inputImage forKey:kCIInputImageKey];
    [blur setValue:@3.0f forKey:@"inputRadius"];
    return blur.outputImage;
    
}
-(CIImage*)CIInvert:(CIImage*)inputImage{
    CIFilter*  invert = [CIFilter filterWithName:@"CIColorInvert"];
   [ invert setValue:inputImage forKey:kCIInputImageKey];
    
    return invert.outputImage;
}
-(CIImage*)CICrop:(CIImage*)inputImage{
    CIFilter *crop = [CIFilter filterWithName:@"CICrop"];
    [crop setValue:inputImage forKey:kCIInputImageKey];
    [crop setValue:[CIVector vectorWithCGRect:[inputImage extent]] forKey:@"inputRectangle"];
    return crop.outputImage;
}
-(CIImage*)CIBloom:(CIImage*)inputImage
{
    CIFilter *bloom =[CIFilter filterWithName:@"CIBloom"];
    [bloom setValue:inputImage forKey:kCIInputImageKey];
    [bloom setValue:@100 forKey:@"inputRadius"];
    [bloom setValue:@1.0f forKey:@"inputIntensity"];
    return bloom.outputImage;
    
}
-(CIImage*)CISimpleEdgeDetection:(CIImage*)inputImage
{
    CIFilter *desaturate=[CIFilter filterWithName:@"CIColorControls"];
    [desaturate setValue:inputImage forKey:kCIInputImageKey];
    [desaturate setValue:@0.0f forKey:@"inputSaturation"];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blur setValue:desaturate.outputImage forKey:kCIInputImageKey];
    [blur setValue:@3.0f forKey:@"inputRadius"];
    
    CIFilter*  invert = [CIFilter filterWithName:@"CIColorInvert"];
    [ invert setValue:blur.outputImage forKey:kCIInputImageKey];
    
    CIFilter*  blendDodge= [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    [blendDodge setValue:invert.outputImage forKey:kCIInputBackgroundImageKey];
    [blendDodge setValue:desaturate.outputImage forKey:kCIInputImageKey];
    
    CIFilter*  blendBurn= [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    [blendBurn setValue:blendDodge.outputImage forKey:kCIInputImageKey];
     [blendBurn setValue:inputImage forKey:kCIInputBackgroundImageKey];
    
   
    return blendBurn.outputImage;
    
}
-(CIImage*)CIPinch:(CIImage*)inputImage pinchRadius:(CGFloat)radius pinchScale:(CGFloat)scale
{
    if (scale > 2) {
        scale = 2.0f;
    }
    CIFilter *pinchF =[CIFilter filterWithName:@"CIPinchDistortion"];
    [pinchF setValue:inputImage forKey:kCIInputImageKey];
        //if filter uses inputRadius
        [pinchF setValue:@(radius) forKey:@"inputRadius"];
      [pinchF setValue:@(scale) forKey:@"inputScale"];
        //if filter uses inputIntensity
        //[filter setValue:@1.0f forKey:@"inputIntensity"];
        //if filter uses inputAngle
        //[filter setValue:[NSNumber numberWithFloat:<#float#>] forKey: @"inputAngle"];
        //if filter uses inputRectangle
        //[filter setValue:[CIVector vectorWithCGRect:[inputImage extent]] forKey:@"inputRectangle"];
        //if filter uses inputSaturation
        //[filter setValue:@0.0f forKey:@"inputSaturation"];
    return pinchF.outputImage;
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"FullView"]) {
       
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            //=  UIGraphicsGetImageFromCurrentImageContext();
        [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
         
            //UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
       
        [segue.destinationViewController setFullScreenImage: self.imageView];
        [segue.destinationViewController setImageF:self.imageView.image];
         UIGraphicsEndImageContext();

    }
    
}

- (void)deviceOrientationDidChange
{	
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
	if (deviceOrientation == UIDeviceOrientationPortrait)
		self.orientation = AVCaptureVideoOrientationPortrait;
        //else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        //self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
	
        // AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
	else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
		self.orientation = AVCaptureVideoOrientationLandscapeRight;
	else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
		self.orientation = AVCaptureVideoOrientationLandscapeRight;
	
        // Ignore device orientations for which there is no corresponding still image orientation (e.g. UIDeviceOrientationFaceUp)
}




-(NSDictionary *)_contextDic{

    
    if (!_contextDic) {
   _contextDic = [[NSDictionary alloc]init];
}


return _contextDic;
}


-(ALAssetsLibrary *)photoLibrary{
   if(!_photoLibrary) _photoLibrary = [[ALAssetsLibrary alloc]init];
    return _photoLibrary;
    
}


-(CIContext*)context{
if (!_context) {
    _context = [CIContext contextWithOptions:self.contextDic];  
}
return _context;
}
- (NSString *)saveBaseDir {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);  
        return [array objectAtIndex:0];
}

- (BOOL) captureView:(UIView *)aview name:(NSString *)filename {
    
    UIGraphicsBeginImageContext(aview.frame.size);
    [aview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *saveFileName = filename;
    NSString *saveFilePath = [[self saveBaseDir] stringByAppendingPathComponent:saveFileName];
    
    NSData *data = UIImagePNGRepresentation(viewImage);
    NSError *error = nil;
    [data writeToFile:saveFilePath options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Error png file:%@ error=%@", saveFileName, [error description]);
        return NO;
    } else {
        NSLog(@"Success png file:%@", saveFileName);
        return YES;
    }
}



-(void)saveToDisk{
    [self captureView:self.view name:[self.DDdate_Class Todays_Date]];
 
    }

  /*  
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:2.0f];
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [animation setTimingFunction:tf];
    [animation setType:@"rippleEffect"];
    [self.previewLayer addAnimation:animation forKey:NULL];
    
    useFilters = !useFilters;
}

-(void)handleSingleTap:(UIGestureRecognizer *)singleTap{
   CGPoint tapPoint= [singleTap locationInView:self.imageView];
    if (singleTap) {
       
        
    } 
   
        // _singleTap = [[UIGestureRecognizer alloc]initWithTarget:self action:([self captureStillImage])];
}
   */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
   
    self.ciImageStill = ciImage;
    CIImage* filteredImage = [self CIInvert:ciImage];
    
    CGImageRef ref =[self.context createCGImage:filteredImage  fromRect:filteredImage.extent];
    CIImage* bluedImage = [self CIInvert:[self CISimpleEdgeDetection:ciImage]];
 CGImageRef ref2 =[self.context createCGImage:bluedImage  fromRect:bluedImage.extent];
    self.imageView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:self.orientation ];
    self.imageView2.image = [UIImage imageWithCGImage:ref2 scale:1.0 orientation:self.orientation ];
                                                                                
    
       CGImageRelease(ref2);
    CGImageRelease(ref);    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)takePicture{
        //   [DSBezelActivityView newActivityViewForView:self.navigationController.navigationBar.superview withLabel:@"Capturing image" width:160];
    AVCaptureConnection* videoConnection = nil;
    for (AVCaptureConnection *connection in [[self StillPicture] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType]isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    NSLog(@"Requesting still image capture from %@",[self StillPicture]);
    [[self StillPicture] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, CFSTR("MetadataDictionary"), NULL);
        if (exifAttachments) {
            NSLog(@"Attachments :%@",exifAttachments);
            
        }else{
            NSLog(@"No Attachments");
            
        }
        NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
            //   [self setStillUIImage:image];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:(__bridge NSDictionary *)(exifAttachments)
                                  completionBlock:^(NSURL *assetURL, NSError *error) {
                                      if (error) {
                                          NSLog(@"Error %@", [error localizedDescription]);
                                      } else {
                                              //  [self checkForAndDeleteFile];
                                          NSLog(@"finished saving");
                                      }
                                  }];
        [_session startRunning];
            // [DSBezelActivityView removeViewAnimated:YES];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.session =[[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
    
    self.videoDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    
    self.frameOutput = [[AVCaptureVideoDataOutput alloc]init];
    self.frameOutput.videoSettings =[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
        // [self.session addOutput:self.stillImage];
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue ()];
    
    [self.session startRunning];
 
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self deviceOrientationDidChange];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
        // create memory pool for handling our images since we are off the main thread.
    @autoreleasepool {
        
            // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
        
            // turn buffer into an image we can manipulate
        CIImage *result = [CIImage imageWithCVPixelBuffer:imageBuffer];
        
            // store final usable image
        CGImageRef finishedImage;
        
        if( useFilters ) {
                // hue
            CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
            [hueAdjust setDefaults];
            [hueAdjust setValue:result forKey:@"inputImage"];
            [hueAdjust setValue:[NSNumber numberWithFloat:8.094] forKey: @"inputAngle"];
            result = hueAdjust.outputImage;
            
            
                // gradient
                //            CIFilter *redEye = [CIFilter filterWithName:@"CIRadialGradient"];
                //            [redEye setDefaults];
                //            [redEye setValue:result forKey:@"inputImage"];
                //            [redEye setValue:[NSNumber numberWithInt:100] forKey:@"inputRadius0"];
                //            [redEye setValue:[NSNumber numberWithInt:600] forKey:@"inputRadius1"];
                //            
                //            [redEye setValue:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f] forKey:@"inputColor0"];
                //            [redEye setValue:[UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f] forKey:@"inputColor1"];
                //            result = redEye.outputImage;
            
                //            [self printFilterInfo:redEye];
            
            
                // invert
                //            CIFilter *invert = [CIFilter filterWithName:@"CIColorInvert"];
                //            [invert setDefaults];
                //            [invert setValue:result forKey:@"inputImage"];
                //            result = invert.outputImage;
        }
        else {
                // add vibrance
            
        }
        
        finishedImage = [self.context createCGImage:result fromRect:[result extent]];    
        
        [self.previewLayer performSelectorOnMainThread:@selector(setContents:) withObject:(__bridge id)finishedImage waitUntilDone:YES];
        
        CGImageRelease(finishedImage);
    }    }


*/
-(void)captureStillImage:(UIImageView*)inputView{
      [self.captureFunc captureView:inputView name:[self.DDdate_Class Todays_Date]];
}

-(void)captureStillImage{
    
    self.capturedimage = [[UIImage alloc]initWithCIImage:self.ciImageStill];
        // CGImageRef still = [self.context createCGImage:self.ciImageStill fromRect:self.view.bounds];
    
    
    
}
    //#define PICTURE_NUMBER_KEY @"pNumber"
- (IBAction)takePic:(UIButton *)sender
{ 
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self takePicture];
    int picNumber = picNumber + 1;
    NSString *dateString = [[NSString alloc]init];
    dateString = [self.DDdate_Class Todays_Date];
        //CGImageRef still = [self.context createCGImage:self.ciImageStill fromRect:self.view.bounds];
    NSLog(@"%@",dateString);

    [self.captureFunc captureView:self.imageView name:[self.DDdate_Class Todays_Date]];
    [self captureStillImage:self.imageView2];
        //[self captureView:self.imageView name: [[NSString alloc]initWithFormat: @"%@",[self.DDdate_Class Todays_Date]]];

}
- (IBAction)FullImageBottom:(id)sender {
    [self captureStillImage:self.imageView];
}

- (IBAction)FullView:(id)sender {
    [self captureStillImage:self.imageView2];

}
@end
