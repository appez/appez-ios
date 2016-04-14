//
//  LocationService.m
//  appez
//
//  Created by Transility on 7/28/14.
//
//
#import <Foundation/Foundation.h>
#import "LocationService.h"
#import "AppUtils.h"
#import "WebEvents.h"
#import "LocationUtility.h"
#import "ExceptionTypes.h"
#import "SmartConstants.h"

@interface LocationService(PrivateMethods)
-(void)getCurrentLocation;
-(void)didCompleteLocationServiceWithSuccess:(NSString*)callbackData;
-(void)didCompleteLocationServiceWithError:(int)exceptionType andMessage:(NSString*)exceptionMessage;
@end

@implementation LocationService:SmartService
@synthesize locationManager;

-(instancetype)initWithSmartServiceDelegate:(id<SmartServiceDelegate>)delegate
{
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
    [self processLocationRequest:smartevent];
    switch (smartevent.smartEventRequest.serviceOperationId) {
        case WEB_USER_CURRENT_LOCATION:
            [self getCurrentLocation];
            break;
            
        default:
            break;
    }
}

-(void)processLocationRequest:(SmartEvent*)smartEvt
{
 @try
    {
    NSDictionary *serviceRequestData=smartEvt.smartEventRequest.serviceRequestData;
    if ([serviceRequestData.allKeys containsObject:MMI_REQUEST_PROP_LOC_ACCURACY]) {
        locationAccuracy=[serviceRequestData valueForKey:MMI_REQUEST_PROP_LOC_ACCURACY];
    }
    if ([serviceRequestData.allKeys containsObject:MMI_REQUEST_PROP_LOCATION_TIMEOUT]) {
        locationRequestTimeout=[[serviceRequestData valueForKey:MMI_REQUEST_PROP_LOCATION_TIMEOUT]floatValue];
    }
    else
        locationRequestTimeout=LOCATION_SERVICE_DEFAULT_TIMEOUT;
    }
    @catch(NSException *exception){
        NSLog(@"Exception :%@",[exception description]);

    }
}

-(void)getCurrentLocation
{
    locationManager=[[CLLocationManager alloc]init];
    NSDate *startTime;
    
    if([locationAccuracy isEqualToString:LOCATION_ACCURACY_COARSE])
    {
        locationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
    }
    else
    {
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    }
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    if([CLLocationManager locationServicesEnabled])
    {
        //[self showProgressDialog];
        [AppUtils showDebugLog:@"Location Enabled"];
       // [NSThread detachNewThreadSelector:@selector(showProgressDialog) toTarget:self withObject:nil];
        [self showProgressDialog];
        deviceCurrentLocation=locationManager.location;
        startTime=[NSDate date];

        while (1)
        {
            if([[NSDate date]timeIntervalSinceDate:startTime]/60.f>=2)
            break;
            if(deviceCurrentLocation!=NULL)
            {
                [AppUtils showDebugLog:@"location has been found"];
                break;
            }
            else
            {
                if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
                {
                    [AppUtils showDebugLog:@"service denied"];
                    [self didCompleteLocationServiceWithError:LOCATION_ERROR_PERMISSION_DENIED.intValue andMessage:LOCATION_ERROR_PERMISSION_DENIED_MESSAGE];
                    break;
                }
                [locationManager startUpdatingLocation];
                deviceCurrentLocation=locationManager.location;
            }
        }
    
        [self hideProgressDialog];
        NSString *locationResponse=[LocationUtility prepareLocationResponse:deviceCurrentLocation];
        [self didCompleteLocationServiceWithSuccess:locationResponse];
    }
    else
    {
        [AppUtils showDebugLog:@"location disableed"];
        [self didCompleteLocationServiceWithError:[LOCATION_ERROR_GPS_NETWORK_DISABLED intValue]andMessage:LOCATION_ERROR_GPS_NETWORK_DISABLED_MESSAGE];
        [locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [AppUtils showDebugLog:@"location updated"];
    deviceCurrentLocation=newLocation;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [AppUtils showDebugLog:@"did fail in fetching locations"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [AppUtils showDebugLog:@"locations array found"];
    deviceCurrentLocation=locations.lastObject;
}

-(void)showProgressDialog
{

    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
      
    mDialogBuilder=nil;
    mDialogBuilder=[[AlertView alloc]initWithAlertViewDelegate:self];
    [mDialogBuilder showAlertViewWithType:ALERTVIEW_LOADING WithMessage:MAP_CURRENT_LOCATION_LOADING_MSG];
         });
}

-(void)hideProgressDialog
{
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
    [mDialogBuilder hideDialog];
    mDialogBuilder=nil;
    });
}

-(void)didCompleteLocationServiceWithSuccess:(NSString *)callbackData
{
    [locationManager stopUpdatingLocation];
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:callbackData];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

-(void)didCompleteLocationServiceWithError:(int)exceptionType andMessage:(NSString *)exceptionMessage
{
    [locationManager stopUpdatingLocation];
    SmartEventResponse *smEventResponse=[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}
@end
