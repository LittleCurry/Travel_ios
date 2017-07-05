//
//  NinePicView.h
//  Travel_ios
//
//  Created by 李云鹏 on 17/7/4.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinePicView : UIView
// 九宫格图片
@property (nonatomic, strong, readonly) NSArray *picArr;
// 视图的最大宽度，用于计算label文字的宽
@property (nonatomic, assign, readonly) CGFloat maxViewWidth;

/**
 *  生成9宫格图片
 *
 *  @param picArr 图片数组
 *  @param viewWidth 视图最大宽度
 *
 *  @return 填充完毕后视图的高度
 */
- (CGFloat)fillDetailWithPicArr:(NSArray *)picArr maxViewWidth:(CGFloat)viewWidth;

@end
