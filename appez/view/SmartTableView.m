//
//  SmartTableView.m
//  SampleXib
//
//  Created by Transility on 25/09/12.
//

#import "SmartTableView.h"

@implementation SmartTableView
@synthesize smartTableView;
@synthesize smartItemArray;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"SmartTableView->initwithFrame");
    }
    return self;
}

//- (void)dealloc {
//    [smartTableView release];
//    [super dealloc];
//}

#pragma 
#pragma mark-
#pragma 

#pragma mark - Table view data source

//This will determine the number of columns in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//This will determine the number of rows to be displayed in a particular column
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.smartItemArray.count;
}

//Method to customize the cell at a particular row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell...
    NSDictionary *cellDataDict=[smartItemArray objectAtIndex:indexPath.row];
	cell.textLabel.text =[cellDataDict valueForKey:@"element1"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
