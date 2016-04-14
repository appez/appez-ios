//
//  NotifierEvent.m
//  appez
//
//  Created by Transility on 10/10/14.
//
//

#import "NotifierEvent.h"
#import "NotifierMessageConstants.h"
#import "AppUtils.h"
#import "GTMBase64.h"

@implementation NotifierEvent
@synthesize transactionId;
@synthesize type;
@synthesize actionType;
@synthesize isOperationSuccess;
@synthesize requestData;
@synthesize responseData;
@synthesize errorType;
@synthesize errorMessage;

-(instancetype)init
{
    self = [super init];
    if(self)   //intialize parameters by default values
    {
        self.transactionId =@"";
        self.type=0;
        self.actionType=0;
        self.isOperationSuccess=FALSE;
        self.requestData=NULL;
        self.responseData=NULL;
        self.errorType = 0;
        self.errorMessage = @"";
    }
    return self;
}

-(instancetype)initWithMessage:(NSString*)message
{
    self=[super init];
    if(self)
    {
        @try {
            NSDictionary *notifierRequest=[AppUtils getDictionaryFromJson:message];
            [AppUtils showDebugLog:[NSString stringWithFormat:@"notifierRequest %@",notifierRequest]];
            notifierRequest=[notifierRequest valueForKey:NOTIFIER_PROP_TRANSACTION_REQUEST];
            [AppUtils showDebugLog:[NSString stringWithFormat:@"notifierRequest %@",notifierRequest]];
            NSString *notifierReqData=[notifierRequest valueForKey:NOTIFIER_REQUEST_DATA];
            notifierReqData=[[NSString alloc]initWithData:[GTMBase64 decodeString:notifierReqData] encoding:NSUTF8StringEncoding];
            ;
            [AppUtils showDebugLog:[NSString stringWithFormat:@"notifierReqData %@",notifierReqData]];
            self.type=[[notifierRequest valueForKey:NOTIFIER_TYPE] intValue];
            self.actionType=[[notifierRequest valueForKey:NOTIFIER_ACTION_TYPE] intValue];
            self.requestData=[AppUtils getDictionaryFromJson:notifierReqData];
            [AppUtils showDebugLog:[NSString stringWithFormat:@"SmartViewController->processEventThread->notifierEvetn:%@",self.requestData]];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception :%@",[exception description]);
        }
    }
    return self;
}

-(NSString*)getJavascriptNameToCallArg
{
    NSString *jsNameToCallArg = NULL;
    
    @try {
        NSMutableDictionary *jsNameToCallArgObj= [[NSMutableDictionary alloc]init];
        [jsNameToCallArgObj setValue:self.transactionId forKey:NOTIFIER_PROP_TRANSACTION_ID];
        
        NSMutableDictionary *transactionRequestObj=[[NSMutableDictionary alloc]init];
        [transactionRequestObj setValue:[NSNumber numberWithInt:self.type] forKey:NOTIFIER_TYPE];
        [transactionRequestObj setValue:[NSNumber numberWithInt:self.actionType ] forKey:NOTIFIER_ACTION_TYPE];

        NSString *notifierRequest=@"{}";
       
        if(self.requestData!=nil)
        notifierRequest=[AppUtils getJsonFromDictionary:self.requestData];
    
        notifierRequest=[GTMBase64 stringByEncodingData:[notifierRequest dataUsingEncoding:NSUTF8StringEncoding]];
        notifierRequest=[notifierRequest stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [transactionRequestObj setValue:notifierRequest forKey:NOTIFIER_REQUEST_DATA];
        [jsNameToCallArgObj setValue:transactionRequestObj forKey:NOTIFIER_PROP_TRANSACTION_REQUEST];
        
        NSMutableDictionary *transactionResponseObj=[[NSMutableDictionary alloc]init];
        [transactionResponseObj setValue:[NSNumber numberWithBool:self.isOperationSuccess] forKey:NOTIFIER_OPERATION_IS_SUCCESS];
        [transactionResponseObj setValue:errorMessage forKey:NOTIFIER_OPERATION_ERROR];
        [transactionResponseObj setValue:[NSNumber numberWithInt:errorType]forKey:NOTIFIER_OPERATION_ERROR_TYPE];

        NSString *notifierResponse=[ AppUtils getJsonFromDictionary:self.responseData];
        notifierResponse=[GTMBase64 stringByEncodingData:[notifierResponse dataUsingEncoding:NSUTF8StringEncoding]];
        notifierResponse=[notifierResponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [transactionResponseObj setValue:notifierResponse forKey:NOTIFIER_EVENT_RESPONSE];
        [jsNameToCallArgObj setValue:transactionResponseObj forKey:NOTIFIER_PROP_TRANSACTION_RESPONSE];
        
        jsNameToCallArg=[AppUtils getJsonFromDictionary:jsNameToCallArgObj];
    
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",[exception description]);

        
    }
    return jsNameToCallArg;
}


@end
