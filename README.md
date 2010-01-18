[xcode-template]: http://github.com/rbartolome/xcode-cappuccino

# How to use CoreData for Cappuccino #
Just copy the CoreData folder to your Project Frameworks folder and import the Framework in you Application Delegate file.

	#import <CoreData/CoreData.j>  

# Data Model #

## 1. Supported Data Model Formats ##
- CoreData - *.xcdatamodel (Cocoa Model File Format)
- EOModel - *.eomodeld (WebObjects Model File Format)

## 2. How to load a Data Model ##
The Data Model file must be stored in your Project `Resources` folder.

CoreData:

	var model = [CPDObjectModel objectModelWithModelNamed:@"YourModelFile.xcdatamodel" bundle:nil];

EOModel:

	var model = [CPDObjectModel objectModelWithModelNamed:@"YourModelFile.eomodeld" bundle:nil];
  
## 3. How to Compile and Convert a CoreData Model for Cappuccino ##
*This instruction is not necessary if you use the latest [Xcode Cappuccino Templates][xcode-template].*  
  

1. Your .xcdatamodel file location should be the Project Resources folder

2. Open a Terminal and switch to the Project Resources folder.

3. Compile the .xcdatamodel file with momc    

	`/Developer/usr/bin/momc source.xcdatamodel target.cxcdatamodel`  
  
	The compiled file suffix is .cxcdatamodel

4. Transform the binary formatted file into xml   
	(I work on a binary parser for Cappuccino but until I am finish this step is necessary)  
	  
	`plutil -convert xml1 target.cxcdatamodel`
	
	
# Persistant Store #

## 1. Available stores ##
### CPDWebDAVStore ###
**Configuration Dictionary:**

1. 	*Key:* CPDWebDAVStoreConfigurationKeyBaseURL  
	*Object:* is the base URL for exp.: `@"http://localhost:8080"`  
	
2. 	*Key:* CPDWebDAVStoreConfigurationKeyFilePath  
	*Object:*  file path/name.suffix exp.: `@"addressbook.json"`
	
3. 	*Key:* CPDWebDAVStoreConfigurationKeyFileFormat  
	*Object:* The format of your store exp.:  
	`CPDSerializationJSONFormat || CPDSerializationXMLFormat || CPDSerialization280NPLISTFormat`

**Implementation:**
You can see a demo for this in the Addressbook Example ABContextController.j Class.

	- (id) initWithContext
	{
		if(self = [super init])
		{
			//load your model file
			model = [CPDObjectModel objectModelWithModelNamed:@"AddressBook.xcdatamodel" bundle:nil];
			//init the context with your configuration dictionary
			context = [[CPDObjectContext alloc] initWithObjectModel: model 
													  storeType: [CPDWebDAVStoreType class] 
											 storeConfiguration: [ABContextController webDAVConfig]];
																				 	
		}
	
		return self;
	}

	+ (CPDictionary) webDAVConfig
	{
		var result = [[CPMutableDictionary alloc] init];

		[result setObject:@"http://localhost:8080" forKey:CPDWebDAVStoreConfigurationKeyBaseURL];
		[result setObject:@"addressbook.json" forKey:CPDWebDAVStoreConfigurationKeyFilePath];
		[result setObject:CPDSerializationJSONFormat forKey:CPDWebDAVStoreConfigurationKeyFileFormat];

		return result
	}

**Using the Addressbook Application Example:**  
If you have no WebDAV Server running I recommend [jack-dav](http://github.com/tlrobinson/jack-dav) for Testing.
The Example work also without a server, in this case the data will store in memory

**Notes:**  
Currently accessing a user/password protected webdav is not supported, If you know how, please write me a mail.

### CPDWOStore ###
*!!! Currently not up-to-date with the latest implementation, I work on a update for both client and server side !!!*

## 2. Write your own Persistant Store ##
