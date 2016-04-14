//
//  ExceptionTypes.h
//  appez
//
//  Created by Transility on 2/28/12.
//

#define    UNKNOWN_EXCEPTION                               @"-1"
#define    SERVICE_TYPE_NOT_SUPPORTED_EXCEPTION            @"-2"
#define    SMART_APP_LISTENER_NOT_FOUND_EXCEPTION          @"-3"
#define    SMART_CONNECTOR_LISTENER_NOT_FOUND_EXCEPTION    @"-4"
#define    INVALID_PAGE_URI_EXCEPTION                      @"-5"
#define    INVALID_PROTOCOL_EXCEPTION                      @"-6"
#define    INVALID_ACTION_CODE_PARAMETER                   @"-7"
#define    ACTION_CODE_NUMBER_FORMAT_EXCEPTION             @"-8"
#define    IO_EXCEPTION                                    @"-9"
#define    HTTP_PROCESSING_EXCEPTION                       @"-10"
#define    NETWORK_NOT_REACHABLE_EXCEPTION                 @"-11"
#define     FILE_NOT_FOUND_EXCEPTION                       @"-12"
#define     MALFORMED_URL_EXCEPTION                        @"-13"
#define     PROTOCOL_EXCEPTION                             @"-14"
#define     UNSUPPORTED_ENCODING_EXCEPTION                 @"-15"
#define     SOCKET_EXCEPTION_REQUEST_TIMED_OUT             @"-16"
#define     ERROR_SAVE_DATA_PERSISTENCE                    @"-17"
#define     ERROR_RETRIEVE_DATA_PERSISTENCE                @"-18"
#define     ERROR_DELETE_DATA_PERSISTENCE                  @"-19"
#define     JSON_PARSE_EXCEPTION                           @"-20"
#define     UNKNOWN_CURRENT_LOCATION_EXCEPTION             @"-21"
#define     DB_OPERATION_ERROR                             @"-22"
#define    SOCKET_EXCEPTION                                @"-23"
#define    UNKNOWN_NETWORK_EXCEPTION                       @"-24"
#define     DEVICE_SUPPORT_EXCEPTION                       @"-25"
#define     FILE_READ_EXCEPTION                            @"-26"
#define     EXTERNAL_SD_CARD_NOT_AVAILABLE_EXCEPTION       @"-27"
#define PROBLEM_SAVING_IMAGE_TO_EXTERNAL_STORAGE_EXCEPTION @"-28"
#define     PROBLEM_CAPTURING_IMAGE_EXCEPTION              @"-29"
#define     ERROR_RETRIEVING_CURRENT_LOCATION              @"-30"
#define     DB_SQLITE_INIT_ERROR                           @"-31"
#define     FILE_UNZIP_ERROR                               @"-32"
#define     FILE_ZIP_ERROR                                 @"-33"
#define     DB_OPEN_ERROR                                  @"-34"
#define     DB_QUERY_EXEC_ERROR                            @"-35"
#define     DB_READ_QUERY_EXEC_ERROR                       @"-36"
#define     DB_TABLE_NOT_EXIST_ERROR                       @"-37"
#define     DB_CLOSE_ERROR                                 @"-38"
#define     INVALID_SERVICE_REQUEST_ERROR                  @"-39"
#define     INVALID_JSON_REQUEST                           @"-40"
#define     LOCATION_ERROR_GPS_NETWORK_DISABLED            @"-41"
#define     LOCATION_ERROR_PERMISSION_DENIED               @"-42"
#define     NOTIFIER_REQUEST_INVALID                       @"-43"
#define     NOTIFIER_REQUEST_ERROR                         @"-44"
#define     USER_SIGN_CAPTURE_ERROR                        @"-45"

//EXCEPTION MESSAGE
#define NETWORK_NOT_REACHABLE_EXCEPTION_MESSAGE     @"Network not reachable"
#define UNABLE_TO_PROCESS_MESSAGE                   @"Unable to process request"
#define UNKNOWN_CURRENT_LOCATION_EXCEPTION_MESSAGE  @"Could not get current location"
#define JSON_PARSE_EXCEPTION_MESSAGE                @"Unable to parse JSON"
#define HARDWARE_CAMERA_IN_USE_EXCEPTION_MESSAGE  @"Camera already in use"
#define PROBLEM_CAPTURING_IMAGE_EXCEPTION_MESSAGE @"Problem capturing image from camera"
#define ERROR_RETRIEVING_CURRENT_LOCATION_MESSAGE @"Unable to retrieve current location"
#define ERROR_DELETE_DATA_PERSISTENCE_MESSAGE     @"Problem deleting data from persistence store"
#define ERROR_RETRIEVE_DATA_PERSISTENCE_MESSAGE   @"Problem retrieving data from persistence store"
#define ERROR_SAVE_DATA_PERSISTENCE_MESSAGE       @"Problem saving data to persistence store"
#define DB_OPERATION_ERROR_MESSAGE                @"Problem performing database operation"
#define FILE_UNZIP_ERROR_MESSAGE                  @"Unable to extract the archive file."
#define FILE_ZIP_ERROR_MESSAGE                    @"Unable to create archive file."

#define INVALID_SERVICE_REQUEST_ERROR_MESSAGE     @"Invalid Service Request. Make sure that you have provided all the required parameters in the request."
#define LOCATION_ERROR_GPS_NETWORK_DISABLED_MESSAGE @"Could not fetch the location.GPS radio or Network disabled."
#define LOCATION_ERROR_PERMISSION_DENIED_MESSAGE     @"Could not retrieve location because permission for location service for this application is denied by the user.If you want to re-enable the location service then go to Settings->LocationService and then enable the location for your application."

#define NOTIFIER_REQUEST_INVALID_MESSAGE    @"Notifier request invalid."
#define NOTIFIER_REQUEST_ERROR_MESSAGE      @"Error processing notifier request"

#define USER_SIGN_CAPTURE_ERROR_MESSAGE  @"Unable to capture the user signature"