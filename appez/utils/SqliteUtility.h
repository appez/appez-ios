//
//  SqliteUtility.h
//  appez
//
//  Created by Transility on 20/08/12.
//
//
/**
 *SqliteUtility: Utility class that helps execute SQlite queries and
 * perform operations for Database
 * */

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "CommMessageConstants.h"

@interface SqliteUtility : NSObject
{
    sqlite3 *sqliteDb;
    NSString *appDbName;
    BOOL isDbOperationComplete;
    BOOL isEncryptionRequired;
    int queryExceptionType;
}

@property int queryExceptionType;
-(instancetype)initWithDbName:(NSString*)appDb andEncyptionFlag:(BOOL)encryptionFlag;
- (BOOL)sqlite3_close_Ex;
- (BOOL)sqlite3_open_Ex:(NSString*)dbName;
- (BOOL)sqlite3_exec_Ex:(NSString*)queryString;
- (NSString*)sqlite3_prepare_v2_Ex:(NSString*)queryString;
- (NSString*) getEncryptionKey;

@end
