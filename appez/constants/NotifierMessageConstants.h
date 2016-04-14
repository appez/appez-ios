//
//  Header.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#ifndef appez_NotifierMessageConstants_h
#define appez_NotifierMessageConstants_h

//Standard request properties
#define  NOTIFIER_REQUEST_PROP_CALLBACK_FUNC @"notifierCallback"
#define NOTIFIER_PROP_TRANSACTION_ID  @"transactionId"
#define NOTIFIER_PROP_TRANSACTION_REQUEST @"notifierTransactionRequest"
#define NOTIFIER_PROP_TRANSACTION_RESPONSE  @"notifierTransactionResponse"
#define NOTIFIER_TYPE @"notifierType"
#define NOTIFIER_ACTION_TYPE   @"notifierActionType"
#define NOTIFIER_REQUEST_DATA @"notifierRequestData"
#define NOTIFIER_EVENT_RESPONSE  @"notifierEventResponse"
#define NOTIFIER_OPERATION_IS_SUCCESS  @"isOperationSuccess"
#define NOTIFIER_OPERATION_ERROR  @"notifierError"
#define NOTIFIER_OPERATION_ERROR_TYPE  @"notifierErrorType"

//Push notifier constants
#define NOTIFIER_REGISTER_ERROR_CALLBACK @"errorNotifierCallback"
#define NOTIFIER_REGISTER_ERROR_CALLBACK_SCOPE @"errorNotifierCallbackScope"
#define NOTIFIER_PUSH_PROP_SERVER_URL @"pushServerUrl"

//Standard response properties
#define NOTIFIER_PUSH_PROP_MESSAGE  @"notifierPushMessage"

//Network status notifier constants
#define NOTIFIER_RESP_NWSTATE_WIFI_CONNECTED @"wifiConnected"
#define NOTIFIER_RESP_NWSTATE_CELLULAR_CONNECTED  @"cellularConnected"
#define NOTIFIER_RESP_NWSTATE_CONNECTED  @"networkConnected"

#endif
