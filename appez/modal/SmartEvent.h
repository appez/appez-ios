//
//  SmartEvent.h
//  appez
//
//  Created by Transility on 2/27/12.
//
/**
 * Holds the necessary parameters for Smart object. Parses the smart message
 * received from JavaScript to extract parameter values
 */

#import <Foundation/Foundation.h>
#import "SmartEventResponse.h"
#import "SmartEventRequest.h"
#import "GTMBase64.h"

// constant for event types
#define WEB_EVENT           1
#define CO_EVENT            2
#define APP_EVENT           3



#define JS_CALLBACK_FUNCTION @"appez.mmi.getMobiletManager().processNativeResponse"

#define HTTP_REQUEST_VERB_GET  @"GET"
#define HTTP_REQUEST_VERB_POST @"POST"

@interface SmartEvent : NSObject
{
@private NSString *transactionId;
@private BOOL isResponseExpected;
@private BOOL isValidProtocol;
@private int eventType;
@private int serviceType;
@private NSString *serviceRequestData;
    SmartEventRequest *smartEventRequest;
@private SmartEventResponse *smartEventResponse;
@private NSString *jsNameToCallArg;
}

@property(nonatomic,retain) NSString *transactionId;
@property(nonatomic,readwrite) BOOL isResponseExpected;
@property(nonatomic,readwrite) BOOL isValidProtocol;
@property(nonatomic,retain) SmartEventRequest *smartEventRequest;
@property(nonatomic,retain)  NSString * serviceRequestData;
@property(nonatomic,readwrite) int                eventType;
@property(nonatomic,readwrite) int                serviceType;
@property(nonatomic,retain) NSString *jsNameToCallArg;
@property(nonatomic,retain) SmartEventResponse *smartEventResponse;

- (instancetype)init;
- (instancetype)initWithMessage:(NSString*)message;
-(NSString*)getJavaScriptNameToCallArg;
-(NSString*)getJavaScriptNameToCall;

@end
