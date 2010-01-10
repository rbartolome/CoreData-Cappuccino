//
//  CPPropertyListReader_Vintage.j
//
//  Created by Raphael Bartolome on 20.11.09.
//

@import <Foundation/Foundation.j>

/*
	@public
		+ (CPDictionary)dictionaryForString:(CPString) aString
		+ (CPArray)arrayForString:(CPString) aString
*/

//Global definitions
var PLIST_ARRAY = 0;
var PLIST_DICTIONARY = 1;
var PLIST_DATA = 2;
var PLIST_STRING = 3;

var TOKEN_BEGIN = ['(', '{', '<', '"'];
var TOKEN_END = [')', '}', '>', '"'];
var QUOTING_CHARS = [':', '/', '-', '.', '\\'];

@implementation CPPropertyListReader_Vintage : CPObject
{
}


+ (CPDictionary)dictionaryForString:(CPString) aString
{
	var s = [CPPropertyListReader_Vintage _trimString:aString];
	if(!(s.charAt(0) == TOKEN_BEGIN[PLIST_DICTIONARY] && s.charAt(s.length-1) == TOKEN_END[PLIST_DICTIONARY]))
		return nil;

	var d = [[CPMutableDictionary alloc] init];
	var pos = 1;
	var parsing = YES;
	var key = nil;
	var valbegin = -1;

	while (pos < s.length) 
	{
		//find open token
		var c = s.charAt(pos);
		var tokenCount = 0;
		var kindOfToken = 0;
		
		var i = 0;
		for (i = 0 ; i < TOKEN_BEGIN.length ; i++) 
		{			
			if (c == TOKEN_BEGIN[i]) 
			{
		    	tokenCount = 1;
		        kindOfToken = i;
		        break;
		    }
		}

		if (tokenCount > 0) 
		{
			var quote = pos;
			do {	
				pos++
				
				if(pos > s.length)
					break;
					
				c = s.charAt(pos);

				if (c == '"' && kindOfToken == PLIST_STRING) 
				{
					if (pos > 0 && s.charAt(pos-1) != '\\')
					{
						tokenCount--;
					}
				} 
				else if (c == TOKEN_BEGIN[kindOfToken])
				{
					tokenCount++;
				}
				else if (c == TOKEN_END[kindOfToken])
				{
					tokenCount--;
				}					
			}while (tokenCount != 0);
			
			if (key == nil) 
			{					
				key = [CPPropertyListReader_Vintage propertyListFromString:s.substring(quote, pos+1)];
			} 
			else 
			{
				key = [CPPropertyListReader_Vintage _trimString:key];
				var aValue = [CPPropertyListReader_Vintage propertyListFromString:s.substring(quote, pos+1)];
				[d setObject:aValue forKey:key];
				key = nil;
			}
			
			valbegin = -1;
			//advance to the next position
			do {
				pos++;
				c = s.charAt(pos);
			} while (c == " ");				
		}			
		if (c == ';' || c == '=' || c == '}') 
		{
			if (valbegin > 0) 
			{
				if (key == nil) 
				{
					//need a trim						
					key = s.substring(valbegin, pos);
					key = [CPPropertyListReader_Vintage _trimString:key];
				} 
				else 
				{
					// need a trim
					var value = [CPPropertyListReader_Vintage _trimString:s.substring(valbegin, pos)];
					value = [CPPropertyListReader_Vintage valueForString:value];
					[d setObject:value forKey:key];
					key = nil;
				}
				valbegin = -1;
			}
		} 
		else if (c != ' ') 
		{
			if (valbegin < 0) 
			{
				valbegin = pos;
			}
		}
		pos++;
	}	

	return d;
}


+ (CPArray)arrayForString:(CPString) aString
{
	var s = [CPPropertyListReader_Vintage _trimString:aString];
	
	if(!(s.charAt(0) == TOKEN_BEGIN[PLIST_ARRAY] && s.charAt(s.length-1) == TOKEN_END[PLIST_ARRAY]))
		return nil;

	var a = [[CPMutableArray alloc] init];
	var pos = 1;
	var valbegin = -1;

	while (pos < s.length) 
	{
		//find open token
		var c = s.charAt(pos);
		var tokenCount = 0;
		var kindOfToken = 0;
		
		var i = 0;
		for (i = 0 ; i < TOKEN_BEGIN.length ; i++) 
		{			
			if (c == TOKEN_BEGIN[i]) 
			{
		    	tokenCount = 1;
		        kindOfToken = i;
		        break;
		    }
		}
		
		if (tokenCount > 0) 
		{
			var quote = pos;
			do {	
				pos++
				
				if(pos > s.length)
					break;
					
				c = s.charAt(pos);
			
				if (c == '"' && kindOfToken == PLIST_STRING) 
				{
					if (pos > 0 && s.charAt(pos-1) != '\\')
					{
						tokenCount--;
					}
				} 
				else if (c == TOKEN_BEGIN[kindOfToken])
				{
					tokenCount++;
				}
				else if (c == TOKEN_END[kindOfToken])
				{
					tokenCount--;
				}				
			}while (tokenCount != 0);
			
			[a addObject:([CPPropertyListReader_Vintage propertyListFromString:s.substring(quote, pos+1)])];
			valbegin = -1;
			//advance to the next position
			do {
				pos++;
				c = s.charAt(pos);
			} while (c == " ");				
		}
		//find the closing token
		
		if (c == "," || c == ")") 
		{
			if (valbegin > 0) 
			{
				var aValue = [CPPropertyListReader_Vintage _trimString:s.substring(valbegin, pos)];
				aValue = [CPPropertyListReader_Vintage valueForString:aValue];
		        [a addObject:aValue];
				valbegin = -1;
			}
		} 
		else if (c != " ") 
		{
			if (valbegin < 0) 
			{
				valbegin = pos;
			}
		}
		pos++;
	}	

	return a;
}

+ (CPData) dataFromPropertyList:(CPString) aString
{
	    var s = [CPPropertyListReader_Vintage _trimString:aString];
	
	    if (!(s.charAt(0) == TOKEN_BEGIN[PLIST_DATA] && s.charAt(s.length-1) == TOKEN_END[PLIST_DATA]))
	        return nil;
	
	return [CPData dataWithString:s.substring(1,s.length-1)];
}

+ (CPObject) propertyListFromString:(CPString) aString
{
	var s = [CPPropertyListReader_Vintage _trimString:aString];
	
	var type = -1;
	var i = 0;
	
	for (i = 0; i < TOKEN_BEGIN.length; i++) 
	{
		if (TOKEN_BEGIN[i] == s.charAt(0)) 
		{
			if (TOKEN_END[i] == s.charAt(s.length - 1))
			{	
				type = i;
			}
		}
	}
	
    switch (type) 
	{
		case PLIST_DATA:
			return [CPPropertyListReader_Vintage dataFromPropertyList:s];
		case PLIST_ARRAY:
			return [CPPropertyListReader_Vintage arrayForString:s];
		case PLIST_DICTIONARY:
			return [CPPropertyListReader_Vintage dictionaryForString:s];
		case PLIST_STRING:
			if (aString == "\"\"")
				return  "";

			return s.substring(1, s.length - 1);
    }

	
    return nil;
}

+ (CPObject)valueForString:(CPString) aString
{
	//	aString = aString.substring(1, aString.length - 1);
	if([[aString uppercaseString] isEqualToString:@"N"] || [[aString uppercaseString] isEqualToString:@"NO"] || [[aString uppercaseString] isEqualToString:@"FALSE"])
		return NO;
	else if([[aString uppercaseString] isEqualToString:@"Y"] || [[aString uppercaseString] isEqualToString:@"YES"] || [[aString uppercaseString] isEqualToString:@"TRUE"])
		return YES;
	
	return aString;
}


/*
 * replace this stuff later when we have NSCharacterSet ...
 */
+ (CPString)_trimString:(CPString) aString
{	
	if(aString.length > 0)
	{
		var s = aString.replace(/^\s*/, "").replace(/\s*$/, "");
		return s;
	}
	
	return aString;
}

@end