//
//  LocationUtility.h
//  appez
//
//  Created by Transility on 7/28/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtility : NSObject
+(NSString*)prepareLocationResponse:(CLLocation*)location;
@end
