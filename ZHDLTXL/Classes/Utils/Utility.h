//
//  Utility.h
//  LeheB
//
//  Created by zhangluyi on 11-5-4.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import "MBProgressHUD.h"

@interface Utility : NSObject {
    
}

+ (void)removeShadow:(UIView *)view;
+ (void)addShadowUp:(UIView *)view;
+ (void)addShadowByLayer:(UIView *)view;
+ (void)addShadow:(UIView *)view;
+ (void)addBorderColor:(UIView *)imageView;
+ (void)clearBorderColor:(UIView *)imageView;
+ (void)addRoundCornerToView:(UIView *)view;

+ (NSString *)codeOfString:(NSString*)string;
+ (BOOL)isNumberString:(NSString*)str;

+ (void)doAnimationFromLeft:(BOOL)leftDir
                   delegate:(id)_delegate 
                       view:(UIView *)_view 
                   duration:(CGFloat)duration;

+ (BOOL)isCharacterChinese:(unichar)ch;
char indexTitleOfString(unsigned short string);
+ (BOOL)isCharacter:(unichar)ch;
+ (CGFloat)getFloatRandom;
+ (NSInteger)getIntegerRandomWithInMax:(NSInteger)max;

+ (UIAlertView *)startWebViewMaskWithMessage:(NSString *)_message;

+ (void)disMissMaskView:(UIAlertView **)_alertView;

+ (NSMutableString *)URLStringMakeWithDict:(NSDictionary *)dict;

+ (void)setWebView:(UIWebView *)webView withId:(NSInteger)webId;

+ (void)changeNavigation:(UINavigationItem *)navItem Title:(NSString *)title;

+ (NSString *)descriptionForDateInterval:(NSString *)dateString;
+ (BOOL)isValidLatLon:(double)lat Lon:(double)lon;
+ (NSString*)getPhotoDownloadURL:(NSString*)currentURLString sizeType:(NSString*)sizetype;

+ (NSMutableDictionary *)datasourceFromListArray:(NSArray *)array;
+ (void)addRoundCornerToView:(UIView *)view radius:(NSInteger)radius borderColor:(UIColor *)color;
+ (void)addRoundCornerToView:(UIView *)view radius:(NSInteger)radius;
+ (void)addBorderView:(UIView *)view withColor:(UIColor *)color width:(CGFloat)width;
+ (NSString *)descriptionForDistance:(NSInteger)distance;

+ (double)distanceFromPoint:(GPoint)point1 toPoint:(GPoint)point2;

+ (NSString *)item:(NSString *)name descriptionWithCount:(NSInteger)count;

+ (NSString *)date:(NSDate *)date descriptorWithFormate:(NSString *)dateFormat;

+ (NSDictionary *)parseByDate:(NSDate *)date;
+ (NSDictionary *)intervalForDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (void)groupTableView:(UITableView *)_tableView changeBgForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

+ (void)plainTableView:(UITableView *)_tableView changeBgForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)getCityIdByCityName:(NSString *)cityName;
@end
