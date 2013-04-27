//
//  SMSRecord.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-27.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMSRecord : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * loginid;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * userid;

@end
