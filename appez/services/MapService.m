//
//  MapService.m
//  appez
//
//  Created by Transility on 11/09/12.
//
//

#import "MapService.h"
#import "SmartUIUtility.h"
#import "CoEvents.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"
@implementation MapService

/**
 * Creates the instance of MapService
 * @param delegate
 */
-(instancetype)initMapServiceWithDelegate:(id<SmartServiceDelegate>)delegate
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
    smartEvent=smartevent;
    @try {
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents] == TRUE)
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        int serviceOpId=smartEvent.smartEventRequest.serviceOperationId;
        NSString *serviceReqData=[AppUtils getJsonFromDictionary:smartEvent.smartEventRequest.serviceRequestData];
        switch (serviceOpId)
        {
            case CO_SHOW_MAP_ONLY:
                [[SmartUIUtility sharedInstance] showMapView:serviceReqData WithDelegate:self WithAnimation:FALSE WithDirection:FALSE];
                break;
            case CO_SHOW_MAP_N_DIR:
                [[SmartUIUtility sharedInstance] showMapView:serviceReqData WithDelegate:self WithAnimation:FALSE WithDirection:TRUE];
                break;
            case CO_SHOW_MAP_N_ANIMATION:
                [[SmartUIUtility sharedInstance] showMapView:serviceReqData WithDelegate:self WithAnimation:TRUE WithDirection:FALSE];
                break;

    }
    
    }
    @catch (NSException *exception) {
        [self didCompleteCoActionWithError:UNKNOWN_EXCEPTION.intValue WithMessage:[exception description]];
    }
}
/**
 * Sends the map show completion notification to the web layer. This event
 * is triggered when the container has shown the map and user goes back from
 * the native map screen.
 *
 * @param mapsData
 *            :
 *
 * */

-(void)didCompleteCoActionWithSuccess:(NSString*)mapsData {
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:mapsData];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}
/**
 * Sends the map show error notification to the web layer.
 *
 * @param exceptionType
 *            : Unique ID corresponding to the error in showing map
 *
 * @param exceptionMessage
 *            : Message describing the nature of problem with showing map
 * */
-(void)didCompleteCoActionWithError:(int)exceptionType WithMessage:(NSString*)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}
@end
