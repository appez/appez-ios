//
//  ManagedEvent.h
//  appez
//
//  Created by Transility on 02/04/14.
//
//

#import <Foundation/Foundation.h>

@interface ManagedEvent : NSObject
{
   @private int managedEventType;
   @private NSDictionary *managedEventRequest;
   @private NSDictionary *managedEventResponse;
}

@property (nonatomic,readwrite) int managedEventType;
@property (nonatomic,retain) NSDictionary *managedEventRequest;
@property (nonatomic,retain) NSDictionary *managedEventResponse;
-(id)initWithManagedEvent:(NSString*)eventMessage;
@end
