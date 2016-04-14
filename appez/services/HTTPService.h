//
//  HTTPService.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * HttpService : Performs HTTP operations. Currently supports HTTP GET and POST
 * operations. 
 **/
#import <Foundation/Foundation.h>
#import "SmartService.h"
#import "SmartServiceDelegate.h"
#import "SmartNetworkDelegate.h"

@interface HTTPService : SmartService<SmartNetworkDelegate>
{
    SmartEvent *smartEvent;
    id<SmartServiceDelegate> smartServiceDelegate;
}

-(instancetype)initHttpServiceWithDelegate:(id<SmartServiceDelegate>)delegate;


@end
