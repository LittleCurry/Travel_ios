//
//  JSESSIONID.m
//  TeSuFu
//
//  Created by yunPeng on 15/7/14.
//  Copyright (c) 2015年 yunPeng. All rights reserved.
//

#import "JSESSIONID.h"

@implementation JSESSIONID
+ (JSESSIONID *) getJSESSIONID
{
    static JSESSIONID *dbHandler = nil;
    if (dbHandler == nil) {
        dbHandler = [[JSESSIONID alloc] init];
    }
//    NSString *token = [NSString stringWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token.length>0) {
        dbHandler.token = token;
    }
    return dbHandler;
}


@end
