//
//  MKMapView+MapViewUtil_h.h
//  ZXCXBlyt
//
//  Created by zly on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
- (CLLocationCoordinate2D)coordFromFramePoint:(CGPoint)point;

- (double)radius;
- (NSString *)radiusString;
- (NSString *)viewCenterLatString;
- (NSString *)viewCenterLonString;
- (NSString *)lastCorrectLonString;
- (NSString *)lastCorrectLatString;

@end
