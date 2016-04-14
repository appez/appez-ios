//
//  AppUtils.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "AppUtils.h"
#import "PunchLocation.h"
#import "PunchInformation.h"
#import "SmartConstants.h"

@implementation AppUtils
@synthesize isMapBusy;
#pragma
#pragma mark -  Helper Methods
//----------------------------------------------------------------------------------------------------------------------
/** 
 Returns the absolute path of the html file in assets. The input is the html file whose path is to be returned.
 */

+(NSString*)getAbsolutePathForHtml:(NSString*)htmlFile
{
    NSString *returnPath;
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSString * fullPath = nil;
    NSString *curDir=[NSString stringWithFormat:@"?curDir=%@assets/web_assets",mainBundle.bundleURL.absoluteString];
    NSString *assetsPath=ASSETS_PATH_SMARTPHONE;
    if([AppUtils isDeviceiPad])
    {
        assetsPath=ASSETS_PATH_TABLET;
    }
    else
    {
        assetsPath=ASSETS_PATH_SMARTPHONE;
    }
    
    fullPath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@/%@",assetsPath,htmlFile] ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    
    NSString *theAbsoluteURLString = url.absoluteString;
    
    returnPath=[theAbsoluteURLString stringByAppendingString:curDir];
    
    return returnPath;
    
}
//--------------------------------------------------------------------------------------------------------------------------
/** 
 Used to get the documents path of the application
 */

+(NSString*)getDocumentpath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//--------------------------------------------------------------------------------------------------------------------------

/**
 Used to get the name of the xib filename which is given in input to the method.If the device is iPad, or iphone5, or else, corresponding xib names according to their standard will be returned.
 */
+(NSString*)getXibWithName:(NSString*)xibName
{
    BOOL isiPad = [AppUtils isDeviceiPad];
    NSString * nibName = xibName;
    
    if(isiPad == TRUE)
    {
       nibName = [NSString stringWithFormat:@"%@_iPad",xibName];
    }
    else if([AppUtils isDeviceiPhone5]==TRUE)
    {
       nibName = [NSString stringWithFormat:@"%@_5G",xibName];
    }
    else
    {
        //for normal screen
        nibName=xibName;
    }
    return nibName;
}

/**
 Used to check if the current device is iPhone5 or not
 */

+(BOOL)isDeviceiPhone5
{
    if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
    {
         CGSize result = [[UIScreen mainScreen] bounds].size;
         CGFloat scale = [UIScreen mainScreen].scale;
         result = CGSizeMake(result.width * scale, result.height * scale);
        if(result.height == 1136)
         {
             // iPhone 5 (1136px height)
             return TRUE;
         } else {
         //Not iPhone 5
             return FALSE;
         }
    }

    return FALSE;
}

//-------------------------------------------------------------------------------------------------------------------------
+(BOOL)isPopoverSupported
{
	return ( NSClassFromString(@"UIPopoverController") != nil) &&
	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}
//--------------------------------------------------------------------------------------------------------------------------

/**
 This method is used to determine whether the current device is ipad.Returns true if device is ipad, else returns false
 */

+(BOOL)isDeviceiPad
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        return TRUE;
    else
        return FALSE;
}
//--------------------------------------------------------------------------------------------------------------------------
/**
 Returns the frame which is suitable to the device frame depending on  its type as, iphone, iphone5 or ipad
 */
+(CGRect)getScreenFrame
{
    CGRect screenFrame;
    if([AppUtils isDeviceiPad])
        screenFrame=SCREEN_SIZE_IPAD;
    else if([AppUtils isDeviceiPhone5])
        screenFrame=SCREEN_SIZE_IPHONE_5G;
    else
        screenFrame=SCREEN_SIZE_IPHONE;        
    return screenFrame;
}
//--------------------------------------------------------------------------------------------------------------------------

//
+(NSBundle*)getBundlePath
{
    NSBundle *mainBundle=[NSBundle mainBundle];
    NSLog(@"%@.....%@",mainBundle,[NSBundle bundleWithURL:[mainBundle URLForResource:@"appezResources" withExtension:@"bundle"]]);
    return [NSBundle bundleWithURL:[mainBundle URLForResource:@"appezResources" withExtension:@"bundle"]];
}

//
+(NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet newlineCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

+(NSMutableArray*)punchLocation:(NSArray*)mapData
{
    
    NSMutableArray *array=[NSMutableArray array];
    for(NSDictionary *item in mapData)
    {
        PunchLocation *location=[[PunchLocation alloc] init];
        location.latitude=[[item valueForKey:MMI_REQUEST_PROP_LOC_LATITUDE] floatValue];
        location.longitude=[[item valueForKey:MMI_REQUEST_PROP_LOC_LONGITUDE] floatValue];
        location.title=[item valueForKey:MMI_REQUEST_PROP_LOC_TITLE];
        location.description=[item valueForKey:MMI_REQUEST_PROP_LOC_DESCRIPTION];
        location.hexColorForPin=[item valueForKey:MMI_REQUEST_PROP_LOC_MARKER];
        [array addObject:location];
    }
    
    return array;
}


+(NSMutableArray*)punchInformation:(NSArray*)mapData
{
    NSMutableArray *array=[NSMutableArray array];
    for(NSDictionary *item in mapData)
    {
        PunchInformation *location=[[PunchInformation alloc] init];
        location.title=[item valueForKey:MMI_REQUEST_PROP_LOC_TITLE];
        location.hexColorForPin=[item valueForKey:MMI_REQUEST_PROP_LOC_MARKER] ;
        [array addObject:location];
    }
    
    return array;
}
/**
 Utility method that converts the hexadecimal color code into the color(UIColor)
 */

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    scanner.scanLocation=1; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

/**
 * Prepares JSON image response based on the successful completion of image
 * operation
 *
 * @param imagePath
 *            : Absolute path of the image in the storage where the user
 *            captured image is stored. This value is non-null if user
 *            chooses to receive the image as saved image in the
 *            external/internal storage
 * @param imageData
 *            : Base64 encoded image data. This value is non-null if user
 *            chooses to receive the image as Base64 encoded data
 * @param imageFormatToSave
 *            : If the image is saved in the storage, then this parameter
 *            indicates the format in which the image was saved.
 *
 * @return String : JSON string containing image data
 *
 * */

+(NSString*) prepareImageSuccessResponse:(NSString*)imagePath imageData:(NSString*)imageData WithImageFormat:(NSString*)imageFormatToSave
{
    NSString *imageResponse = NULL;
    @try {
        NSMutableDictionary *response = [NSMutableDictionary dictionary];
        [response setObject:imagePath forKey:CAMERA_RESPONSE_TAG_IMG_URL];
        [response setObject:imageData forKey:CAMERA_RESPONSE_TAG_IMG_DATA];
        [response setObject:imageFormatToSave forKey:CAMERA_RESPONSE_TAG_IMG_TYPE];
        [response setObject:[NSNumber numberWithBool:TRUE] forKey:CAMERA_OPERATION_SUCCESSFUL_TAG];
     
        imageResponse =[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] ;
    } @catch (NSException *exception) {
        // TODO catch this exception
        NSLog(@"Exception :%@",[exception description]);

    }
    
    return imageResponse;
}


/*Utility method to convert the NSdictionary object into the json string.

 @param dictionary: The dictionary object that has to be converted to json
 
 @return String: The json string corresponding to the dictionary key value pairs
 
 */
+(NSString*)getJsonFromDictionary:(NSDictionary*)dictionary;
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding] ;
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   
    return jsonString;

}

/*Utility method to convert the json string into key value pairs of NSdictionary object
 @param jsonString: The json string that has to be converted to dictionary object
 
 @return NSDictionary: The key value pair containing dictionary created from the json String
 
 */
+(NSDictionary*)getDictionaryFromJson:(NSString*)jsonString;
{
    NSError *error;
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error]  ;
    return dictionary;
    
}

+(BOOL)deleteFileAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error=nil;
    BOOL isSuccess=[manager removeItemAtPath:filePath error:&error];
    if(isSuccess)
    {
        return TRUE;
    }
    else
    {
       [ AppUtils showDebugLog:[NSString stringWithFormat:@"Error in deleting file->%@",error ] ];
        return FALSE;
    }
}

+(void)showDebugLog:(NSString *)logToShow
{
#ifdef LIB_DEBUG
    NSLog(@"%@",logToShow);
#endif
}

+(SmartEventResponse*)createSuccessResponseWithserviceResponse:(NSString*)serviceResponse
{
    SmartEventResponse *smartEventResponse=[[SmartEventResponse alloc]init] ;
    smartEventResponse.serviceResponse=serviceResponse;
    smartEventResponse.exceptionType=0;
    smartEventResponse.exceptionMessage=@"";
    smartEventResponse.isOperationComplete=TRUE;
    return smartEventResponse;
}

+(SmartEventResponse*)createErrorResponseWithExceptionType:(int)exceptionType andExceptionMessage:(NSString *)exceptionMessage
{
    SmartEventResponse *smartEventResponse=[[SmartEventResponse alloc]init] ;
    smartEventResponse.serviceResponse=@"null";
    smartEventResponse.exceptionType=exceptionType;
    smartEventResponse.exceptionMessage=exceptionMessage;
    smartEventResponse.isOperationComplete=FALSE;
    return smartEventResponse;
}

+(BOOL)isNetworkAvailable
{
    Reachability *netReachablity=[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [netReachablity currentReachabilityStatus];
    BOOL isNetAvailable=netStatus==ReachableViaWWAN || netStatus==ReachableViaWiFi;
    return isNetAvailable;
}

+(NSString*)getAbsolutePathForFile:(NSString*)filePath
{
    NSString *docPath=[[[self getBundlePath] bundlePath] stringByDeletingLastPathComponent];
    NSString *absolutePath=[docPath stringByAppendingPathComponent:filePath];
    return absolutePath;
}

+(void)curlUpAnimationForView:(UIView *)view{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                           forView:view
                             cache:NO];
    
    [UIView commitAnimations];
}

+(void)curlDownAnimationForView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                           forView:view
                             cache:NO];
    
    [UIView commitAnimations];
}

+(void)flipFromLeftAnimationForView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:view
                             cache:NO];
    
    [UIView commitAnimations];
    
}
+(void)flipFromRightAnimationForView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:view
                             cache:NO];
    
    [UIView commitAnimations];
    
}

+(NSDictionary*)getAppConfigFileProps:(NSString*)configFileLocation
{
    NSString *fileAbsolutePath=[AppUtils getAbsolutePathForFile:configFileLocation];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *fileDataStr=NULL;
    NSMutableDictionary *keyValuePairObj=[[NSMutableDictionary alloc]init] ;
    
    if([fileManager fileExistsAtPath:fileAbsolutePath] == TRUE)
    {
        //If the file exists at the location
        fileDataStr=[[NSString alloc]initWithData:[fileManager contentsAtPath:fileAbsolutePath] encoding:NSUTF8StringEncoding] ;
    }
    NSArray *allComponents=[fileDataStr componentsSeparatedByString:@"\n"];
    NSInteger numberOfComp=allComponents.count;
    
    for (int i=0; i<numberOfComp; i++) {
        NSArray *keyValuePair=[[allComponents objectAtIndex:i] componentsSeparatedByString:@"="];
        NSString *key=[keyValuePair objectAtIndex:0];
        NSString *value=[keyValuePair objectAtIndex:1];
        [keyValuePairObj setValue:value forKey:key];
    }
    return keyValuePairObj;
}

+(float)getSystemVersion;
{
    float systemVersion;
    systemVersion=[[UIDevice currentDevice] systemVersion].floatValue;
    return systemVersion;
}
+(void)setMapBusy:(BOOL)isMapBusy
{
    [[SessionData sharedInstance] addSessionObject:[NSNumber numberWithBool:isMapBusy] withKey:@"isMapBusy"];
}
+(BOOL)getMapBusy
{
    
    BOOL isMapBusy =[(NSNumber*)[[SessionData sharedInstance] getSessionObject:@"isMapBusy"] boolValue];
    return isMapBusy;
}

+(NSString*)getDeviceUdid
{
    NSString *deviceId=NULL;
#if TARGET_IPHONE_SIMULATOR
    deviceId = @"iphonesimulator";
#else
    deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
    
    return deviceId;
}


@end
