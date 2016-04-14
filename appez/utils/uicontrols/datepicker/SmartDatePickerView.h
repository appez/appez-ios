//
//  DatePickerController.h
//  Volly
//
//  Created by Transility on 11/21/11.
//

#import <UIKit/UIKit.h>
#import "SmartPickerDelegate.h"

@interface SmartDatePickerView : UIView
{
   // id<SmartPickerDelegate> delegate;
}
@property(nonatomic,strong)    id<SmartPickerDelegate> delegate;
@property(nonatomic,strong)   IBOutlet UIDatePicker* datePicker;
@property (retain, nonatomic) IBOutlet UIView *backGroundPickerView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIView *datePickerView;

-(IBAction)doneButtonAction;
-(IBAction)cancelButtonAction;
@end

