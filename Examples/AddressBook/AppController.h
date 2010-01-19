//
//  AppController.h
//  AddressBook
//
//  Created by Raphael Bartolome on 14.01.10.
//


@interface AppController : CPObject
{
	IBOutlet id addressBookContext;

	IBOutlet id emailsController;
	IBOutlet id mainWindow;
	IBOutlet id mainView;
	IBOutlet id tableView;
	
	IBOutlet id addButton;
	IBOutlet id deleteButton;
	
	IBOutlet id firstNameField;
	IBOutlet id lastNameField;
	IBOutlet id birthDateField;
	IBOutlet id phoneField;
	IBOutlet id imageView;
	
}

- (IBAction)addNewAddress:(id)sender;
- (IBAction)deleteSelectedAddress:(id)sender;

- (IBAction)saveAction:(id)sender;

@end