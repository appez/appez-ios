//
//  DatabaseService.m
//  appez
//
//  Created by Transility on 20/08/12.
//
//

#import "DatabaseService.h"
#import "WebEvents.h"
#import "SmartConstants.h"
#import "MobiletException.h"
#import "AppUtils.h"

@interface DatabaseService(PrivateMethods)
-(void)didCompleteDatabaseOperationWithSuccess:(NSString *)dbResponse;
-(void)didCompleteDatabaseOperationWithError:(int)exceptionType andMessage:(NSString*)exceptionMessage;
-(NSString*)prepareResponse;
@end

@implementation DatabaseService

-(instancetype)initDatabaseServiceWithDelegate:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        smartServiceDelegate=delegate;
    }
    return self;
}

/**
 * Performs supported SQL operations
 *
 * @param smartEvent
 *            : SmartEvent that contains details of the operations to be
 *            performed
 * */
-(void)performAction:(SmartEvent*)smartevent
{
    smartEvent=smartevent;
    BOOL isDbOperationSuccessfull=FALSE;
    NSString *queryString=NULL;
    NSString *readQueryString=NULL;
    NSString *readQueryResponse=NULL;
    NSDictionary *serviceRequestData=[[NSDictionary alloc]initWithDictionary:smartevent.smartEventRequest.serviceRequestData];
    
    @try {
        appDBName=[serviceRequestData valueForKey:MMI_RESPONSE_PROP_APP_DB];
        isEncryptionNeeded=[[serviceRequestData valueForKey:MMI_REQUEST_PROP_SHOULD_ENCRYPT_DB] boolValue];
        if(sqliteUtility==nil)
            sqliteUtility=[[SqliteUtility alloc] initWithDbName:appDBName andEncyptionFlag:isEncryptionNeeded];
        
        switch (smartevent.smartEventRequest.serviceOperationId )
        {
            case WEB_OPEN_DATABASE:
                
                isDbOperationSuccessfull=[sqliteUtility sqlite3_open_Ex:appDBName];
                
                if(isDbOperationSuccessfull)
                {
                    [self didCompleteDatabaseOperationWithSuccess:[self prepareResponse]];
                }
                else
                {
                    [self didCompleteDatabaseOperationWithError:DB_OPERATION_ERROR.intValue  andMessage:DB_OPERATION_ERROR_MESSAGE];
                }
                
                break;
                
            case WEB_EXECUTE_DB_QUERY:
                
                queryString=[serviceRequestData valueForKey:MMI_REQUEST_PROP_QUERY_REQUEST];
                isDbOperationSuccessfull=[sqliteUtility sqlite3_exec_Ex:queryString];
                
                if (isDbOperationSuccessfull)
                {
                    [self didCompleteDatabaseOperationWithSuccess:[self prepareResponse]];
                    
                }
                else
                {
                    [self didCompleteDatabaseOperationWithError:DB_OPERATION_ERROR.intValue andMessage:DB_OPERATION_ERROR_MESSAGE];
                }
                break;
                
            case WEB_EXECUTE_DB_READ_QUERY:
                
                if ([serviceRequestData valueForKey:MMI_REQUEST_PROP_QUERY_REQUEST]!=nil)
                {
                    readQueryString=[serviceRequestData valueForKey:MMI_REQUEST_PROP_QUERY_REQUEST];
                }
                readQueryResponse=[sqliteUtility sqlite3_prepare_v2_Ex:readQueryString];
                
                if(readQueryResponse!=nil)
                {
                    [self didCompleteDatabaseOperationWithSuccess:readQueryResponse];
                }
                else
                {
                    [self didCompleteDatabaseOperationWithError:sqliteUtility.queryExceptionType andMessage:DB_OPERATION_ERROR_MESSAGE];
                }
                
                break;
            case WEB_CLOSE_DATABASE:
				
                isDbOperationSuccessfull = [sqliteUtility sqlite3_close_Ex];
                if (isDbOperationSuccessfull)
                    [self didCompleteDatabaseOperationWithSuccess:[self prepareResponse]];
                else
                    [self didCompleteDatabaseOperationWithError:DB_OPERATION_ERROR.intValue andMessage:DB_OPERATION_ERROR_MESSAGE];
                
                break;
                
            default:
                break;
        }
        
    }
    @catch (MobiletException *exception)//This catch block is deadcode according to the current implementation
    {
        [self didCompleteDatabaseOperationWithError:DB_OPERATION_ERROR.intValue andMessage:[exception description]];
    }
}

-(NSString *)prepareResponse{
    NSMutableDictionary *dbResponseObj=[[NSMutableDictionary alloc]init];
    @try {
        [dbResponseObj setValue:appDBName forKey:MMI_RESPONSE_PROP_APP_DB];
    }
    @catch (NSException *exception) {
        //Do nothing here
        NSLog(@"Exception :%@",[exception description]);

    }
    
    NSString *dbResponseObjString=[AppUtils getJsonFromDictionary:dbResponseObj];
    return dbResponseObjString;
}

-(void)didCompleteDatabaseOperationWithError:(int)exceptionType andMessage:(NSString *)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}
-(void)didCompleteDatabaseOperationWithSuccess:(NSString *)dbResponse
{
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:dbResponse];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}
@end
