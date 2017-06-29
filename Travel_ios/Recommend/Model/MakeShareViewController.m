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
    [self.addPictureButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:0];
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
    cell.imageView.image = self.selectedPhotoArr[indexPath.row];
    cell.imageView.tag = indexPath.row + 1000;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = true;
    cell.imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletePhoto)];
    [cell.imageView addGestureRecognizer:longPress];
    return cell;
}

- (void)addPicture
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.selectedPhotoArr.count delegate:self];
    imagePickerVC.allowPickingVideo = NO;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)deletePhoto
{
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
    NSLog(@"完成");
    [self.selectedPhotoArr addObjectsFromArray:photos];
    [self changeCollectionAddButtonAndReloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
    NSLog(@"完成2");
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
func deletePhoto(_ longPress:UILongPressGestureRecognizer) -> Void {
    if longPress.state == UIGestureRecognizerState.began {
        self.selectedPhotoArr.remove(self.selectedPhotoArr[longPress.view!.tag - 1000])
        self.changeCollectionAddButtonAndReloadData()
    }
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    let browser = MJPhotoBrowser.init()
    let photos:NSMutableArray = []
    for i in 0...self.selectedPhotoArr.count-1 {
        let currentPhoto = MJPhoto.init()
        currentPhoto.image = self.selectedPhotoArr[i] as! UIImage
        photos.add(currentPhoto)
    }
    browser.photos = photos as [AnyObject]
    browser.currentPhotoIndex = UInt(indexPath.row)
    browser.show()
}
 
// 选完照片
func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, infos: [[AnyHashable: Any]]!) {
    //
    self.selectedPhotoArr.addObjects(from: photos)
    self.changeCollectionAddButtonAndReloadData()
    
}

// 拍完照片
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    self.pickerController.dismiss(animated: true) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        self.selectedPhotoArr.add(image)
        self.changeCollectionAddButtonAndReloadData()
    }
    
}

// 添加图片
func addPicture() -> Void {
    let imagePickerVC = TZImagePickerController.init(maxImagesCount: 9-self.selectedPhotoArr.count, delegate: self)
    imagePickerVC?.allowPickingVideo = false
    self.present(imagePickerVC!, animated: true, completion: nil)
}

// 调整[+]位置
func changeCollectionAddButtonAndReloadData() -> Void {
    
    if self.selectedPhotoArr.count<=8 {
        self.addPictureButton.frame = CGRect(x: CGFloat(self.selectedPhotoArr.count%4)*(10+(WIDTH-70)/4)+20, y: CGFloat(self.selectedPhotoArr.count/4)*(10+(WIDTH-70)/4)+200, width: PART_W(self.addPictureButton), height: PART_H(self.addPictureButton))
    }else{
        self.addPictureButton.frame = CGRect(x: WIDTH, y: HEIGHT, width: PART_W(self.addPictureButton), height: PART_H(self.addPictureButton))
    }
    self.collectionView.reloadData()
}
 
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
