//
//  Collect.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/23.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collect : NSObject
/*!
 * @brief 收藏页里的id
 */
@property(nonatomic, assign) NSInteger id;
/*!
 * @brief 头图
 */
@property(nonatomic, retain) NSString *img;
/*!
 * @brief title
 */
@property(nonatomic, retain) NSString *title;
/*!
 * @brief 100元起
 */
@property(nonatomic, assign) NSInteger money;
/*!
 * @brief 收藏时间
 */
@property(nonatomic, retain) NSString *createdate;
/*!
 * @brief 详情页
 */
@property(nonatomic, retain) NSString *src;
/*!
 * @brief tourist里的id
 */
@property(nonatomic, assign) NSInteger tourist_id;

- (instancetype) initWithDictionary:(NSDictionary *)dic;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (id) valueForUndefinedKey:(NSString *)key;

@end
