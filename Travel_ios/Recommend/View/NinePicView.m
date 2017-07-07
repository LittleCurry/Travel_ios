//
//  NinePicView.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/7/4.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "NinePicView.h"
//#import <SDWebImage/UIImageView+WebCache.h>
static const CGFloat kPicWidth = 90;        // 图片宽度
static const CGFloat kPicHeight = 90;        // 图片高度
static const CGFloat kPicPadding = 4;       // 图片间距

@interface NinePicView()

// 存放9张图片
@property (nonatomic, strong) NSMutableArray *picViewArr;

@end

@implementation NinePicView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
// 初始化9张图片控件
- (void)setUp{
    self.picViewArr = [@[] mutableCopy];
    for (int i=0; i<9; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        [self.picViewArr addObject:imgView];
    }
}


- (CGFloat)fillDetailWithPicArr:(NSArray *)picArr maxViewWidth:(CGFloat)viewWidth{
    [self clearImgData];
    if (picArr.count == 0) return 0;
    
    // 接收参数
    _picArr = picArr;
    if (picArr.count >9){
        NSMutableArray *marr = [@[] mutableCopy];
        for (int i=0; i<9; i++) {
            [marr addObject:picArr[i]];
        }
        _picArr = [marr copy];
    }
    _maxViewWidth = viewWidth;
    
    // 设置图片
    [self setImgData];
    // 布局图片位置
    CGFloat maxY = [self layoutPosition];
    
    return maxY;
}
// 清空图片
- (void)clearImgData{
    for (UIImageView *imgView in self.picViewArr) {
        imgView.image = nil;
    }
}
// 填充图片
- (void)setImgData{
    for (int i=0; i<_picArr.count; i++) {
//        NSString *picUrlStr = _picArr[i];
        UIImage *img = _picArr[i];
        UIImageView *imgView = self.picViewArr[i];
        imgView.image = img;
        imgView.userInteractionEnabled = YES;
        imgView.tag = 10000+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic:)];
        [imgView addGestureRecognizer:tap];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:picUrlStr]];
    }
}

- (void)showPic:(UIGestureRecognizer *)tap
{
    UIImageView *img = (UIImageView *)tap.view;
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i = 0; i < self.picArr.count; i++) {
        MJPhoto *currentPhoto = [[MJPhoto alloc] init];
        currentPhoto.image = self.picArr[i];
        [photos addObject:currentPhoto];
    }
    browser.photos = photos;
    browser.currentPhotoIndex = img.tag-10000;
    [browser show];
}
// 布局图片的位置
- (CGFloat)layoutPosition{
    CGFloat maxY = 0;       // 视图填充完毕后最大的y值
    NSInteger indexX = 0;
    NSInteger indexY = 0;
    CGFloat maxPicWidth = (_maxViewWidth-2*kPicPadding)/3;
    CGFloat picWidth = kPicWidth>maxPicWidth ? maxPicWidth : kPicWidth;
    CGFloat picHeight = picWidth;
    for (int i=0; i<_picArr.count; i++) {
        UIImageView *imgView = self.picViewArr[i];
        indexX = i%3;
        indexY = i/3;
        CGFloat picX = (picWidth+kPicPadding)*indexX;
        CGFloat picY = (picHeight+kPicPadding)*indexY;
        imgView.frame = CGRectMake(picX, picY, picWidth, picHeight);
        maxY = CGRectGetMaxY(imgView.frame);
    }
    return maxY;
}
@end
