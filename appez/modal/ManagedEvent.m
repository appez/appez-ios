//
//  ManagedEvent.m
//  appez
//
//  Created by Transility on 02/04/14.
//
//

#import "ManagedEvent.h"
#import "AppUtils.h"

@implementation ManagedEvent
@synthesize managedEventRequest;
@synthesize managedEventResponse;
@synthesize managedEventType;

-(id)initWithManagedEvent:(NSString*)eventMessage
{
    @try {
        if (eventMessage != nil && [eventMessage length]>0) {
            NSDictionary *managedEventObj = [AppUtils getDictionaryFromJson:eventMessage];
            self.managedEventRequest=managedEventObj;
        }
    } @catch (NSException *exception) {
    }
    return self;
}

@end
