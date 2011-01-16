//
//  myConnection.m
//  navTest2
//DataList
//  Created by motohiro on 09/04/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "myConnection.h"


@implementation myConnection

-(void) connectionWithPathMethodPost: (NSString *) path
{
	NSArray *arr = [path componentsSeparatedByString:@"?"];
	NSURL* url = [NSURL URLWithString:[arr objectAtIndex:0]];
	NSString* content = [arr objectAtIndex:1];
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];

	[NSURLConnection connectionWithRequest:request delegate:self];
	
	[request release];
}

-(void) connectionWithPath: (NSString *) path
{
	NSURLRequest *request;
	request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
	mData = [[[NSMutableData alloc] init] retain];
}

-(void) connection:(NSURLConnection*) connection didReceiveData:(NSData *)partialData
{
	[mData appendData: partialData];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:mData ,@"data",nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_DID_FINISH_NOTIFICATION
														object:self
													  userInfo:dict];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:DID_FAIL_WITH_ERRO_NOTIFICATION
														object:self];
}
@end
