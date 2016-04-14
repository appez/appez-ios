//
//  MobiletException.m
//  appez
//
//  Created by Transility on 4/12/12.
//

#import "MobiletException.h"
#import "ExceptionTypes.h"
@implementation MobiletException
+ (NSException *)MobiletExceptionWithType:(NSString *)name Message:(NSString *)message 
{
    if([name length]<= 0)
        name=UNKNOWN_EXCEPTION;
    return [super exceptionWithName:name reason:message userInfo:nil];
}
@end
