//  CoEvents.h
//  appez
//  Created by Transility on 2/29/12.


//[4][3][2][1][0]
//[4]th Place- Will signify Event type i.e. Web=1, CO=2 or App=3
//[3]rd and [2]nd place - Will signify service type like UI Service, reachability service or HTTP Service
//[1]st and [0]th place - Will signify Action type like show loader, hide loader, HTTP Action types


#ifndef appez_CoEvents_h
#define appez_CoEvents_h

#define CONTEXT_CHANGE  20601
#define  CONTEXT_WEBVIEW_SHOW  20602
#define  CONTEXT_WEBVIEW_HIDE  20603

//Maps service constants
#define CO_SHOW_MAP_ONLY  20701
#define CO_SHOW_MAP_N_DIR 20702
#define CO_SHOW_MAP_N_ANIMATION 20703
//----------------------------------------

#define  CONTEXT_NOTIFICATION_CREATELIST  203

#define  ANIMATION_FLIP_PLAY  204
#define  ANIMATION_FLIP_RESUME    205
#define  ANIMATION_CURL_PLAY  206
#define  ANIMATION_CURL_RESUME    207
#define  CONTEXT_POPOVER_SHOW  208
#define  CONTEXT_POPOVER_HIDE  209
#define  CONTEXT_NOTIFICATION_MASTER  210
#define  CONTEXT_NOTIFICATION_DETAIL  211


#endif   
