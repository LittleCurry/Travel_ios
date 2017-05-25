//
//  CollectViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/23.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"

@interface CollectViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *collectArr;
/*!
 * @brief 查询到第几条
 */
@property(nonatomic, assign) NSInteger count;

@end

@implementation CollectViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self consumer];
    self.count = 0;
    [self getView];
    self.collectArr = [NSMutableArray array];
    [self playCollectData];
    __weak typeof(self) weakSelf = self;
    [self showStatus:@"暂无数据" imageName:@"nodata" type:@"" tapViewWithBlock:^{
        [weakSelf playCollectData];
    }];
}

- (void)consumer
{
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)getView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak __typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf playCollectData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf playMoreCollectData];
    }];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"546adasdadadqwbsdaQW";
    CollectTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell =[[CollectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    Collect *collect = self.collectArr[indexPath.row];
    cell.collect = collect;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Collect *collect = self.collectArr[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.urlStr = collect.src;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Collect *collect = self.collectArr[indexPath.row];
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"%@/collect/%ld/del", HEADHOST, collect.id];
        [NetHandler putDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
        } success:^(NSData *successData) {
            [weakSelf.collectArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            [self successAliHUD:@"取消收藏成功" delay:1.5];
        } failure:^(NSData *failureData) {
        }];
    }];
    markAction.backgroundColor = UIColorFromRGB(0xd9d9d9);
    NSArray *arr = @[markAction];
    return arr;
}

- (void)changeMessageFrame
{
    if (self.collectArr.count==0) {
        [self show];
    }else{
        [self hide];
    }
}

#pragma mark - 刷新
- (void)playCollectData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/collect/list/0/10", HEADHOST];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
        id dict = [NSJSONSerialization JSONObjectWithData:cachesData options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.collectArr removeAllObjects];
        [weakSelf.tableView reloadData];
        for (NSDictionary *dic in dict) {
            Collect *collect = [[Collect alloc] initWithDictionary:dic];
            [weakSelf.collectArr addObject:collect];
        }
        [weakSelf.tableView reloadData];
        [weakSelf changeMessageFrame];
        weakSelf.tableView.footer.state = 1;
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.collectArr removeAllObjects];
        [weakSelf.tableView reloadData];
        for (NSDictionary *dic in dict) {
            Collect *collect = [[Collect alloc] initWithDictionary:dic];
            [weakSelf.collectArr addObject:collect];
        }
        weakSelf.count = weakSelf.collectArr.count;
        [weakSelf.tableView reloadData];
        [weakSelf changeMessageFrame];
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    } failure:^(NSData *failureData) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    }];
}

#pragma mark - 加载更多
- (void)playMoreCollectData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/collect/list/%ld/10", HEADHOST, self.count];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        NSInteger count = 0;
        for (NSDictionary *dic in dict) {
            Collect *collect = [[Collect alloc] initWithDictionary:dic];
            [weakSelf.collectArr addObject:collect];
            weakSelf.count = weakSelf.collectArr.count;
            count++;
        }
        [weakSelf.tableView reloadData];
        [weakSelf changeMessageFrame];
        [weakSelf.tableView.footer endRefreshing];
        if (count <10) {
            [weakSelf.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSData *failureData) {
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
