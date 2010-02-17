//
//  CPWebDAVRequest.j
//
//  Created by Raphael Bartolome on 04.12.09.
//
//	This code is inspired by August Mueller from Flying Meat Inc. (@ccgus)
//	http://code.google.com/p/flycode
//

@import <Foundation/Foundation.j>

@implementation CPWebDAVRequest : CPObject
{
	CPString _baseURL @accessors(property=baseURL);
}

+ (id)requestWithBaseURL:(CPString)baseURL
{
	var request = [[CPWebDAVRequest alloc] init];
	[request setBaseURL:baseURL];
	return request;
}


- (CPArray) contentsOfDirectoryAtPath:(CPString)aPath
{
	return [self _contentsOfDirectoryAtPath:aPath withDepth:1 extraToPropfind:nil];
}


- (void) writeFileWithDataContent:(CPData)aData toPath:(CPString)aPath 
{    
	[self writeFileWithStringContent:[aData string] toPath:aPath];
}

- (void) writeFileWithStringContent:(CPString)aString toPath:(CPString)aPath
{
	var url = [self _appendPathToBaseURL:aPath];    
    var urlRequest = [CPURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setValue:[CPString stringWithFormat:@"%d", [aString length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:[aString string]];
    [self _sendRequest:urlRequest];
}

- (void) deleteFileAtPath:(CPString)aPath 
{
	var url = [self _appendPathToBaseURL:aPath];    
    var urlRequest = [CPURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"DELETE"];
    [urlRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [self _sendRequest:urlRequest];   
}

- (void) createDirectoryAtPath:(CPString)aPath
{
	var url = [self _appendPathToBaseURL:aPath];    
    var urlRequest = [CPURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"MKCOL"];
    [urlRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
	[self _sendRequest:urlRequest];
}

- (CPData) contentOfFileAtPath:(CPString)aPath
{
	var url = [self _appendPathToBaseURL:aPath];    
    var urlRequest = [CPURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    return 	[self _sendRequest:urlRequest];
}



/*
 *	Private methods
 */
- (CPURL)_appendPathToBaseURL:(CPString) aPath
{
	var resultString = _baseURL;
	if((aPath == nil || ![[aPath substringToIndex:1] isEqualToString:@"/"]) 
			&& ![[_baseURL substringFromIndex:[_baseURL length]] isEqualToString:@"/"])
	{
		resultString = resultString + "/";
	}
	
	resultString = resultString + aPath;

	return [CPURL URLWithString:resultString];
}


- (CPArray)_contentsOfDirectoryAtPath:(CPString)aPath withDepth:(int)depth extraToPropfind:(CPString)extra 
{    
	var url = [self _appendPathToBaseURL:aPath];
	
    if (extra == nil) {
        extra = @"";
    }
    
    var urlRequest = [CPURLRequest requestWithURL:url];    
    // the trailing / always gets stripped off for some reason...
    var _uriLength = [[url path] length] + 1;
    
    [urlRequest setHTTPMethod:@"PROPFIND"];
    
    var xmlAsString = [CPString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<D:propfind xmlns:D=\"DAV:\"><D:allprop/>%@</D:propfind>", extra];
    
    if (depth > 1) {
        [urlRequest setValue:@"infinity" forHTTPHeaderField:@"Depth"];
    }
    else {
        [urlRequest setValue:[CPString stringWithFormat:@"%d", depth] forHTTPHeaderField:@"Depth"];
    }
    
    [urlRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPBody:[xmlAsString string]];
    
   	var result = [self _sendRequest:urlRequest];    
    return [self _parseDirectoryContentResponse:[result string]];
}


- (CPData) _sendRequest:(CPURLRequest)urlRequest 
{        
	var urlResponse;
	var responseData = [CPURLConnection sendSynchronousRequest: urlRequest returningResponse:urlResponse error:nil];    
	
	return responseData;
}


- (CPArray)_parseDirectoryContentResponse:(CPString) aResponseString
{
	var resultArray = [[CPMutableArray alloc] init];
	
    var XMLDocument = XMLDocumentFromString(aResponseString);
    var responses = XMLDocument.getElementsByTagNameNS("*", "response");
    var responseIndex = 0;
    var responseCount = responses.length;
  
    for (; responseIndex < responseCount; ++responseIndex)
    {
        var response = responses[responseIndex]; 
        var href = response.getElementsByTagNameNS("*", "href").item(0);

        [resultArray addObject:[href.firstChild.nodeValue lastPathComponent]];
    }

	return resultArray;
}



@end


var XMLDocumentFromString = function(anXMLString)
{//console.log(anXMLString);
    if (typeof window["ActiveXObject"] !== "undefined")
    {
        var XMLDocument = new ActiveXObject("Microsoft.XMLDOM");
 
        XMLDocument.async = false;
        XMLDocument.loadXML(anXMLString);
 
        return XMLDocument;
    }
 
    return new DOMParser().parseFromString(anXMLString,"text/xml");
}