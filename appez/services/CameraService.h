//
//  CameraService.h
//  appez
//
//  Created by Transility on 11/07/13.
//
//
/**
 * CameraService : Provides access to the camera hardware of the device.
 * Supports capturing image from the camera or getting image from the gallery.
 * Also allows the user to perform basic filter operations on the image such as
 * Monochrome and Sepia
 *
 * */
#import "SmartService.h"
#import "SmartService.h"
#import "SmartServiceDelegate.h"
#import "SmartNotificationDelegate.h"
#import "SmartImagePicker.h"


@interface CameraService : SmartService <SmartNotificationDelegate>
{
    SmartEvent *smartEvent;
    id<SmartServiceDelegate> smartServiceDelegate;
}
@property(strong) SmartImagePicker *smartImagePicker;
-(instancetype)initWithCameraServiceWithDelegate:(id<SmartServiceDelegate>)delegate;
-(void)performAction:(SmartEvent*)smartevent;
@end
