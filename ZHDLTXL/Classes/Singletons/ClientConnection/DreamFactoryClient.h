//
//  DreamFactoryClient.h
//  DreamFactory
//
//  Created by zhangluyi on 12-2-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kAFGowallaBaseURLString;

@interface DreamFactoryClient : AFHTTPClient {
    
}

+ (DreamFactoryClient *)sharedClient;
+ (void)getWithURLParameters:(NSDictionary *)parameters
                         success:(void (^)(NSDictionary *json))successBlock
                         failure:(void (^)(NSError *error))failureBlock;

+ (void)postWithParameters:(NSDictionary *)parameters 
                     image:(UIImage *)image 
                   success:(void (^)(id))successBlock 
                   failure:(void (^)(void))failureBlock;

@end
