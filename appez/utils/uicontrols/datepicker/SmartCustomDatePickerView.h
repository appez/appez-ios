//
//  SmartCustomDatePickerView.h
//  appez
//
//  Created by Transility on 4/19/12.
//

#import <UIKit/UIKit.h>
#import "SmartPickerDelegate.h"

@interface SmartCustomDatePickerView : UIView
{  
}
@property(nonatomic,assign)    id<SmartPickerDelegate> delegate;
@property(nonatomic,assign)   IBOutlet UIDatePicker* datePicker;
@property (retain, nonatomic) IBOutlet UIView *backGroundPickerView;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;

-(IBAction)doneButtonAction;

@end
