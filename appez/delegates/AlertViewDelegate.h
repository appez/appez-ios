//
//  AlertViewDelegate.h
//  appez
//
//  Created by Transility on 2/29/12.
//


#import <Foundation/Foundation.h>


#define ALERTVIEW_MESSAGE_YESNO  1002
#define ALERTVIEW_MESSAGE_OK     1004
#define ALERTVIEW_LOADING        1005


@protocol AlertViewDelegate <NSObject>

@optional
/**
 * Specifies action to be taken on the basis of user selection provided
 * 
 * userSelection : User selection
 */
-(void)processUsersSelection:(NSString*)userSelection;

/**
 * Specifies action to be taken when application exits
 * 
 */
-(void)exitApp;

@end
