//
//  DatabaseService.h
//  appez
//
//  Created by Transility on 20/08/12.
//
/**
 * DatabaseService : Provides access to the device database which is a SQLite
 * implementation. Enables the user to create database that resides in the
 * application sandbox. Also enables user to perform basic CRUD operations.
 * Current implementation allows for execution of queries as they are provided
 * by the user
 *
 * */

#import <Foundation/Foundation.h>
#import "SmartService.h"
#import "SmartServiceDelegate.h"
#import "SqliteUtility.h"
#import "CommMessageConstants.h"
#import "ExceptionTypes.h"

@interface DatabaseService : SmartService
{
    SmartEvent *smartEvent;
    id<SmartServiceDelegate> smartServiceDelegate;
    SqliteUtility *sqliteUtility;
    NSString *appDBName;
    BOOL isEncryptionNeeded;
}

-(instancetype)initDatabaseServiceWithDelegate:(id<SmartServiceDelegate>)delegate;

@end
