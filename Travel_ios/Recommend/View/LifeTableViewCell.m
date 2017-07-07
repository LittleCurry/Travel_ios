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
        self.headImg = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.infoLabel = [[UILabel alloc] init];
        self.nineView = [[NinePicView alloc] init];
        self.timeLabel = [[UILabel alloc] init];
        self.commentImg = [[UIImageView alloc] init];
        
        
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = RGBACOLOR(101, 114, 140, 1);
        self.nameLabel.textAlignment = 0;
        self.infoLabel.font = WORDFONT;
//        self.infoLabel.textColor = BlackColor(0.8);
        self.infoLabel.textColor = RGBACOLOR(70, 70, 70, 1);
        self.nameLabel.text = @"Xxづ蒾夨ㄋ";
        self.infoLabel.numberOfLines = 0;
        self.timeLabel.textColor = BlackColor(0.3);
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.commentImg.image = [UIImage imageNamed:@"comment.png"];
        
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.nineView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.commentImg];
    }
    return self;
}

CGFloat aHeight = 0;

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headImg.frame = CGRectMake(5, 5, 40, 40);
    NSDictionary *dic = @{NSFontAttributeName:WORDFONT};
    CGRect rect = [self.currrntLife.info boundingRectWithSize:CGSizeMake(self.contentView.PART_W-60, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.nameLabel.frame = CGRectMake(50, 10, self.contentView.PART_W-70, 20);
    self.infoLabel.frame = CGRectMake(50, 30, self.contentView.PART_W-60, rect.size.height);
    self.nineView.frame = CGRectMake(50, rect.size.height+30, WIDTH-140, [self rowCount:self.currrntLife.imgs.count]*(WIDTH-140)/3.0);
    self.timeLabel.frame = CGRectMake(50, self.contentView.PART_H-30, self.contentView.PART_W-100, 20);
    self.commentImg.frame = CGRectMake(self.contentView.PART_W-35, self.contentView.PART_H-30, 25, 25);
}

- (NSInteger)rowCount:(NSInteger)arrCount
{
    switch (arrCount) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 2;
            break;
        case 6:
            return 2;
            break;
        case 7:
            return 3;
            break;
        case 8:
            return 3;
            break;
        case 9:
            return 3;
            break;
        default:
            break;
    }
    return 0;
}

- (void)setLife:(Life *)life
{
    self.currrntLife = life;
    [self.headImg sd_setImageWithURL:@"http://img2.imgtn.bdimg.com/it/u=2814844067,420417492&fm=214&gp=0.jpg" placeholderImage:[UIImage imageNamed:@"head_default.png"]];
//    [self.headImg sd_setImageWithURL:@"http://imgsrc.baidu.com/image/c0%3Dshijue%2C0%2C0%2C245%2C40/sign=a51c37d15bda81cb5aeb8b8e3a0fba63/78310a55b319ebc4bf37a9bc8826cffc1e171643.jpg" placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    self.infoLabel.text = life.info;
    
    self.timeLabel.text = life.create_time;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in life.imgs) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dic[@"img"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *aImage = [UIImage imageWithData:data];
        [tempArr addObject:aImage];
    }
    CGFloat ninePicViewHeight = [self.nineView fillDetailWithPicArr:tempArr maxViewWidth:WIDTH-140];
    if (ninePicViewHeight == 0) {
        self.nineView.hidden = YES;
//        self.ninePicViewHeightCons.constant = 0;
//        self.ninePicViewTopPaddingCons.constant = 0;
    }else{
        self.nineView.hidden = NO;
//        self.ninePicViewHeightCons.constant = ninePicViewHeight;
//        self.ninePicViewTopPaddingCons.constant = kPadding_8;
    }
    
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
