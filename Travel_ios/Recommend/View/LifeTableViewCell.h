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
@property(nonatomic, retain) UILabel *titleLabel;
/*!
 * @brief 详情
 */
@property(nonatomic, retain) UILabel *infoLabel;
@property(nonatomic, retain) NinePicView *nineView;




@property(nonatomic, retain) UIView *whiteVeiw;
@property(nonatomic, retain) UILabel *nameLabel;
//@property(nonatomic, retain) UILabel *contentLabel;
//@property(nonatomic, retain) UIImageView *bigImageView;
@property(nonatomic, retain) UILabel *authorLabel;
@property(nonatomic, retain) UIButton *authorButton;
@property(nonatomic, retain) UILabel *timeLabel;
@property(nonatomic, retain) UIView *lineView;
//@property(nonatomic, retain)Tiezi *tiezi;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *urlArray;
//@property (nonatomic, retain)Tiezi *currentTiezi;
@property(nonatomic, retain) UIImageView *oneImageView;


















@property(nonatomic, retain) Life *life;
@property(nonatomic, retain) Life *currrntLife;// 本页已赋值的model
@property(nonatomic, assign) CGFloat aHeight;// 九宫格高度

@end
