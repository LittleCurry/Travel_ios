//
//  Life.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/26.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Life : NSObject

/*!
 * @brief id
 */
@property(nonatomic, assign) NSInteger id;
/*!
 * @brief 描述
 */
@property(nonatomic, retain) NSString *info;
/*!
 * @brief 时间
 */
@property(nonatomic, retain) NSString *create_time;
/*!
 * @brief 图片
 */
@property(nonatomic, retain) NSMutableArray *imgs;


- (instancetype) initWithDictionary:(NSDictionary *)dic;
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (id) valueForUndefinedKey:(NSString *)key;


@end
