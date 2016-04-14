//
//  NotifierEvent.h
//  appez
//
//  Created by Transility on 10/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NotifierEvent : NSObject
{
    @private NSString *transactionId;
	@private int type;
	@private int actionType;
	@private BOOL isOperationSuccess;
	@private NSDictionary *requestData;
	@private NSDictionary *responseData;
	@private int errorType;
	@private NSString *errorMessage;
}

@property(nonatomic,retain) NSString *transactionId;
@property(nonatomic,readwrite) int type;
@property(nonatomic,readwrite) int actionType;
@property(nonatomic,readwrite) BOOL isOperationSuccess;
@property(nonatomic,retain) NSDictionary *requestData;
@property(nonatomic,retain) NSDictionary *responseData;
@property(nonatomic,readwrite) int errorType;
@property(nonatomic,retain) NSString *errorMessage;

-(NSString*)getJavascriptNameToCallArg;
-(instancetype)initWithMessage:(NSString*)message;

@end
