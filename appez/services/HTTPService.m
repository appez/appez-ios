//
//  HTTPService.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "HTTPService.h"
#import "SmartEventResponse.h"
#import "WebEvents.h"
#import "NetworkService.h"

@implementation HTTPService

-(instancetype)initHttpServiceWithDelegate:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self) 
    {
        smartServiceDelegate=delegate;
    }
    return self;
}

/** Performs HTTP action based on SmartEvent action type
 * 
 *  @param smartEvent :  SmartEvent specifying action type for the HTTP action
 */

-(void)performAction:(SmartEvent*)smartevent
{
    smartEvent=smartevent;
    NetworkService *service=[[NetworkService alloc] initWithDelegate:self] ;
    BOOL createFile=smartevent.smartEventRequest.serviceOperationId ==WEB_HTTP_REQUEST_SAVE_DATA ? TRUE : NO;
    NSString *requestData=[AppUtils getJsonFromDictionary:smartEvent.smartEventRequest.serviceRequestData];
    [service performAsyncRequest:requestData WithFlag:createFile];
}

/** Updates SmartEventResponse and thereby SmartEvent based on the HTTP operation performed in NetworkService. 
 * Also notifies SmartServiceListener about successful completion of HTTP operation
 *
 * @param responseData : HTTP response data
 * 
 */
-(void)didCompleteHttpOperationWithSuccess:(NSString*)responseData
{
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:responseData];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

/** Notifies SmartServiceListener about unsuccessful completion of HTTP operation
 * 
 * @param exceptionData : Exception type
 * 
 */
-(void)didCompleteHttpOperationWithError:(int)exceptionType WithMessage:(NSString *)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}

@end
