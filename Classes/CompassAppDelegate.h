//
//  CompassAppDelegate.h
//  Compass
//
//  Created by Koichiro,Sumi on 09/10/22.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompassViewController;

@interface CompassAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CompassViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CompassViewController *viewController;

@end

