//
//  TouristTableViewCell.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "TouristTableViewCell.h"

@implementation TouristTableViewCell

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

- (void)setTourist:(Tourist *)tourist
{
    [self.bigImage sd_setImageWithURL:tourist.img placeholderImage:[UIImage imageNamed:@"touristHolder.png"]];
    self.titleLabel.text = tourist.title;
    self.detailLabel.text = tourist.introduction;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
