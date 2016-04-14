//
//  CameraConfigInformation.h
//  appez
//
//  Created by Transility on 05/08/13.
//
//

/**
 * CameraConfigInformation : Model bean defining parameters for the Camera
 * service. Its properties are user configurable via the web layer API for
 * Camera Service.
 *
 * */

#import <Foundation/Foundation.h>

@interface CameraConfigInformation : NSObject

@property(nonatomic,retain)  NSString *filter;// Defines the filter effect to be applied on the image. If no effect needs
// to be applied, then this parameter needs to be kept STANDARD. Effects
// that can be applied include SEPIA and MONOCHROME
@property(nonatomic,readwrite)  int quality;// the more the compression level that needs to be achieve, the higher the
// value of this parameter should be.
@property(nonatomic,retain)   NSString *returnType;// Indicates the format in which the image data should be returned to the
// web layer. Based on user selection, it can be either a saved image URL or
// Base64 encoded image data
@property(nonatomic,retain)   NSString * encoding;	// Defines the image encoding format.
@property(nonatomic,readwrite)  int width;// Defines the image width. Currently not configurable by the
// user and not used in image processing.
@property(nonatomic,readwrite)  int height;// Defines the image height. Currently not configurable by the
// user and not used in image processing.
@property(nonatomic,readwrite)  BOOL isFlashRequired;// Flag indicating whether or not the flash should be used. In modified
// current implementation, this flag is not used because now native camera
// app is launched and it already contains option for enabling/disabling
// flash
@property(nonatomic,retain)   NSString * direction;// User defined property indicating the camera direction that user wants to
// capture image from
@property(nonatomic,retain)     NSString* applicationName;
@property(nonatomic,readwrite)  int source;// Defines the source of image. Accpetable sources are device camera and
// image gallery

@end
