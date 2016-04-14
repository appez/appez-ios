//
//  SmartImagePicker.m
//  appez
//
//  Created by Transility on 11/07/13.
//
//

#import "SmartImagePicker.h"
#import "SmartUIUtility.h"
#import "SmartConstants.h"
#import "ExceptionTypes.h"
#import "WebEvents.h"
#import "AppUtils.h"
#import "GTMBase64.h"

@interface SmartImagePicker (PrivateMethod)

-(void)parseCameraConfigInformation:(NSString*) cameraInfo;
-(UIImage *)changeImageSepia: (UIImage *)image;
-(UIImage*)changeImageToBlacknWhite:(UIImage*)originalImage;

@end

@implementation SmartImagePicker

-(instancetype)initWithDelegate:(id<SmartNotificationDelegate>)Delegate
{
    self = [super init];
	if (self != nil)
	{
        delegate=Delegate;
    }
    return self;
}

-(void)performRequest:(NSString *)requestdata withOperationId:(int)serviceOperationId
{
    serviceOpId=serviceOperationId;
    NSLog(@"SmartImagePicker->PerformAction");
    [self parseCameraConfigInformation:requestdata];
    if ([NSThread isMainThread])
    {
        [self performRequestOnMainThread];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performRequestOnMainThread];
        });
    }
}

/**
 *This method sets the parameters of the ImagePickerController, and checks whether the source
 *of image is camera, or gallery.If it is camera, then checks if the front camera has to be
 *used or the back camera has to be used.and sets the parameters of the 
 *UIImagepickerController
 *accordingly
 */
-(void)performRequestOnMainThread
{
    NSLog(@"SmatImagePicker->performRequestOnMainThread");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing=TRUE;
    
    if(serviceOpId == WEB_CAMERA_OPEN)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        else {
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            
            if([cameraConfigInformation.direction isEqualToString:CAMERA_FRONT])
                imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceFront;
            else if ([cameraConfigInformation.direction isEqualToString:CAMERA_BACK])
                imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
            
            if(cameraConfigInformation.isFlashRequired)
                imagePickerController.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;
        }
    }
    
    else if (serviceOpId==WEB_IMAGE_GALLERY_OPEN)
         imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    /// commented and replaced by below line..for ipad support also.[[SmartUIUtility sharedInstance].delegate presentModalViewController:imagePickerController animated:YES completion:nil];
    
    if(![AppUtils isDeviceiPad])
       [[SmartUIUtility sharedInstance].delegate presentModalViewController:imagePickerController animated:YES];
    else
    {
        [SmartUIUtility sharedInstance].viewController=imagePickerController;
        [[SmartUIUtility sharedInstance] showPopOverFromRect:CGRectMake(0, 0, 400,800) WithView:imagePickerController.view];
    }
}
/**
 The delegate method of the UIImagePickerControllerDelegate, which is implemented to specify what action to be performed when the camera has clicked finishing image and the picker has picked the image.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* filePath;
    //Get the originally picked image in the variable "image"
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    [AppUtils showDebugLog:[NSString stringWithFormat:@"image orientation just before jpeg  is %d",image.imageOrientation]];    //Check what filter has to be applied if needed and perform corresponding processing
    if([cameraConfigInformation.filter isEqualToString:MONOCHROME])
        image=[self changeImageToBlacknWhite:image];
    else if ([cameraConfigInformation.filter isEqualToString:SEPIA])
        image=[self changeImageSepia:image];
    
    image=[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:3];
    
    NSData *imageData=nil;
    //Set default imag encoding to png
    NSString *imageEncoding=IMAGE_PNG;
    
    //Check if iamge format is png or jpeg, and get the data bytes into imageData variable accordingly
    if ([cameraConfigInformation.encoding isEqualToString:IMAGE_JPEG]) {
        imageData = UIImageJPEGRepresentation(image,cameraConfigInformation.quality/100.0f);
        imageEncoding=IMAGE_JPEG;
    } else {
        imageData = UIImagePNGRepresentation(image);
    }
    
    int i=1;
    do{
        filePath = [NSString stringWithFormat:@"%@/%d.%@", docsPath,i++,imageEncoding];
      } while ([fileMgr fileExistsAtPath:filePath]);
    
    NSLog(@"SmartImagePicker->jusbBeforeSavingData");
    //save file
    if (![imageData writeToFile:filePath atomically:YES]){
        if (delegate && [delegate respondsToSelector:@selector(didResponseErrorReceived:WithMessage:)])
            [delegate didResponseErrorReceived:IO_EXCEPTION.intValue WithMessage:@""];
    } else {
        
        if(delegate && [delegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
        {
            //If the image url has to be returned to the user.
            if([cameraConfigInformation.returnType isEqualToString:IMAGE_URL])
                [delegate didResponseDataReceived:[AppUtils prepareImageSuccessResponse:filePath imageData:@"" WithImageFormat:imageEncoding]];
            //If the image data has to be returned to the user.
            else if([cameraConfigInformation.returnType isEqualToString:IMAGE_DATA])
                [delegate didResponseDataReceived:[AppUtils prepareImageSuccessResponse:@"" imageData:[GTMBase64 stringByEncodingData:imageData]  WithImageFormat:imageEncoding]];
        }
    }
    
   [[SmartUIUtility sharedInstance] hidePopOver];
   [[SmartUIUtility sharedInstance].delegate dismissViewControllerAnimated:YES completion:nil];
}

/**
 *This method is called when cancel button is pressed on the ImagePickerController view.
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[SmartUIUtility sharedInstance] hidePopOver];
    [[SmartUIUtility sharedInstance].delegate dismissViewControllerAnimated:YES completion:nil];
    [delegate didResponseDataReceived:@"-1"];
}

/**
 *This method is used to change the image provided as the parameter to the corresponding monochrome format and returning
 *the monochrome form image.
 @param: image
 *       The image that has to be converted to the monochrome format
 */
-(UIImage*)changeImageToBlacknWhite:(UIImage*)originalImage
{
    CGImageRef image = [originalImage CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(image),
                                                       CGImageGetHeight(image),
                                                       CGImageGetBitsPerComponent(image),
                                                       CGImageGetWidth(image)*4,
                                                       colorSpace,
                                                       (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), image);
    CGImageRef bwImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    CGImageRelease(bwImage);
    
    return resultImage;
}

/**
 *This method is used to change the image provided as the parameter to the corresponding sepia format and returning
 *the sepia form image.
 @param: image
 *       The image that has to be converted to the sepia format
 */
-(UIImage *)changeImageSepia: (UIImage *)image{
    
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       CGImageGetBitsPerComponent(originalImage),
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    
    UInt8 *data = CGBitmapContextGetData(bitmapContext);
    int numComponents = 4;
    NSInteger bytesInContext = CGBitmapContextGetHeight(bitmapContext) * CGBitmapContextGetBytesPerRow(bitmapContext);
    
    int redIn=0, greenIn=0, blueIn=0, redOut=0, greenOut=0, blueOut=0;
    
    for (int i = 0; i < bytesInContext; i += numComponents) {
        redIn = data[i];
        greenIn = data[i+1];
        blueIn = data[i+2];
        
        // the values based on other colors are added, so that at alpha 0.0 they could equate to, for example redOut = redIn + 0.0 + 0.0
        redOut = (int)(redIn * (.393 )) + (greenIn * (.769 )) + (blueIn * (.189 ));
        greenOut = (int)(redIn * (.349 )) + (greenIn * (.686 )) + (blueIn * (.168 ));
        blueOut = (int)(redIn * (.272 )) + (greenIn * (.534 )) + (blueIn * (.131 ));
        
        // overflow corner case
        if (redOut>255) redOut = 255;
        if (blueOut>255) blueOut = 255;
        if (greenOut>255) greenOut = 255;
        
        //Sepia code
        data[i] = (redOut);
        data[i+1] = (greenOut);
        data[i+2] = (blueOut);
    }

    CGImageRef outImage=CGBitmapContextCreateImage(bitmapContext);
    //UIImage *newImage=[UIImage imageWithCGImage:outImage];
    UIImage *newImage=[UIImage imageWithCGImage:outImage scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(outImage);
    CFRelease(bitmapContext);
   
    return newImage;
}

/**
 *This method is used to parse the camera configuration to determine all the parameters needed for getting image 
 *like the source used should be gallery or camera, in the camera mode, whether to use front or the back camera,
 *and the height and width of the image to be taken, and the encoding, and the image filter like sepia,monochrome
 *etc.
 @param: cameraInfo
 *       The camera info that is to be parsed.
 */
-(void)parseCameraConfigInformation:(NSString*) cameraInfo {
    
    NSLog(@"parseCameraConfigInformation");
    
    cameraConfigInformation = [[CameraConfigInformation alloc] init];
    
    @try {
        NSDictionary *cameraConfiguration =[AppUtils getDictionaryFromJson:cameraInfo];
      
        if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_IMG_ENCODING])
        cameraConfigInformation.encoding=[cameraConfiguration valueForKey:MMI_REQUEST_PROP_IMG_ENCODING];
        
         if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_IMG_FILTER])
        cameraConfigInformation.filter=[cameraConfiguration valueForKey:MMI_REQUEST_PROP_IMG_FILTER];
        
        if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_IMG_SRC])
       cameraConfigInformation.source=[[cameraConfiguration valueForKey:MMI_REQUEST_PROP_IMG_SRC] intValue];
        
        if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_IMG_COMPRESSION])
       cameraConfigInformation.quality=[[cameraConfiguration valueForKey:MMI_REQUEST_PROP_IMG_COMPRESSION] intValue];
        
        if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_IMG_RETURN_TYPE])
       cameraConfigInformation.returnType=[cameraConfiguration valueForKey:MMI_REQUEST_PROP_IMG_RETURN_TYPE];
        
        if([cameraConfiguration.allKeys containsObject:MMI_REQUEST_PROP_CAMERA_DIR])
        cameraConfigInformation.direction=[cameraConfiguration valueForKey:MMI_REQUEST_PROP_CAMERA_DIR];
        
        if([cameraConfiguration.allKeys containsObject:@"appName"])
        cameraConfigInformation.applicationName=[cameraConfiguration valueForKey:@"appName"];
        
        
    } @catch (NSException* error) {
        
        if (delegate && [delegate respondsToSelector:@selector(didResponseErrorReceived:WithMessage:)])
            [delegate didResponseErrorReceived:IO_EXCEPTION.intValue WithMessage:@""];

    }
}

@end
