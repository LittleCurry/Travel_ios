//
//  MakeShareViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/6/28.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "MakeShareViewController.h"
#import "MSSCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "MJPhotoBrowser.h"

NSString *MSSReuseIdentifier = @"MSSCollectionViewCell";

@interface MakeShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, TZImagePickerControllerDelegate>
@property(nonatomic, retain) NSMutableArray *selectedPhotoArr;
@property(nonatomic, retain) UIImagePickerController *pickerController;
@property(nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic, retain) UIButton *addPictureButton;
@property(nonatomic, retain) UITextField *nowTextField;

@end

@implementation MakeShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getView];
    self.selectedPhotoArr = [NSMutableArray array];
    self.pickerController = [[UIImagePickerController alloc] init];
}

- (void)getView
{
    self.navigationItem.title = @"相册选择";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(shareFriend)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0 green:190/255.0 blue:44/255.0 alpha:1];
    
    self.nowTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, WIDTH-40, 40)];
    self.nowTextField.placeholder = @"这一刻的想法...";
    [self.view addSubview:self.nowTextField];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    flowLayout.itemSize = CGSizeMake((WIDTH-70)/4, (WIDTH-70)/4);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, WIDTH, WIDTH) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MSSCollectionViewCell class] forCellWithReuseIdentifier:MSSReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    self.addPictureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addPictureButton.frame = CGRectMake(20, 200, (WIDTH-70)/4, (WIDTH-70)/4);
    [self.addPictureButton setBackgroundImage:[UIImage imageNamed:@"squareAdd.png"] forState:0];
    [self.addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPictureButton];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPhotoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSSReuseIdentifier forIndexPath:indexPath];
    cell.bigImageView.image = self.selectedPhotoArr[indexPath.row];
    cell.delBtn.tag = indexPath.row + 1000;
    [cell.delBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击预览
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i=0; i<self.selectedPhotoArr.count; i++) {
        MJPhoto *currentPhoto = [[MJPhoto alloc] init];
        currentPhoto.image = self.selectedPhotoArr[i];
        [photos addObject:currentPhoto];
    }
    browser.photos = photos;
    browser.currentPhotoIndex = indexPath.row;
    [browser show];
}


- (void)addPicture
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.selectedPhotoArr.count delegate:self];
    imagePickerVC.allowPickingVideo = NO;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)deletePhoto:(UIButton *)button
{
    [self.selectedPhotoArr removeObjectAtIndex:button.tag - 1000];
    [self changeCollectionAddButtonAndReloadData];
}

- (void)shareFriend
{
    NSString *errMsg = @"";
    if (self.nowTextField.text.length <= 0) {
        errMsg = [errMsg stringByAppendingString:@"文字内容不能为空 "];
    }
    if (self.selectedPhotoArr.count <= 0) {
        errMsg = [errMsg stringByAppendingString:@"图片"];
    }
    if (errMsg.length > 0) {
        [self failureAliHUD:errMsg delay:1.5];
        return;
    }
    
    NSMutableArray *uploadArr = [NSMutableArray array];
    for (UIImage *aImage in self.selectedPhotoArr) {
        NSData *imageData = UIImageJPEGRepresentation(aImage, 0.5);
        NSString *encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [uploadArr addObject:encodeResult];
    }
    NSDictionary *postDic = @{@"info":@"nihaome", @"imgs":uploadArr};
    NSString *str = [NSString stringWithFormat:@"%@/share/makeShare", HEADHOST];
    [NetHandler postDataWithUrl:str parameters:postDic tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
    } success:^(NSData *successData) {
        [self successAliHUD:@"上传成功" delay:1.5];
    } failure:^(NSData *failureData) {
        [self successAliHUD:@"上传失败" delay:1.5];
    }];
    /*
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
     */
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
    [self.selectedPhotoArr addObjectsFromArray:photos];
    [self changeCollectionAddButtonAndReloadData];
}

// 调整[+]位置
- (void)changeCollectionAddButtonAndReloadData
{
    if (self.selectedPhotoArr.count<=8) {
        self.addPictureButton.frame = CGRectMake((self.selectedPhotoArr.count%4)*(10+(WIDTH-70)/4)+20, (self.selectedPhotoArr.count/4)*(10+(WIDTH-70)/4)+200, self.addPictureButton.PART_W, self.addPictureButton.PART_H);
    }else{
        self.addPictureButton.frame = CGRectMake(WIDTH, HEIGHT, self.addPictureButton.PART_W, self.addPictureButton.PART_H);
    }
    [self.collectionView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.nowTextField resignFirstResponder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
