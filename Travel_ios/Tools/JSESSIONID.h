//
//  JSESSIONID.h
//  TeSuFu
//
//  Created by yunPeng on 15/7/14.
//  Copyright (c) 2015年 yunPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AccountInfo.h"
@interface JSESSIONID : NSObject
/*!
 * @brief token
 */
@property(nonatomic, retain) NSString *token; //Bearer 3a66f9e4d0a944fd08ba34e439e00e1a
/*!
 * @brief 是否处于登录状态
 */
@property(nonatomic, assign) BOOL isLogin;
/*!
 * @brief 账户信息
 */
//@property(nonatomic, retain) AccountInfo *accountInfo;

+ (JSESSIONID *) getJSESSIONID;

@end
