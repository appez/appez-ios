//
//  SmartCustomDatePickerView.m
//  appez
//
//  Created by Transility on 4/19/12.
//

#import "SmartCustomDatePickerView.h"
#import "SmartUIUtility.h"

@implementation SmartCustomDatePickerView

@synthesize delegate;
@synthesize datePicker;
@synthesize backGroundPickerView;
@synthesize doneButton;

-(void)awakeFromNib
{
    [doneButton  addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        NSLog(@"smartcustoDatePicker->init");
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------
-(IBAction)doneButtonAction
{
    if(delegate && [delegate respondsToSelector:@selector(processUsersCustomSelectedDate:)])
        [delegate processUsersCustomSelectedDate:[datePicker.date description]];
}
//------------------------------------------------------------------------------------------------------

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
	
	UITouch *touch =[touches anyObject];
    CGPoint gestureStartPoint = [touch locationInView:self];
	BOOL flag =CGRectContainsPoint(self.backGroundPickerView.frame,gestureStartPoint);
	if(!flag)
	{
        [[SmartUIUtility sharedInstance] hideCustomDatePicker];
	}
}
@end
