//
//  Collect.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/23.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "Collect.h"

@implementation Collect

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
