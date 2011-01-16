#import <MapKit/MapKit.h>  

@interface MyAnnotation : NSObject <MKAnnotation> {  
	CLLocationCoordinate2D coordinate;  
	NSString *annotationTitle;  
	NSString *annotationSubtitle;  
}   
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;  
@property (nonatomic, retain) NSString *annotationSubtitle;  

- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord   
						   title:(NSString *)annTitle subtitle:(NSString *)annSubtitle;  
- (NSString *)title;  
- (NSString *)subtitle;  
@end  