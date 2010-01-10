[xcode-template]: http://github.com/rbartolome/xcode-cappuccino

## How to use CoreData for Cappuccino ##
****************************************
Just copy the CoreData folder to your Project Frameworks folder and import the Framework in you Application Delegate file.

	#import <CoreData/CoreData.j>  

## Cappuccino Data Model ##
***************************

### 1. Supported Data Model Formats ####
- CoreData - *.xcdatamodel (Cocoa Model File Format)
- EOModel - *.eomodeld (WebObjects Model File Format)

### 2. How to load a Data Model ####
The Data Model file must be stored in your Project `Resources` folder.

CoreData:

	var model = [CPDObjectModel objectModelWithModelNamed:@"YourModelFile.xcdatamodel" bundle:nil];

EOModel:

	var model = [CPDObjectModel objectModelWithModelNamed:@"YourModelFile.eomodeld" bundle:nil];
  
### 2. How to Compile and Convert a CoreData Model for Cappuccino ####
*This instruction is not necessary if you use the latest [Xcode Cappuccino Templates][xcode-template].*  
  

1. Your .xcdatamodel file location should be the Project Resources folder

2. Open a Terminal and switch to the Project Resources folder.

3. Compile the .xcdatamodel file with momc    

	`/Developer/usr/bin/momc source.xcdatamodel target.xcdatamodelc`  
  
	The compiled file suffix is .xcdatamodelc  

4. Transform the binary formatted file into xml   
	(I work on a binary parser for Cappuccino but until I am finish this step is necessary)  
	  
	`plutil -convert xml1 target.xcdatamodelc`