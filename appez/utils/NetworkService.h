//
//  NetworkService.h
//  appez
//
//  Created by Transility on 2/27/12.

/**
 * Utility class that enables background processing of
 * HTTP operation. Currently supports HTTP GET and POST operations. Also
 * supports file upload on a remote server
 *
 * */
#import <Foundation/Foundation.h>
#import "HTTPService.h"
#import "SmartNetworkDelegate.h"
#import "CommMessageConstants.h"
#import "AppUtils.h"
@interface NetworkService : NSObject
{
    @private NSMutableData      *responseData;
	@private NSString           *requestURL;
	@private NSString           *requestVerb;
	@private NSString           *requestBody;
    @private NSArray            *requestHeader;
	@private BOOL               bCreateFileDump;
    id<SmartNetworkDelegate>    delegate;
    
   // NSMutableURLRequest         *request;
	//NSHTTPURLResponse           *httpResponse;
    NSURLConnection             *urlConnection;
    
    NSMutableDictionary         *headerMap;
    
    NSString                    *requestFileUploadInfo;
	NSString                    *requestContentType;
    NSString                    *requestFileToSaveName;
   // NSString                    *fileToSaveLocation;
}
@property (nonatomic, assign) NSMutableURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *httpResponse;

-(instancetype)initWithDelegate:(id<SmartNetworkDelegate>)Delegate;
-(void)performSyncRequest:(NSString*)requestdata WithFlag:(BOOL)createFile ;
-(void)performAsyncRequest:(NSString*)requestdata WithFlag:(BOOL)createFile;
-(void)cancelRequest;

@end
