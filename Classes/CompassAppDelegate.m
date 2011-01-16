//
//  CompassAppDelegate.m
//  Compass
//
//  Created by Koichiro,Sumi on 09/10/22.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CompassAppDelegate.h"
#import "CompassViewController.h"

@implementation CompassAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
