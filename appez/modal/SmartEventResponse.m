//
//  SmartEventResponse.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SmartEventResponse.h"
#import "ExceptionTypes.h"

@implementation SmartEventResponse

@synthesize isOperationComplete;
@synthesize exceptionMessage;
@synthesize exceptionType;
@synthesize serviceResponse;

- (instancetype)init {
    self = [super init];
    if (self) 
    {
        self.exceptionType=UNKNOWN_EXCEPTION.intValue;
    }
    return self;
}

@end
