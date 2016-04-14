//
//  AppUtils.h
//  appez
//
//  Created by Transility on 2/27/12.
//
/**
 * AppUtils : Collection of utility functions used throughout the application
 * and the appez library
 * */
#import <Foundation/Foundation.h>
#import "CommMessageConstants.h"
#import "SmartEventResponse.h"
#import "Reachability.h"
#import "SessionData.h"

#define LIB_DEBUG
#define ENVIRONMENTAL_VARIABLE @"LSEnvironment"

@interface AppUtils : NSObject
{
    
}
@property BOOL isMapBusy;
+(NSString*)getAbsolutePathForHtml:(NSString*)htmlFile;
+(NSString*)getDocumentpath;
+(NSString*)getXibWithName:(NSString*)xibName;
+(BOOL)isDeviceiPad;
+(NSBundle*)getBundlePath;
+(NSMutableArray*)punchLocation:(NSArray*)mapData;
+(NSMutableArray*)punchInformation:(NSArray*)mapData;
+(CGRect)getScreenFrame;
+(NSString *)stringByRemovingControlCharacters: (NSString *)inputString;
+(BOOL)isDeviceiPhone5;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+(NSString*) prepareImageSuccessResponse:(NSString*)imagePath imageData:(NSString*)imageData WithImageFormat:(NSString*)imageFormatToSave;
+(BOOL)isPopoverSupported;
+(NSString*)getJsonFromDictionary:(NSDictionary*)dictionary;
+(NSDictionary*)getDictionaryFromJson:(NSString*)jsonString;
+(BOOL)deleteFileAtPath:(NSString*)filePath;
+(void)showDebugLog:(NSString*)logToShow;
+(SmartEventResponse*)createSuccessResponseWithserviceResponse:(NSString*)serviceResponse;
+(SmartEventResponse*)createErrorResponseWithExceptionType:(int)exceptionType andExceptionMessage:(NSString *)exceptionMessage;
+(BOOL)isNetworkAvailable;
+(NSString*)getAbsolutePathForFile:(NSString*)filePath;
+(void)curlUpAnimationForView:(UIView*)view;
+(void)curlDownAnimationForView:(UIView*)view;
+(void)flipFromLeftAnimationForView:(UIView*)view;
+(void)flipFromRightAnimationForView:(UIView*)view;
+(NSDictionary*)getAppConfigFileProps:(NSString*)configFileLocation;
+(float)getSystemVersion;
+(void)setMapBusy:(BOOL)isMapBusy;
+(BOOL)getMapBusy;
+(NSString*)getDeviceUdid;
@end
