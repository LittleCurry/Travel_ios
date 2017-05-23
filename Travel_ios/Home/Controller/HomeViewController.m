//
//  HomeViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *touristArr;
/*!
 * @brief 查询到第几条
 */
@property(nonatomic, assign) NSInteger count;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self consumer];
    self.count = 0;
    [self getView];
    self.touristArr = [NSMutableArray array];
    [self playTouristData];
//    __weak typeof(self) weakSelf = self;
//    [self showStatus:@"暂无数据" imageName:@"nodata" type:@"" tapViewWithBlock:^{
//        [weakSelf playNotifyData];
//    }];
}

- (void)consumer
{
    self.navigationItem.title = @"首页";
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
        [weakSelf playTouristData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf playMoreTouristData];
    }];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.touristArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"546absad11qsdaQW";
    TouristTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[TouristTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.tourist = self.touristArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tourist *tourist = self.touristArr[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.urlStr = tourist.detail;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tourist *tourist = self.touristArr[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"%@/tourist/%ld", HEADHOST, tourist.id];
        [NetHandler deleteDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
        } success:^(NSData *successData) {
            [weakSelf.touristArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        } failure:^(NSData *failureData) {
        }];
    }];
    
    NSString *collectStr = @"收藏";
    if (tourist.collected) {
        collectStr = @"取消收藏";
    }
    
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:collectStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __weak typeof(self) weakSelf = self;
        NSString *str = [NSString stringWithFormat:@"%@/tourist/%ld/collect", HEADHOST, tourist.id];
        if (tourist.collected) {
            str = [NSString stringWithFormat:@"%@/tourist/%ld/cancelcollect", HEADHOST, tourist.id];
        }
        [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
        } success:^(NSData *successData) {
            tourist.collected = !tourist.collected;
            [weakSelf.tableView reloadData];
        } failure:^(NSData *failureData) {
        }];
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    markAction.backgroundColor = UIColorFromRGB(0xd9d9d9);
    NSArray *arr = @[deleteAction, markAction];
    
    return arr;
}

#pragma mark - 刷新
- (void)playTouristData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/tourist/0/10", HEADHOST];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
#if 0
        id dict = [NSJSONSerialization JSONObjectWithData:cachesData options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.notifyArr removeAllObjects];
        [weakSelf.tableView reloadData];
        for (NSDictionary *dic in dict) {
            Notify *notify = [[Notify alloc] initWithDictionary:dic];
            [weakSelf.notifyArr addObject:notify];
        }
        [weakSelf.tableView reloadData];
        [weakSelf changeMessageFrame];
        weakSelf.tableView.footer.state = 1;
#endif
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.touristArr removeAllObjects];
        [weakSelf.tableView reloadData];
        for (NSDictionary *dic in dict) {
            Tourist *tourist = [[Tourist alloc] initWithDictionary:dic];
            [weakSelf.touristArr addObject:tourist];
        }
        weakSelf.count = weakSelf.touristArr.count;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    } failure:^(NSData *failureData) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.tableView.footer.state = 1;
    }];
}

#pragma mark - 加载更多
- (void)playMoreTouristData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/tourist/%ld/10", HEADHOST, self.count];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        NSInteger count = 0;
        for (NSDictionary *dic in dict) {
            Tourist *tourist = [[Tourist alloc] initWithDictionary:dic];
            [weakSelf.touristArr addObject:tourist];
            weakSelf.count = weakSelf.touristArr.count;
            count++;
        }
        [weakSelf.tableView reloadData];
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
