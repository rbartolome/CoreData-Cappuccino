//
//  AppController.j
//  AddressBook
//
//  Created by Raphael Bartolome on 30.12.09.
//
//*******************************************
//
//*****************************
//
// DatePicker source
// 
// Created by Randall Luecke.
// Copyright 2009, RCL Concepts.
// http://www.rclconcepts.com/
// http://www.timetableapp.com/
//
//*****************************

@import <Foundation/CPObject.j>
@import "ABContextController.j"
@import "DatePicker/DatePicker.j"
@import "EmailsController.j"

@implementation AppController : CPObject
{
	IBOutlet ABContextController addressBookContext;

	IBOutlet id emailsController;

	IBOutlet CPWindow mainWindow;
	IBOutlet CPView mainView;
	IBOutlet CPTableView tableView;
	
	IBOutlet CPButton addButton;
	IBOutlet CPButton deleteButton;
	
	IBOutlet CPTextField firstNameField;
	IBOutlet CPTextField lastNameField;
	IBOutlet DatePicker birthDateField;
	IBOutlet CPTextField phoneField;
	IBOutlet CPImageView imageView;
	
	CPManagedObject selectedAddress;
	
	CPFetchRequest allAddressFetchRequest;
}


- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
}


- (void)awakeFromCib
{
	[self setSelectedAddress:nil];
		
	//ui settings
	[mainWindow setFullBridge:YES];
	[[mainWindow contentView] setBackgroundColor:[CPColor colorWithHexString:@"A8C0D1"]];
	[mainView setBackgroundColor:[CPColor whiteColor]];

    var shadowView = [[CPShadowView alloc] initWithFrame:CGRectMakeZero()];
    [shadowView setAutoresizingMask: [mainView autoresizingMask]];
    [shadowView setFrameForContentFrame:[mainView frame]];
    [[mainWindow contentView] addSubview:shadowView];
    [[mainWindow contentView] addSubview:mainView];

	//register context changes notification
	[[CPNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(contextDidChange:)
											name:@"CPManagedObjectContextObjectsDidChangeNotification"
											object:nil];										

	
	//datepicker settings
	[birthDateField displayPreset:1];
	[birthDateField setDelegate:self];
	
	[firstNameField setDelegate:self];
	[lastNameField setDelegate:self];
	[phoneField setDelegate:self];
}


/*
 ************
 * UI Actions
 ************
 */
- (IBAction)addNewAddress:(id)sender
{
	var aAddress = [self addNewAddress];
}

- (IBAction)deleteSelectedAddress:(id)sender
{
	[self deleteAddress:selectedAddress];
	[self setSelectedAddress:nil];	
	[self reloadData];
}

- (IBAction)saveAction:(id)sender
{
	[[addressBookContext context] saveAll];
}

/*
 *****************
 * Address Methods
 *****************
 */
- (CPManagedObject) addNewAddress
{	
	var aAddress = [CPEntityDescription insertNewObjectForEntityForName:@"Address" 
												 inManagedObjectContext:[addressBookContext context]];
	return aAddress;
}

- (void) deleteAddress:(CPManagedObject) aAddress
{
	[[addressBookContext context] deleteObject:aAddress];
}

- (CPArray) addresses
{
	if(!allAddressFetchRequest)
	{
		var aEntity = [[[addressBookContext context] model] entityWithName:@"Address"];
		allAddressFetchRequest = [[CPFetchRequest alloc] initWithEntity:aEntity 
															predicate:nil
															sortDescriptors:nil 
															fetchLimit:0];
	}
	
	return [[addressBookContext context] executeFetchRequest:allAddressFetchRequest];
}

/*
 *******************
 * UI fields changes 
 *******************
 */
- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
	if([[aNotification object] isEqual:firstNameField])
		[selectedAddress setValue:[firstNameField stringValue] forKey:@"firstname"];
	else if([[aNotification object] isEqual:lastNameField])
		[selectedAddress setValue:[lastNameField stringValue] forKey:@"lastname"];
	else if([[aNotification object] isEqual:phoneField])
		[selectedAddress setValue:[CPNumber numberWithInt:[[phoneField stringValue] intValue]] forKey:@"phone"];
}


/*
 ***************************
 * Selected Address methods
 ***************************
 */
- (void)setSelectedAddress:(CPManagedObject) aAddress
{
	selectedAddress = aAddress;

	if(selectedAddress == nil)
	{
		[deleteButton setEnabled:NO];

		[firstNameField setStringValue:@""];
		[lastNameField setStringValue:@""];
		[phoneField setStringValue:@""];
		[birthDateField setDate:[CPDate date]];
	}
	else
	{

		[deleteButton setEnabled:YES];
		
		[firstNameField setStringValue:[selectedAddress valueForKey:@"firstname"]];
		[lastNameField setStringValue:[selectedAddress valueForKey:@"lastname"]];
		[phoneField setStringValue:[selectedAddress valueForKey:@"phone"]];
		
		if([aAddress valueForKey:@"dateOfBirth"] != nil)
			[birthDateField setDate:[aAddress valueForKey:@"dateOfBirth"]];
		else
			[birthDateField setDate:[CPDate date]];
	}
	
	[emailsController setAddress:selectedAddress];
}

- (CPManagedObject)selectedAddress
{
	return selectedAddress;
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
	return [[self addresses] count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(int)rowIndex
{
	var address = [[self addresses] objectAtIndex:rowIndex];

	if(address == nil || [[address valueForKey:@"firstname"] length] < 1|| [[address valueForKey:@"lastname"] length] < 1)
	{
		return "Untitled";
	}
	else
	{	
		return [address valueForKey:@"firstname"] + " " + [address valueForKey:@"lastname"];
	}
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
		[self setSelectedAddress:[[self addresses] objectAtIndex:selectedRow]];
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



/*
 **************************
 * CoreData context changes
 **************************
 */
- (void)contextDidChange:(CPNotification) notfication
{
	[self reloadData];
}


/*
 ******************************************
 * DatePicker for Birthday Delegate methods
 ******************************************
 */
-(void)datePickerDidChange:(id)sender
{
	[selectedAddress setValue:[birthDateField date] forKey:@"dateOfBirth"];	
}

@end
