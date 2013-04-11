//
//  NSUserDefaults+objForKey.m
//  LeheV2
//
//  Created by zhangluyi on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSUserDefaults+objForKey.h"

@implementation NSUserDefaults (NSUserDefaults_objForKey)

- (id)objForKey:(NSString *)key {

    id ret = nil;
	
	if ([self isKindOfClass:[NSArray class]])
	{
		if ([(NSArray*)self count]==1) {
			self = [(NSArray*)self objectAtIndex:0];
		}else {
			return nil;
		}
	}
    
    @try {
        ret = [self objectForKey:key];
    }
    @catch (NSException *exception) {
        ret = nil;
    }
    
    if (!ret || [(NSNull *)ret isEqual:[NSNull null]]) {
        return nil;
    } else {
        return ret;
    }
}

@end
