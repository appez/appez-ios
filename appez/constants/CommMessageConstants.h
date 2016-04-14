//
//  CommMessageConstants.h
//  appez
//
//  Created by Transility on 3/3/14.
//
//

#ifndef appez_CommMessageConstants_h
#define appez_CommMessageConstants_h


//Request Object JSON properties
#define MMI_MESSAGE_PROP_TRANSACTION_ID @"transactionId"
#define MMI_MESSAGE_PROP_RESPONSE_EXPECTED @"isResponseExpected"
#define MMI_MESSAGE_PROP_TRANSACTION_REQUEST  @"transactionRequest"
#define MMI_MESSAGE_PROP_REQUEST_OPERATION_ID  @"serviceOperationId"
#define MMI_MESSAGE_PROP_REQUEST_DATA  @"serviceRequestData"
#define MMI_MESSAGE_PROP_TRANSACTION_RESPONSE  @"transactionResponse"
#define MMI_MESSAGE_PROP_TRANSACTION_OP_COMPLETE  @"isOperationComplete"
#define MMI_MESSAGE_PROP_SERVICE_RESPONSE  @"serviceResponse"
#define MMI_MESSAGE_PROP_RESPONSE_EX_TYPE  @"exceptionType"
#define MMI_MESSAGE_PROP_RESPONSE_EX_MESSAGE  @"exceptionMessage"

//Service Request object properties
#define MMI_REQUEST_PROP_SERVICE_SHUTDOWN  @"serviceShutdown"

//UI service request
#define MMI_REQUEST_PROP_MESSAGE  @"message"
#define MMI_REQUEST_PROP_ITEM  @"item"
//HTTP service request
#define MMI_REQUEST_PROP_REQ_METHOD  @"requestMethod"
#define MMI_REQUEST_PROP_REQ_URL  @"requestUrl"
#define MMI_REQUEST_PROP_REQ_HEADER_INFO  @"requestHeaderInfo"
#define MMI_REQUEST_PROP_REQ_POST_BODY  @"requestPostBody"
#define MMI_REQUEST_PROP_REQ_CONTENT_TYPE  @"requestContentType"
#define MMI_REQUEST_PROP_REQ_FILE_INFO  @"requestFileInformation"
#define MMI_REQUEST_PROP_REQ_FILE_TO_SAVE_NAME @"requestFileNameToSave"
//Persistence service request
#define MMI_REQUEST_PROP_STORE_NAME  @"storeName"
#define MMI_REQUEST_PROP_PERSIST_REQ_DATA  @"requestData"
#define MMI_REQUEST_PROP_PERSIST_KEY  @"key"
#define MMI_REQUEST_PROP_PERSIST_VALUE  @"value"
//Database service request
#define MMI_REQUEST_PROP_APP_DB  @"appDB"
#define MMI_REQUEST_PROP_QUERY_REQUEST  @"queryRequest"
#define MMI_REQUEST_PROP_SHOULD_ENCRYPT_DB  @"shouldEncrypt"
//Map service request
#define MMI_REQUEST_PROP_LOCATIONS  @"locations"
#define MMI_REQUEST_PROP_LEGENDS  @"legends"
#define MMI_REQUEST_PROP_LOC_LATITUDE  @"locLatitude"
#define MMI_REQUEST_PROP_LOC_LONGITUDE  @"locLongitude"
#define MMI_REQUEST_PROP_LOC_MARKER  @"locMarkerPin"
#define MMI_REQUEST_PROP_LOC_TITLE  @"locTitle"
#define MMI_REQUEST_PROP_LOC_DESCRIPTION  @"locDescription"
#define MMI_REQUEST_PROP_ANIMATION_TYPE   @"mapAnimationType"

//File/Folder read service
#define MMI_REQUEST_PROP_FILE_TO_READ_NAME  @"fileName"
#define MMI_REQUEST_PROP_FOLDER_FILE_READ_FORMAT @"fileFormatToRead"
#define MMI_REQUEST_PROP_FOLDER_READ_SUBFOLDER @"readFilesInSubfolders"
//Camera service
#define MMI_REQUEST_PROP_CAMERA_DIR  @"cameraDirection"
#define MMI_REQUEST_PROP_IMG_COMPRESSION  @"imageCompressionLevel"
#define MMI_REQUEST_PROP_IMG_ENCODING  @"imageEncoding"
#define MMI_REQUEST_PROP_IMG_RETURN_TYPE  @"imageReturnType"
#define MMI_REQUEST_PROP_IMG_FILTER  @"imageFilter"
#define MMI_REQUEST_PROP_IMG_SRC  @"imageSource"

// Location service
#define MMI_REQUEST_PROP_USE_NETWORK @"useNetwork"
#define MMI_REQUEST_PROP_LOCATION_TIMEOUT @"locTimeout"
#define MMI_REQUEST_PROP_LOC_ACCURACY @"locAccuracy"

//Service Response object properties

//UI service response
#define MMI_RESPONSE_PROP_USER_SELECTION  @"userSelection"
#define MMI_RESPONSE_PROP_USER_SELECTED_INDEX  @"selectedIndex"
//HTTP service request
#define MMI_REQUEST_PROP_HTTP_HEADER_KEY @"headerKey"
#define MMI_REQUEST_PROP_HTTP_HEADER_VALUE @"headerValue"

//HTTP service response
#define MMI_RESPONSE_PROP_HTTP_RESPONSE_HEADERS  @"httpResponseHeaders"
#define MMI_RESPONSE_PROP_HTTP_RESPONSE  @"httpResponse"
#define MMI_RESPONSE_PROP_HTTP_HEADER_NAME  @"headerName"
#define MMI_RESPONSE_PROP_HTTP_HEADER_VALUE  @"headerValue"
//Persistence service response
#define MMI_RESPONSE_PROP_STORE_NAME  @"storeName"
#define MMI_RESPONSE_PROP_STORE_RETURN_DATA  @"storeReturnData"
#define MMI_RESPONSE_PROP_STORE_KEY  @"key"
#define MMI_RESPONSE_PROP_STORE_VALUE  @"value"
//Database service response
#define MMI_RESPONSE_PROP_APP_DB  @"appDB"
#define MMI_RESPONSE_PROP_DB_RECORDS  @"dbRecords"
#define MMI_RESPONSE_PROP_DB_ATTRIBUTE  @"dbAttribute"
#define MMI_RESPONSE_PROP_DB_ATTR_VALUE  @"dbAttrValue"
//Map service response
//File Read service response
#define MMI_RESPONSE_PROP_FILE_CONTENTS  @"fileContents"
#define MMI_RESPONSE_PROP_FILE_NAME  @"fileName"
#define MMI_RESPONSE_PROP_FILE_CONTENT  @"fileContent"
#define MMI_RESPONSE_PROP_FILE_TYPE  @"fileType"
#define MMI_RESPONSE_PROP_FILE_SIZE  @"fileSize"
#define MMI_RESPONSE_PROP_FILE_UNARCHIVE_LOCATION @"fileUnarchiveLocation"
#define MMI_RESPONSE_PROP_FILE_ARCHIVE_LOCATION   @"fileArchiveLocation"

//Camera service response
#define MMI_RESPONSE_PROP_IMAGE_URL  @"imageURL"
#define MMI_RESPONSE_PROP_IMAGE_DATA  @"imageData"
#define MMI_RESPONSE_PROP_IMAGE_TYPE  @"imageType"

//Signature Service request constants
#define  MMI_REQUEST_PROP_SIGN_PENCOLOR  @"signPenColor"
#define  MMI_REQUEST_PROP_SIGN_IMG_SAVEFORMAT  @"signImageSaveFormat"

//Signature Service response constants
#define  MMI_RESPONSE_PROP_SIGN_IMAGE_URL   @"signImageUrl"
#define  MMI_RESPONSE_PROP_SIGN_IMAGE_DATA  @"signImageData"
#define  MMI_RESPONSE_PROP_SIGN_IMAGE_TYPE  @"signImageType"


#endif
