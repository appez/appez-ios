//
//  SmartEventProcessor.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SmartEventProcessor.h"
#import "SmartService.h"
#import "Reachability.h"

@interface SmartEventProcessor(PrivateMethods)
-(void)handleWebEvent:(SmartEvent*)smartEvent;
-(void)handleAppEvent:(SmartEvent*)smartEvent;
-(void)handleCoEvent:(SmartEvent*)smartEvent;
-(void)didCompleteServiceWithError:(SmartEvent*)smartEvent;
@end

@implementation SmartEventProcessor
@synthesize smartServiceRouter;

-(instancetype)initSmartEventProcessorWithDelegate:(id<SmartEventDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        smartEventDelegate=delegate;
        smartServiceRouter=[[SmartServiceRouter alloc] initSmartServiceRouter:self];
    }
    return self;
}



//-------------------------------------------------------------------------------------------------------------------------
-(void)processSmartEvent:(SmartEvent*)smartEvent
{
    int eventType = smartEvent.eventType;
    
    switch (eventType)
    {
        case WEB_EVENT:
            [self handleWebEvent:smartEvent];
            break;
            
        case CO_EVENT:
            [self handleCoEvent:smartEvent];
            break;
            
        case APP_EVENT:
            [self handleAppEvent:smartEvent];
            break;
    }
}

/**
 * Specifies action to be taken on the basis of type SmartEvent service.
 * Initialises SmartService via SmartServiceRouter and performs desired
 * Action
 *
 * @param smartEvent
 *            : SmartEvent that specifies service to be processed
 */
-(void)handleWebEvent:(SmartEvent*)smartEvent
{
    int serviceType = smartEvent.serviceType;
    
    SmartService *smartService =nil;
    
    if(!isBusy){
        isBusy=TRUE;
        smartService=[smartServiceRouter getService:serviceType];

        if (smartService != nil)
            [smartService performAction:smartEvent];
    }
    else{
        // Show a log to the user indicating that another SmartEvent is
        // under process
        [AppUtils showDebugLog:@"**********ANOTHER SMARTEVENT UNDER PROCESS**********"];
    }

}

-(void)handleAppEvent:(SmartEvent*)smartEvent
{
    [smartEventDelegate didCompleteActionWithSuccess:smartEvent];
}

-(void)handleCoEvent:(SmartEvent*)smartEvent
{
    int serviceType = smartEvent.serviceType;
    BOOL isValidServiceType = TRUE;
    SmartService *smartService =nil;
    
    switch (serviceType)
    {
        case CONTEXT_CHANGE_SERVICE:
            // Done for handling CONTEXT events such as CONTEXT_WEBVIEW_SHOW, CONTEXT_WEBVIEW_HIDE and CONTEXT_NOTIFICATION_CREATELIST(and others) since they require the control to be transferred to the implementation of SmartConnectorListener(in this case SmartViewActivity)
            [smartEventDelegate didCompleteActionWithSuccess:smartEvent];
            break;
            
        case MAPS_SERVICE:
            
            if(![AppUtils getMapBusy])
            {
                [AppUtils setMapBusy:TRUE];
                smartService = [smartServiceRouter getService:MAPS_SERVICE];
            }
            else
            {
                [AppUtils showDebugLog:@"**********ANOTHER SMARTEVENT UNDER PROCESS**********"];
            }
            break;
            
        default:
            isValidServiceType = FALSE;
            break;
    }
    
    if (!isValidServiceType) {
        
        [self didCompleteServiceWithError:smartEvent];
    }
    if (smartService != nil)
    {
        [smartService performAction:smartEvent];
    }
    
}

/**
 * Sends completion notification of success to intended client using
 * SmartEventListener
 *
 * @param smartEvent
 *            : SmartEvent on which success notification is received from
 *            SmartService
 */
-(void)didCompleteServiceWithSuccess:(SmartEvent*)smartEvent
{
    isBusy=FALSE;
    if (smartServiceRouter != nil) {
        [smartServiceRouter releaseService:smartEvent.serviceType WithFlag:smartEvent.smartEventRequest.serviceShutdown ];
    }
    [smartEventDelegate didCompleteActionWithSuccess:smartEvent];
}

/**
 * Sends error notification to intended client using SmartEventListener
 *
 * @param smartEvent
 *            : SmartEvent on which error notification is received from
 *            SmartService
 */
-(void)didCompleteServiceWithError:(SmartEvent*)smartEvent
{
    isBusy=FALSE;
    if (smartServiceRouter != nil) {
        [smartServiceRouter releaseService:smartEvent.serviceType WithFlag:smartEvent.smartEventRequest.serviceShutdown];
    }
    [smartEventDelegate didCompleteActionWithError:smartEvent];
}

@end
