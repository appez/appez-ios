//
//  SmartMessagePicker.m
//  appez
//
//  Created by Transility on 07/01/13.
//
//

#import "SmartMessagePickerView.h"
#import "SmartConstants.h"
#import "SmartUIUtility.h"
#import "CommMessageConstants.h"
#import "AppUtils.h"
@implementation SmartMessagePickerView
@synthesize smartPicker;
@synthesize delegate;
@synthesize message;
@synthesize messagesArray;
@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.smartPicker.delegate=self;
    }
    
    return self;
}
- (IBAction)doneButtonAction:(id)sender
{
    [[SmartUIUtility sharedInstance] hideSmartMessagePicker];
    
    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedIndex:)])
       [delegate processUsersSelectedIndex:[NSString stringWithFormat:@"%d",selectedIndex]];
}

- (IBAction)cancelButtonAction:(id)sender
{

    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedIndex:)])
        [delegate processUsersSelectedIndex:@"-1"];
}

#pragma mark- UIPickerDelegate
#pragma 
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.messagesArray.count;
}

/**
 *This method returns the title for a particular row item of the list
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [self.messagesArray objectAtIndex:row];
}

/**
 *This method decides what has to be done when a particular row is selected
 */
- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex=(int)row;
}

-(void)processSelectionListItemInfo:(NSString*)listInfo
{
    self.messagesArray=[NSMutableArray arrayWithObject:listInfo];
    NSDictionary *listInfoObj=[messagesArray objectAtIndex:0];
    self.messagesArray=[listInfoObj valueForKey:MMI_REQUEST_PROP_ITEM];
}
//------------------------------------------------------------------------------------------------------
@end
