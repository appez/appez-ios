//
//  MapService.h
//  appez
//
//  Created by Transility on 11/09/12.
//
//

/**
 * MapService : Allows the web layer to show maps in the appez powered
 * application. Currently this operation
 * is supported through the CO event which means it is not purely WEB or APP
 * event
 * */
#import <Foundation/Foundation.h>
#import "SmartServiceDelegate.h"
#import "SmartService.h"
#import "SmartCoActionDelegate.h"

@interface MapService : SmartService <SmartCoActionDelegate>
{
    SmartEvent *smartEvent;
     id<SmartServiceDelegate> smartServiceDelegate;
}
-(instancetype)initMapServiceWithDelegate:(id<SmartServiceDelegate>)delegate;
@end
