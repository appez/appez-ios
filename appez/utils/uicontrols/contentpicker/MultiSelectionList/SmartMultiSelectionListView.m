//
//  appez
//
//  Created by Transility on 5/13/14.
//

#import "SmartMultiSelectionListView.h"
#import "SmartUIUtility.h"
#import "AppUtils.h"

@interface SmartMultiSelectionListView (PrivateMethods)

-(void)saveCheckBoxInfoForTag:(int)tag;
-(int)getCheckBoxClickCountForTag:(int)tag;
-(NSString*)prepareMultiSelectionListString;
@end

@implementation SmartMultiSelectionListView
@synthesize messagesArray;
@synthesize message;
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.smartList.delegate=self;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messagesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *mCell=[self.smartList cellForRowAtIndexPath:indexPath];
    if(![cellInfo containsObject:indexPath])
    {
        [mCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cellInfo addObject:indexPath];
    }
    else
    {
        if(mCell.accessoryType==UITableViewCellAccessoryCheckmark)
            [mCell setAccessoryType:UITableViewCellAccessoryNone];
        else
            [mCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cellInfo removeObject:indexPath];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mCell;
    if(!cellInfo)
        cellInfo=[[NSMutableSet alloc]init];
        mCell=[[UITableViewCell alloc]init] ;
        mCell.textLabel.text=[self.messagesArray objectAtIndex:indexPath.row];
        mCell.selectionStyle = UITableViewCellSelectionStyleNone;
        mCell.backgroundColor=[UIColor clearColor];
    if([cellInfo containsObject:indexPath])
    {
        mCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    return mCell;
}

- (IBAction)doneButtonAction:(id)sender {
    
    NSString *selectionInfo=[self prepareMultiSelectionListString];
    [[SmartUIUtility sharedInstance] hideMultiSelector];
    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedIndex:)])
        [delegate processUsersSelectedIndex:selectionInfo];
}

- (IBAction)cancelButtonAction:(id)sender {
    

    [[SmartUIUtility sharedInstance] hideMultiSelector];
    if(delegate && [delegate respondsToSelector:@selector(processUsersSelectedIndex:)])
        [delegate processUsersSelectedIndex:@"-1"];
}

-(void)processSelectionListItems:(NSString*)listInfo{

    self.messagesArray=[NSMutableArray arrayWithObject:listInfo];
    NSDictionary *listInfoObj=[self.messagesArray objectAtIndex:0];
    self.messagesArray=[listInfoObj valueForKey:MMI_REQUEST_PROP_ITEM];
}

-(NSString*)prepareMultiSelectionListString
{
    NSInteger totalItems=messagesArray.count;
    NSMutableSet *selectedIndicesSet=[[NSMutableSet alloc]init];
    NSArray *selectedIndicesArray;
    
    for (int i=0; i<totalItems; i++)
    {
        if([cellInfo containsObject:[NSIndexPath indexPathForRow:i inSection:0]])
        {
            [selectedIndicesSet addObject:[NSNumber numberWithInt:i]];
        }
    }
    selectedIndicesArray=selectedIndicesSet.allObjects;
    NSString *selectedIndicesString=[AppUtils getJsonFromDictionary:(NSDictionary*)selectedIndicesArray];
    return selectedIndicesString;
}
@end
