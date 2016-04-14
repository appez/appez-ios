//
//  SmartDatePickerDelegate.h
//  appez
//
//  Created by Transility on 4/17/12.
//

#import <Foundation/Foundation.h>

@protocol SmartPickerDelegate <NSObject>
@optional
-(void)processUsersSelectedDate:(NSString*)date;
-(void)processUsersCustomSelectedDate:(NSString*)date;
-(void)processUsersSelectedIndex:(NSString*)index;
@end

