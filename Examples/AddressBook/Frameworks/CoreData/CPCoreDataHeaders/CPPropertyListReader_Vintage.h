//
//  CPPropertyListReader_Vintage.h
//
//  Created by Raphael Bartolome on 25.11.09.
//
// inspired by wotonomy
//

@interface CPPropertyListReader_Vintage : CPObject
{
}

+ (CPDictionary)dictionaryForString:(CPString) aString;
+ (CPArray)arrayForString:(CPString) aString;

@end