//
//  SignatureService.m
//  appez
//
//  Created by Transility on 29/11/14.
//
//

#import "SignatureService.h"
#import "WebEvents.h"
#import "SmartUIUtility.h"

@implementation SignatureService

-(instancetype)initWithSmartServiceDelegate:(id<SmartServiceDelegate>)delegate{
    
    self=[super init];
    if(self)
    {
        smartServiceDelegate=delegate;
    }
    
    return self;
}

-(void)performAction:(SmartEvent *)smartevent
{
    smartEvent=smartevent;
    
    switch (smartEvent.smartEventRequest.serviceOperationId) {
        case WEB_SIGNATURE_SAVE_IMAGE:
            
            [self captureUserSignature:CAPTURE_MODE_SAVE_IMAGE];
            break;
         
         case WEB_SIGNATURE_IMAGE_DATA:
            
            [self captureUserSignature:CAPTURE_MODE_IMAGE_DATA];
            break;
            
        default:
            break;
    }
}

-(void)captureUserSignature:(int)captureMode
{
    //delegate the responsibility to smartSignature utility
    
    BOOL shouldSave=FALSE;
    
    if (captureMode == CAPTURE_MODE_SAVE_IMAGE) {
        
        shouldSave=TRUE;
    }
    
    NSString *signData=[AppUtils getJsonFromDictionary:smartEvent.smartEventRequest.serviceRequestData];
    [[SmartUIUtility sharedInstance] showSignatureView:signData WithImageSaveFlag:shouldSave andWithDelegate:self];
}

-(void)didCaptureUserSignatureWithSuccess:(NSString *)responseData
{
    //callback from utility if signature captured successfuly
    SmartEventResponse *smEventResponse = [[SmartEventResponse alloc]init] ;
    smEventResponse.isOperationComplete=TRUE;
    smEventResponse.serviceResponse=responseData;
    smEventResponse.exceptionType=0;
    smEventResponse.exceptionMessage=NULL;
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

-(void)didCaptureUserSignatureWithError:(int)exceptionType withMessage:(NSString *)exceptionMessage
{
    //callback from utility if error in capturing
    SmartEventResponse *smEventResponse = [[SmartEventResponse alloc]init] ;
    smEventResponse.isOperationComplete=TRUE;
    smEventResponse.serviceResponse=NULL;
    smEventResponse.exceptionType=exceptionType;
    smEventResponse.exceptionMessage=exceptionMessage;
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];

}

@end
