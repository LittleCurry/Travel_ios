//
//  Tourist.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "Tourist.h"

@implementation Tourist

- (instancetype) initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id) valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
