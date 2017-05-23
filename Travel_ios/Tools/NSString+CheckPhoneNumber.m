//
//  NSString+CheckPhoneNumber.m
//  Lock
//
//  Created by 李云鹏 on 17/3/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "NSString+CheckPhoneNumber.h"

@implementation NSString (CheckPhoneNumber)
- (BOOL)checkPhoneNum

{
    //1[0-9]{10}
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
