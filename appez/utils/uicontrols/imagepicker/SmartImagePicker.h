//
//  SmartImagePicker.h
//  appez
//
//  Created by Transility on 11/07/13.
//

/**
*This class is responsible for the view that is displayed whenever camera operation is 
*performed.It implements the
*protocols UIImagePickerControllerDelegate, and *UINavigationControllerDelegate
*/

#import <Foundation/Foundation.h>
#import "SmartNotificationDelegate.h"
#import "CameraConfigInformation.h"
#import "CommMessageConstants.h"


@interface SmartImagePicker : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    id<SmartNotificationDelegate> delegate;
     int serviceOpId;
     CameraConfigInformation *cameraConfigInformation;
}

-(instancetype)initWithDelegate:(id<SmartNotificationDelegate>)Delegate;
-(void)performRequest:(NSString*)requestdata withOperationId:(int)serviceOperationId;
@end
