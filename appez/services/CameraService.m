//
//  CameraService.m
//  appez
//
//  Created by Transility on 11/07/13.
//
//

#import "CameraService.h"
#import "SmartImagePicker.h"
#import "GTMBase64.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"
@implementation CameraService
@synthesize smartImagePicker;

/**
 * Creates the instance of CameraService
 *
 * @param delegate
 *            : SmartServiceDelegate that listens for completion events of
 *            the camera service and thereby helps notify them to the web
 *            layer
 */
-(instancetype)initWithCameraServiceWithDelegate:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        smartServiceDelegate=delegate;
    }
    return self;
}


-(void)performAction:(SmartEvent*)smartevent
{
    smartEvent = smartevent;
    @try {
        
        smartImagePicker=[[SmartImagePicker alloc] initWithDelegate:self];
       
        NSString *requestData=[AppUtils getJsonFromDictionary:smartEvent.smartEventRequest.serviceRequestData];
        NSLog(@"CameraService->PerformAction");
        [smartImagePicker performRequest:requestData withOperationId:smartevent.smartEventRequest.serviceOperationId];
        
    } @catch (NSException *rte) {
        SmartEventResponse *smartEventResponse =[[SmartEventResponse alloc] init];
        smartEventResponse.exceptionType=UNKNOWN_EXCEPTION.intValue;
        smartEventResponse.exceptionMessage=[rte description];
        smartEvent.smartEventResponse=smartEventResponse;
        [smartServiceDelegate didCompleteServiceWithError:smartEvent];
    }
}

/**
 * SmartCamera Delegate method that listens for successful completion of
 * camera service operation. Responsible for creating the SmartEventResponse
 * and dispatching it to the corresponding SmartServiceDelegate.Handling of imageResponse if it comes in byte stream is done in didResponseDataRecievedInBytes.
 *
 * @param imageResponse
 *            : Callback data from the image processor that contains
 *            well-formed response to be delivered to the web layer
 * */

-(void)didResponseDataReceived:(NSString*)imageResponse
{
    NSLog(@"didResponseDataReceived");

    imageResponse=[imageResponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    imageResponse=[imageResponse stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    imageResponse=[imageResponse stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:imageResponse];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

/** Notifies SmartServiceListener about unsuccessful completion of HTTP operation
 *
 * @param exceptionData : Exception type
 *
 */
-(void)didResponseErrorReceived:(int)exceptionData WithMessage:(NSString*)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionData andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}

@end
