//
//  PushNotiicationUtility.m
//  appez
//
//  Created by Transility on 25/09/14.
//
//

#import "PushNotificationUtility.h"
#import "AppUtils.h"

#define CURRENT_EVENT_PUSH_REGISTER 0
#define CURRENT_EVENT_PUSH_UNREGISTER 1

@implementation PushNotificationUtility

-(instancetype)initWithNotifierPushMessageDelegate:(id<NotifierPushMessageDelegate>)notifierPNMessageDelegate
{
    self=[super init];
    if(self)
    {
        currentEvent=-1;
        notifierPushMessageDelegate=notifierPNMessageDelegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRegistrationInfo:) name:@"appezPushRegistrationReceived" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRegistrationError:) name:@"appezPushRegistrationFailed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"appezPushNotificationReceived" object:nil];
    }
    return  self;
}

-(void)registerPush:(NotifierEvent *)notifierEvent
{
    currentNotifierEvent=notifierEvent;
    currentEvent=CURRENT_EVENT_PUSH_REGISTER;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings *settings =[UIUserNotificationSettings settingsForTypes:
                                               (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
    
}

-(void)unregisterPush:(NotifierEvent*)notifierEvent
{
    currentNotifierEvent=notifierEvent;
    currentEvent=CURRENT_EVENT_PUSH_UNREGISTER;
    [self initUnregistrationParams:notifierEvent];
    [self unregisterDeviceWithServer];
}

-(void)unregisterDeviceWithServer
{
    NSString *appId=[[NSBundle mainBundle] bundleIdentifier];
    
    NSMutableDictionary *requestPostBody=[[NSMutableDictionary alloc]init];
    [requestPostBody setValue:[AppUtils getDeviceUdid] forKey:@"deviceId"];
    [requestPostBody setValue:appId forKey:@"applicationId"];
    
    NSMutableDictionary *networkReqObj=[[NSMutableDictionary alloc]init];
    [networkReqObj setValue:HTTP_REQUEST_VERB_POST forKey:MMI_REQUEST_PROP_REQ_METHOD];
    [networkReqObj setValue:self.pushServerUrl forKey:MMI_REQUEST_PROP_REQ_URL];
    [networkReqObj setValue:[AppUtils getJsonFromDictionary:requestPostBody] forKey:MMI_REQUEST_PROP_REQ_POST_BODY];
    [networkReqObj setValue:@"application/json" forKey:MMI_REQUEST_PROP_REQ_CONTENT_TYPE];
    NSString *reqParam=[AppUtils getJsonFromDictionary:networkReqObj];
    NetworkService *networkService=[[NetworkService alloc]initWithDelegate:self];
    [networkService performAsyncRequest:reqParam WithFlag:NO];

}

-(void)initUnregistrationParams:(NotifierEvent*)notifierEvent
{
    NSDictionary *unregistrationParams=notifierEvent.requestData;
    
    if ([unregistrationParams.allKeys containsObject:NOTIFIER_PUSH_PROP_SERVER_URL]) {
        self.pushServerUrl=[unregistrationParams valueForKey:NOTIFIER_PUSH_PROP_SERVER_URL];
    }
}

-(void)registerDeviceWithServer:(NSString*)deviceToken
{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *appVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *appName=[infoDict objectForKey:@"CFBundleDisplayName"];
    NSString *appId=[[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *requestPostBody=[[NSMutableDictionary alloc]init] ;
    
    [requestPostBody setValue:[AppUtils getDeviceUdid] forKey:@"deviceId"];
    [requestPostBody setValue:appId forKey:@"applicationId"];
    [requestPostBody setValue:appName forKey:@"applicationName"];
    [requestPostBody setValue:appVersion forKey:@"appVersion"];
    [requestPostBody setValue:@"iOS" forKey:@"platform"];
    [requestPostBody setValue:deviceToken forKey:@"pushId"];
    
    NSMutableDictionary *networkReqObj=[[NSMutableDictionary alloc]init];
        
    [networkReqObj setValue:self.pushServerUrl forKey:MMI_REQUEST_PROP_REQ_URL];
    [networkReqObj setValue:HTTP_REQUEST_VERB_POST forKey:MMI_REQUEST_PROP_REQ_METHOD];
    [networkReqObj setValue:[AppUtils getJsonFromDictionary:requestPostBody] forKey:MMI_REQUEST_PROP_REQ_POST_BODY];
    [networkReqObj setValue:@"application/json" forKey:MMI_REQUEST_PROP_REQ_CONTENT_TYPE];
    
    NSString *reqParam=[AppUtils getJsonFromDictionary:networkReqObj];
    NetworkService *networkService=[[NetworkService alloc]initWithDelegate:self];
    [networkService performAsyncRequest:reqParam WithFlag:NO];

}

-(void)didReceiveRegistrationInfo:(NSDictionary*)notification {
    
    [self initRegistrationParams:currentNotifierEvent];
    NSString *deviceToken=[notification valueForKey:@"object"];
    [self registerDeviceWithServer:deviceToken];
}

-(void)initRegistrationParams:(NotifierEvent*)notifierEvent
{
    NSDictionary *registrationParams=notifierEvent.requestData;    
    
    if(registrationParams!=nil)
    {
        if ([registrationParams.allKeys containsObject:NOTIFIER_PUSH_PROP_SERVER_URL]) {
            self.pushServerUrl=[registrationParams valueForKey:NOTIFIER_PUSH_PROP_SERVER_URL];
        }
    }
}

-(void)didCompleteHttpOperationWithSuccess:(NSString *)responseData
{
    switch (currentEvent) {
            //Added cases to match analogy with android.
        case CURRENT_EVENT_PUSH_REGISTER:
            [notifierPushMessageDelegate didReceiveRegistrationToken:responseData];
            break;
            
        case CURRENT_EVENT_PUSH_UNREGISTER:
            [notifierPushMessageDelegate didReceiveRegistrationToken:responseData];
            break;
    }
}

-(void)didCompleteHttpOperationWithError:(int)exceptionType WithMessage:(NSString *)exceptionMessage
{
    switch (currentEvent) {
            //Added cases to match analogy with android.
        case CURRENT_EVENT_PUSH_REGISTER:
            [notifierPushMessageDelegate didReceiveRegistrationError:exceptionMessage];
            break;
            
        case CURRENT_EVENT_PUSH_UNREGISTER:
            [notifierPushMessageDelegate didReceiveRegistrationError:exceptionMessage];
            break;
    }
}

-(void)didReceiveRegistrationError:(NSDictionary*)error
{
    NSString *regErr=[error valueForKey:@"object"];
    regErr=[regErr valueForKey:@"NSLocalizedDescription"];
    [notifierPushMessageDelegate didReceiveRegistrationError:regErr];
}

-(void)pushNotificationReceived:(NSNotification *)notification{
    
    NSString *pushNotif=[AppUtils getJsonFromDictionary:[[notification object] valueForKey:@"aps"]];
    
    if(notifierPushMessageDelegate!=nil)
    {
        [notifierPushMessageDelegate didReceivePushMessage:pushNotif];
    }
    else
    {
        // It means that the application is neither in background nor in
        // foreground. It means either the application is deliberately
        // stopped by the user or the device has restarted. In such cases,
        // we are not sending the notifications to JS. For now this case is
        // not handled. Will implement it if required by the application.
    }
    
}

@end
