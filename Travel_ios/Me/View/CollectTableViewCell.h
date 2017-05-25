//
//  CollectTableViewCell.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/23.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collect.h"

@interface CollectTableViewCell : UITableViewCell
/*!
 * @brief 背景图
 */
@property(nonatomic, retain) UIImageView *bigImage;
/*!
 * @brief 标题
 */
@property(nonatomic, retain) UILabel *titleLabel;
/*!
 * @brief 详情
 */
@property(nonatomic, retain) UILabel *detailLabel;
/*!
 * @brief 日期
 */
@property(nonatomic, retain) UILabel *dateLabel;

@property (nonatomic, retain) Collect *collect;

@end
