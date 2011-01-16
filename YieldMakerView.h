//
//  YieldMakerView.h
//  RealYieldTest
//
//  Created by macbook on 10-5-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YieldMakerView : UIWebView <UIWebViewDelegate> {
	UIWebView *webView;
	UIViewController *uc;
	NSString *tempurl;
	
}
@property(nonatomic,retain) UIViewController *uc;
@property(nonatomic,retain) NSString *tempurl;
@property(nonatomic,retain)  UIWebView *webView;
-(void)setController:(UIViewController *)vcontroller;
-(void)setUrl:(NSString *)surl;
-(void)start;
@end
