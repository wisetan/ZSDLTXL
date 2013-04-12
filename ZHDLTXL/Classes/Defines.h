//
//  Defines.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#ifndef ZHDLTXL_Defines_h
#define ZHDLTXL_Defines_h


#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568 )

#define kClientVersion  [[[NSBundle mainBundle] infoDictionary] objForKey:@"CFBundleVersion"]
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define kErrorIcon @"ico_error_info.png"
#define kNetworkError  @"网络不给力啊"

//app API
#define kGetProAndCityData              @"getProAndCityData.json"
#define kGetInvestmentUserList          @"getInvestmentUserList.json"
#define kGetPharmacologyPicturelinkurl  @"getPharmacologyPicturelinkurl.json"


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define bgSkyBlueColor  RGBCOLOR(0,184,238)
#define bgGreyColor     RGBCOLOR(231,234,239)
#define kContentColor   RGBCOLOR(70, 70, 70)
#define kSubContentColor RGBCOLOR(98, 98, 98)

#define kContentBlueColor RGBCOLOR(20,100,170);
#define kContentGrayColor RGBCOLOR(200,200,200);

typedef struct
{
	double lat;
	double lon;
} GPoint;

#define GET_RETURNCODE(xx_json) \
[[xx_json objForKey:@"returnCode"] stringValue]

#define GET_RETURNMESSAGE(xx_json) \
[[xx_json objForKey:@"returnMess"] stringValue]

#define kCityChangedNotification @"CityChangedNotification"
#define kInvestmentUserListRefreshed @"investmentUserListRefreshed"

#endif
