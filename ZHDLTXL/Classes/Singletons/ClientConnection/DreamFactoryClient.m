//
//  DreamFactoryClient.m
//  DreamFactory
//
//  Created by zhangluyi on 12-2-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import "DreamFactoryClient.h"
#import "AFJSONRequestOperation.h"

//NSString * const kAFGowallaBaseURLString = @"http://www.baolaitong.com:9101/BLYTCloud";
//NSString * const kAFGowallaBaseURLString = @"http://192.168.1.234:9101/BLYTCloud";
//NSString * const kAFGowallaBaseURLString = @"http://192.168.1.126:9080/BLYTCloud";

//NSString * const kAFGowallaBaseURLString = @"http://www.boracloud.com:9101/BLYTCloud";
NSString * const kAFGowallaBaseURLString = @"http://192.168.1.234:9101/BLZTCloud";

@implementation DreamFactoryClient

+ (DreamFactoryClient *)sharedClient {
    static DreamFactoryClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAFGowallaBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    return self;
}

+ (void)getWithURLParameters:(NSDictionary *)parameters 
                         success:(void (^)(NSDictionary *json))successBlock 
                         failure:(void (^)(NSError *error))failureBlock {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        //set main para
        
//        [mutableParameters setValue:[kAppDelegate uuid] forKey:@"uuid"];
//        [mutableParameters setValue:@"iphone" forKey:@"via"];
//        [mutableParameters setValue:kClientVersion forKey:@"version"];
        
        NSString *userid = [PersistenceHelper dataForKey:@"userid"];
        if ([userid isValid]) {
            [mutableParameters setValue:userid forKey:@"myuserid"];
        }
    }
    
    NSString *path = [mutableParameters objForKey:@"path"];
    if (![path isValid]) {
        path = @"/BLZTCloud";
    } else {
        path = [NSString stringWithFormat:@"/BLZTCloud/%@", path] ;
    }
    
    [mutableParameters removeObjectForKey:@"path"];
    
    [[DreamFactoryClient sharedClient] getPath:path parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id JSON) {        
        if (successBlock) {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                successBlock((NSDictionary *)JSON);
            }
            if ([JSON isKindOfClass:[NSString class]]) {
                successBlock((NSDictionary *)[JSON objectFromJSONString]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)postWithParameters:(NSDictionary *)parameters 
                     image:(UIImage *)image 
                   success:(void (^)(id))successBlock 
                   failure:(void (^)(void))failureBlock {
    
    NSData *imageData = nil;
    
    if (image) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
    }
    
    NSString *path = [parameters objForKey:@"path"];
    if (![path isValid]) {
        path = @"/BLZTCloud";
    } else {
        path = [NSString stringWithFormat:@"/BLZTCloud/%@", path] ;
    }
    NSMutableURLRequest *request = [[DreamFactoryClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"imgFile001" mimeType:@"image/jpeg"];
        
        [formData appendPartWithFormData:[[kAppDelegate uuid] dataUsingEncoding:NSUTF8StringEncoding] name:@"uuid"];
        [formData appendPartWithFormData:[@"iphone" dataUsingEncoding:NSUTF8StringEncoding] name:@"via"];
        [formData appendPartWithFormData:[kClientVersion dataUsingEncoding:NSUTF8StringEncoding] name:@"version"];
        
        NSString *myUid = [PersistenceHelper dataForKey:@"userid"];
        if ([myUid isValid]) {
            [formData appendPartWithFormData:[myUid dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
            [formData appendPartWithFormData:[myUid dataUsingEncoding:NSUTF8StringEncoding] name:@"myuserid"];
        }
        
        for (NSString *key in [parameters allKeys]) {
            [formData appendPartWithFormData:[[parameters objForKey:key] dataUsingEncoding:NSUTF8StringEncoding] name:key];            
        }
    }];
    
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSString class]]) {
            successBlock([responseObject objectFromJSONString]);
        } else {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    [operation start];
}

@end
