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
        _imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = GRAY121COLOR;
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.contentMode =  UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds  = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
