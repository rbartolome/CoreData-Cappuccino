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
// DatePicker source by
// 
// Created by Randall Luecke.
// Copyright 2009, RCL Concepts.
// http://www.rclconcepts.com/
// http://www.timetableapp.com/
//
//*****************************

@import <Foundation/CPObject.j>
@import "ABContextController.j"
@import "DatePicker.j"

@implementation AppController : CPObject
{
	IBOutlet ABContextController addressBookContext;

    IBOutlet CPWindow mainWindow;
	IBOutlet CPView mainView;
	IBOutlet CPTableView tableView;
	
	IBOutlet CPButton addButton;
	IBOutlet CPButton deleteButton;
	
	IBOutlet CPTextField firstNameField;
	IBOutlet CPTextField lastNameField;
	IBOutlet DatePicker birthDateField;
	IBOutlet CPTextField emailField;
	IBOutlet CPTextField phoneField;
	IBOutlet CPImageView imageView;
	
	CPDObject selectedAddress;
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
											name:@"CPDObjectContextObjectsDidChangeNotification"
											object:nil];										

	
	//datepicker settings
	[birthDateField displayPreset:1];
	[birthDateField setDelegate:self];
	
	//observe changes from user interface
	[firstNameField addObserver:self forKeyPath:@"objectValue" options:(CPKeyValueObservingOptionNew) context:nil];
	[lastNameField addObserver:self forKeyPath:@"objectValue" options:(CPKeyValueObservingOptionNew) context:nil]; 
	[emailField addObserver:self forKeyPath:@"objectValue" options:(CPKeyValueObservingOptionNew) context:nil];
	[phoneField addObserver:self forKeyPath:@"objectValue" options:(CPKeyValueObservingOptionNew) context:nil];

}


/*
 ************
 * UI Actions
 ************
 */
- (IBAction)addNewAddress:(id)sender
{
	[addressBookContext addNewAddress];
}

- (IBAction)deleteSelectedAddress:(id)sender
{
	[addressBookContext deleteAddress:selectedAddress];
	[self setSelectedAddress:nil];	
	[self reloadData];
}


/*
 ****************************
 * UI fields changes Observer
 ****************************
 */
- (void)observeValueForKeyPath:(CPString)aKeyPath
                      ofObject:(id)anObject
                        change:(CPDictionary)aChange
                       context:(id)aContext
{
	if([anObject isEqual:firstNameField])
	{
		[selectedAddress setValue:[firstNameField stringValue] forKey:@"firstname"];
	}
	else if([anObject isEqual:lastNameField])
	{
		[selectedAddress setValue:[lastNameField stringValue] forKey:@"lastname"];
	}	
	else if([anObject isEqual:emailField])
	{
		[selectedAddress setValue:[emailField stringValue] forKey:@"email"];
	}	
	else if([anObject isEqual:phoneField])
	{
		[selectedAddress setValue:[CPNumber numberWithInt:[[phoneField stringValue] intValue]] forKey:@"phone"];
	}	
}


/*
 ***************************
 * Selected Address methods
 ***************************
 */
- (void)setSelectedAddress:(CPDObject) aAddress
{
	selectedAddress = aAddress;

	if(selectedAddress == nil)
	{
		[deleteButton setEnabled:NO];

		[firstNameField setStringValue:@""];
		[lastNameField setStringValue:@""];
		[emailField setStringValue:@""];
		[phoneField setStringValue:@""];
		[birthDateField setDate:[CPDate date]];
	}
	else
	{
		[deleteButton setEnabled:YES];
		
		[firstNameField setStringValue:[selectedAddress valueForKey:@"firstname"]];
		[lastNameField setStringValue:[selectedAddress valueForKey:@"lastname"]];
		[emailField setStringValue:[selectedAddress valueForKey:@"email"]];
		[phoneField setStringValue:[selectedAddress valueForKey:@"phone"]];
//		[birthDateField setDate:[aAddress valueForKey:@"dateOfBirth"]];
	}
}

- (CPDObject)selectedAddress
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
	return [[addressBookContext addresses] count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(int)rowIndex
{
	var address = [[addressBookContext addresses] objectAtIndex:rowIndex];
	
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
		[self setSelectedAddress:[[addressBookContext addresses] objectAtIndex:selectedRow]];
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
	CPLog.info(@"Value from cpdobject: " + [selectedAddress valueForKey:@"dateOfBirth"]);
}

@end
