//
//  AdView.m
//  Navi
//
//  Created by sumy on 10/09/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdView.h"


@implementation AdView
@synthesize currentViewController;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
	[self setBackgroundColor:[UIColor clearColor]];
	[self startAd:@"http://images.ad-maker.info/apps/carnavi.html"];
	//[self startAd:@"http://images.ad-maker.info/apps/dekamoji.html"];
    return self;
}

- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return @"a14b3399f40db99"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return currentViewController;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)startAd:(NSString*)url{
	NSString *admobPerString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://comion.jp/admob_per_carnavi.html"] encoding:NSUTF8StringEncoding error:nil];
	float admobPer = 1.0;
	if(admobPerString != nil){
		admobPer = [admobPerString floatValue];
	}
	
	//NSLog(@"AdmobPer: %f", admobPer);
	// 現在の日時を用いて乱数を初期化する
	//time(NULL)で現在の時刻が1970年1月1日午前0時0分0秒からの通算秒数で得られる。  
	srand(time(NULL));
	// 乱数を発生
	float randomFloat = (float)(rand() % 1000) / 1000.0;
	
	// わーい！！わーい！！
	//NSLog(@"randomFloat: %f", randomFloat);
	
	if(admobPer >= randomFloat){
		AdMobView *ad = [AdMobView requestAdWithDelegate:self]; // start a new ad request
		ad.frame = CGRectMake(0, 0, 320, 48); // set the frame, in this case at the bottom of the screen
		[self addSubview:ad]; // attach the ad to the view hierarchy; self.window is responsible for retaining the ad
	}
	else {	
		lwebview = [[YieldMakerView alloc]initWithFrame:CGRectMake(0,0,320,50)];
		[lwebview setController:self.currentViewController];
		[lwebview setUrl:url];
		[lwebview start];
	
		[lwebview setBackgroundColor:[UIColor clearColor]];
		[lwebview setOpaque:NO];
		[[lwebview webView] setBackgroundColor:[UIColor clearColor]];
		[[lwebview webView] setOpaque:NO];
		[lwebview setAlpha:0.0];
		
		[self addSubview:lwebview];
		
		
		//アニメーションの対象となるコンテキスト
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(startYieldAdReloadTimer)];
		[UIView setAnimationDelay:2.5];
		[UIView setAnimationDuration:0.3];
		//TODO: 
		[lwebview setAlpha:1.0];
		// アニメーション開始
		[UIView commitAnimations];
	}
}

- (void)startYieldAdReloadTimer{
	//NSLog(@"startYieldAdReloadTimer");
	yieldAdTimer = [NSTimer scheduledTimerWithTimeInterval:20.0				//	発生間隔(秒)
											 target:self				//	送信先オブジェクト
										   selector:@selector(reloadYieldAd:)	//	コールバック関数
										   userInfo:nil					//	パラメータ
											repeats:YES];				//	繰り返し
}


- (void)reloadYieldAd:(NSTimer*)timer{
	//NSLog(@"reloadYieldAd");
	if(lwebview==nil || [self alpha] == 0.0)
		return;
	
	//NSLog(@"reloading");	
	[lwebview start];
}

- (void)dealloc {
    [super dealloc];
}


@end
