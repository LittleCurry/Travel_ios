//
//  LifeTableViewCell.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/26.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NinePicView.h"
#import "Life.h"

@interface LifeTableViewCell : UITableViewCell
/*!
 * @brief 头像
 */
@property(nonatomic, retain) UIImageView *headImg;
/*!
 * @brief 标题
 */
@property(nonatomic, retain) UILabel *nameLabel;
/*!
 * @brief 详情
 */
@property(nonatomic, retain) UILabel *infoLabel;
/*!
 * @brief 九宫格
 */
@property(nonatomic, retain) NinePicView *nineView;
/*!
 * @brief 发表时间
 */
@property(nonatomic, retain) UILabel *timeLabel;
/*!
 * @brief 评论
 */
@property(nonatomic, retain) UIImageView *commentImg;
@property(nonatomic, retain) Life *life;
@property(nonatomic, retain) Life *currrntLife;// 本页已赋值的model

@end
