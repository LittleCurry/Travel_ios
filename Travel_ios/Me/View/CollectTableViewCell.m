//
//  CollectTableViewCell.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/23.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bigImage = [[UIImageView alloc] init];
        self.titleLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        
        self.titleLabel.font = WORDFONT;
//        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        self.detailLabel.textColor = PLACEHOLODERCOLOR;
        self.detailLabel.textAlignment = 0;
//        self.detailLabel.numberOfLines = 2;
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel.textColor = PLACEHOLODERCOLOR;
        self.dateLabel.textAlignment = 2;
        
        [self.contentView addSubview:self.bigImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bigImage.frame = CGRectMake(10, 10, 50, 50);
    self.titleLabel.frame = CGRectMake(70, 10, self.contentView.PART_W-200, 20);
    self.detailLabel.frame = CGRectMake(70, 40, self.contentView.PART_W-200, 20);
    self.dateLabel.frame = CGRectMake(self.contentView.PART_W-130, 8, 120, 20);
}

- (void)setCollect:(Collect *)collect
{
    [self.bigImage sd_setImageWithURL:collect.img placeholderImage:[UIImage imageNamed:@"touristHolder.png"]];
    self.titleLabel.text = collect.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%.2f元起", collect.money/100.0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
