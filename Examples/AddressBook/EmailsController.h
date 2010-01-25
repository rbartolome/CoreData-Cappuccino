//
//  EmailsController.h
//  AddressBook
//
//  Created by Raphael Bartolome on 14.01.10.
//


@interface EmailsController : CPObject
{
	IBOutlet id appController;
	IBOutlet id tableView;
	IBOutlet id addButton;
	IBOutlet id removeButton;
	IBOutlet id textField;
	
	CPManagedObject address;
}

- (IBAction)addEmailAddress:(id)sender;
- (IBAction)remoteEmailAddress:(id)sender;

@end