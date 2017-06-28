//
//  LifeTableViewCell.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/26.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "LifeTableViewCell.h"

@implementation LifeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bigImage = [[UIImageView alloc] init];
        self.titleLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:17];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textAlignment = 0;
        self.detailLabel.numberOfLines = 2;
        
        [self.contentView addSubview:self.bigImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.titleLabel.frame = CGRectMake(20, 0, self.contentView.PART_W-30, 30);
    self.bigImage.frame = CGRectMake(0, 30, self.contentView.PART_W, self.contentView.PART_H-30);
    self.detailLabel.frame = CGRectMake(20, 40, self.contentView.PART_W-30, 50);
}

- (void)setLife:(Life *)life
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:life.img options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.bigImage.image = [UIImage imageWithData:data];
    // 字符串转Data
//    NSString *str = @"encode string";
    // 字符串转成Data
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];// 13 bytes
    // 加密Data
//    NSData *encodeData = [data base64EncodedDataWithOptions:0];// 20 bytes
    // 解密Data
//    NSData *decodeData = [[NSData alloc] initWithBase64EncodedData:encodeData options:0];// 13 bytes
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
