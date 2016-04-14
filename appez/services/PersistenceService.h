//
//  PersistenceService.h
//  appez
//
//  Created by Transility on 5/11/12.
//
/**
 * PersistenceService : Allows the user to hold data in
 * SharedPreferences for holding data across application's session. This service
 * allows saving data in key-value pair, retrieving data and deleting data on
 * the basis of key
 * */

#import "SmartService.h"
#import "SmartEvent.h"
#import "SmartServiceDelegate.h"
#import "StorePreferences.h"

@interface PersistenceService : SmartService
{
    SmartEvent *smartEvent;
    id<SmartServiceDelegate> smartServiceDelegate;
    StorePreferences *storePreferences;
}
-(instancetype)initPersistenceServiceWithDelegate:(id<SmartServiceDelegate>)delegate;
@end
