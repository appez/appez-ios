//
//  DatePickerController.m
//  Volly
//
//  Created by Transility on 11/21/11.
//

#import "SmartDatePickerView.h"
#import "SmartUIUtility.h"

@implementation SmartDatePickerView
@synthesize delegate;
@synthesize datePicker;
@synthesize backGroundPickerView;

-(void)awakeFromNib
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        NSLog(@"SmartDatePickerView->init");
    }

return self;
}

//------------------------------------------------------------------------------------------------------
-(IBAction)doneButtonAction
{
    //mm-dd-yyyy
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat=@"MM-dd-yyyy";
    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedDate:)])
         [delegate processUsersSelectedDate:[NSString stringWithFormat:@"%@"/*@"{\"data\":\"%@\"}"*/,[dateFormatter stringFromDate:datePicker.date]]];
}
//------------------------------------------------------------------------------------------------------
-(IBAction)cancelButtonAction
{

    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedDate:)])
        [delegate processUsersSelectedDate:@"-1"];
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
        [[SmartUIUtility sharedInstance] hideDatePicker];
        [delegate processUsersSelectedDate:@"-1"];
	}
}
@end
