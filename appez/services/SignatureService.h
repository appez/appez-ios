//
//  SignatureService.h
//  appez
//
//  Created by Transility on 29/11/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartSignatureDelegate.h"
#import "SmartEvent.h"
#import "SmartServiceDelegate.h"
#import "SmartService.h"
#import "AppUtils.h"

#define CAPTURE_MODE_SAVE_IMAGE  1
#define CAPTURE_MODE_IMAGE_DATA  2

@interface SignatureService : SmartService<SmartSignatureDelegate>
{
    SmartEvent *smartEvent;
    id <SmartServiceDelegate> smartServiceDelegate;
}
-(instancetype)initWithSmartServiceDelegate:(id<SmartServiceDelegate>)delegate;
@end
