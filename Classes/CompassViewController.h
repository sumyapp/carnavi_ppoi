//
//  CompassViewController.h
//  Compass
//
//  Created by Koichiro,Sumi on 09/10/22.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MyAnnotation.h"
#import "Reachability.h"
#import "CJSONDeserializer.h"

#define PI 3.14159265358979323846264338327950288
#define DRIVEMODE_KANKAKU 0.07
#define ACCURA_LEVEL 300
#define SETPIN 1
#define SETPREV 2
#define SETADDRESSBOOK 3

@class Reachability;


@interface CompassViewController : UIViewController <MKReverseGeocoderDelegate, CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation, UIActionSheetDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate> {
	CLLocationManager *locationManager;
    CLLocation *locationInfo;  
	
	float latitude1, latitude2;
	float longitude1, longitude2;
	float distance, dir;
	
	int getlocatecount;
	BOOL animationDidEnd;
	//map系
	IBOutlet MKMapView *mapview;
	
	MKReverseGeocoder *reverseGeocoder;
	MKPlacemark *placemark;
	IBOutlet UILabel *addressView;
	
	IBOutlet UIActivityIndicatorView *actv;
	
	BOOL geocoderWorking;

	IBOutlet UIToolbar *toolbar;
	BOOL restartButtonIconStart;
	
	//フルスクリーンモード用
	IBOutlet UIButton *backButton;
	//検索用
	IBOutlet UISearchBar *LocationSearchBar;
	
	//地点検索関連
	NSString *tempString;
	NSMutableDictionary *xmlDict;
	
	BOOL addressLineFound;
	BOOL localityNameFound;
	BOOL administrativeAreaNameFound;
	BOOL serchLocationFound;
	
	MyAnnotation *targetAnnotation;
	MyAnnotation *selectAnnotation;
	
	//目的地表示に使用するIBOutlet
	int nowDirection;
	IBOutlet UIImageView *arrow;
	IBOutlet UILabel *targetDist;
	//- (void)addAnnotation:で、現在地から一番近いAnnotationを計算、保存しておく。
	float nearAnnotationDist;
	MyAnnotation *nearAnnotation;
	int alertNum;
	
	//言語環境などのため
	BOOL mileUse;
	BOOL inJp;
	
	//アニメーションの制御のため
	BOOL rotateNow;	

	//任意の地点にピンを刺す用
	BOOL setPinAnnotationStartPmGet;
	
	IBOutlet UIButton *setPinForCenterLocationButton;
	
	BOOL mapviewRottateBegin;
	BOOL viewDidLoadEnd;
	
	NSString *searchText;
}
- (IBAction)backButtonPress;
- (IBAction)searchButtonPress;
- (IBAction)restartButtonPress;
- (IBAction)peraButtonPress;
- (IBAction)trashButtonPress;
- (IBAction)refreshButtonPush;
- (IBAction)setPinForCenterLocation;

- (void)startNavi;
- (void)stopNavi;
- (void)pmGet;

- (float)azimuthCalc:(float)la1
	   longtitude1:(float)lo1
		 latitude2:(float)la2
	   longtitude2:(float)lo2;
- (float)distanceCalc:(float)la1
		  longtitude1:(float)lo1
			latitude2:(float)la2
		  longtitude2:(float)lo2;
- (void)mapRotationAnimation:(int)rotateDir;

//地点検索関連
- (void)search:(NSString*)text;
- (void)searchDo;
- (void)searchDidEnd;

- (void)netAccessStart;
- (void)netAccessEnd;
- (void)addAnnotation:(CLLocationCoordinate2D)addLocationCoordinate
				title:(NSString*)addTitle
			 subtitle:(NSString*)addSubTitle;
//目的地との情報を表示するメソッド
- (void)setTargetInfo;
- (float)km_to_mi:(float)dist_km;
- (void)loadLocationData;
- (void)saveLocationData:(CLLocationCoordinate2D)addLocationCoordinate
				   title:(NSString*)addTitle
				subtitle:(NSString*)addSubTitle;

- (void)mapAndArrowRotationAnimation:(int)mapRotateDir
							arrowdir:(int)arrowRotateDir;
- (void)arrowRotationAnimation:(int)rotateDir;
- (BOOL)getNowAnimating;
- (void)setNowAnimating;
- (void)setNowAnimatingEnd;


@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;  
@property (nonatomic, retain) MKPlacemark *placemark;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *locationInfo;
@end