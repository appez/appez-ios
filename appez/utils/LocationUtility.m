//
//  LocationUtility.m
//  appez
//
//  Created by Transility on 7/28/14.
//
//

#import "LocationUtility.h"
#import "SmartConstants.h"
#import "AppUtils.h"

@implementation LocationUtility

+(NSString*)prepareLocationResponse:(CLLocation *)location
{
    [AppUtils showDebugLog:@"prepare location response"];
    NSString *locationResponse=NULL;
    @try {
        NSMutableDictionary *locationResponseObj=[[NSMutableDictionary alloc]init];
        if (location!=nil) {
            [locationResponseObj setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:LOCATION_RESPONSE_TAG_LATITUDE];
            [locationResponseObj setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:LOCATION_RESPONSE_TAG_LONGITUDE];
        }
        else
        {
            [locationResponseObj setValue:@"" forKey:LOCATION_RESPONSE_TAG_LATITUDE];
            [locationResponseObj setValue:@"" forKey:LOCATION_RESPONSE_TAG_LONGITUDE];
        }
        locationResponse=[AppUtils getJsonFromDictionary:locationResponseObj];
    }
    @catch (NSException *exception) {
        // TODO handle this exception
        NSLog(@"Exception :%@",[exception description]);

    }
    
    return locationResponse;
}

@end
