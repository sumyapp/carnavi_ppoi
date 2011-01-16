//
//  myConnection.h
//  navTest2
//DataList
//  Created by motohiro on 09/04/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CONNECTION_DID_FINISH_NOTIFICATION @"connectionDidFinishNotification"
#define DID_FAIL_WITH_ERRO_NOTIFICATION    @"didFailWithErrorNotification"

@interface myConnection : NSObject {
	NSMutableData * mData;
}

-(void) connectionWithPath:(NSString*) path;
-(void) connectionWithPathMethodPost: (NSString *) path;
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse*)response;
-(void) connection:(NSURLConnection*) connection didReceiveData:(NSData*)partialData;
-(void) connectionDidFinishLoading:(NSURLConnection*) connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
