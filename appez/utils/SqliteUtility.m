//
//  SqliteUtility.m
//  appez
//
//  Created by Transility on 20/08/12.
//
//

#import "SqliteUtility.h"
#import "AppUtils.h"
#import "MobiletException.h"
#import "ExceptionTypes.h"
#import "SmartConstants.h"

@implementation SqliteUtility
@synthesize queryExceptionType;

-(instancetype)initWithDbName:(NSString*)appDb andEncyptionFlag:(BOOL)encryptionFlag
{
    self=[super init];
    if(self!=nil)
    {
        isEncryptionRequired=encryptionFlag;
        appDbName=appDb;
    }
    return self;
}


#pragma
#pragma mark - Helper Methods
#pragma
-(BOOL)resultString:(int)resultCode
{
    switch (resultCode) {
        case SQLITE_OK:
            return TRUE;
            break;
        case SQLITE_ERROR:
            return FALSE;
            break;
        default:
            return FALSE;
    }
}

//-------------------------------------------------------------------------------------------------
/**
 appez framework level method to close database, making use of sqlite
 */

-(BOOL)sqlite3_close_Ex
{
	if(sqliteDb)
	{
        sqlite3_close(sqliteDb);
        sqliteDb= nil;
    }
    if (!sqliteDb) {
        isDbOperationComplete=TRUE;
    }
    else{
        isDbOperationComplete=FALSE;
    }
    return isDbOperationComplete;
}


- (NSString*) getEncryptionKey
{
    NSString *key=[NSString stringWithFormat:@"BIGSecret"];
    return key;
}
//--------------------------------------------------------------------------------------------
/**
 appez framework level method to open the database,making use of sqlite
 *@param : name of the database which has to be opened.
 */

-(BOOL)sqlite3_open_Ex:(NSString*)dbName
{
    appDbName=dbName;
    int resultCode;
    NSString* docPath =[AppUtils getDocumentpath];
    NSString *databaseName=[NSString stringWithFormat:@"%@.sqlite",dbName];
    docPath = [docPath stringByAppendingPathComponent:databaseName];
    resultCode=sqlite3_open(docPath.UTF8String,&sqliteDb);
    
#if defined(ENCRYPT)
    if(isEncryptionRequired)
    {
        const char *key=[self getEncryptionKey].UTF8String;
        sqlite3_key(sqliteDb,key, strlen(key));
    }
#endif
    isDbOperationComplete=[self resultString:resultCode];
    return isDbOperationComplete;
}


/**
 appez framework level method to execute a query string provided as a argument
 @param: queryString which has to be executed.
 */
-(BOOL)sqlite3_exec_Ex:(NSString*)queryString
{
    if(sqliteDb)
    {
        [AppUtils showDebugLog:[NSString stringWithFormat:@"QUERY for EXEC: %@",queryString]];
        @try {
            char *ab;
            isDbOperationComplete=[self resultString:sqlite3_exec(sqliteDb,queryString.UTF8String, NULL, NULL, &ab)];
        }
        @catch (NSException *exception) {
            
            isDbOperationComplete=FALSE;
        }
        
    }
    else
        isDbOperationComplete=FALSE;
    
    return isDbOperationComplete;
}


/**
 appez Framework level method sqlite prepare
 */

-(NSString*)sqlite3_prepare_v2_Ex:(NSString*)queryString
{
    if(sqliteDb)
    {
        sqlite3_stmt *stmt;
        
        int resultCode=sqlite3_prepare_v2(sqliteDb, queryString.UTF8String, -1, &stmt, NULL);
    
        if(resultCode==SQLITE_OK)
        {
            [AppUtils showDebugLog:[NSString stringWithFormat:@"ok case"]];
            return [self prepareQueryData:stmt];
        }
        else
        {
            if(resultCode==SQLITE_ERROR)
            {
                self.queryExceptionType=DB_TABLE_NOT_EXIST_ERROR.intValue;
            }
            else
            {
                self.queryExceptionType=DB_OPERATION_ERROR.intValue;
            }
            return nil;
        }
    }
    else
        return nil;
    
    return nil;
}

/**
 A common method to prepare all type of complete queries from general statement provided as argument
 *@param: stmt
 The sqlite stament which is general and has to be prepared into specific query.
 */
-(NSString*)prepareQueryData:(sqlite3_stmt*)stmt
{
    NSString *queryResponse=NULL;
    int columnCount=0;
    NSMutableArray *resultRows=[[NSMutableArray alloc]init];
    NSMutableDictionary *readQueryResponseObj=[[NSMutableDictionary alloc]init];
    
    while(sqlite3_step(stmt)==SQLITE_ROW)
    {
        NSMutableDictionary *rowItem=[[NSMutableDictionary alloc]init];
        NSMutableArray *tableRow=[[NSMutableArray alloc]init];
        
        columnCount =sqlite3_column_count(stmt);
        if(columnCount>0)
        {
            for(int columnNumber=0;columnNumber<columnCount ;columnNumber++)
            {
                NSString *columnName=[NSString stringWithFormat:@"%s",sqlite3_column_name(stmt, columnNumber)];
                double column;
                NSString *str;
                int column_type=sqlite3_column_type(stmt,columnNumber);
                
                switch (column_type) {
                        
                    case SQLITE_INTEGER:
                        [rowItem setValue:[NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, columnNumber)] forKey:columnName];
                        break;
                        
                    case SQLITE_FLOAT:
                        column=sqlite3_column_double(stmt, columnNumber);
                        str=[NSString stringWithFormat:@"%lf",column];
                        [rowItem setValue:str forKey:columnName];
                        break;
                        
                    case SQLITE_TEXT:
                        
                        [rowItem setValue:[NSString stringWithFormat:@"%s",sqlite3_column_text(stmt, columnNumber)]  forKey:columnName];
                        
                        break;
                        
                    case SQLITE_BLOB:
                        [rowItem setValue:(__bridge id)(sqlite3_column_blob(stmt, columnNumber)) forKey:columnName];
                        break;
                        
                    case SQLITE_NULL:
                        [rowItem setValue:@"null" forKey:columnName];
                        break;
                    default:
                        break;
                }
                [tableRow addObject:rowItem];
            }
            [resultRows addObject:rowItem];
        }
    }
    
    if(columnCount>=0)
    {
        [readQueryResponseObj setValue:resultRows forKey:MMI_RESPONSE_PROP_DB_RECORDS];
        [readQueryResponseObj setValue:appDbName forKey:MMI_RESPONSE_PROP_APP_DB];
        
        queryResponse=[AppUtils getJsonFromDictionary:readQueryResponseObj];
        
        [AppUtils showDebugLog:[NSString stringWithFormat:@"SqliteUtility->prepareQueryData->queryresponse->%@",queryResponse]];
    }
    else
    {
        queryResponse=nil;
    }
    sqlite3_finalize(stmt);  
    return queryResponse;
}

@end