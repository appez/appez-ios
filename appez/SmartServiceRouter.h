//  SmartServiceRouter.h
//  appez
//  Created by Transility on 2/27/12.

/** 
 * SmartServiceRouter.java: 
 * It is based on factory pattern. It maintains the pool of Services, on new requests 
 * it checks the availability of request in pool. If it is available then it uses the reference else 
 * it creates the object of new services makes entry in Pool and then returns the object of service.
 */

#import <Foundation/Foundation.h>
#import "SmartServiceDelegate.h"
#import "SmartService.h"
#import "ServiceConstants.h"

@interface SmartServiceRouter : NSObject 
{
    @private NSMutableDictionary        *serviceDictionary;
	@private id<SmartServiceDelegate>   smartServiceDelegate;
}
-(instancetype)initSmartServiceRouter:(id<SmartServiceDelegate>)delegate;

/**
 * Returns instance of SmartService based on the service type
 * 
 * @param serviceType
 *            : Type of service
 * @param context
 *            : Application context
 * @return SmartService
 * */
-(SmartService*)getService:(int)serviceType;

/**
 * Removes the mentioned service from services set
 * 
 * @param serviceType
 *            : Type of service
 * @param isEventCompleted
 *            : Indicates whether or not the event is complete
 */
-(void)releaseService:(int)serviceType WithFlag:(BOOL)isEventCompleted;
@end
