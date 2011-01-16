//
//  AdView.h
//  Navi
//
//  Created by sumy on 10/09/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YieldMakerView.h"
#import "AdMobView.h"
#import "AdMobDelegateProtocol.h"

@interface AdView : UIView<AdMobDelegate> {
	//adMaker
	YieldMakerView *lwebview;
	AdMobView *adMobAd;
	
	UIViewController *currentViewController;
	NSTimer *yieldAdTimer;
}
- (void)startAd:(NSString*)url;
- (void)startYieldAdReloadTimer;
- (void)reloadYieldAd:(NSTimer*)timer;

@property (nonatomic,assign) UIViewController *currentViewController;

@end
