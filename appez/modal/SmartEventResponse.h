//
//  SmartEventResponse.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * SmartEventResponse : Model bean defining the response parameters for Smart
 * Event request generated from the web layer
 *
 * */

#import <Foundation/Foundation.h>

@interface SmartEventResponse : NSObject
{
    @private BOOL isOperationComplete;
    @private NSString   *serviceResponse;
    @private NSString   *exceptionMessage;
    @private int        exceptionType;
}
@property(nonatomic,readwrite)  BOOL isOperationComplete;
@property(nonatomic,retain)     NSString *serviceResponse;
@property(nonatomic,retain)     NSString *exceptionMessage;
@property(nonatomic,readwrite)  int      exceptionType;

@end
