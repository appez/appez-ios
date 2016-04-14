//  SmartConstants.h
//  appez
//  Created by Transility on 2/29/12.

#define APP_NAME    @"appez"

#define PAGE_URI                @"key_url"
#define MA_INFO                 @"manageability_info"
#define KEY_APP_PAGE_URL        @"APP_PAGE_URL"
#define REQUEST_DATA            @"Http_request_data"
#define CREATE_FILE_DUMP        @"Is_file_dump_required"
#define FILE_LOCATION           @"file_location"
#define CHECK_FOR_INTENT_EXTRA  @"check_for_intent_extra"
#define CHECK_FOR_APP_CONFIG_INFO @"app_config_information"
#define CHECK_FOR_BACKGROUND    @"is_show_background"
#define SHOW_APP_HEADER         @"show_app_header"
#define HTTP_REQUEST_TYPE_POST   @"POST"
#define HTTP_REQUEST_TYPE_GET    @"GET"
#define HTTP_REQUEST_TYPE_PUT    @"PUT"
#define HTTP_REQUEST_TYPE_DELETE @"DELETE"

#define NATIVE_EVENT_BACK_PRESSED           0
#define NATIVE_EVENT_PAGE_INIT_NOTIFICATION 1
#define NATIVE_EVENT_ENTER_PRESSED          2
#define NATIVE_EVENT_LIST_ITEM_SELECTED     3
#define NATIVE_EVENT_LIST_ITEM_SELECTED_SEPARATOR = "^";
#define MENU_OPTION_LOGOUT_ID   100

#define USER_SELECTION_YES      @"0"
#define USER_SELECTION_NO       @"1"
#define USER_SELECTION_OK       @"2"

//--------------------------------------------------------------
#pragma mark- PERSISTANCE

#define SEPARATOR_NEW_LINE                              @"\n"
#define MSG_REQUEST_HEADER_SPLIT                        @"##"
#define MSG_KEY_VALUE_SEPARATOR                         @"|"
#define ESCAPE_SEQUENCE_BACKSLASH_DOUBLEQUOTES          @"\\\""
#define RETRIEVE_ALL_FROM_PERSISTENCE                   @"*"

#define FILE_TYPE_DAT                                   @".dat"

#define RESPONSE_TYPE_XML_START_SYMBOL  @"<"
#define RESPONSE_TYPE_XML_END_SYMBOL  @">"
#define RESPONSE_TYPE_XML                               @"<?xml version"
#define RESPONSE_TYPE_JSON                               @"{"
#define JSON_RESPONSE_START_IDENTIFIER                  @"{"
#define JSON_RESPONSE_END_IDENTIFIER                    @"}"
#define REQUEST_TYPE_XML                                @"XML"
#define REQUEST_TYPE_JSON                               @"JSON"
#define FILE_TYPE_XML                                   @"xml"

#define REQUEST_SUCCESSFUL_EXECUTION                    0
#define REQUEST_TIMED_OUT                               @"The operation timed out"

#define ENCODE_SINGLE_QUOTE_UTF8                        @"%27"


#define HTTP_RESPONSE_STATUS_OK                         200
#define HTTP_REQUEST_ELEMENT_LENGTH                     6
#define HTTP_RESPONSE_HEADERS_ARRAY_NODE_NAME  @"appez-responseHeaders"
#define HTTP_RESPONSE_HEADER_PROP_NAME  @"appez-headerName"
#define HTTP_RESPONSE_HEADER_PROP_VALUE  @"appez-headerValue"
#define HTTP_REQUEST_TYPE_GET  @"GET"

//GENERIC JSON RESPONSE PROPERTY TAGS
#define RESPONSE_JSON_PROP_DATA  @"data"

// Successful event completion notifications
#define NETWORK_REACHABLE                               2
#define DB_OPERATION_SUCCESSFUL                         3
#define PERSISTENCE_OPERATION_SUCCESSFUL                4
#define CO_EVENT_SUCCESSFUL                             5
#define DB_OPERATION_ERROR_MESSAGE_TABLE_NOT_EXISTS  @"Table does not exist"


#define DEFAULT_BACKGROUND_IMAGE                        @"background.png"
#define DEFAULT_BACKGROUND_IMAGE5G                        @"background_5G.png"
#define DEFAULT_BACKGROUND_LANDSCAPE                    @"background_iPad_Landscape.png"
#define DEFAULT_BACKGROUND_PORTRAIT                     @"background_iPad_Portrait.png"
#define DEFAULT_appez_IMAGE                         @"appezResources.bundle/DefaultMobilizer.png"
//----------------------------------------------------

#define LIST_CREATION_INFO_JSON_ROOT_NODE               @"items"
#define LIST_CREATION_INFO_JSON_ITEM_ROOT_NODE          @"item"
#define LIST_HEADER_CREATION_INFO_JSON_ROOT_NODE        @"headers"
#define LIST_HEADER_CREATION_INFO_JSON_ITEM_ROOT_NODE   @"header"
#define LIST_CREATION_INFO_JSON_INFO_NODE               @"element"
#define LISTVIEW_HEADER_CREATION_INFO_JSON_ROOT_NODE      @"list_headers"
#define LISTVIEW_HEADER_CREATION_INFO_JSON_ITEM_ROOT_NODE @"list_header"
#define LISTVIEW_FOOTER_CREATION_INFO_JSON_ROOT_NODE       @"list_footers"
#define LISTVIEW_FOOTER_CREATION_INFO_JSON_ITEM_ROOT_NODE  @"list_footer"
#define LISTVIEW_LAYOUT_XML_TAG                         @"cell_xml"
#define LIST_HEADER_LAYOUT_XML_TAG                      @"list_header_layout"
#define LISTVIEW_HEADER_LAYOUT_XML_TAG                  @"listview_header_layout"
#define LISTVIEW_FOOTER_LAYOUT_XML_TAG                  @"listview_footer_layout"
#define LIST_SELECTOR_DRAWABLE                          @"list_selector"



#pragma mark- MAP SEPRATOR
#define MAP_DEFAULT_ZOOM_LEVEL              12
#define MAP_INFO_PAIR_SEPARATOR             @"|"
#define MAP_INFO_PARAMETER_SEPARATOR        @"~"
#define MAP_INTENT_MAP_CREATION_INFO        @ "MapCreationInfo"
#define MAP_INTENT_GET_DIRECTION_INFO       @"MapGetDirectionInfo"
#define MAP_INTENT_SOURCE_LATITUDE          @"SourceLatitude"
#define MAP_INTENT_SOURCE_LONGITUDE         @"SourceLongitude"
#define MAP_INTENT_DESTINATION_LATITUDE     @"DestinationLatitude"
#define MAP_INTENT_DESTINATION_LONGITUDE    @"DestinationLongitude"
#define MAP_ERROR_MESSAGE_GETTING_DIRECTIONS  @"Error getting directions for the specified pair of locations"

// Request location updates after 0 minutes
#define MAP_LOCATION_UPDATES_MINIMUM_TIME       0 * 60 * 1000
// Request location updates after change in distance over previous location
// is 5KM
#define MAP_LOCATION_UPDATES_MINIMUM_DISTANCE   1 * 1000
#define MAP_CURRENT_LOCATION_LOADING_MSG        @"Determining current location..."
#define MAP_CURRENT_LOCATION_TEXT_NOTE   @"Current Location"

#define PUNCH_LOCATION                      @"punchLocations"
#define PUNCH_INFORMATION                   @"punchInformation"
#define TITLE                               @"title"
#define COLOR                               @"color"
#define DESCRIPTION                         @"description"
#define LATITUDE                            @"lat"
#define LONGITUDE                           @"long"

//----------------------------------------------------
#pragma JAVASCRIPT NOTIFICATION
#define JS_HANDLE_CONTEXT_DETAIL @"javascript:AppController.getAppController().showDataDetail" //need to change as per new heirarchy
#define JS_HANDLE_CONTEXT_MASTER @"javascript:AppController.getAppController().showDataMaster" //need to change as per new heirarchy
#define JS_NOTIFICATION_FROM_NATIVE @"appez.mmi.manager.MobiletManager.notificationFromNative" 
//----------------------------------------------------
#pragma mark- URL Schemes
#define MIME_TYPE_PDF                   @"application/pdf"
#define kURLSchemeHTTP                  @"http"
#define kURLSchemeHTTPS                 @"https"
#define kURLSchemeFILE                  @"file"
#define kURLSchemeIMR                   @"imr"
#define kURLSchemeIMRFILE                @"imrfile"
#define kURLSchemeIMRLOG              @"imrlog"
//----------------------------------------------------
#pragma mark- SCREEN RECT

#define MasteriPadBoundsInPortriat                      CGRectMake(0,0,0,0)
#define MasteriPadBoundsInLandScape                     CGRectMake(0,0,318,768)
#define DetailiPadBoundsInPortriat                      CGRectMake(0,0,768,1004)
#define DetailiPadBoundsInLandScape                     CGRectMake(320,0,704,768)


#define SCREEN_SIZE_IPHONE (CGRect){0,0,320,480}
#define SCREEN_SIZE_IPHONE_5G (CGRect){0,0,320,568}
#define SCREEN_SIZE_IPAD (CGRect){0,0,768,1024}
#define NAVIGATION_SIZE_IPHONE (CGRect){0,0,320,44}
#define NAVIGATION_SIZE_IPAD (CGRect){0,0,768,44}


#define POPOVER_POSITION (CGRect){10,10,20,10}
#define POPOVER_CONTENT_SIZE (CGSize){320,480} 

#define ASSETS_PATH_SMARTPHONE @"assets/web_assets/app/html"
#define ASSETS_PATH_TABLET @"assets/web_assets/app/html"

#define FREE_NSOBJ(x) {if(x!=nil){[x release]; x= nil;}}


// Constants required for Application startup file

#define APP_STARTUP_INFO_NODE_ROOT  @"appStart"
// Information tags in Application startup JSON containing information
// regarding dynamic menu creation
#define APP_STARTUP_INFO_NODE_MENUS    @"menus"
#define MENUS_CREATION_PROPERTY_LABEL  @"menuTitle"
#define MENUS_CREATION_PROPERTY_ICON   @"menuIcon"
#define MENUS_CREATION_PROPERTY_ID     @"menuId"
#define MENU_CREATION_INFO_SEPARATOR   @"#"
#define MENU_DETAILS_KEY                @"menuDetails"
#define MENU_INFO_KEY                @"menuInfo"
#define MENU_TITLE                   @"title"
// TODO Add Information tags in Application startup JSON containing
// information regarding tab creation
#define APP_STARTUP_INFO_NODE_TABS     @"tabs"
#define TABS_CREATION_PROPERTY_LABEL   @"tabLabel"
#define TABS_CREATION_PROPERTY_ICON    @"iosTabIcon"
#define TABS_CREATION_PROPERTY_ID      @"tabId"
#define TABS_CREATION_PROPERTY_CONTENT_URL  @"tabContentUrl"
#define TABS_CREATION_INFO_SEPARATOR   @"#"

#define APP_STARTUP_INFO_NODE_TOPBAR_STYLING_INFO @"topbarstyle"
#define TOPBAR_STYLING_PROPERTY_START_COLOR  "topbarStartColor"
#define TOPBAR_STYLING_PROPERTY_END_COLOR  "topbarEndColor"
#define TOPBAR_TAB_STYLING_PROPERTY_START_COLOR  "topbarTabStartColor"
#define TOPBAR_TAB_STYLING_PROPERTY_END_COLOR  "topbarTabEndColor"

// Constants related to topbar styling information that needs to be sent in
// the application startup
#define TOPBAR_BG_TYPE_TAG  @"topbar-bg-type"
#define TOPBAR_BG_VALUE_TAG  @"topbar-bg-value"
#define TOPBAR_TEXT_COLOR_TAG @"topbar-text-color"
#define TABBAR_BG_TYPE_TAG @"tabbar-bg-type"
#define TABBAR_BG_VALUE_TAG  @"tabbar-bg-value"
#define TABBAR_TEXT_COLOR_TAG @"tabbar-text-color"

#define BAR_BG_TYPE_COLOR  @"bg-color"
#define BAR_BG_TYPE_GRADIENT @"bg-gradient"
#define BAR_BG_TYPE_IMAGE  @"bg-image"
#define BAR_BG_GRADIENT_IDENTIFIER  @"-webkit-linear-gradient"
#define BAR_BG_IMAGE_IDENTIFIER  @"url("

#define BAR_BG_GRADIENT_TYPE_HORIZONTAL  @"horizontal"
#define BAR_BG_GRADIENT_TYPE_VERTICAL  @"vertical"

// New set of constants for theme related information
#define TOPBAR_TXT_COLOR_TAG        @"topbar-text-color"
#define TOPBAR_BACKGROUND_COLOR_TAG  @"topbar-background-color"
#define TOPBAR_BACKGROUND_IMAGE_TAG   @"topbar-background-image"
#define TOPBAR_BACKGROUND_GRADIENT_TAG @"topbar-background-gradient"
#define TOPBAR_BACKGROUND_GRADIENT_TYPE_TAG @"gradient-type"
#define TOPBAR_BACKGROUND_GRADIENT_INFO_TAG @"gradient-info"

#define TABBAR_TXT_COLOR_TAG   @"tabbar-text-color"
#define TABBAR_BACKGROUND_COLOR_TAG  @"tabbar-background-color"
#define TABBAR_BACKGROUND_IMAGE_TAG  @"tabbar-background-image"
#define TABBAR_BACKGROUND_GRADIENT_TAG @"tabbar-background-gradient"

#define TOPBAR_BG_TYPE_IMAGE  @"background-type-image"
#define TOPBAR_BG_TYPE_COLOR  @"background-type-color"
#define TOPBAR_BG_TYPE_GRADIENT @"background-type-gradient"
#define TABBAR_BG_TYPE_IMAGE  @"tabbar-background-type-image"
#define TABBAR_BG_TYPE_COLOR  @"tabbar-background-type-color"
#define TABBAR_BG_TYPE_GRADIENT @"tabbar-background-type-gradient"
// ----------------------------------------------------
// Constants for Camera service
//camera cofiguration parameter
#define  CAM_PROPERTY_SOURCE  @"source"
#define  CAM_PROPERTY_QUALITY  @"quality"
#define  CAM_PROPERTY_RETURN_TYPE  @"returnType"
#define  CAM_PROPERTY_ENCODING  @"encoding"
#define  CAM_PROPERTY_FILTER  @"filter"
#define  CAM_PROPERTY_DIRECTION  @"direction"
#define  CAM_PROPERTY_WIDTH  @"width"
#define  CAM_PROPERTY_HEIGHT @"height"

#define CAMERA_PIC_CAPTURE_INTERVAL 5000
#define CAMERA_PIC_NAME  @"test"
#define IMAGES_TO_HOLD_IN_STORAGE  10
#define IMAGE_FORMAT_TO_SAVE_JPEG  @"jpg"
#define IMAGE_FORMAT_TO_SAVE_PNG  @"png"
#define REQ_CODE_PICK_IMAGE  1
#define INTENT_EXTRA_SAVED_IMAGE_NAME  @"SAVED_IMAGE_NAME"
#define INTENT_EXTRA_IMAGE_OPERATION_RESULT  @"IMAGE_OPERATION_RESULT"
#define REQ_CODE_START_CAMERA_OPERATION_ACTIVITY  1
#define IMAGE_URL  @"IMAGE_URL"
#define IMAGE_DATA  @"IMAGE_DATA"
#define STANDARD  @"STANDARD"
#define MONOCHROME  @"MONOCHROME"
#define SEPIA  @"SEPIA"
#define IMAGE_JPEG  @"jpg"
#define IMAGE_PNG  @"png"
#define CAMERA_FRONT  @"CAMERA_FRONT"
#define CAMERA_BACK  @"CAMERA_BACK"
#define CAMERA_RESPONSE_TAG_IMG_URL  @"imageURL"
#define CAMERA_RESPONSE_TAG_IMG_DATA  @"imageData"
#define CAMERA_RESPONSE_TAG_IMG_TYPE  @"imageType"
#define CAMERA_OPERATION_SUCCESSFUL_TAG  @"isCameraOperationSuccessful"
#define CAMERA_OPERATION_EXCEPTION_TYPE_TAG  @"cameraOperationExceptionType"
#define CAMERA_OPERATION_EXCEPTION_MESSAGE_TAG  @"cameraOperationExceptionMessage"
#define CAMERA_CAPTURED_TEMP_FILE = "eMob-temp.jpg"
#define FILE_UPLOAD_TYPE_URL  @"FILE_URL"
#define FILE_UPLOAD_TYPE_DATA  @"FILE_DATA"

//Constants for Location service
#define LOCATION_RESPONSE_TAG_LATITUDE  @"locationLatitude"
#define LOCATION_RESPONSE_TAG_LONGITUDE @"locationLongitude"

//New appez.config property file property keys
#define appez_CONF_PROP_MENU_INFO @"app.menuInfo"
#define appez_CONF_PROP_TOPBAR_INFO @"app.topbar"
#define appez_CONF_PROP_ACTIONBAR_ENABLE @"app.actionbarEnable"
#define appez_CONF_PROP_MANAGEABILITY_ENABLE @"app.manageabilityEnabled"
#define appez_CONF_PROP_PUSH_NOTIFIER_LISTENER_FUNCTION @"app.pushNotifierListener"
#define appez_CONF_PROP_NWSTATE_NOTIFIER_LISTENER @"app.networkNotifierListener"

//Default timeout for location requests. Currently 2 minutes.
#define LOCATION_SERVICE_DEFAULT_TIMEOUT 2 * 60 * 1000

#define LOCATION_ACCURACY_COARSE @"coarse"
#define LOCATION_ACCURACY_FINE @"fine"





