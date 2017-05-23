//
//  MeViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *notifyArr;

@end

@implementation MeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self consumer];
    [self getView];
//    [self playNotifyData];
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
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)settingAction
{
    
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
//    headImg.image = [UIImage imageNamed:@""];
//    var gradientLayer = CAGradientLayer.init()
//    var timer = Timer.init()
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
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 50, 50)];
    headImg.image = [UIImage imageNamed:@"touristHolder.png"];
    [headView addSubview:headImg];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"546absdaQW";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

