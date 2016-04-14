//  WebEvents.h
//  appez
//  Created by Transility on 2/29/12.


//[4][3][2][1][0]
//[4]th Place- Will signify Event type i.e. Web=1, CO=2 or App=3
//[3]rd and [2]nd place - Will signify service type like UI Service, reachability service or HTTP Service
//[1]st and [0]th place - Will signify Action type like show loader, hide loader, HTTP Action types


//UI Service constants
#define WEB_SHOW_ACTIVITY_INDICATOR  10101
#define WEB_HIDE_ACTIVITY_INDICATOR  10102
#define WEB_UPDATE_LOADING_MESSAGE   10103
#define WEB_SHOW_DATE_PICKER         10104
#define WEB_SHOW_MESSAGE             10105
#define WEB_SHOW_MESSAGE_YESNO       10106
#define WEB_SHOW_INDICATOR           10107
#define WEB_HIDE_INDICATOR           10108
#define WEB_SHOW_DIALOG_SINGLE_CHOICE_LIST              10109
#define WEB_SHOW_DIALOG_SINGLE_CHOICE_LIST_RADIO_BTN    10110
#define WEB_SHOW_DIALOG_MULTIPLE_CHOICE_LIST_CHECKBOXES 10111

//HTTP Service constants
#define WEB_HTTP_REQUEST             10201
#define WEB_HTTP_REQUEST_SAVE_DATA   10202

//Data Persistence service constants
#define WEB_SAVE_DATA_PERSISTENCE       10401
#define WEB_RETRIEVE_DATA_PERSISTENCE   10402
#define WEB_DELETE_DATA_PERSISTENCE     10403

// Database service constants
#define WEB_OPEN_DATABASE           10501
#define WEB_EXECUTE_DB_QUERY        10502
#define WEB_EXECUTE_DB_READ_QUERY   10503
#define WEB_CLOSE_DATABASE          10504

//File Reading service constants
#define WEB_READ_FILE_CONTENTS       10801
#define WEB_READ_FOLDER_CONTENTS     10802
#define WEB_UNZIP_FILE_CONTENTS      10803
#define WEB_ZIP_CONTENTS             10804

//Camera service constants
#define WEB_CAMERA_OPEN         10901
#define WEB_IMAGE_GALLERY_OPEN  10902

//Location service constants
#define WEB_USER_CURRENT_LOCATION  11001
//Signature service constants
#define WEB_SIGNATURE_SAVE_IMAGE  11201
#define WEB_SIGNATURE_IMAGE_DATA  11202
