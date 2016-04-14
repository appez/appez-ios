//
//  PersistenceService.m
//  appez
//
//  Created by Transility on 5/11/12.
//

#import "PersistenceService.h"
#import "WebEvents.h"
#import "SmartConstants.h"
#import "ExceptionTypes.h"
#import "CommMessageConstants.h"
#import "AppUtils.h"
#define DEFAULT_DOMAIN @"applicationPrferences"
#define PRE_DOMAIN_NAME @"com.appez."

@interface PersistenceService(PrivateMethods)
-(void)saveData:(NSDictionary*)dataString;
-(void)retrieveData:(NSDictionary*)reqObject;
-(void)deleteData:(NSDictionary*)reqObject;
-(NSMutableArray*)getAllFromSharedPreference;
-(NSString*)getDomainName:( NSDictionary*)dataString;
-(void)didCompletePersistenceServiceWithError:(int)exceptionType andMessage:(NSString*)exceptionMessage;
-(void)didCompletePersistenceServiceWithSuccess:(NSString *)callbackData;
@end

@implementation PersistenceService

-(instancetype)initPersistenceServiceWithDelegate:(id<SmartServiceDelegate>)delegate
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

-(void)performAction:(SmartEvent*)smEvent
{
    smartEvent=smEvent;
    NSString *domainName=[self getDomainName:smartEvent.smartEventRequest.serviceRequestData];
    
    if(storePreferences)
    {
        //[storePreferences release];
        storePreferences=nil;
    }
    storePreferences=[[StorePreferences alloc] initWithDomainName:domainName];
    
    @try {
        switch (smEvent.smartEventRequest.serviceOperationId) {
			case WEB_SAVE_DATA_PERSISTENCE:
                
                [self saveData:smEvent.smartEventRequest.serviceRequestData];
                
				break;
                
			case WEB_RETRIEVE_DATA_PERSISTENCE:
				
                
				[self retrieveData:smEvent.smartEventRequest.serviceRequestData];
                
				break;
                
			case WEB_DELETE_DATA_PERSISTENCE:
                
				
                [self deleteData:smEvent.smartEventRequest.serviceRequestData];
                
				break;
        }
    } @catch (NSException *ex)
    {
        [self didCompletePersistenceServiceWithError:UNKNOWN_EXCEPTION.intValue andMessage:[ex description]];
    }
}

//Adds the domain name, to the key of the key value collection and returns it.
-(NSString*)getDomainName:(NSDictionary*)dataStringDict
{
    NSString *domain=nil;
    domain=[dataStringDict valueForKey:MMI_REQUEST_PROP_STORE_NAME];
    return  domain;
}
//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------

/**
 * Saves the data in the persistence storage in the form of key-value pair.
 * User can save multiple key-value pairs at once
 *
 * @param dataString
 *            : String containing list of key-value pairs that the user
 *            wants to save
 * */

-(void)saveData:(NSDictionary*)reqObject
{
    @try {
        BOOL preferenceSet=FALSE;
        
        storePreferences=[storePreferences initWithDomainName:[reqObject valueForKey: MMI_REQUEST_PROP_STORE_NAME]];
        
        NSArray *requestData=[NSArray arrayWithObject:[reqObject objectForKey:MMI_REQUEST_PROP_PERSIST_REQ_DATA]];
        
        NSInteger allElementsCount=requestData.count;
       
        if (requestData!=nil && allElementsCount>0) {
            
            for (int element=0; element<allElementsCount; element++) {
                NSDictionary *keyValuePairObj=[requestData objectAtIndex:element];
                
                NSString *keyResponse=[[keyValuePairObj valueForKey:MMI_REQUEST_PROP_PERSIST_KEY] objectAtIndex:element];
                NSString *valueResponse=[[keyValuePairObj valueForKey:MMI_REQUEST_PROP_PERSIST_VALUE] objectAtIndex:element];

                preferenceSet=[storePreferences setObject:valueResponse forKey:keyResponse];
                
                if (!preferenceSet) {
                    break;
                }
            }
            if (preferenceSet) {
                NSMutableDictionary *storeResponseObj=[[NSMutableDictionary alloc]init];
                [storeResponseObj setValue:[reqObject valueForKey:MMI_REQUEST_PROP_STORE_NAME] forKey:MMI_RESPONSE_PROP_STORE_NAME];
                [storeResponseObj setValue:nil forKey:MMI_RESPONSE_PROP_STORE_RETURN_DATA];
                
                NSString *callBackData=[AppUtils getJsonFromDictionary:storeResponseObj];
                
                [self didCompletePersistenceServiceWithSuccess:callBackData];
            }
            else{
                [self didCompletePersistenceServiceWithError:ERROR_SAVE_DATA_PERSISTENCE.intValue andMessage:ERROR_SAVE_DATA_PERSISTENCE_MESSAGE];
            }
        }
    }
    @catch (NSException *e) {
        
        [self didCompletePersistenceServiceWithError:ERROR_SAVE_DATA_PERSISTENCE_MESSAGE.intValue andMessage:ERROR_SAVE_DATA_PERSISTENCE_MESSAGE];
    }
}

/**
 * Retrieve data from the SharedPreferences based on the key provided by the
 * user. User can retrieve multiple values at once
 *
 * @param retrieveFilter
 *            : Specifies the keys that the user wants to retrieve. User can
 *            use '*' to retrieve all the keys in the SharedPreferences at
 *            once
 * */

-(void)retrieveData:(NSDictionary*)reqObject
{
    @try {
        NSArray *requestData = [NSArray arrayWithObject:[reqObject valueForKey:MMI_REQUEST_PROP_PERSIST_REQ_DATA]];
        
        NSInteger allElementsCount=requestData.count;
        
        if (requestData!=nil && allElementsCount>0) {
            
            NSMutableArray *storeResponseData=[[NSMutableArray alloc]init];
            
            for (int element=0; element<allElementsCount; element++) {
              
                NSDictionary *keyValuePairObj=[requestData objectAtIndex:element];
                NSString *keyResponse=[[keyValuePairObj valueForKey:MMI_REQUEST_PROP_PERSIST_KEY]objectAtIndex:element];
                NSString *valueResponse=[NSString stringWithFormat:@"%@",[storePreferences objectForKey:keyResponse]] ;
                
                if ([keyResponse isEqualToString:RETRIEVE_ALL_FROM_PERSISTENCE]) {
                    storeResponseData=[self getAllFromSharedPreference];
                    break;
                }
                else
                {
                    NSMutableDictionary *responseElement=[[NSMutableDictionary alloc]init];
                                       [responseElement setValue:valueResponse forKey:MMI_RESPONSE_PROP_STORE_VALUE];
                    [responseElement setValue:keyResponse forKey:MMI_RESPONSE_PROP_STORE_KEY];
                    
                    [storeResponseData addObject:responseElement];
                }
            }
            
            NSMutableDictionary *storeResponseObj=[[NSMutableDictionary alloc]init];
            [storeResponseObj setValue:[reqObject valueForKey:MMI_REQUEST_PROP_STORE_NAME] forKey:MMI_RESPONSE_PROP_STORE_NAME];
            [storeResponseObj setValue:storeResponseData forKey:MMI_RESPONSE_PROP_STORE_RETURN_DATA];
            
            NSString *callBackData=[AppUtils getJsonFromDictionary:storeResponseObj];
            
            [self didCompletePersistenceServiceWithSuccess:callBackData];
        }
    }
    @catch (NSException *exception) {
        [self didCompletePersistenceServiceWithError:ERROR_RETRIEVE_DATA_PERSISTENCE.intValue andMessage:ERROR_RETRIEVE_DATA_PERSISTENCE_MESSAGE];
    }
}

/**
 * Deletes the specified key from the persistent store. Currently user can
 * delete only 1 key from the store
 *
 * @param deleteFilter
 *            : The string that specifies the key to be deleted from store.
 *            Returns the remaining keys in the store as a response to the
 *            web layer
 *
 * */
-(void)deleteData:(NSDictionary*)reqObject
{
    // After deleting the key specified by the user,this method returns all
    // the elements remaining in the SharedPreference
    @try {
        BOOL isDeleteFromPersistence=FALSE;
        NSArray *requestData = [NSArray arrayWithObject:[reqObject valueForKey:MMI_REQUEST_PROP_PERSIST_REQ_DATA]];
        
        NSInteger allElementsCount=requestData.count;
        
        if (requestData!=nil && allElementsCount>0)
        {
            for (int element=0; element<allElementsCount; element++)
            {
                NSDictionary *keyValuePairObj=[requestData objectAtIndex:element];
                NSString *removeKey=[[keyValuePairObj valueForKey:MMI_REQUEST_PROP_PERSIST_KEY] objectAtIndex:element];
                
                isDeleteFromPersistence=[storePreferences removeObjectForKey:removeKey];
                
                if(!isDeleteFromPersistence){
                    break;
                }
            }
            if (isDeleteFromPersistence) {
                NSMutableDictionary *storeResponseObj=[[NSMutableDictionary alloc]init];
                
                [storeResponseObj setValue:[reqObject valueForKey:MMI_REQUEST_PROP_STORE_NAME] forKey:MMI_RESPONSE_PROP_STORE_NAME];
                [storeResponseObj setValue:nil forKey:MMI_RESPONSE_PROP_STORE_RETURN_DATA];
                
                NSString *callBackData=[AppUtils getJsonFromDictionary:storeResponseObj];
                
                [self didCompletePersistenceServiceWithSuccess:callBackData];
            }
            else{
                [self didCompletePersistenceServiceWithError:ERROR_DELETE_DATA_PERSISTENCE.intValue andMessage:ERROR_DELETE_DATA_PERSISTENCE_MESSAGE];
            }
        }
        
    }
    @catch (NSException *exception) {
        
        [self didCompletePersistenceServiceWithError:ERROR_DELETE_DATA_PERSISTENCE.intValue andMessage:ERROR_DELETE_DATA_PERSISTENCE_MESSAGE];
    }
    
}

/**
 * Helps retrieve all the saved keys from the persistent store.
 *
 * @return String : String containing all the keys and their corresponding
 *         values from the persistent store
 * */
-(NSMutableArray*)getAllFromSharedPreference
{
    NSMutableArray *responseArray =[[NSMutableArray alloc]init];
    @try{
        NSDictionary *allPreferenceEntries = [storePreferences allPreferences];
        NSArray *allKeys = allPreferenceEntries.allKeys;
        if (allKeys.count>0)
        {
            
            for (int index=0;index<allKeys.count;index++)
            {
                NSString *nextKey = [allKeys objectAtIndex:index];
                NSString *nextValue =[allPreferenceEntries valueForKey:nextKey];
                NSMutableDictionary *responseElement=[[NSMutableDictionary alloc]init];
                [responseElement setValue:nextKey forKey:MMI_RESPONSE_PROP_STORE_KEY];
                [responseElement setValue:nextValue forKey:MMI_RESPONSE_PROP_STORE_VALUE];
                [responseArray addObject:responseElement];
            }
            
        }
    }@catch (NSException *e) {
        responseArray=nil;
    }
    return responseArray;
}

-(void)didCompletePersistenceServiceWithError:(int)exceptionType andMessage:(NSString *)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}

-(void)didCompletePersistenceServiceWithSuccess:(NSString *)callbackData
{
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:callbackData];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

@end
