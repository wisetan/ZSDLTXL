//
//  ValueForKey.m
//  LeheV2
//
//  Created by zhangluyi on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ValueForKey.h"

@implementation NSDictionary(ValueForKey)

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
        ret = [self valueForKey:key];
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


- (id)objForKeyPath:(NSString *)key {
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
        ret = [self valueForKeyPath:key];
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

#pragma mark NSArray
@implementation NSArray(ValueForKey)
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
        ret = [self valueForKey:key];
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


- (id)objForKeyPath:(NSString *)key {
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
        ret = [self valueForKeyPath:key];
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
