//
//  CameraConfigInformation.m
//  appez
//
//  Created by Transility on 05/08/13.
//
//

#import "CameraConfigInformation.h"
#import "SmartConstants.h"

@implementation CameraConfigInformation

@synthesize  filter;
@synthesize  quality;
@synthesize  returnType;
@synthesize  encoding;
@synthesize  width;
@synthesize  height;
@synthesize  isFlashRequired;
@synthesize  direction;
@synthesize  applicationName;
@synthesize  source;

//Initialize the parameters of the bean
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.quality=100;
        self.width=300;
        self.height=300;
        self.encoding=IMAGE_PNG; //setting the type of image to save as .png
        self.direction=CAMERA_BACK; //by default , setting the back camera of the device as source if it is device camera
        self.returnType=IMAGE_URL;
        self.applicationName=APP_NAME;
        self.filter=STANDARD; //setting default image mode
    }
    return self;
}

@end
