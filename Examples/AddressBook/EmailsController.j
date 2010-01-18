//
//  EmailsController.j
//  AddressBook
//
//  Created by Raphael Bartolome on 14.01.10.
//

@import <Foundation/CPObject.j>

@implementation EmailsController : CPObject
{
	IBOutlet id appController;
	IBOutlet CPTableView tableView;
	IBOutlet CPButton addButton;
	IBOutlet id removeButton;
	IBOutlet CPTextField textField;
	
	CPDObject address;
	CPDObject selectedEmail @accessors(property=selectedEmail);
}

- (void)setAddress:(CPDObject)aAddress
{
	address = aAddress;
	[self reloadData];
}

- (CPArray)emails
{
	var result = [address valueForKey:@"emails"];
	if(result != nil)
		return [result allObjects];
	else
		return [CPArray new];
}

- (IBAction)addEmailAddress:(id)sender
{
	if([[textField stringValue] length] > 1)
	{
		var mail = [[address context] insertNewObjectForEntityNamed:@"EMail"];
		[mail setValue:[textField stringValue] forKey:@"mail"];
		[textField setStringValue:@""];
		[address addObject:mail toBothSideOfRelationship:@"emails"];
		[self reloadData];
	}
}

- (IBAction)remoteEmailAddress:(id)sender
{
	if(selectedEmail != nil)
	{
		[[address context] deleteObject:selectedEmail];
		[self reloadData];
	}
}


/*
 ************************
 * CPTableView DataSource
 ************************
 */
- (void)reloadData
{
	[tableView reloadData];
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	if(address == nil)
		return 0;
	else
		return [[address valueForKey:@"emails"] count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(int)rowIndex
{
	var mail = [[self emails] objectAtIndex:rowIndex];
	return [mail valueForKey:@"mail"];
}



/*
 **********************
 * CPTableView Delegate
 **********************
 */
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	var selectedRow = [[tableView selectedRowIndexes] firstIndex];
	
	if(selectedRow != -1)
	{
		[self setSelectedEmail:[[self emails] objectAtIndex:selectedRow]];
	}
	else
	{
		[self setSelectedAddress:nil];
	}
}

- (BOOL)selectionShouldChangeInTableView:(CPTableView)aTableView
{
	return YES;
}

@end