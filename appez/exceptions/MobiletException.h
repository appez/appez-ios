//
//  MobiletException.h
//  appez
//
//  Created by Transility on 4/12/12.
//

#import <Foundation/Foundation.h>

@interface MobiletException : NSException
+ (NSException *)MobiletExceptionWithType:(NSString *)name Message:(NSString *)message;
@end
