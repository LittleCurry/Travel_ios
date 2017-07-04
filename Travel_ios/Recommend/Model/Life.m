//
//  Life.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/26.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "Life.h"

@implementation Life

- (instancetype) initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        
        if (![[dic objectForKey:@"imgs"] isKindOfClass:[NSNull class]]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in [dic objectForKey:@"imgs"]) {
//                CutTime *cutTime = [[CutTime alloc] initWithDictionary:dict];
                [tempArr addObject:dic];
            }
            if (self.imgs == nil) {
                self.imgs = [NSMutableArray array];
            }
            [self.imgs removeAllObjects];
            self.imgs = tempArr;
        }
        
        
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
