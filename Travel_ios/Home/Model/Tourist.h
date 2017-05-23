//
//  Tourist.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tourist : NSObject

/*!
 * @brief id
 */
@property(nonatomic, assign) NSInteger id;
/*!
 * @brief title
 */
@property(nonatomic, retain) NSString *title;
/*!
 * @brief 内容
 */
@property(nonatomic, retain) NSString *introduction;
/*!
 * @brief 时间节点
 */
@property(nonatomic, retain) NSString *img;
/*!
 * @brief 详情页src
 */
@property(nonatomic, retain) NSString *detail;
/*!
 * @brief 是否已收藏
 */
@property(nonatomic, assign) BOOL collected;


- (instancetype) initWithDictionary:(NSDictionary *)dic;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (id) valueForUndefinedKey:(NSString *)key;


@end
