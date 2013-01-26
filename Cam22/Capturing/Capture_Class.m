//
//  Capture_Class.m
//  Cam22
//
//  Created by Jeffry Bobb on 6/21/12.
//  Copyright (c) 2012 Develomentional Development. All rights reserved.
//

#import "Capture_Class.h"
@interface Capture_Class ()



@end

@implementation Capture_Class
-(void)renderView:(UIView*)view inContext:(CGContextRef)context{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    CGContextConcatCTM(context, [view transform]);
    CGContextTranslateCTM(context, -[view bounds].size.width * [[view layer]anchorPoint].x, -[view bounds].size.width * [[view layer]anchorPoint].y);
    [[view layer]renderInContext:context];
    CGContextRestoreGState(context);
}
-(void)captureOutput:(AVCaptureOutput*)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    CGSize imageSize = [[UIScreen mainScreen]bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
       else
           UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    float menubarUIOffset = 44.0;
    UIGraphicsPushContext(context);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height - menubarUIOffset)];
    UIGraphicsPopContext();
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
} 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
}

-(id)init{
    
    self = [super init];
    if(!self){
        
        self = [[Capture_Class alloc]init];
    }
    return self;
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
    
    NSString *saveFileName = [filename stringByAppendingPathExtension:@"PNG"] ;
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

@end
