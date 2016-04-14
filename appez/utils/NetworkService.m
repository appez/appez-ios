//
//  NetworkService.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "NetworkService.h"
#import "SmartEvent.h"
#import "SmartConstants.h"
#import "ExceptionTypes.h"
#import "GTMBase64.h"
#import "XMLReader.h"

#define FREE_NSOBJ(x) {if(x!=nil){[x release]; x= nil;}}
#define HTTP_RESPONSE_OK                200
#define SERVER_TIMEOUT 75

@interface NetworkService(private)
- (void)startRequest:(NSMutableURLRequest *)request;
- (void)tearDownConnection;
-(void)parseDataCallback:(NSString*)dataCallback;
-(void)executeSyncRequest:(NSMutableURLRequest*)aRequest;
-(void)parseRequestHeader:(NSArray*)reqHeader;
-(BOOL)isImageUrl;
-(NSMutableData*)processFileUploadInfo;
-(NSData*)addHeadersToResponse;
@end

@implementation NetworkService
@synthesize request;
@synthesize httpResponse;
//-------------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithDelegate:(id<SmartNetworkDelegate>)Delegate
{
	self = [super init];
	if (self != nil)
	{
		delegate =Delegate;
        request = nil;
		httpResponse = nil;
		urlConnection = nil;
		responseData = nil;
        headerMap=[[NSMutableDictionary alloc] initWithCapacity:2];
	}
	
	return self;
}

//------------------------------------------------------------------------------------------------------------------------
-(void)performSyncRequest:(NSString*)requestdata WithFlag:(BOOL)createFile
{
 
        //Inform delegate about the request being sent
        bCreateFileDump=createFile;
        [self parseDataCallback:requestdata];
        NSMutableURLRequest *aRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:SERVER_TIMEOUT];
  
        [self executeSyncRequest:aRequest];
    
}
//------------------------------------------------------------------------------------------------------------------------
-(void)performAsyncRequest:(NSString*)requestdata WithFlag:(BOOL)createFile
{
   
    bCreateFileDump=createFile;
    [self parseDataCallback:requestdata];
    NSMutableURLRequest *aRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:SERVER_TIMEOUT];
    [self startRequest:aRequest];
  
}
//------------------------------------------------------------------------------------------------------------------------
-(void)cancelRequest
{
    [self tearDownConnection];

}
//------------------------------------------------------------------------------------------------------------------------
-(void)tearDownConnection
{
    
    if(urlConnection!=nil)
    {
       
        [urlConnection cancel];
        urlConnection = nil;
    }
    
    if(responseData!=nil)
    {
        responseData = nil;
    }
    
    if(httpResponse!=nil)
    {
        httpResponse = nil;
    }
   
}
//-------------------------------------------------------------------------------------------------------------------------
-(void)executeSyncRequest:(NSMutableURLRequest*)aRequest
{
    
    responseData = nil;
    request = nil;
    httpResponse = nil;
    
    request = aRequest;
    
    NSArray  *headerKey=nil;
    // To traverse through the hashmap based on the keys
    if (headerMap.allKeys.count>0)
    {
        headerKey = headerMap.allKeys;
        for(int i=0 ; i<=headerKey.count ; i++)
        {
            NSString *nextKey = [headerKey objectAtIndex:i];
            [request setValue:[headerKey valueForKey:nextKey] forHTTPHeaderField:nextKey];
        }
        [headerMap removeAllObjects];
    }
    
    request.HTTPMethod=requestVerb;
    
    if([requestVerb isEqualToString:HTTP_REQUEST_TYPE_POST])
    {
        request.HTTPBody=[requestBody dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSError * error = nil;
    NSURLResponse *urlResonse=nil;
    responseData = [NSMutableData dataWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResonse error:&error]];
    httpResponse=(NSHTTPURLResponse*)urlResonse;
    if((httpResponse!= nil) && (error== nil))
    {
       if([httpResponse statusCode]==HTTP_RESPONSE_OK)
       {
           NSString *fileName=nil;
            
           if(bCreateFileDump)
           {
               NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
               fileName=[NSString stringWithFormat:@"%f/%@",NSDate.timeIntervalSinceReferenceDate,FILE_TYPE_DAT];
                NSString *finalPath=[NSString stringWithFormat:@"%@/%@",path,fileName];
                
                NSFileManager *fileManager=[NSFileManager defaultManager];
                [fileManager createFileAtPath:finalPath contents:responseData attributes:nil];
           }
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNetworkDelegate)])
                [delegate didCompleteHttpOperationWithSuccess:[[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]];;
       }
        else
        {
            //Error case
            responseData = nil;
            request = nil;
            httpResponse = nil;
            
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNetworkDelegate)])
                [delegate didCompleteHttpOperationWithError:HTTP_PROCESSING_EXCEPTION.intValue WithMessage:UNABLE_TO_PROCESS_MESSAGE];
        }
    }
    else
    {
        //Error case
        responseData = nil;
        request = nil;
        httpResponse = nil;
        
        if (delegate && [delegate conformsToProtocol:@protocol(SmartNetworkDelegate)])
            [delegate didCompleteHttpOperationWithError:(int)[error code] WithMessage:UNABLE_TO_PROCESS_MESSAGE];
    }
    
}
//------------------------------------------------------------------------------------------------------------------------
#pragma mark- Private methods
- (void)startRequest:(NSMutableURLRequest *)aRequest
{
    //Clean up
    [self tearDownConnection];
    
	request =aRequest;
    
    NSArray  *headerKey=nil;
    // To traverse through the hashmap based on the keys
    if (headerMap.allKeys.count>0)
    {
        headerKey = headerMap.allKeys;
        NSInteger headerCount=headerKey.count;
        for(int i=0 ; i< headerCount ; i++)
        {
            NSString *nextKey = [NSString stringWithFormat:@"%@",[headerKey objectAtIndex:i]];
            NSString *nextValue=[headerMap valueForKey:nextKey];
            nextKey=[nextKey stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            nextValue=[nextValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [AppUtils showDebugLog:[NSString stringWithFormat:@"next key %@ value %@",nextKey,nextValue]];
            [request setValue:nextValue forHTTPHeaderField:nextKey];
            [AppUtils showDebugLog:[NSString stringWithFormat:@"request set value %@ for key %@",[headerMap valueForKey:nextKey],nextKey]];
        }
        [headerMap removeAllObjects];
    }
    
    request.HTTPMethod=requestVerb;
       
    if([requestVerb isEqualToString:HTTP_REQUEST_TYPE_POST])
    {
        request.HTTPMethod=HTTP_REQUEST_TYPE_POST;
        [AppUtils showDebugLog:[NSString stringWithFormat:@"inside post request value is %@",request]];
        if (requestFileUploadInfo != NULL && [requestFileUploadInfo length] > 0) {
        
            NSData *uploadData= [self processFileUploadInfo];
            request.HTTPBody=uploadData;
        }
        else
        {
            request.HTTPBody=[requestBody dataUsingEncoding:NSUTF8StringEncoding];
            if(requestContentType != NULL && [requestContentType length]>0)
            {
                [request setValue:requestContentType forHTTPHeaderField:@"Content-Type"];
            }
        }
    }
    //Adding implementation for PUT request on 6th Aug 2014
    else if ([requestVerb isEqualToString:HTTP_REQUEST_TYPE_PUT])
    {
        [AppUtils showDebugLog:[NSString stringWithFormat:@"inside put request value is %@",request]];
        request.HTTPMethod=HTTP_REQUEST_TYPE_PUT;
        request.HTTPBody=[requestBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    else if ([requestVerb isEqualToString:HTTP_REQUEST_TYPE_DELETE])
    {
        request.HTTPMethod=HTTP_REQUEST_TYPE_DELETE;
    }
    
    responseData = [NSMutableData new];
	
    urlConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                   
    [[NSRunLoop currentRunLoop] run];
    
}
/**
 * Processes file upload information to extract the information regarding
 * the files from the device storage that needs to be uploded to the remote
 * server
 * */
-(NSMutableData*)processFileUploadInfo
{
    NSArray *fileUploadArray=[NSJSONSerialization JSONObjectWithData:[requestFileUploadInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableData *fileUploadData=[NSMutableData data];
    
    // We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
	CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(nil, uuid)) ;
	CFRelease(uuid);
	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    
	[request  setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary] forHTTPHeaderField:@"Content-Type"];
	
    //start boundry
	[fileUploadData appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger i=0;
    //add extra parameter
    if(requestBody != NULL && [requestBody length] > 0)
    {
        NSArray *postHeaders=[requestBody componentsSeparatedByString:@"&"];
        
        for (NSString *keyvalue in postHeaders) {
            
            NSArray *keyValueArray=[keyvalue componentsSeparatedByString:@"="];
            if(keyValueArray.count==2)
            {
                [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",[keyValueArray objectAtIndex:0],[keyValueArray objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            else
            {
                [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",[keyValueArray objectAtIndex:0],@""] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            i++;
            if(i!=postHeaders.count || fileUploadArray.count>0)
            {
                [fileUploadData appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    i=0;
    
    for (NSDictionary *fileToUpload in fileUploadArray) {

        NSString *fileToUploadType=[fileToUpload valueForKey:@"imageType"];
        if([fileToUploadType isEqualToString:FILE_UPLOAD_TYPE_URL])
        {
            NSString *fileName=[[fileToUpload valueForKey:@"imageData"] componentsSeparatedByString:@"/"].lastObject;
            
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[fileToUpload valueForKey:@"name"],fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            //todo : need to get content type from java script
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

            
            NSData *data=[NSData dataWithContentsOfFile:[fileToUpload valueForKey:@"imageData"]];
            [fileUploadData appendData:data];
        }
        else if([fileToUploadType isEqualToString:FILE_UPLOAD_TYPE_DATA])
        {
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n",[fileToUpload valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
            //todo : need to get content type from java script
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileUploadData appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [fileUploadData appendData:[GTMBase64 decodeString:[fileToUpload valueForKey:@"imageData"]]];
        }
        
        i++;
		// Only add the boundary if this is not the last item in the post body
		if (i != fileUploadArray.count) {
			[fileUploadData appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
		}
    }
    
    [fileUploadData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return fileUploadData;
}
//-------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData
{
	[responseData appendData:newData];
}
//-------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];

    [AppUtils showDebugLog:[NSString stringWithFormat:@"httpresponse is %@",httpResponse]];
  if([httpResponse statusCode] == HTTP_RESPONSE_OK)
    {
        if(bCreateFileDump)
        {
            NSString *docPath=[AppUtils getDocumentpath];
            NSString *finalPath=[docPath stringByAppendingPathComponent:requestFileToSaveName];
            NSError *error;
            [responseData writeToFile:finalPath options:NSDataWritingAtomic error:&error];

            responseData=[[finalPath dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        
            NSDictionary *responseHeaders =[httpResponse allHeaderFields];
        
            if ((responseHeaders != NULL) && (responseHeaders.count > 0)) {
            // If the response contains headers, then a JSON needs
            // to be created in the response that contains server
            // response in JSON format and also the response headers
            NSData *responseWithHeadrs=[self addHeadersToResponse];
                if(responseData!=nil)
                {
                responseData=nil;
                }
            
                responseData =[NSMutableData dataWithData:responseWithHeadrs];
            
            }
        
            [AppUtils showDebugLog:[NSString stringWithFormat:@"response string is %@",[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] ]];
        
            if (delegate && [delegate respondsToSelector:@selector(didCompleteHttpOperationWithSuccess:)])
            [delegate didCompleteHttpOperationWithSuccess:[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]];
        }
        else
        {
        NSDictionary *responseHeaders =[httpResponse allHeaderFields];
            
            if ((responseHeaders != NULL) && (responseHeaders.count > 0))
            {
            // If the response contains headers, then a JSON needs
            // to be created in the response that contains server
            // response in JSON format and also the response headers
            NSData *responseWithHeadrs=[self addHeadersToResponse];
            
                if(responseData!=nil)
                {
                    responseData=nil;
                }
                
                responseData =[NSMutableData dataWithData:responseWithHeadrs];
            }
        
            [AppUtils showDebugLog:[NSString stringWithFormat:@"response string is %@",[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] ]];
            
            if (delegate && [delegate respondsToSelector:@selector(didCompleteHttpOperationWithSuccess:)])
            [delegate didCompleteHttpOperationWithSuccess:[[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        }
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(didCompleteHttpOperationWithError:WithMessage:)])
        [delegate didCompleteHttpOperationWithError:HTTP_PROCESSING_EXCEPTION.intValue WithMessage:UNABLE_TO_PROCESS_MESSAGE];
    }
    
    [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    [self tearDownConnection];
}

/**
 * Adds headers in HTTP response before sending it to the web layer. Forms a
 * JSON that can be sent to the web layer
 *
 * @return NSData : Data containing the response which needs to be sent to server
 * */

-(NSData*)addHeadersToResponse{
    
    NSData *httpResponseData = NULL;
    @try
    {
        NSString *responseString=NULL;
        
        if([self isImageUrl])
        {
            responseString=[[NSString alloc]init];
            responseString =[GTMBase64 stringByEncodingData:responseData];
        }
        else
        {
            responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] ;
            [AppUtils showDebugLog:[NSString stringWithFormat:@"responseString %@",responseString]];
        }
          
        // Check if the server response is in XML, If is is XML then convert it in to JSON and encode it
        if (([responseString rangeOfString:RESPONSE_TYPE_XML].length >0)
            || (([[responseString substringWithRange:NSMakeRange(0,1)] isEqualToString:RESPONSE_TYPE_XML_START_SYMBOL]) &&
                ([[responseString substringWithRange:NSMakeRange([responseString length]-1,1)] isEqualToString:RESPONSE_TYPE_XML_END_SYMBOL]))) {
            
                responseString = [AppUtils getJsonFromDictionary:[XMLReader dictionaryForXMLData:responseData error:nil]];
            }
            else  // Convert response data in to BASE 64
            {
                NSData* data=[responseString dataUsingEncoding:NSUTF8StringEncoding];

                responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
                
            }
        responseString=[responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString=[responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        responseString=[responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];

        //Header Processing block
        /////////////////////////////////////////////////////////////
        NSDictionary *responseHeaders =[httpResponse allHeaderFields];
        NSInteger responseHeaderCount = responseHeaders.count;
        
        NSMutableDictionary *responseWithHeader = [NSMutableDictionary dictionary];
        NSMutableArray *responseHeadersArray = [NSMutableArray array];
        
        NSArray *allKeys=responseHeaders.allKeys;
        
        for (int header = 0; header < responseHeaderCount; header++) {
            
            NSMutableDictionary *headerNode = [NSMutableDictionary dictionary];
            [headerNode setObject:[allKeys objectAtIndex:header] forKey:MMI_RESPONSE_PROP_HTTP_HEADER_NAME];
            [headerNode setObject:[responseHeaders valueForKey:[allKeys objectAtIndex:header]] forKey:MMI_RESPONSE_PROP_HTTP_HEADER_VALUE];
            [responseHeadersArray addObject:headerNode];
        }
        ///////////////////////////////////////////////////////////////////
        
        [responseWithHeader setObject:responseString forKey:MMI_RESPONSE_PROP_HTTP_RESPONSE];
        [responseWithHeader setObject:responseHeadersArray forKey:MMI_RESPONSE_PROP_HTTP_RESPONSE_HEADERS];
        
        httpResponseData = [NSJSONSerialization dataWithJSONObject:responseWithHeader options:NSJSONWritingPrettyPrinted error:nil];
    
    } @catch (NSException *exception) {
        // TODO handle this exception
        NSLog(@"Exception :%@",[exception description]);

    }

    return httpResponseData;

}

//-------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	
    if (delegate && [delegate respondsToSelector:@selector(didCompleteHttpOperationWithError:WithMessage:)])
        [delegate didCompleteHttpOperationWithError:NETWORK_NOT_REACHABLE_EXCEPTION.intValue WithMessage:NETWORK_NOT_REACHABLE_EXCEPTION_MESSAGE];
    [self tearDownConnection];
   
}
//-------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    httpResponse = (NSHTTPURLResponse*)response;
    //[httpResponse retain];
}
#pragma
#pragma mark - Utility Methods
#pragma

/**
 * Parses request data to extract HTTP request parameters
 *
 * @param dataCallback
 *            : Request data containing parameters for performing HTTP
 *            action
 */

-(void)parseDataCallback:(NSString*)dataCallback
{
        @try {
            NSDictionary *httpRequestData=[AppUtils getDictionaryFromJson:dataCallback];
			
            if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_URL])
            {
				requestURL = [httpRequestData valueForKey: MMI_REQUEST_PROP_REQ_URL];
			}
            else
            {
				requestURL =@"";
			}
            
			if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_METHOD])
            {
				requestVerb = [httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_METHOD];
			}
            else
            {
				requestVerb = @"";
			}
			
			if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_POST_BODY])
            {
				requestBody = [httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_POST_BODY];
			}
            else
            {
				requestBody = @"";
			}
			
			if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_HEADER_INFO])
            {
				requestHeader = [httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_HEADER_INFO];
				//Change made to fix the issue of saving http response data to dump file
                if(requestHeader!=NULL && ![requestHeader isEqual:@""]){
                    [self parseRequestHeader:requestHeader];
                }
			}
            else
            {
				requestHeader = NULL;
			}
			
			if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_FILE_INFO])
            {
				requestFileUploadInfo = [httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_FILE_INFO];
			}
            else
            {
				requestFileUploadInfo = @"";
			}
			
			if([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_CONTENT_TYPE])
            {
				requestContentType = [httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_CONTENT_TYPE];
			}
            else
            {
				requestContentType = @"";
			}
            
            if ([httpRequestData.allKeys containsObject:MMI_REQUEST_PROP_REQ_FILE_TO_SAVE_NAME])
            {
                requestFileToSaveName=[httpRequestData valueForKey:MMI_REQUEST_PROP_REQ_FILE_TO_SAVE_NAME];
            }
            else
            {
                requestFileToSaveName=@"";
            }

        }@catch (NSException *exception) {
            NSLog(@"Exception :%@",[exception description]);
   
        }
}

/**
 * Parses the request header string to extract information regarding the
 * request headers
 *
 * @param reqHeader
 *            : String containing all the request headers associated with
 *            the HTTP request
 * */

-(void)parseRequestHeader:(NSArray*)reqHeader
{
    NSInteger headerCount=reqHeader.count;
    int i=0;
    for(i=0;i<headerCount;i++)
    {
        NSDictionary *reqHeaderObj=[reqHeader objectAtIndex:i];
        NSString *headerKey=[reqHeaderObj valueForKey:MMI_REQUEST_PROP_HTTP_HEADER_KEY];
        NSString *headerValue=[reqHeaderObj valueForKey:MMI_REQUEST_PROP_HTTP_HEADER_VALUE];
        if([headerKey length]>0 && [headerValue length]>0)
           [headerMap setValue:headerValue forKey:headerKey];
    }
}

-(BOOL)isImageUrl{
    
    BOOL isImageUrl=FALSE;
    NSString *extension=[requestURL pathExtension];
   
    if([extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"bmp"] || [extension isEqualToString:@"gif"] || [extension isEqualToString:@"png"]) {
    
        isImageUrl=TRUE;
    }

    return isImageUrl;
}
@end
