//
//  SmartEventRequest.h
//  appez
//
//  Created by Transility on 3/3/14.
//
//

#import <Foundation/Foundation.h>

@interface SmartEventRequest : NSObject
{
@private int serviceOperationId;
@private  NSDictionary *serviceRequestData;
}

@property (nonatomic,readwrite) int serviceOperationId;
@property (nonatomic,retain) NSDictionary *serviceRequestData;
@property BOOL serviceShutdown;
@end
