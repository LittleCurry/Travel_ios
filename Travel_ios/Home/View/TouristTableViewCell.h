//
//  TouristTableViewCell.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tourist.h"

@interface TouristTableViewCell : UITableViewCell
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

@property (nonatomic, retain) Tourist *tourist;

@end
