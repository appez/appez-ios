//
//  SmartEvent.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SmartEvent.h"
#import "CommMessageConstants.h"
#import "GTMBase64.h"
#import "XMLReader.h"
#import "SmartConstants.h"
#import "AppUtils.h"


#pragma
#pragma mark -  SmartEvent Private Methods

@interface SmartEvent(PrivateMethods)
-(NSString*)decodedRequestData:(NSString*)encodedRequestData;
-(int)parseEventType:(int) actioncode;
-(int)parseServiceType:(int)actioncode;
@end

#pragma
#pragma mark - SmartEvent Class Implementation
#pragma

@implementation SmartEvent
@synthesize smartEventRequest;
@synthesize transactionId;
@synthesize jsNameToCallArg;
@synthesize isResponseExpected;
@synthesize isValidProtocol;
@synthesize serviceRequestData;
@synthesize smartEventResponse;
@synthesize eventType;
@synthesize serviceType;

-(instancetype) init
{
    self = [super init];
    if(self)   //intialize parameters by default values
    {
        self.jsNameToCallArg =@"";
        self.isResponseExpected=FALSE;
        self.isValidProtocol=FALSE;
        self.serviceRequestData=@"";
        self.smartEventRequest=NULL;
        self.smartEventResponse=NULL;
        self.isValidProtocol = FALSE;
        self.eventType = -1;
        self.serviceType = -1;
    }
    return self;
}

/**
 * Parses the SmartEvent protocol message received from the web layer to
 * create a SmartEvent object
 * */
- (instancetype)initWithMessage:(NSString*)message
{
    self = [super init];
    if (self)
    {
        @try {
            message=[message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *messageDictionary= [AppUtils getDictionaryFromJson:message];
            
            if (messageDictionary!=NULL )
            {
                self.transactionId=[messageDictionary valueForKey:MMI_MESSAGE_PROP_TRANSACTION_ID];
                self.isResponseExpected=[[messageDictionary valueForKey:MMI_MESSAGE_PROP_RESPONSE_EXPECTED] boolValue];
                smartEventRequest=[[SmartEventRequest alloc]init];
                
                NSDictionary *transactionRequestObj;
                int serviceOperationId;
                
                if([messageDictionary.allKeys containsObject:MMI_MESSAGE_PROP_TRANSACTION_REQUEST])
                {
                    transactionRequestObj=[messageDictionary valueForKey:MMI_MESSAGE_PROP_TRANSACTION_REQUEST];
                    
                    if([transactionRequestObj.allKeys containsObject:MMI_MESSAGE_PROP_REQUEST_OPERATION_ID])
                    {
                        serviceOperationId=[[transactionRequestObj valueForKey:MMI_MESSAGE_PROP_REQUEST_OPERATION_ID] intValue];
                    }
                }
                
                eventType=[self parseEventType:serviceOperationId];
                serviceType=[self parseServiceType:serviceOperationId];
                smartEventRequest.serviceOperationId=serviceOperationId;
                
                NSString *serviceReqData=[[messageDictionary valueForKey:MMI_MESSAGE_PROP_TRANSACTION_REQUEST] valueForKey:MMI_MESSAGE_PROP_REQUEST_DATA];
                serviceReqData=[[NSString alloc]initWithData:[GTMBase64 decodeString:serviceReqData] encoding:NSUTF8StringEncoding];
                
                NSDictionary *serviceReqObj=[AppUtils getDictionaryFromJson:serviceReqData];
                smartEventRequest.serviceRequestData=[NSDictionary dictionaryWithDictionary:serviceReqObj];
                
                //Added for specifying that service should be released only if user desires.
				if ([serviceReqObj.allKeys containsObject:MMI_REQUEST_PROP_SERVICE_SHUTDOWN])
                {
					smartEventRequest.serviceShutdown=[[serviceReqObj valueForKey:MMI_REQUEST_PROP_SERVICE_SHUTDOWN] boolValue];
                    [AppUtils showDebugLog:[NSString stringWithFormat:@"serviceShutDown param is %d",smartEventRequest.serviceShutdown]];
				} else {
					smartEventRequest.serviceShutdown=TRUE;
				}
                
                smartEventResponse=[[SmartEventResponse alloc]init];
                self.smartEventRequest=smartEventRequest;
                self.smartEventResponse=smartEventResponse;
                isValidProtocol=TRUE;
                
            }
        }
        @catch (NSException *exception) {
            isValidProtocol=FALSE;
        }
    }
    return self;
}

-(BOOL)isValidProtocol
{
    return isValidProtocol;
}


-(int)getServiceType{
    return serviceType;
}
-(int)getEventType
{
    return eventType;
}


#pragma
#pragma mark - Utility Methods Using GTMBase64 For Decode Data
#pragma

/**
 * This method does the parsing of event type from given 5 digit number
 * [0][1][2][3][4]. and we are extracting int digit available at 0'th place.
 *
 * @param actionCode
 * @return
 */
-(int)parseEventType:(int) actioncode
{
    return actioncode / 10000;
}

/**
 * This method does the parsing of service type from given 5 digit number
 * [0][1][2][3][4], & we are extracting int digits available at 1'st and
 * 2'nd place.
 *
 * @param actionCode
 * @return
 */
-(int)parseServiceType:(int)actioncode
{
    int tmpNum = actioncode % 10000;
    return tmpNum / 100;
}

-(NSString*)getTransactionId
{
    return transactionId;
}

-(NSString*)getServiceRequestData{
    return serviceRequestData;
}

-(SmartEventRequest*)getSmartEventRequest
{
    return smartEventRequest;
}

-(SmartEventResponse*)getSmartEventResponse{
    
    return smartEventResponse;
}


-(NSString*)getJavaScriptNameToCall
{
    return JS_CALLBACK_FUNCTION;
}

-(void)setJavaScriptNameToCallArg:(NSString *)argument
{
    self.jsNameToCallArg=argument;
}

-(NSString*)getJavaScriptNameToCallArg
{
    @try {
        NSMutableDictionary *callbackResponseObj=[[NSMutableDictionary alloc]init];
        [callbackResponseObj setValue:transactionId forKey:MMI_MESSAGE_PROP_TRANSACTION_ID];
        [callbackResponseObj setValue:[ NSNumber numberWithBool:isResponseExpected ]forKey:MMI_MESSAGE_PROP_RESPONSE_EXPECTED];
        
        NSMutableDictionary *transactionRequestObj=[[NSMutableDictionary alloc]init];
        NSDictionary *serviceReqdataObj=[NSDictionary dictionaryWithDictionary:self.smartEventRequest.serviceRequestData];
        NSString *serviceReqDataStr=[AppUtils getJsonFromDictionary:serviceReqdataObj];
        
        serviceReqDataStr=[GTMBase64 stringByEncodingData:[serviceReqDataStr dataUsingEncoding:NSUTF8StringEncoding]];
        serviceReqDataStr=[serviceReqDataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [transactionRequestObj setValue:[NSString stringWithFormat:@"%@" ,serviceReqDataStr] forKey:MMI_MESSAGE_PROP_REQUEST_DATA];
        [transactionRequestObj setValue:[NSString stringWithFormat:@"%d",smartEventRequest.serviceOperationId] forKey:MMI_MESSAGE_PROP_REQUEST_OPERATION_ID];
        
        [callbackResponseObj setValue:transactionRequestObj forKey:MMI_MESSAGE_PROP_TRANSACTION_REQUEST];
        
        NSMutableDictionary *transactionResponseObj=[[NSMutableDictionary alloc]init];
        [transactionResponseObj setValue:[NSNumber numberWithBool:self.smartEventResponse.isOperationComplete] forKey:MMI_MESSAGE_PROP_TRANSACTION_OP_COMPLETE];
        
        NSString *serviceResponseData=self.smartEventResponse.serviceResponse;
        serviceResponseData=[GTMBase64 stringByEncodingData:[serviceResponseData dataUsingEncoding:NSUTF8StringEncoding]];
        serviceResponseData=[serviceResponseData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [transactionResponseObj setValue:serviceResponseData forKey:MMI_MESSAGE_PROP_SERVICE_RESPONSE];
        [transactionResponseObj setValue:[NSString stringWithFormat:@"%d",self.smartEventResponse.exceptionType] forKey:MMI_MESSAGE_PROP_RESPONSE_EX_TYPE];
        
        [transactionResponseObj setValue:self.smartEventResponse.exceptionMessage forKey:MMI_MESSAGE_PROP_RESPONSE_EX_MESSAGE];
        [callbackResponseObj setValue:transactionResponseObj forKey:MMI_MESSAGE_PROP_TRANSACTION_RESPONSE];
        
        self.jsNameToCallArg=[AppUtils getJsonFromDictionary:callbackResponseObj];
    }
    @catch (NSException *exception) {
        
        self.jsNameToCallArg=NULL;
    }
    
    return self.jsNameToCallArg;
}


@end
