//
//  MeViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "MeViewController.h"
#import "CollectViewController.h"

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *notifyArr;
@property(nonatomic, assign) NSInteger count;

@end

@implementation MeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self consumer];
    [self getView];
    self.count = 0;
    [self playCollectData];
}

- (void)consumer
{
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)getView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStyleDone target:self action:@selector(settingAction)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak __typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf playCollectData];
    }];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)settingAction
{
    
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    UIView *changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    [headView addSubview:changeView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = changeView.bounds;
    gradientLayer.locations = @[@0.33, @1.0];
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)RGBACOLOR(0, 109, 188, 1).CGColor, (__bridge id)RGBACOLOR(181, 206, 177, 1).CGColor];
    [changeView.layer addSublayer:gradientLayer];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 60, 60)];
    [headImg.layer setMasksToBounds:YES];
    headImg.layer.cornerRadius = 30;
    [headImg.layer setBorderWidth:0.5];
    [headImg.layer setBorderColor:GRAY121COLOR.CGColor];
    [headImg sd_setImageWithURL:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495516870360&di=a700af304be5c237869ccaef37b16d96&imgtype=0&src=http%3A%2F%2Fwww.caslon.cn%2Fpics%2Fallimg%2Fbd3378986.jpg" placeholderImage:[UIImage imageNamed:@"touristHolder.png"]];
    [headView addSubview:headImg];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 110, 100, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = WORDFONT;
    nameLabel.text = @"Xxづ蒾夨ㄋ";
    [headView addSubview:nameLabel];
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, 100, 20)];
    accountLabel.textColor = [UIColor whiteColor];
    accountLabel.font = [UIFont systemFontOfSize:12];
    accountLabel.text = @"2813022";
    [headView addSubview:accountLabel];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imgArr = @[@"record.png",@"partner.png",@"collect.png",@"message.png",@"idea.png",@"about.png"];
    NSArray *contentArr = @[@"行程记录",@"同伴",@"收藏",@"消息",@"意见与建议",@"关于"];
    static NSString *str = @"546adasdadadqwbsdaQW";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", self.count];
    }
    cell.textLabel.font = WORDFONT;
    cell.textLabel.text = contentArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        CollectViewController *collectVC = [[CollectViewController alloc] init];
        collectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectVC animated:YES];
    }
}

#pragma mark - 刷新
- (void)playCollectData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/collect/count", HEADHOST];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        self.count = [[dict objectForKey:@"count"] integerValue];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    } failure:^(NSData *failureData) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

