//
//  RecommendViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "RecommendViewController.h"
#import "MakeShareViewController.h"

@interface RecommendViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *lifeArr;
/*!
 * @brief 查询到第几条
 */
@property(nonatomic, assign) NSInteger count;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getView];
    self.count = 0;
    self.lifeArr = [NSMutableArray array];
    [self playLifeData];
    __weak typeof(self) weakSelf = self;
    [self showStatus:@"暂无数据" imageName:@"nodata" type:@"" tapViewWithBlock:^{
        [weakSelf playLifeData];
    }];
}

- (void)getView
{
    self.navigationItem.title = @"足迹";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"idea.png"] style:UIBarButtonItemStyleDone target:self action:@selector(choseImage)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak __typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf playLifeData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf playMoreLifeData];
    }];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    
}

- (void)choseImage
{
    MakeShareViewController *makeVC = [[MakeShareViewController alloc] init];
    makeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:makeVC animated:YES];
}

/*

// 拍完照片
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    self.pickerController.dismiss(animated: true) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        self.selectedPhotoArr.add(image)
        self.changeCollectionAddButtonAndReloadData()
    }
    
}
 */

- (void)makeShare
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self.navigationController presentViewController:pickerImage animated:YES completion:^{}];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *choseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(choseImage, 0.5);
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *postDic = @{@"info":@"nihaoaaa", @"img":encodeResult};
    NSString *str = [NSString stringWithFormat:@"%@/share/makeShare", HEADHOST];
    [NetHandler postDataWithUrl:str parameters:postDic tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        //
        [self successAliHUD:@"上传成功" delay:1.5];
    } failure:^(NSData *failureData) {
        //
        [self successAliHUD:@"上传失败" delay:1.5];
    }];
}

- (void)changeMessageFrame
{
    if (self.lifeArr.count==0) {
        [self show];
    }else{
        [self hide];
    }
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lifeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Life *life = self.lifeArr[indexPath.row];
    NSDictionary *dic = @{NSFontAttributeName:WORDFONT};
    CGRect rect = [life.info boundingRectWithSize:CGSizeMake(WIDTH-60, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + 70 + [self rowCount: life.imgs.count]*(WIDTH-140)/3.0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"546absad11qsdaQW";
    LifeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[LifeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.life = self.lifeArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Life *life = self.lifeArr[indexPath.row];
//    WebViewController *webVC = [[WebViewController alloc] init];
//    webVC.urlStr = tourist.detail;
//    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 刷新
- (void)playLifeData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/share/0/10", HEADHOST];
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
        [weakSelf.lifeArr removeAllObjects];
        [weakSelf.tableView reloadData];
        for (NSDictionary *dic in dict) {
            Life *life = [[Life alloc] initWithDictionary:dic];
            [weakSelf.lifeArr addObject:life];
        }
        weakSelf.count = weakSelf.lifeArr.count;
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
- (void)playMoreLifeData
{
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"%@/share/%ld/10", HEADHOST, self.count];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        NSInteger count = 0;
        for (NSDictionary *dic in dict) {
            Life *life = [[Life alloc] initWithDictionary:dic];
            [weakSelf.lifeArr addObject:life];
            weakSelf.count = weakSelf.lifeArr.count;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
