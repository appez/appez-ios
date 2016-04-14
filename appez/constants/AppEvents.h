//  AppEvents.h
//  appez
//  Created by Transility on 2/29/12.
//[4][3][2][1][0]
//[4]th Place- Will signify Event type i.e. Web=1, CO=2 or App=3
//[3]rd and [2]nd place - Will signify service type like UI Service, reachability service or HTTP Service
//[1]st and [0]th place - Will signify Action type like show loader, hide loader, HTTP Action types

#define APP_NOTIFICATION   30000

// App Notification constants
#define  APP_DEFAULT_ACTION         30001
#define  APP_NOTIFY_EXIT            30002
#define  APP_NOTIFY_MENU_ACTION     30003
#define  APP_NOTIFY_DATA_ACTION     30004
#define  APP_NOTIFY_ACTIVITY_ACTION 30005
#define  APP_CONTROL_TRANSFER       30006
#define  APP_NOTIFY_CREATE_TABS     30007
#define  APP_NOTIFY_CREATE_MENU     30008
#define  APP_MANAGE_STARTUP         30009
#define  APP_NOTIFY_OPEN_BROWSER    30010
