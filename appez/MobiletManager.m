

//
//  SmartConnector.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "MobiletManager.h"
#import "SmartUIUtility.h"
#import "ExceptionTypes.h"
#import "MobiletException.h"
#import "SmartConstants.h"
#import "SmartViewController.h"

@interface MobiletManager (SmartConnectorMethods)
-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
-(void)performSmartSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
@end

@implementation MobiletManager

-(instancetype)initSmartConnectorWithDelegate:(id<SmartConnectorDelegate>)connectordelegate WithAppDelegate:(id<SmartAppDelegate>)appdelegate
{
    if (connectordelegate == nil) {
        @throw [MobiletException MobiletExceptionWithType:SMART_CONNECTOR_LISTENER_NOT_FOUND_EXCEPTION Message:nil];
    }
    
    if (appdelegate == nil) {
        @throw [MobiletException MobiletExceptionWithType:SMART_APP_LISTENER_NOT_FOUND_EXCEPTION Message:nil];
    }
    
    self = [super init];
    if (self) 
    {
        smartAppDelegate=appdelegate;
        smartConnectorDelegate=connectordelegate;
    }
    return self;
}

-(instancetype)initSmartConnectorWithDelegate:(id<SmartConnectorDelegate>)connectordelegate
{
    if (connectordelegate == nil) {
        @throw [MobiletException MobiletExceptionWithType:SMART_CONNECTOR_LISTENER_NOT_FOUND_EXCEPTION Message:nil];
    }
    
    self = [super init];
    if (self) 
    {
        smartConnectorDelegate=connectordelegate;
    }
    return self;
}



//--------------------------------------------------------------------------------------------------------------------------------------
-(BOOL)processSmartEvent:(SmartEvent*)smartEvent
{
    BOOL isValidEvent = FALSE;
    isValidEvent = smartEvent.isValidProtocol;
    
    if (isValidEvent)
    {
        if (smartEventProcessor == nil)
        {
            smartEventProcessor =[[SmartEventProcessor alloc] initSmartEventProcessorWithDelegate:self];
        }

        [AppUtils showDebugLog:[NSString stringWithFormat:@"Processing event Event Type:%d Service Type:%d \n\n", smartEvent.eventType, smartEvent.serviceType]];

        [smartEventProcessor processSmartEvent:smartEvent];
    }
    return isValidEvent;
}

//--------------------------------------------------------------------------------------------------------------------------------------
/** Sends failure notification to intended client in event of erroneous completion of smart service action
 * 
 * @param smartEvent : SmartEvent received after erroneous completion of smart service action
 */
-(void)didCompleteActionWithError:(SmartEvent*)smartEvent
{
     [AppUtils showDebugLog:[NSString stringWithFormat:@"Completed Event Processing with ERROR for Event Type:%d Service Type:%d \n\n", smartEvent.eventType, smartEvent.serviceType]];
  
    if(smartConnectorDelegate && [smartConnectorDelegate respondsToSelector:@selector(didFinishProcessingWithError:)])
        [smartConnectorDelegate didFinishProcessingWithError:smartEvent];
}

//--------------------------------------------------------------------------------------------------------------------------------------
/** Sends success notification to intended client in event of successful completion of action. 
 * Also determines the type of notification and accordingly sends notification to either App Listener or
 * Connector Listener or both.
 * 
 * @param smartEvent : SmartEvent received after successful completion of smart service action
 */

-(void)didCompleteActionWithSuccess:(SmartEvent*)smartEvent
{
    int eventType = smartEvent.eventType;
    NSString *notification=[NSString stringWithFormat:@"%d",smartEvent.smartEventRequest.serviceOperationId];
    NSString *eventData=smartEvent.serviceRequestData;
    
    switch (eventType)
    {
        case WEB_EVENT:
            [smartConnectorDelegate didFinishProcessingWithOptions:smartEvent];
            break;
        case CO_EVENT:
            [smartConnectorDelegate didReceiveContextNotification:smartEvent];
            break;
        case APP_EVENT:
            // Check the value of notification, notify to App listener in case
			// of valid data
            @try {
                eventData=[smartEvent.smartEventRequest.serviceRequestData valueForKey:MMI_REQUEST_PROP_MESSAGE];

                if (notification!=nil)
                {
                    [smartAppDelegate didReceiveSmartNotification:eventData WithNotification:notification];
                }
            }
            @catch (NSException *exception) {
                [smartAppDelegate didReceiveSmartNotification:NULL WithNotification:NULL];
            }
        default:
            break;
    }
}

/**
 * Sets target to receive SmartAppListener Notifications
 * 
 * @param argSmartAppListener
 *            : reference of outer activity
 * @return void
 */
-(void)registerAppDelegate:(id<SmartAppDelegate>)argSmartAppDelegate
{
    if (argSmartAppDelegate != nil)
    {
        smartAppDelegate = argSmartAppDelegate;
    }
    else
    {
        @throw [MobiletException MobiletExceptionWithType:SMART_APP_LISTENER_NOT_FOUND_EXCEPTION Message:nil];
    }
    
}

//---------------------------------------------------------------------------------------------
-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ...
{
    // First attempt to create the method signature with the provided selector.
    NSMethodSignature *signature;// = [smartAppDelegate methodSignatureForSelector:selector];
    if ( !signature ) {
         [AppUtils showDebugLog:@"NSObject: Method signature could not be created."];
        return;
        }
    
    // Next we create the invocation that will actually call the required selector.
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:smartAppDelegate];
    [invocation setSelector:selector];
    
    // Now add arguments from the variable list of objects (nil terminated).
    va_list args;
    va_start(args, firstObject);
    int nextArgIndex = 2;
    
    for (NSObject *object = firstObject; object != nil; object = va_arg(args, NSObject*))
        {
            if ( object != [NSNull null] )
                {
                    [invocation setArgument:&object atIndex:nextArgIndex];
                    }
            
            nextArgIndex++;
            }
    
    va_end(args);
    
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}
//---------------------------------------------------------------------------------------------
-(void)performSmartSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ...
{
    // First attempt to create the method signature with the provided selector.
    NSMethodSignature *signature;// = [smartConnectorDelegate methodSignatureForSelector:selector];
    if ( !signature ) {
         [AppUtils showDebugLog:@"NSObject: Method signature could not be created."];
        return;
    }
    
    // Next we create the invocation that will actually call the required selector.
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:smartConnectorDelegate];
    [invocation setSelector:selector];
    
    // Now add arguments from the variable list of objects (nil terminated).
    va_list args;
    va_start(args, firstObject);
    int nextArgIndex = 2;
    
    for (NSObject *object = firstObject; object != nil; object = va_arg(args, NSObject*))
    {
        if ( object != [NSNull null] )
        {
            [invocation setArgument:&object atIndex:nextArgIndex];
        }
        
        nextArgIndex++;
    }
    
    va_end(args);
    
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end
