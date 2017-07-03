//
//  MSSCollectionViewCell.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/28.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "MSSCollectionViewCell.h"

@implementation MSSCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bigImageView = [[UIImageView alloc] init];
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bigImageView.contentScaleFactor = [UIScreen mainScreen].scale;
//                          WithFrame:self.contentView.bounds];
//        self.imageView.backgroundColor = GRAY121COLOR;
        
//        [self.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.bigImageView.contentMode =  UIViewContentModeScaleAspectFill;
        self.bigImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.bigImageView.clipsToBounds  = YES;
        self.delBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.delBtn setTitle:@"╳" forState:0];
        
        
        [self.contentView addSubview:self.bigImageView];
        [self.contentView addSubview:self.delBtn];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.bigImageView.frame = self.contentView.bounds;
    self.delBtn.frame = CGRectMake(self.contentView.frame.size.width-20, 0, 20, 20);
}

@end
