//
//  CompassViewController.m
//  Compass
//
//  Created by Koichiro,Sumi on 09/10/22.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CompassViewController.h"

@implementation CompassViewController

@synthesize reverseGeocoder;
@synthesize placemark;
@synthesize locationManager;
@synthesize locationInfo;
@synthesize coordinate;

- (IBAction)setPinForCenterLocation{
	setPinAnnotationStartPmGet = YES;	
	[self pmGet];
}

- (IBAction)searchButtonPress{
	[UIView beginAnimations:nil context:NULL];
	LocationSearchBar.alpha  = 1.0;
	[UIView commitAnimations];
	[LocationSearchBar becomeFirstResponder];
}

- (IBAction)backButtonPress{
	/*if (restartButtonIconStart == YES) {
		[[ UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	}
	 */
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2f){
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	}
	else{
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	}
	
	[UIView beginAnimations:nil context:NULL];
	toolbar.alpha  = 1.0;
	addressView.alpha = 1.0;
	[UIView commitAnimations];
}
- (IBAction)trashButtonPress{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2f){
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	}
	else{
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	}
	[UIView beginAnimations:nil context:NULL];
	toolbar.alpha  = 0.0;
	addressView.alpha = 0.0;
	[UIView commitAnimations];
	return;
}
- (IBAction)restartButtonPress{
	if(restartButtonIconStart){
		[self startNavi];

		setPinForCenterLocationButton.hidden = YES;
		restartButtonIconStart = NO;
		//ToolBarに登録されているアイテムのidが入ったNSArrayをうけとり（COPY）、
		//NSMutableArrayを生成している。これはNSArrayがものすごく低機能な為。
		NSMutableArray *tmpItemListToolbarButtons = [[NSMutableArray alloc] initWithArray:[toolbar items]];
		//新しくUIBarbuttonItemのインスタンスを作る
		UIBarButtonItem *tmpButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(restartButtonPress)];
		//UIBarButtonItem *tmpButton  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
		tmpButton.style = UIBarButtonItemStyleBordered;
		//配列の左から三番目のオブジェクトを差し替える
		[tmpItemListToolbarButtons replaceObjectAtIndex:0 withObject:tmpButton];
		//こうして出来たToolBar itemsを再度ToolBarに代入してやる
		[toolbar setItems:tmpItemListToolbarButtons animated:YES];
		[self pmGet];
		[tmpButton release];
		[tmpItemListToolbarButtons release];
	}
	else {
		[self stopNavi];
		setPinForCenterLocationButton.hidden = NO;
		restartButtonIconStart = YES;
		//ToolBarに登録されているアイテムのidが入ったNSArrayをうけとり（COPY）、
		//NSMutableArrayを生成している。これはNSArrayがものすごく低機能な為。
		NSMutableArray *tmpItemListToolbarButtons = [[NSMutableArray alloc] initWithArray:[toolbar items]];
		//新しくUIBarbuttonItemのインスタンスを作る
		UIBarButtonItem *tmpButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(restartButtonPress)];
		//UIBarButtonItem *tmpButton  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
		tmpButton.style = UIBarButtonItemStyleBordered;
		//配列の左から三番目のオブジェクトを差し替える
		[tmpItemListToolbarButtons replaceObjectAtIndex:0 withObject:tmpButton];
		//こうして出来たToolBar itemsを再度ToolBarに代入してやる
		[toolbar setItems:tmpItemListToolbarButtons animated:YES];
		[tmpButton release];
		[tmpItemListToolbarButtons release];
	}

}
- (IBAction)refreshButtonPush{
	[self pmGet];
}
- (void)startNavi{
	//[[ UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	geocoderWorking = NO;
	BOOL locationServicesEnabled;
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];

	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f){
		//LOG(@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]);
		locationServicesEnabled = [CLLocationManager locationServicesEnabled];
	}
	else{
		locationServicesEnabled = self.locationManager.locationServicesEnabled;
	}
	
    if (locationServicesEnabled) {  
		locationManager.delegate = self;  
		locationManager.distanceFilter = kCLDistanceFilterNone;  
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;  
		[locationManager startUpdatingLocation];  
	}
	else {
		addressView.text = @"error";
         // error message...  
	}
}
- (void)stopNavi{
	//[[ UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[locationManager stopUpdatingLocation];
	
	latitude1 = 0;
	latitude2 = 0;
	longitude1 = 0;
	longitude2 = 0;
	distance = 0;
	dir = 0;
	
	getlocatecount = 0;
	
	if(geocoderWorking == YES){
		[reverseGeocoder cancel];
		[actv stopAnimating];
		geocoderWorking = NO;
	}
	else {
		[actv stopAnimating];
	}
}
- (void)pmGet{
	if (geocoderWorking == YES) {
		return;
	}
	//LOG(@"pm_get_start");
	[actv startAnimating];
	
	geocoderWorking = YES;
	//[self netAccessStart];
	if (setPinAnnotationStartPmGet) {
		self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:mapview.centerCoordinate] autorelease];
	}
	else {
		self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:self.locationInfo.coordinate] autorelease];  
	}

	reverseGeocoder.delegate = self;  
	[reverseGeocoder start];		
}
- (IBAction)peraButtonPress{
	if(inJp){
		UIActionSheet*  sheet;
		sheet = [[UIActionSheet alloc] 
				 initWithTitle:@"マップの種類変更" 
				 delegate:self 
				 cancelButtonTitle:@"Cancel" 
				 destructiveButtonTitle:nil 
				 otherButtonTitles:@"マップ", @"地図＋写真", @"sumyapp applist", nil];
		[sheet autorelease];
		
		// アクションシートを表示する
		[sheet showInView:self.view];		
	}
	else {
    UIActionSheet*  sheet;
    sheet = [[UIActionSheet alloc] 
			 initWithTitle:@"Select Map Type" 
			 delegate:self 
			 cancelButtonTitle:@"Cancel" 
			 destructiveButtonTitle:nil 
			 otherButtonTitles:@"Map", @"Map+Satellite", @"sumyapp applist", nil];
    [sheet autorelease];
	
    // アクションシートを表示する
    [sheet showInView:self.view];
	}
}
- (void)resetButtonPress{
	latitude1 = 0;
	latitude2 = 0;
	longitude1 = 0;
	longitude2 = 0;
	distance = 0;
	dir = 0;
	
//	getlocatecount = 0;
}
- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex > 2) {
        return;
    }
	// ボタンインデックスをチェックする)
	switch (buttonIndex) {
		case 0:
			mapview.mapType = MKMapTypeStandard;
			break;
		case 1:
			mapview.mapType = MKMapTypeHybrid;
			break;
		case 2:
			[[UIApplication sharedApplication] openURL:
			 [NSURL URLWithString:@"http://redirect.sumyapp.com/applist/"]];
			break;
		default:
			mapview.mapType = MKMapTypeStandard;
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{	
	//LOG([newLocation description]);
	self.locationInfo = newLocation;
	//ここからマップ関連
	//CLLocationCoordinate2D coordinate2 = newLocation.coordinate;
	// 取得した座標を中心に地図を表示
	//[mapview setCenterCoordinate:newLocation.coordinate animated:YES];
	// 縮尺を設定
	if(mapview.showsUserLocation == NO){
		MKCoordinateRegion zoom = mapview.region;
		zoom.span.latitudeDelta = 0.007;
		zoom.span.longitudeDelta = 0.007;
		zoom.center = newLocation.coordinate;
		[mapview setRegion:zoom animated:YES];
		mapview.showsUserLocation = YES;
		[self pmGet];
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults boolForKey:@"prevLocation"]) {
			alertNum = SETPREV;
			UIAlertView*    alertView;
			alertView = [[UIAlertView alloc] initWithTitle:@"Load Destination?" message:nil
												  delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
			[alertView autorelease];
			[alertView show];
		}
	}
	else {
		[mapview setCenterCoordinate:newLocation.coordinate animated:YES];
	}

	//現在地の住所を調査

	//ここまで
	
	getlocatecount++;
	if(getlocatecount < 3 || newLocation.horizontalAccuracy < 0){
		return;
	}
	if(getlocatecount < 30 && newLocation.horizontalAccuracy > ACCURA_LEVEL) {
		return;
	}
	
	if(latitude1 == 0 && longitude1 == 0){
		latitude1 = newLocation.coordinate.latitude;
		longitude1 = newLocation.coordinate.longitude;
		latitude2 = latitude1;
		longitude2 = longitude1;
	}
	latitude2 = newLocation.coordinate.latitude;
	longitude2 = newLocation.coordinate.longitude;

	distance = [self distanceCalc:latitude1
					  longtitude1:longitude1
						latitude2:latitude2
					  longtitude2:longitude2];
	int tmp = 20;
	if(isnan(distance) != TRUE)
		tmp = tmp - (distance * 1000);
	if(tmp <= 0) {		
		mapviewRottateBegin = YES;
		dir = [self azimuthCalc:latitude1
					longtitude1:longitude1
					  latitude2:latitude2
					longtitude2:longitude2];
		if(targetAnnotation != nil){
			int tmp_dir;
			tmp_dir = [self azimuthCalc:self.locationInfo.coordinate.latitude
							longtitude1:self.locationInfo.coordinate.longitude
							  latitude2:targetAnnotation.coordinate.latitude
							longtitude2:targetAnnotation.coordinate.longitude];
			[self mapAndArrowRotationAnimation:dir arrowdir:dir - tmp_dir];
		}
		else {
			[self mapRotationAnimation:dir];
		}
		
	}
	//ドライブモード, リセット
	if(distance > DRIVEMODE_KANKAKU){
		[self resetButtonPress];
		if(targetAnnotation != nil){
			[self setTargetInfo];
		}
	}	
	
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	addressView.text = @"GPS can't be acquired";
}
- (float)azimuthCalc:(float)la1
	   longtitude1:(float)lo1
		 latitude2:(float)la2
	   longtitude2:(float)lo2
{
	float dirN0, dirE0;
	float x, y;
	y = cos(lo2*PI/180) * sin(la2*PI/180 - la1*PI/180);
	x = cos(lo1*PI/180) * sin(lo2*PI/180) - sin(lo1*PI/180) * cos(lo2*PI/180) * cos(la2*PI/180 - la1*PI/180);
	//	x = cos(lo2*PI/180) * sin(lo2*PI/180) - sin(la1*PI/180) * cos(lo2*PI/180) * cos(la2*PI/180 - la1*PI/180);
	dirE0=180*atan2(y, x)/PI; // 東向きが０度の方向
	if(dirE0<0){
		dirE0=dirE0+360; //0〜360 にする。
	}
	dirN0 = fmod((dirE0 + 90), 360);
	return dirN0;

}
- (float)distanceCalc:(float)la1
		  longtitude1:(float)lo1
			latitude2:(float)la2
		  longtitude2:(float)lo2
{
	int decimal = 10;
	float dist;
	float a, b, f, p1, p2, x, l, decimal_no;
	// 引数　$decimal は小数点以下の桁数
	la1 = la1*PI/180;lo1 = lo1*PI/180;
	la2 = la2*PI/180;lo2 = lo2*PI/180;
		
	a = 6378140;
	b = 6356755;
	f = (a-b)/a;
		
	p1 = atan((b/a)*tan(la1));
	p2 = atan((b/a)*tan(la2));
		
		
	x = acos( sin(p1)*sin(p2) + cos(p1)*cos(p2)*cos(lo1-lo2) );
	l = (f/8)*( (sin(x)-x)*pow((sin(p1) + sin(p2)),2)/pow(cos(x/2) ,2) - (sin(x)-x)*pow(sin(p1)-sin(p2),2)/pow(sin(x),2) );
		
	dist = a*(x+l);
	decimal_no=pow(10,decimal);
	dist = round(decimal_no*dist/1000)/decimal_no;
	return dist;	//km単位で距離を返す
}
//サーチ関連のプライベートメソッド
- (void)search:(NSString*)text{
	serchLocationFound = NO;
	searchText = [[NSString stringWithFormat:@"%@", text] retain];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSThread detachNewThreadSelector:@selector(searchDo)
							 toTarget:self withObject:self];
}
- (void)searchDo{
	NSAutoreleasePool* pool;
    pool = [[NSAutoreleasePool alloc]init];
	
	//LOG(@"searchDo:%@",searchText);
	
	NSString *request = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) [NSString stringWithFormat:@"http://maps.google.co.jp/maps/geo?q=%@&output=json", searchText], NULL, NULL, kCFStringEncodingUTF8);
	//request = [NSString stringWithFormat:@"http://maps.google.co.jp/maps/geo?q=%@&output=json", searchText];
	//NSString *urlString = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=test"], NULL, NULL, kCFStringEncodingUTF8);
	
	NSURL *url = [NSURL URLWithString:request];
	[request autorelease];
	
	NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *jsonDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	NSArray *jsonArray = [[[jsonDic objectForKey:@"Placemark"] retain] autorelease];
	//LOG(@"%@", [jsonDic description]);
	//LOG(@"%@", [jsonArray description]);
	
	for (NSDictionary *dic in jsonArray) {
		if([dic objectForKey:@"address"] != nil){
			if([dic objectForKey:@"Point"] != nil){
				serchLocationFound = YES;
				CLLocationCoordinate2D _location;
				_location.longitude =  [[[[dic objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue];
				_location.latitude = [[[[dic objectForKey:@"Point"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue];
				
				LOG(@"%@",[dic objectForKey:@"address"]);
				LOG(@"coordinates:%f",  _location.longitude, _location.latitude);
				[self addAnnotation:_location title:[dic objectForKey:@"address"] subtitle:nil];
			}
		}
	}

	
	[self performSelectorOnMainThread:@selector(searchDidEnd)
						   withObject:nil
						waitUntilDone:YES];
	
	[pool release];
    [NSThread exit];
}
	
- (void)searchDidEnd{
	LOG(@"searchDidEnd");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[UIView beginAnimations:nil context:NULL];
	LocationSearchBar.alpha = 0.0;
	[UIView commitAnimations];
	
	if (serchLocationFound == NO){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"not found." message:@"Sorry,\n Nothing was found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alert show];
		[alert release];		
	}
	else {
		[mapview setCenterCoordinate:nearAnnotation.coordinate animated:YES];
	}
}


//ここからサーチ関連のメソッド
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	//探す
	nearAnnotationDist = 0;
	nearAnnotation = nil;
	[self netAccessStart];
	[self search:searchBar.text];
	//隠す処理
	[searchBar resignFirstResponder];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:LocationSearchBar.text forKey:@"searchLocation"];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[searchBar resignFirstResponder];
	[UIView beginAnimations:nil context:NULL];
	LocationSearchBar.alpha = 0.0;
	[UIView commitAnimations];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:LocationSearchBar.text forKey:@"searchLocation"];
}

- (void)netAccessStart {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// ネットワークアクセスインジケータON（画面中央）
}
- (void)netAccessEnd {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[UIView beginAnimations:nil context:NULL];
	LocationSearchBar.alpha = 0.0;
	[UIView commitAnimations];
	// 画面中央の処理中インジケータ表示OFF
	if (serchLocationFound == NO){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"not found." message:@"Sorry,\n Nothing was found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alert show];
		[alert release];		
	}
	else {
		[mapview setCenterCoordinate:nearAnnotation.coordinate animated:YES];
	}

	serchLocationFound = NO;
}

- (void)addAnnotation:(CLLocationCoordinate2D)addLocationCoordinate
				title:(NSString*)addTitle
			 subtitle:(NSString*)addSubTitle;
{
	MyAnnotation *annotation;
	annotation = [[MyAnnotation alloc] initWithLocationCoordinate:addLocationCoordinate title:addTitle subtitle:addSubTitle];
	[mapview addAnnotation:annotation];
	
	//一番近いAnnotationを保存する
	float tmp = [self distanceCalc:self.locationInfo.coordinate.latitude
					   longtitude1:self.locationInfo.coordinate.longitude
						 latitude2:addLocationCoordinate.latitude
					   longtitude2:addLocationCoordinate.longitude];
	selectAnnotation = annotation;
	if (tmp < nearAnnotationDist || nearAnnotationDist == 0) {
		nearAnnotation = annotation;
		nearAnnotationDist = tmp;
	}
	
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id <MKAnnotation>)annotation
{
	// これがユーザの位置の場合は、単にnilを返す
	if ([annotation isKindOfClass:[MKUserLocation class]]){
		LOG(@"tttttttt");
		if(inJp){
			[(MKUserLocation*)annotation setTitle:@"現在地"];
		}
		/*
		MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
		//annotationView.image = [UIImage imageNamed:@"arrows.png"]; 
		//[annotationView setPinColor:MKPinAnnotationColorGreen];
		//[annotationView setCanShowCallout:YES];
		//[annotationView setAnimatesDrop:YES];
		//[annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
		
		UIImage *pinImage = [UIImage imageNamed:@"arrows.png"];
		[annotationView setImage:pinImage];
		
		annotationView.annotation = annotation;
		
		return annotationView;
		 */
	}
	// カスタム注釈を処理する
	if ([annotation isKindOfClass:[MyAnnotation class]]) {
		// まず、既存のピン注釈ビューをキューから取り出すことを試みる
		MKPinAnnotationView*	pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotation"];
		if (!pinView) {
			// 既存のピン注釈ビューが利用できない場合は、新しいビューを作成する 
			pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
													   reuseIdentifier:@"CustomPinAnnotation"] autorelease];
			pinView.pinColor = MKPinAnnotationColorRed;
			pinView.animatesDrop = YES;
			pinView.canShowCallout = YES;
			// 詳細ディスクロージャボタンをコールアウトに追加する
			UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
			//[rightButton addTarget:self action:@selector(myShowDetailsMethod:) forControlEvents:UIControlEventTouchUpInside];
			pinView.rightCalloutAccessoryView = rightButton;
		}
		else
			pinView.annotation = annotation;
		return pinView;
	}
	return nil;
}

- (void)mapView:(MKMapView*)mapView 
 annotationView:(MKAnnotationView*)view 
calloutAccessoryControlTapped:(UIControl*)control
{
    // アラートを表示する
	selectAnnotation = view.annotation;
	 
    UIAlertView*    alertView;
	alertNum = SETPIN;
	if(inJp){
		alertView = [[UIAlertView alloc] initWithTitle:view.annotation.title message:nil
										  delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"目的地に設定", @"このピンを削除", nil];
	}
	else {
		alertView = [[UIAlertView alloc] initWithTitle:view.annotation.title message:nil
											  delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Set Destination", @"Remove", nil];
	}

    [alertView autorelease];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if (alertNum == SETPIN) {
		switch (buttonIndex) {
			case 0:
				break;
			case 1:
				targetAnnotation = selectAnnotation;
				[self setTargetInfo];
				int tmp_dir = [self azimuthCalc:self.locationInfo.coordinate.latitude
									longtitude1:self.locationInfo.coordinate.longitude
									  latitude2:targetAnnotation.coordinate.latitude
									longtitude2:targetAnnotation.coordinate.longitude];
				[self arrowRotationAnimation:dir - tmp_dir];
				[self saveLocationData:targetAnnotation.coordinate title:targetAnnotation.title subtitle:targetAnnotation.subtitle];
				break;
			case 2:
				if(targetAnnotation == selectAnnotation){
					targetAnnotation = nil;
					arrow.hidden = YES;
					targetDist.hidden = YES;
					[defaults setBool:NO forKey:@"prevLocation"];
				}
				[mapview removeAnnotation:selectAnnotation];
				break;
			default:
				break;
		}
		selectAnnotation = nil;		
	}
	else if(alertNum == SETPREV){
		switch (buttonIndex) {
			case 0:
				[defaults setBool:NO forKey:@"prevLocation"];
				break;
			case 1:
				[self loadLocationData];
				targetAnnotation = selectAnnotation;
				int tmp_dir = [self azimuthCalc:self.locationInfo.coordinate.latitude
									longtitude1:self.locationInfo.coordinate.longitude
									  latitude2:targetAnnotation.coordinate.latitude
									longtitude2:targetAnnotation.coordinate.longitude];
				[self arrowRotationAnimation:dir - tmp_dir];
				[self setTargetInfo];
				break;
			default:
				break;
		}
	}
	else if(alertNum == SETADDRESSBOOK){
		LOG(@"%d", buttonIndex);
		if (buttonIndex == 1) {
			LOG(@"test");
			LocationSearchBar.text = alertView.title;
			[self dismissModalViewControllerAnimated:YES];
			nearAnnotationDist = 0;
			nearAnnotation = nil;
			[self netAccessStart];
			[self search:alertView.title];
			//隠す処理
			[LocationSearchBar resignFirstResponder];
		}

	}

}
//目的地との情報を表示するメソッド
- (void)setTargetInfo{
	if(targetAnnotation != nil){
		if(arrow.hidden = YES){
			arrow.hidden = NO;
			targetDist.hidden = NO;
		}
		
		if(mileUse){
			targetDist.text = [NSString stringWithFormat:@"%.1fmi", [self km_to_mi:[self distanceCalc:self.locationInfo.coordinate.latitude
																						  longtitude1:self.locationInfo.coordinate.longitude
																							latitude2:targetAnnotation.coordinate.latitude
																						  longtitude2:targetAnnotation.coordinate.longitude]]];	
		}
		else {	
			targetDist.text = [NSString stringWithFormat:@"%.1fkm", [self distanceCalc:self.locationInfo.coordinate.latitude
																		   longtitude1:self.locationInfo.coordinate.longitude
																			 latitude2:targetAnnotation.coordinate.latitude
																		   longtitude2:targetAnnotation.coordinate.longitude]];
		}
	}
	else {
		arrow.hidden = YES;
		targetDist.hidden = YES;
	}

}

- (float)km_to_mi:(float)dist_km
{
    return dist_km * 0.6214;
}
- (void)loadLocationData{	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	CLLocationCoordinate2D addLocationCoordinate;
	addLocationCoordinate.latitude = [defaults floatForKey:@"latitude"];
	addLocationCoordinate.longitude = [defaults floatForKey:@"longitude"];

	[self addAnnotation:addLocationCoordinate
				  title:[defaults stringForKey:@"annTitle"] 
			   subtitle:[defaults stringForKey:@"annSubtitle"]];

	//[mapview setCenterCoordinate:targetAnnotation.coordinate];
	MKCoordinateRegion zoom = mapview.region;
	zoom.span.latitudeDelta = 0.007;
	zoom.span.longitudeDelta = 0.007;
	zoom.center = addLocationCoordinate;
	[mapview setRegion:zoom animated:YES];
}
- (void)saveLocationData:(CLLocationCoordinate2D)addLocationCoordinate
				   title:(NSString*)addTitle
				subtitle:(NSString*)addSubTitle{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:@"prevLocation"];
	[defaults setFloat:addLocationCoordinate.latitude forKey:@"latitude"];
	[defaults setFloat:addLocationCoordinate.longitude forKey:@"longitude"];
	[defaults setObject:addTitle forKey:@"annTitle"];
	[defaults setObject:addSubTitle forKey:@"annSubtitle"];	
}
- (void)mapRotationAnimation:(int)rotateDir{
	if([self getNowAnimating]){
		return;
	}
	[self setNowAnimating];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setNowAnimatingEnd)];
	mapview.transform = CGAffineTransformMakeRotation((360 - rotateDir) * PI / 180.0f);
	[UIView commitAnimations];
}
- (void)mapAndArrowRotationAnimation:(int)mapRotateDir
							arrowdir:(int)arrowRotateDir{
	if([self getNowAnimating]){
		return;
	}
	[self setNowAnimating];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setNowAnimatingEnd)];
	mapview.transform = CGAffineTransformMakeRotation((360 - mapRotateDir) * PI / 180.0f);
	arrow.transform = CGAffineTransformMakeRotation((360 - arrowRotateDir) * PI / 180.0f);
	
	[UIView commitAnimations];
}
- (void)arrowRotationAnimation:(int)rotateDir {
	if([self getNowAnimating]){
		return;
	}
	[self setNowAnimating];                                                                             
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(setNowAnimatingEnd)];
	arrow.transform = CGAffineTransformMakeRotation((360 - rotateDir) * PI / 180.0f);	
	[UIView commitAnimations];
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray *languages = [NSLocale preferredLanguages];
	NSString *currentLocale = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	NSString *currentLanguage = [languages objectAtIndex:0];
	if([currentLocale isEqualToString:@"GB"] || [currentLocale isEqualToString:@"US"]){
		mileUse = YES;
	}
	else {
		mileUse = NO;
	}
	
	if ([currentLanguage isEqualToString:@"ja"]) {
		inJp = YES;
	}
	else {
		inJp = NO;
	}
	
	Reachability* hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
	NetworkStatus status = [hostReach currentReachabilityStatus];
	[hostReach release];
	if( status == NotReachable ) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSDictionary *infoDictionary = [bundle localizedInfoDictionary];
        NSString *appName = [[infoDictionary count] ? infoDictionary : [bundle infoDictionary] objectForKey:@"CFBundleDisplayName"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:NSLocalizedString(@"Internet connection is unavailable", nil)
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];	
        [alert release];
		[self stopNavi];
    }
	else {
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		LocationSearchBar.text = [defaults stringForKey:@"searchLocation"];
		[self startNavi];
	}
	viewDidLoadEnd = YES;
}

// プレースマークが取得できた場合の処理  
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder   
    didFindPlacemark:(MKPlacemark *)pm {
    // プレースマークの情報をセット
	if (setPinAnnotationStartPmGet) {
		MyAnnotation* setPinAnnotation = [[MyAnnotation alloc] initWithLocationCoordinate:mapview.centerCoordinate title:@"Location" subtitle:[pm title]];
		[mapview addAnnotation:setPinAnnotation];
		[setPinAnnotation release];
	}
	else {
		self.placemark = pm;
		mapview.userLocation.subtitle = [placemark title];
		addressView.text = [placemark title];
	}
	//フラグ
	geocoderWorking = NO;
	setPinAnnotationStartPmGet = NO;
	[actv stopAnimating];
}  
  
// プレースマークが取得できなかった場合の処理  
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder   
    didFailWithError:(NSError *)error {
	if (setPinAnnotationStartPmGet) {
		MyAnnotation* setPinAnnotation = [[MyAnnotation alloc] initWithLocationCoordinate:mapview.centerCoordinate title:@"Location" subtitle:nil];
		[mapview addAnnotation:setPinAnnotation];
		[setPinAnnotation release];
	}
	else {
		self.placemark = nil;
		addressView.text = @"Sorry, address search service unavailable";
	}
	geocoderWorking = NO;
	setPinAnnotationStartPmGet = NO;
	[actv stopAnimating];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	//LOG(@"2");
	[self setNowAnimating];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	//LOG(@"4");
	[self setNowAnimatingEnd];
	//LOG(@"-----------------");
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	//LOG(@"3");
	//if (tateOn == YES) {
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			mapview.frame = CGRectMake(-190, -120, 700, 700);
			[[[mapview subviews] objectAtIndex:1] setFrame:CGRectMake(195, 510, [[[mapview subviews] objectAtIndex:1] frame].size.width , [[[mapview subviews] objectAtIndex:1] frame].size.height)];
			backButton.frame = CGRectMake(5, 422, 33, 33);
			arrow.frame = CGRectMake(290, 0, 20, 40);
			targetDist.frame = CGRectMake(269, 34, 51, 21);
			setPinForCenterLocationButton.frame = CGRectMake(285, 381, 30, 30);
			actv.frame = CGRectMake(255, 440, 20, 20);
			addressView.hidden = YES;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			mapview.frame = CGRectMake(-190, -120, 700, 700);
			[[[mapview subviews] objectAtIndex:1] setFrame:CGRectMake(195, 510, [[[mapview subviews] objectAtIndex:1] frame].size.width , [[[mapview subviews] objectAtIndex:1] frame].size.height)];
			backButton.frame = CGRectMake(5, 422, 33, 33);
			arrow.frame = CGRectMake(290, 0, 20, 40);
			targetDist.frame = CGRectMake(269, 34, 51, 21);
			setPinForCenterLocationButton.frame = CGRectMake(285, 381, 30, 30);
			actv.frame = CGRectMake(255, 440, 20, 20);
			addressView.hidden = YES;
			break;
		default:
			mapview.frame = CGRectMake(-110, -150, 700, 700);
			[[[mapview subviews] objectAtIndex:1] setFrame:CGRectMake(120, 380, [[[mapview subviews] objectAtIndex:1] frame].size.width , [[[mapview subviews] objectAtIndex:1] frame].size.height)];
			backButton.frame = CGRectMake(6, 262, 33, 33);
			arrow.frame = CGRectMake(450, 0, 20, 40);
			targetDist.frame = CGRectMake(429, 34, 51, 21);
			setPinForCenterLocationButton.frame = CGRectMake(445, 221, 30, 30);
			actv.frame = CGRectMake(415, 280, 20, 20);
			addressView.hidden = NO;
			break;
	}
	//}
/*
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			mapview.frame = CGRectMake(-190, -120, 700, 700);
			backButton.frame = CGRectMake(5, 422, 33, 33);
			arrow.frame = CGRectMake(290, 0, 20, 40);
			targetDist.frame = CGRectMake(269, 34, 51, 21);
			addressView.hidden = YES;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			mapview.frame = CGRectMake(-190, -120, 700, 700);
			backButton.frame = CGRectMake(5, 422, 33, 33);
			arrow.frame = CGRectMake(290, 0, 20, 40);
			targetDist.frame = CGRectMake(269, 34, 51, 21);
			addressView.hidden = YES;
			break;
		default:
			mapview.frame = CGRectMake(-110, -150, 700, 700);
			backButton.frame = CGRectMake(6, 262, 33, 33);
			arrow.frame = CGRectMake(450, 0, 20, 40);
			targetDist.frame = CGRectMake(429, 34, 51, 21);
			addressView.hidden = NO;
			break;
	}
 */
}
- (BOOL)getNowAnimating{
	//LOG(@"getNowAnimating");
	return rotateNow;
}
- (void)setNowAnimating{
	//LOG(@"setNowAnimatingStart");
	rotateNow = YES;
}
- (void)setNowAnimatingEnd{
	//LOG(@"setNowAnimatingEnd");
	rotateNow = NO;
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *) searchBar{
	//	LOG(@"test");
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	//[picker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonAddressCityKey]]];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person{
	//	self.title = [self getName:person];
	return YES;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property
							  identifier:(ABMultiValueIdentifier)identifier{
	int propertyType = ABPersonGetTypeOfProperty(property);
	if(propertyType == kABMultiDictionaryPropertyType){
		NSDictionary *items = [[(NSArray *)ABMultiValueCopyArrayOfAllValues((id)ABRecordCopyValue(person, property)) objectAtIndex:identifier] retain];
		NSString *tmp = [NSString stringWithFormat:@""];
		if([items objectForKey:@"State"] != nil){
			tmp = [NSString stringWithFormat:@"%@", [items objectForKey:@"State"]];
		}
		if ([items objectForKey:@"City"] != nil) {
			if (tmp != nil) {
				tmp = [NSString stringWithFormat:@"%@ %@", tmp, [items objectForKey:@"City"]];
			}
			else {
				tmp = [NSString stringWithFormat:@"%@", [items objectForKey:@"City"]];
			}			
		}
		if ([items objectForKey:@"Street"] != nil) {
			if(tmp != nil){
				tmp = [NSString stringWithFormat:@"%@ %@", tmp, [items objectForKey:@"Street"]];
			}
			else {
				tmp = [NSString stringWithFormat:@"%@", [items objectForKey:@"Street"]];
			}

		}
		
		[items release];

		//NSString *tmp = [NSString stringWithFormat:@"%@ %@ %@", [items objectForKey:@"State"], [items objectForKey:@"City"], [items objectForKey:@"Street"]];
		alertNum = SETADDRESSBOOK;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tmp
														message:@"Do you search by this information?"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Search", nil];
		[alert show];	
		[alert release];
		//[items release];
	}
	
	return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//LOG(@"1");
	//if([self getNowAnimating] == YES || restartButtonIconStart == NO){
	//	return NO;
	//}
	/*
	if (tateOn == YES) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
	else {
		return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);	
	}
	 */
	if(viewDidLoadEnd == NO){
		return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	}
	//if (restartButtonIconStart == YES && toolbar.alpha > 0) {
	//	return YES;
	//}
	else if(mapviewRottateBegin == NO && toolbar.alpha > 0) {
		return YES;
	}
	else {
		return NO;
	}

}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[locationManager stopUpdatingLocation];  
	self.locationManager = nil;
	self.locationInfo = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end