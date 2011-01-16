//
//  MyAnnotation.m
//  Compass
//
//  Created by sumy on 09/12/18.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate;  
@synthesize annotationTitle;  
@synthesize annotationSubtitle;  
   
- (NSString *)title {
	return annotationTitle;
}

- (NSString *)subtitle {
	return annotationSubtitle;
}  
- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord
						   title:(NSString *)annTitle subtitle:(NSString *)annSubtitle {  
	coordinate.latitude = coord.latitude;  
	coordinate.longitude = coord.longitude;
	
	if(annTitle != nil)
		self.annotationTitle = annTitle;
	
	if(annTitle != nil)
		self.annotationSubtitle = annSubtitle;  

	return self;
}

- (void) dealloc {  
	[annotationTitle release];  
	[annotationSubtitle release];
	[super dealloc];  
}
@end
