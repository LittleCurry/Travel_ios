//
//  LoginViewController.m
//  TeSuFu
//
//  Created by yunPeng on 15/7/23.
//  Copyright (c) 2015年 yunPeng. All rights reserved.
//

#import "LoginViewController.h"
//#import "UMSocial.h"

@interface LoginViewController ()<UITextFieldDelegate, NSURLConnectionDataDelegate>
/*!
 * @brief 登陆的手机号
 */
@property(nonatomic, retain) UITextField *phoneTextField;
/*!
 * @brief 登陆的密码
 */
@property(nonatomic, retain) UITextField *keyTextField;
/*!
 * @brief 注册的昵称
 */
@property(nonatomic, retain) UITextField *registerNameTextField;
/*!
 * @brief 注册的手机号
 */
@property(nonatomic, retain) UITextField *registerPhoneTextField;
/*!
 * @brief 注册的密码
 */
@property(nonatomic, retain) UITextField *registerKeyTextField;
/*!
 * @brief 注册的验证码
 */
@property(nonatomic, retain) UITextField *registerTestTextField;
/*!
 * @brief 忘记的手机号
 */
@property(nonatomic, retain) UITextField *forgetPhoneTextField;
/*!
 * @brief 忘记的密码
 */
@property(nonatomic, retain) UITextField *forgetKeyTextField;
/*!
 * @brief 忘记的验证码
 */
@property(nonatomic, retain) UITextField *forgetTestTextField;
@property(nonatomic, retain) UIView *loginView;
@property(nonatomic, retain) UIView *getKeyView;
@property(nonatomic, retain) UIView *forgetView;
@property(nonatomic, retain) UIButton *getTestButton;
@property(nonatomic, retain) UIButton *forgetTestButton;
/*!
 * @brief 点击登陆, 判断密码是否正确
 */
@property(nonatomic, retain) HyLoglnButton *loginButton;
/*!
 * @brief 获取到验证码后, 点击注册时才进行请求
 */
@property(nonatomic, assign) BOOL getTestCode;
/*!
 * @brief 忘记密码获取到验证码后, 点击注册时才进行请求
 */
@property(nonatomic, assign) BOOL forgetTestCode;
/*!
 * @brief 是否已经登陆过
 */
@property(nonatomic ,assign) BOOL haveSuccessdeLogin;

@end

@implementation LoginViewController

-(BOOL)isVisible
{
    return (self.isViewLoaded && self.view.window);
}

+ (LoginViewController *) getLoginVC
{
    static LoginViewController *loginVC = nil;
    if (loginVC == nil) {
        loginVC = [[LoginViewController alloc] init];
    }
    return loginVC;
}

#pragma mark - 测试token是否存在或过期
+ (void)getMeLoginWithToken:(void (^)(BOOL result))resultBlock
{
    NSString *token = [NSString stringWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] encoding:NSUTF8StringEncoding error:nil];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    //GET me
    NSString *str = [NSString stringWithFormat:@"%@/me", HEADHOST];
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // nil
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // token登录成功
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
          [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        
        
        [JSESSIONID getJSESSIONID].token = token;
        [[JSESSIONID getJSESSIONID].token writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        resultBlock(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // token失效
        if (error.code != -1003) {
            resultBlock(NO);
        }
        if (error.code == -1003) {
            NSString *ipUrl = [str stringByReplacingOccurrencesOfString:HEADHOST withString:IPHOST];
            AFHTTPSessionManager *ipSession = [AFHTTPSessionManager manager];
            ipSession.requestSerializer = [AFJSONRequestSerializer serializer];
            ipSession.responseSerializer = [AFHTTPResponseSerializer serializer];
            [ipSession.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
            [ipSession GET:ipUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // token登录成功
                  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                [JSESSIONID getJSESSIONID].token = token;
                [[JSESSIONID getJSESSIONID].token writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
                resultBlock(YES);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                resultBlock(NO);
            }];
        }
    }];
    
//    [NetHandler getDataWithUrl:[NSString stringWithFormat:@"%@/me", HEADHOST] parameters:nil tokenKey:@"Authorization" tokenValue:token ifCaches:NO cachesData:nil success:^(AFHTTPRequestOperation *operation) {
//        // token登录成功
//        [JSESSIONID getJSESSIONID].token = token;
//        resultBlock(YES);
//    } failure:^(AFHTTPRequestOperation *operation) {
//        // token失效
//        resultBlock(NO);
//    }];
}

#pragma mark - 若token过期,则从本地读取账号密码登录,并存新的token
+ (void) accountPasswordLogin:(void (^)(BOOL result))resultBlock
{
    NSString *str = [NSString stringWithFormat:@"%@/login", HEADHOST];
    NSString *accountPassword = [NSString stringWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa.txt"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *parameters = nil;
    if (accountPassword.length > 11) {
    NSString *account = [accountPassword substringToIndex:11];
    NSString *password = [accountPassword substringFromIndex:11];
        parameters = @{@"mobile":account, @"password":password};
    }
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resultBlock(YES);
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
          [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"token_type"], [dict objectForKey:@"access_token"]] forKey:@"token"];
        [JSESSIONID getJSESSIONID].token = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"token_type"], [dict objectForKey:@"access_token"]];
        [[JSESSIONID getJSESSIONID].token writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resultBlock(NO);
    }];
    
    
//    [NetHandler postDataWithUrl:str parameters:parameters tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:nil success:^(AFHTTPRequestOperation *operation) {
//        resultBlock(YES);
//        id dict = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingMutableContainers error:nil];
//        [JSESSIONID getJSESSIONID].token = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"token_type"], [dict objectForKey:@"access_token"]];
//        [[JSESSIONID getJSESSIONID].token writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"aa2.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
//    } failure:^(AFHTTPRequestOperation *operation) {
//        resultBlock(NO);
//    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 注册
    [self getKey];
    // 忘记密码
    [self forget];
    // 登陆
    [self login];
}

#pragma mark - 注册页面
- (void)getKey
{
    self.getTestCode = YES;
    [self.phoneTextField resignFirstResponder];
    [self.keyTextField resignFirstResponder];
    self.getKeyView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.getKeyView.backgroundColor = MAINCOLOR;
    [self.view addSubview:self.getKeyView];
    
    /*
     * logo
     */
    [self.getKeyView addSubview:self.logoView];
    
    
    UIView *circleWhiteView1 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT / 4, WIDTH-40, 44)];
    circleWhiteView1.clipsToBounds = YES;
    circleWhiteView1.layer.cornerRadius = circleWhiteView1.PART_H/2;
    circleWhiteView1.backgroundColor = [UIColor whiteColor];
    [self.getKeyView addSubview:circleWhiteView1];
    UIImageView *namePlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    namePlaceHolder1.image = [UIImage imageNamed:@"headPlaceholder.png"];
    [circleWhiteView1 addSubview:namePlaceHolder1];
    UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine1.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView1 addSubview:verticalLine1];
    
    
    
    self.registerNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, HEIGHT/4, WIDTH-79-20, 50)];
    NSString *holderText1 = @"昵称";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc]initWithString:holderText1];
    [placeholder1 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText1.length)];
    self.registerNameTextField.attributedPlaceholder = placeholder1;
    self.registerNameTextField.delegate = self;
    [self.getKeyView addSubview:self.registerNameTextField];
    UIView *circleWhiteView2 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT / 4+44+15, WIDTH-40, 44)];
    circleWhiteView2.clipsToBounds = YES;
    circleWhiteView2.layer.cornerRadius = circleWhiteView2.PART_H/2;
    circleWhiteView2.backgroundColor = [UIColor whiteColor];
    [self.getKeyView addSubview:circleWhiteView2];
    UIImageView *phonePlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    phonePlaceHolder1.image = [UIImage imageNamed:@"phone.png"];
    [circleWhiteView2 addSubview:phonePlaceHolder1];
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine2.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView2 addSubview:verticalLine2];
    
    
    self.registerPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, HEIGHT/4+44+15, WIDTH-79-20, 50)];
    
    NSString *holderText2 = @"手机";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:holderText2];
    [placeholder2 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText2.length)];
    self.registerPhoneTextField.attributedPlaceholder = placeholder2;
    
    
    
    self.registerPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.registerPhoneTextField.delegate = self;
    [self.getKeyView addSubview:self.registerPhoneTextField];
    [self.registerPhoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *circleWhiteView3 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4+44+15+44+15, WIDTH-40, 44)];
    circleWhiteView3.clipsToBounds = YES;
    circleWhiteView3.layer.cornerRadius = circleWhiteView3.PART_H/2;
    circleWhiteView3.backgroundColor = [UIColor whiteColor];
    [self.getKeyView addSubview:circleWhiteView3];
    
    
    UIImageView *register_testcodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    register_testcodeImage.image = [UIImage imageNamed:@"test_code.png"];
    [circleWhiteView3 addSubview:register_testcodeImage];
    
    UIView *verticalLine10 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine10.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView3 addSubview:verticalLine10];
    
    
    self.registerTestTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, WIDTH-40-100-60, 44)];
    NSString *holderText5 = @"验证码";
    NSMutableAttributedString *placeholder5 = [[NSMutableAttributedString alloc]initWithString:holderText5];
    [placeholder5 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText5.length)];
    self.registerTestTextField.attributedPlaceholder = placeholder5;
    
    self.registerTestTextField.delegate = self;
    self.registerTestTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [circleWhiteView3 addSubview:self.registerTestTextField];
    UIView *verticalLine5 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH-140, 7, 1, 30)];
    verticalLine5.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView3 addSubview:verticalLine5];
    
    self.getTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getTestButton.backgroundColor = PLACEHOLODERCOLOR;
//    self.getTestButton.userInteractionEnabled = NO;
    self.getTestButton.frame = CGRectMake(WIDTH-140, 0, 100, 44);
    [self.getTestButton addTarget:self action:@selector(getTestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.getTestButton.layer setMasksToBounds:YES];
//    self.getTestButton.backgroundColor = [UIColor redColor];
//    [self.getTestButton.layer setCornerRadius:22];
//    [self.getTestButton.layer setBorderWidth:1.5];//设置边界的宽度
    //设置按钮的边界颜色
    //    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
    CGColorRef color = MAINCOLOR.CGColor;
    [self.getTestButton.layer setBorderColor:color];
    [self.getTestButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getTestButton setTitleColor:[UIColor colorWithRed:121 / 255.0 green:121 / 255.0 blue:121 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self.getTestButton setTintColor:[UIColor lightGrayColor]];
    self.getTestButton.titleLabel.font = [UIFont systemFontOfSize: 13];
    [circleWhiteView3 addSubview:self.getTestButton];
    
    //////////////////////
    
    
    
    UIView *circleWhiteView4 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4+44+15+44+15+44+15, WIDTH-40, 44)];
    circleWhiteView4.clipsToBounds = YES;
    circleWhiteView4.layer.cornerRadius = circleWhiteView4.PART_H/2;
    circleWhiteView4.backgroundColor = [UIColor whiteColor];
    [self.getKeyView addSubview:circleWhiteView4];
    UIImageView *keyPlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    keyPlaceHolder1.image = [UIImage imageNamed:@"key.png"];
    [circleWhiteView4 addSubview:keyPlaceHolder1];
    UIView *verticalLine3 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine3.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView4 addSubview:verticalLine3];

    self.registerKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, WIDTH-40-60-60, 44)];
    self.registerKeyTextField.secureTextEntry = YES;
    NSString *holderText3 = @"密码";
    NSMutableAttributedString *placeholder3 = [[NSMutableAttributedString alloc]initWithString:holderText3];
    [placeholder3 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText3.length)];
    self.registerKeyTextField.attributedPlaceholder = placeholder3;
//    self.registerKeyTextField.placeholder = @"6至16位数字或字母";
    self.registerKeyTextField.delegate = self;
    self.registerKeyTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [circleWhiteView4 addSubview:self.registerKeyTextField];
    UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    eyeButton.frame = CGRectMake(WIDTH - 100+17.5, 9.5, 25, 25);
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye.png"] forState:0];
    eyeButton.tag = 1080;
    [eyeButton addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [circleWhiteView4 addSubview:eyeButton];
    
    UIButton *getKeyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getKeyButton.frame = CGRectMake(20, HEIGHT/4+44+15+44+15+44+15+44+15, WIDTH - 40, 44);
    getKeyButton.backgroundColor = [UIColor whiteColor];
    [getKeyButton addTarget:self action:@selector(getKeyAction:) forControlEvents:UIControlEventTouchUpInside];
    [getKeyButton setTitle:@"注册" forState:UIControlStateNormal];
    [getKeyButton setTintColor:DETAILCOLOR];
    [self.getKeyView addSubview:getKeyButton];
    UILabel *backLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, getKeyButton.Y + getKeyButton.PART_H + 5, WIDTH, 5)];
//    backLoginLabel.text = @"已有账号?";
    backLoginLabel.textAlignment = NSTextAlignmentCenter;
    backLoginLabel.textColor = [UIColor lightGrayColor];
    backLoginLabel.font = [UIFont systemFontOfSize:13.5];
    [self.getKeyView addSubview:backLoginLabel];
    UIButton *backLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backLoginButton.frame = CGRectMake(20, backLoginLabel.Y + backLoginLabel.PART_H, WIDTH - 40, 44);
    [backLoginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    backLoginButton.backgroundColor = DETAILCOLOR;
    [backLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backLoginButton setTitle:@"去登陆" forState:UIControlStateNormal];
    [backLoginButton addTarget:self action:@selector(makeLoginUp) forControlEvents:UIControlEventTouchUpInside];
    [self.getKeyView addSubview:backLoginButton];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yesButton.frame = CGRectMake(20, HEIGHT-30, 15, 15);
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setBorderWidth:1];//设置边界的宽度
    [yesButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
    [self.getKeyView addSubview:yesButton];
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, HEIGHT-30, 95, 15)];
    agreeLabel.textColor = [UIColor whiteColor];
    agreeLabel.font = [UIFont systemFontOfSize:12];
    agreeLabel.text = @"我已阅读,并同意";
    [self.getKeyView addSubview:agreeLabel];
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    agreeButton.frame = CGRectMake(120, HEIGHT-30, 100, 15);
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreeButton setTitleColor:DETAILCOLOR forState:UIControlStateNormal];
    [agreeButton setTitle:@"《用户注册协议》" forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.getKeyView addSubview:agreeButton];
    
}

#pragma mark - 忘记密码页面
- (void)forget
{
    self.forgetTestCode = NO;
    self.forgetView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.forgetView.backgroundColor = MAINCOLOR;
    [self.view addSubview:self.forgetView];
    /*
     * logo
     */
    [self.forgetView addSubview:self.logoView];
    
    /*
     * 手机项
     */
    UIView *circleWhiteView1 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4, WIDTH-40, 44)];
    circleWhiteView1.clipsToBounds = YES;
    circleWhiteView1.layer.cornerRadius = circleWhiteView1.PART_H/2;
    circleWhiteView1.backgroundColor = [UIColor whiteColor];
    [self.forgetView addSubview:circleWhiteView1];
    UIImageView *phonePlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    phonePlaceHolder1.image = [UIImage imageNamed:@"phone.png"];
    [circleWhiteView1 addSubview:phonePlaceHolder1];
    UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine1.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView1 addSubview:verticalLine1];
    self.forgetPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, WIDTH-40-60, 44)];
    NSString *holderText2 = @"手机";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:holderText2];
    [placeholder2 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText2.length)];
    self.forgetPhoneTextField.attributedPlaceholder = placeholder2;
    self.forgetPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.forgetPhoneTextField.delegate = self;
    [circleWhiteView1 addSubview:self.forgetPhoneTextField];
    [self.forgetPhoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *circleWhiteView2 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4+44+15, WIDTH-40, 44)];
    circleWhiteView2.clipsToBounds = YES;
    circleWhiteView2.layer.cornerRadius = circleWhiteView2.PART_H/2;
    circleWhiteView2.backgroundColor = [UIColor whiteColor];
    [self.forgetView addSubview:circleWhiteView2];
    
    /*
     * 验证码项
     */
    UIImageView *register_testcodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    register_testcodeImage.image = [UIImage imageNamed:@"test_code.png"];
    [circleWhiteView2 addSubview:register_testcodeImage];
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine2.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView2 addSubview:verticalLine2];
    self.forgetTestTextField = [[UITextField alloc] initWithFrame:CGRectMake(60,0,WIDTH-40-100-60,44)];
    NSString *holderText5 = @"验证码";
    NSMutableAttributedString *placeholder5 = [[NSMutableAttributedString alloc]initWithString:holderText5];
    [placeholder5 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText5.length)];
    self.forgetTestTextField.attributedPlaceholder = placeholder5;
    self.forgetTestTextField.delegate = self;
    self.forgetTestTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [circleWhiteView2 addSubview:self.forgetTestTextField];
    UIView *verticalLine3 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH-140, 7, 1, 30)];
    verticalLine3.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView2 addSubview:verticalLine3];
    self.forgetTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetTestButton.frame = CGRectMake(WIDTH-140, 0, 100, 44);
    self.forgetTestButton.backgroundColor = PLACEHOLODERCOLOR;
    [self.forgetTestButton addTarget:self action:@selector(getForgetTestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetTestButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.forgetTestButton setTitleColor:[UIColor colorWithRed:121 / 255.0 green:121 / 255.0 blue:121 / 255.0 alpha:1] forState:UIControlStateNormal];
    self.forgetTestButton.titleLabel.font = [UIFont systemFontOfSize: 13];
    [circleWhiteView2 addSubview:self.forgetTestButton];
    
    /*
     * 新密码项
     */
    UIView *circleWhiteView3 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4+44+15+44+15, WIDTH-40, 44)];
    circleWhiteView3.clipsToBounds = YES;
    circleWhiteView3.layer.cornerRadius = circleWhiteView3.PART_H/2;
    circleWhiteView3.backgroundColor = [UIColor whiteColor];
    [self.forgetView addSubview:circleWhiteView3];
    UIImageView *keyPlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    keyPlaceHolder1.image = [UIImage imageNamed:@"key.png"];
    [circleWhiteView3 addSubview:keyPlaceHolder1];
    UIView *verticalLine4 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine4.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView3 addSubview:verticalLine4];
    self.forgetKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, WIDTH-40-60, 44)];
    NSString *holderText3 = @"新密码";
    NSMutableAttributedString *placeholder3 = [[NSMutableAttributedString alloc]initWithString:holderText3];
    [placeholder3 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText3.length)];
    self.forgetKeyTextField.attributedPlaceholder = placeholder3;
    self.forgetKeyTextField.delegate = self;
    self.forgetKeyTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [circleWhiteView3 addSubview:self.forgetKeyTextField];
    
    /*
     * 确认提交+去登陆
     */
    UIButton *getKeyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getKeyButton.frame = CGRectMake(20,HEIGHT/4+44+15+44+15+44+15, WIDTH - 40, 44);
    getKeyButton.backgroundColor = DETAILCOLOR;
    getKeyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [getKeyButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [getKeyButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [getKeyButton setTintColor:[UIColor whiteColor]];
    [self.forgetView addSubview:getKeyButton];
    UILabel *backLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, getKeyButton.Y + getKeyButton.PART_H + 5, WIDTH, 5)];
    backLoginLabel.textAlignment = NSTextAlignmentCenter;
    backLoginLabel.textColor = [UIColor lightGrayColor];
    backLoginLabel.font = [UIFont systemFontOfSize:13.5];
    [self.getKeyView addSubview:backLoginLabel];
    UIButton *backLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backLoginButton.frame = CGRectMake(20, backLoginLabel.Y + backLoginLabel.PART_H, WIDTH - 40, 44);
    [backLoginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    backLoginButton.backgroundColor = [UIColor whiteColor];
    backLoginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [backLoginButton setTitleColor:DETAILCOLOR forState:UIControlStateNormal];
    [backLoginButton setTitle:@"去登陆" forState:UIControlStateNormal];
    [backLoginButton addTarget:self action:@selector(makeLoginUp) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetView addSubview:backLoginButton];
}

#pragma mark - 登陆页面
- (void)login
{
    self.loginView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loginView.backgroundColor = MAINCOLOR;
    [self.view addSubview:self.loginView];
    
    /*
     * logo
     */
    [self.loginView addSubview:self.logoView];
    
    
    
    UIView *circleWhiteView1 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT / 4, WIDTH-40, 44)];
    circleWhiteView1.clipsToBounds = YES;
    circleWhiteView1.layer.cornerRadius = circleWhiteView1.PART_H/2;
    circleWhiteView1.backgroundColor = [UIColor whiteColor];
    [self.loginView addSubview:circleWhiteView1];
    UIImageView *phonePlaceHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    phonePlaceHolder1.image = [UIImage imageNamed:@"phone.png"];
    [circleWhiteView1 addSubview:phonePlaceHolder1];
    UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine1.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView1 addSubview:verticalLine1];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, HEIGHT / 4, WIDTH-79-20, 50)];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.delegate = self;
    NSString *holderText1 = @"手机";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc]initWithString:holderText1];
    [placeholder1 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:13]
                         range:NSMakeRange(0, holderText1.length)];
    self.phoneTextField.attributedPlaceholder = placeholder1;
    [self.loginView addSubview:self.phoneTextField];
    
    UIView *circleWhiteView2 = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT/4+30+10 + 1 + 25, WIDTH-40, 44)];
    circleWhiteView2.clipsToBounds = YES;
    circleWhiteView2.layer.cornerRadius = circleWhiteView2.PART_H/2;
    circleWhiteView2.backgroundColor = [UIColor whiteColor];
    [self.loginView addSubview:circleWhiteView2];
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT/4+30+10 + 1 + 25, 48 , 30)];
    UIImageView *headPlaceHolder2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
    headPlaceHolder2.image = [UIImage imageNamed:@"key.png"];
    [circleWhiteView2 addSubview:headPlaceHolder2];
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(54, 7, 1, 30)];
    verticalLine2.backgroundColor = PLACEHOLODERCOLOR;
    [circleWhiteView2 addSubview:verticalLine2];
    keyLabel.text = @"密码:";
    keyLabel.textColor = [UIColor lightGrayColor];
    //    [self.loginView addSubview:keyLabel];
    self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, keyLabel.Y, WIDTH - 79-60, 50)];
    NSString *holderText2 = @"密码";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:holderText2];
    [placeholder2 addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:13]
                         range:NSMakeRange(0, holderText2.length)];
    self.keyTextField.attributedPlaceholder = placeholder2;
    // 读取本地手机号和密码
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    // 拼接上要存储的文件路径(前面自动加上/),如果没有此文件系统会自动创建一个
    NSString *fullPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];
    NSString *userPassword = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    if (userPassword.length > 11) {
        NSString *phoneNumber = [userPassword substringToIndex:11];
        self.phoneTextField.text = phoneNumber;
        NSString *password = [userPassword substringFromIndex:11];
        self.keyTextField.text  = password;
    }
    self.keyTextField.secureTextEntry = YES;
    self.keyTextField.delegate = self;
    self.keyTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.loginView addSubview:self.keyTextField];
    UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    eyeButton.frame = CGRectMake(WIDTH - 60, circleWhiteView2.center.y-12.5, 25, 25);
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye.png"] forState:0];
    eyeButton.tag = 1081;
    [eyeButton addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:eyeButton];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(10, keyLabel.Y + keyLabel.PART_H+10, WIDTH - 20, 1)];
    bView.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1];
    //    [self.loginView addSubview:bView];
    
    self.loginButton = [[HyLoglnButton alloc] initWithFrame:CGRectMake(20, bView.Y + bView.PART_H + 50, WIDTH-40, 44)];
    self.loginButton.backgroundColor = DETAILCOLOR;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginView addSubview:self.loginButton];
    // 忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetButton.frame = CGRectMake(WIDTH / 3, HEIGHT-50, WIDTH / 3, 44);
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTintColor:PLACEHOLODERCOLOR];
    [forgetButton addTarget:self action:@selector(makeForgetUp) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:forgetButton];
    
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getButton.frame = CGRectMake(20, self.loginButton.Y + self.loginButton.PART_H + 10, WIDTH-40, 44);
    getButton.backgroundColor = [UIColor whiteColor];
    getButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [getButton setTitle:@"注册" forState:UIControlStateNormal];
    [getButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [getButton addTarget:self action:@selector(makeKeyUp) forControlEvents:UIControlEventTouchUpInside];
    [getButton setTitleColor:DETAILCOLOR forState:UIControlStateNormal];
    [self.loginView addSubview:getButton];
    
    CGFloat buttonWidth = 44;
    // 添加一个在审核期间隐藏第三方登录的设置
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy-MM-dd";
    NSString *currentDate = [formatter1 stringFromDate:[NSDate date]];
    UIView *thirdLineView = [[UIView alloc] initWithFrame:CGRectMake(10, HEIGHT-50-buttonWidth-10-20, WIDTH - 20, 1)];
    if (HEIGHT < 500) {
        thirdLineView.frame = CGRectMake(thirdLineView.X, thirdLineView.Y + 20, thirdLineView.PART_W, thirdLineView.PART_H);
    }
    thirdLineView.backgroundColor = GRAY121COLOR;
    thirdLineView.alpha = 0.3;
    if ([currentDate compare:CHECKPASSTIME]==1) {
        //        [self.loginView addSubview:thirdLineView];
    }
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-80, thirdLineView.Y-9.5, 160, 20)];
    thirdLabel.backgroundColor = [UIColor whiteColor];
    thirdLabel.font = [UIFont systemFontOfSize:12];
    thirdLabel.textColor = GRAY121COLOR;
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.text = @"使用第三方账号登录";
    if ([currentDate compare:CHECKPASSTIME]==1) {
        //        [self.loginView addSubview:thirdLabel];
    }
    
    UIButton *weiChat = [UIButton buttonWithType:UIButtonTypeCustom];
    weiChat.frame = CGRectMake((WIDTH/2-buttonWidth/2)/2-buttonWidth/2, HEIGHT-50-buttonWidth-10, buttonWidth, buttonWidth);
    if (HEIGHT < 500) {
        weiChat.frame = CGRectMake(weiChat.X, weiChat.Y + 10, weiChat.PART_W, weiChat.PART_H);
    }
    [weiChat addTarget:self action:@selector(weiChatAction) forControlEvents:UIControlEventTouchUpInside];
    [weiChat.layer setMasksToBounds:YES];
    [weiChat.layer setCornerRadius:buttonWidth/2];
    [weiChat.layer setBorderWidth:1];
    [weiChat.layer setBorderColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:0.3].CGColor];
    [weiChat setImage:[UIImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
    weiChat.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
    if ([currentDate compare:CHECKPASSTIME]==1) {
        //        [self.loginView addSubview:weiChat];
    }
    UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
    qq.frame = CGRectMake(WIDTH/2-buttonWidth/2, weiChat.Y, buttonWidth, buttonWidth);
    [qq addTarget:self action:@selector(qqAction) forControlEvents:UIControlEventTouchUpInside];
    [qq.layer setMasksToBounds:YES];
    [qq.layer setCornerRadius:buttonWidth/2];
    [qq.layer setBorderWidth:1];
    [qq.layer setBorderColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:0.3].CGColor];
    [qq setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    qq.imageEdgeInsets = UIEdgeInsetsMake(6,6,6,6);
    if ([currentDate compare:CHECKPASSTIME]==1) {
        //        [self.loginView addSubview:qq];
    }
    UIButton *weiBo = [UIButton buttonWithType:UIButtonTypeCustom];
    weiBo.frame = CGRectMake((WIDTH- qq.X- qq.PART_W)/2 + WIDTH/2, weiChat.Y, buttonWidth, buttonWidth);
    [weiBo addTarget:self action:@selector(weiBoAction) forControlEvents:UIControlEventTouchUpInside];
    [weiBo.layer setMasksToBounds:YES];
    [weiBo.layer setCornerRadius:buttonWidth/2];
    [weiBo.layer setBorderWidth:1];
    [weiBo.layer setBorderColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:0.3].CGColor];
    [weiBo setImage:[UIImage imageNamed:@"weiBo.png"] forState:UIControlStateNormal];
    weiBo.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
    if ([currentDate compare:CHECKPASSTIME]==1) {
        //        [self.loginView addSubview:weiBo];
    }
}

#pragma mark - logo
- (UIView *)logoView
{
    UIView *logo = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2-100, 20, 200, HEIGHT/4-20)];
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (logo.PART_H-80)/2, logo.PART_W/4, 80)];
    logoImage.image = [UIImage imageNamed:@"longLogo.png"];
    [logo addSubview:logoImage];
    UILabel *logoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(logo.PART_W/4, (logo.PART_H-50-20)/2, logo.PART_W*3/4, 50)];
    logoLabel1.textColor = [UIColor whiteColor];
    logoLabel1.font = [UIFont boldSystemFontOfSize:35];
    logoLabel1.textAlignment = NSTextAlignmentCenter;
    logoLabel1.text = @"鲑鱼停车";
    [logo addSubview:logoLabel1];
    UILabel *logoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(logo.PART_W/4, logoLabel1.Y+logoLabel1.PART_H, logo.PART_W*3/4, 20)];
    logoLabel2.textColor = [UIColor whiteColor];
    logoLabel2.font = [UIFont systemFontOfSize:12];
    logoLabel2.textAlignment = NSTextAlignmentCenter;
    logoLabel2.text = @"让  鲑  鱼  更  懂  你";
    [logo addSubview:logoLabel2];
    return logo;
}

#pragma mark - 注册验证码
- (void)getTestAction:(UIButton *)button
{
    if (![self.registerPhoneTextField.text checkPhoneNum]) {
        [StateBarMsgView getStateBarMsgView].message = @"请输入正确的手机号";
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@/sendcode/%@/%@", HEADHOST, self.registerPhoneTextField.text, [[UIDevice currentDevice] uniqueDeviceIdentifier]];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:nil success:^(NSData *successData) {
        self.getTestCode = YES;
        [self startTime:self.getTestButton];
    } failure:^(NSData *failureData) {
    }];
}
#pragma mark GCD实现验证码倒计时
- (void)startTime:(UIButton *)button
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            // int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 发起注册请求
- (void)getKeyAction:(UIButton *)button
{
    if (self.getTestCode) {
        button.userInteractionEnabled = NO;
        NSString *str = [NSString stringWithFormat:@"%@/signup", HEADHOST];
        NSDictionary *parameters = @{@"name":self.registerNameTextField.text,@"mobile":self.registerPhoneTextField.text,@"password":self.registerKeyTextField.text, @"code":self.registerTestTextField.text};
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [session POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            button.userInteractionEnabled = YES;
            [self makeLoginUp];
            self.phoneTextField.text = self.registerPhoneTextField.text;
            self.keyTextField.text = self.registerKeyTextField.text;
            MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finish){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [popupView hide];
                });
            };
//            [StateBarMsgView getStateBarMsgView].message = @"注册成功";
            [self successAliHUD:@"注册成功" delay:1.5];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            button.userInteractionEnabled = YES;
            NSData *responseData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (responseData.length>0) {
                id dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            }
            if (responseData.length==0) {
                NSString *message = (NSString *)error.userInfo[@"NSLocalizedDescription"];
                if (message.length>0 && error.code != -1003) {
                    [StateBarMsgView getStateBarMsgView].message = message;
                }
                if (error.code == -1003) {
                    // 找不到指定域名的主机, 通常为域名解析错误
                    NSString *ipUrl = [str stringByReplacingOccurrencesOfString:HEADHOST withString:IPHOST];
                    AFHTTPSessionManager *ipSession = [AFHTTPSessionManager manager];
                    ipSession.requestSerializer = [AFJSONRequestSerializer serializer];
                    ipSession.responseSerializer = [AFHTTPResponseSerializer serializer];
                    [ipSession POST:ipUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        button.userInteractionEnabled = YES;
                        [self makeLoginUp];
                        self.phoneTextField.text = self.registerPhoneTextField.text;
                        self.keyTextField.text = self.registerKeyTextField.text;
                        MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finish){
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [popupView hide];
                            });
                        };
                        [[[MMAlertView alloc] initWithConfirmTitle:@"注册成功" detail:@""] showWithBlock:completeBlock];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        button.userInteractionEnabled = YES;
                        NSData *responseData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        if (responseData.length>0) {
                            id dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                        }
                        if (responseData.length==0) {
                            NSString *message = (NSString *)error.userInfo[@"NSLocalizedDescription"];
                            if (message.length>0 && error.code != -1003) {
//                                [StateBarMsgView getStateBarMsgView].message = message;
                                [self failureAliHUD:message delay:1.5];
                                
                            }
                        }
                    }];
                }
            }
        }];
    }
}

#pragma mark - 点击确认提交
- (void)makeSureAction
{
#pragma mark 记得改这个地方加验证成功提示
//    if (self.forgetTestCode) {
        NSString *str = [NSString stringWithFormat:@"%@/resetpassword", HEADHOST];
        NSDictionary *parameters = @{@"mobile":self.forgetPhoneTextField.text,@"password":self.forgetKeyTextField.text, @"code":self.forgetTestTextField.text};
        [NetHandler putDataWithUrl:str parameters:parameters tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:^(NSData *cachesData) {
        } success:^(NSData *successData) {
            NSLog(@"找回成功%@", successData);
        } failure:^(NSData *failureData) {
            NSLog(@"找回失败%@", failureData);
        }];
//    }
}

#pragma mark - 忘记密码验证码
- (void)getForgetTestAction:(UIButton *)button
{
    if (![self.forgetPhoneTextField.text checkPhoneNum]) {
        [StateBarMsgView getStateBarMsgView].message = @"请输入正确的手机号";
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@/sendcode2/%@/%@", HEADHOST, self.forgetPhoneTextField.text, [[UIDevice currentDevice] uniqueDeviceIdentifier]];
    [NetHandler getDataWithUrl:str parameters:nil tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:nil success:^(NSData *successData) {
        [self startTime:button];
    } failure:^(NSData *failureData) {
    }];
}

UIView *agreeView;
- (void)agreeButtonAction
{
    if (!agreeView) {
        agreeView = [[UIView alloc] initWithFrame:self.view.bounds];
        agreeView.backgroundColor = MAINCOLOR;
        [self.view addSubview:agreeView];
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 27, 30, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrowBack.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:backButton];
    
    UILabel *agreeTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-60, 20, 120, 40)];
    agreeTitle.textColor = [UIColor whiteColor];
    agreeTitle.textAlignment = NSTextAlignmentCenter;
    agreeTitle.text = @"用户注册协议";
    [agreeView addSubview:agreeTitle];
    
    UITextView *agreeText = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    agreeText.editable = NO;
    NSString *txtPath=[[NSBundle mainBundle] pathForResource:@"registerRule" ofType:@"txt"];
    agreeText.text = [NSString stringWithContentsOfFile:txtPath usedEncoding:0 error:nil];
    [agreeView addSubview:agreeText];
}

- (void)backAction
{
    if (agreeView) {
        [agreeView removeFromSuperview];
        agreeView = nil;
    }
}

#pragma mark - 把注册页面拿到最上方
- (void)makeKeyUp
{
    [self.view bringSubviewToFront:self.getKeyView];
}
- (void)makeForgetUp
{
    [self.view bringSubviewToFront:self.forgetView];
}
- (void)makeLoginUp
{
    [self.view bringSubviewToFront:self.loginView];
}

#pragma mark - 随便看看
- (void)casualAction
{
    [self dismissModalViewControllerAnimated:YES];
//    [self removeFromParentViewController];
//    [self.view removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.keyTextField resignFirstResponder];
    [self.registerNameTextField resignFirstResponder];
    [self.registerPhoneTextField resignFirstResponder];
    [self.registerKeyTextField resignFirstResponder];
    [self.registerTestTextField resignFirstResponder];
    [self.forgetPhoneTextField resignFirstResponder];
    [self.forgetKeyTextField resignFirstResponder];
    [self.forgetTestTextField resignFirstResponder];
}

#pragma mark - 获取登录信息
- (void)loginAction:(HyLoglnButton *)button
{
    NSString *str = [NSString stringWithFormat:@"%@/login", HEADHOST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text, @"mobile", self.keyTextField.text, @"password", nil];
//    [NetHandler postDataWithUrl:str parameters:parameters tokenKey:@"" tokenValue:@"" ifCaches:NO cachesData:nil success:^(AFHTTPRequestOperation *operation) {
//    } failure:^(AFHTTPRequestOperation *operation) {
//    }];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [button ExitAnimationCompletion:^{
            self.haveSuccessdeLogin = YES;
            NSString *str = [NSString stringWithFormat:@"%@%@", self.phoneTextField.text, self.keyTextField.text];
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
            NSString *fullPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];// 存储用户名密码的路径
            NSString *fullPath2 = [documentsPath stringByAppendingPathComponent:@"aa2.txt"];// 存储token的路径
            [str writeToFile:fullPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
              [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@", [responseObject objectForKey:@"token_type"], [responseObject objectForKey:@"access_token"]] forKey:@"token"];
            [JSESSIONID getJSESSIONID].token = [NSString stringWithFormat:@"%@ %@", [responseObject objectForKey:@"token_type"], [responseObject objectForKey:@"access_token"]];
            [self casualAction];
            if (self.personBlock != nil) {
                self.personBlock(@"1");
            }
            [[JSESSIONID getJSESSIONID].token writeToFile:fullPath2 atomically:NO encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"登陆成功%@", responseObject);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != -1003) {
            [button ErrorRevertAnimationCompletion:nil];
        }
        NSData *responseData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (responseData>0) {
            NSString *message = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
            message = [[message stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
            NSRange range;
            range = [message rangeOfString:@":"];
            if (range.location != NSNotFound) {
                message = [message substringFromIndex:range.location+1];
            }
            if (message.length>0) {
//                [[[MMAlertView alloc] initWithConfirmTitle:@"错误" detail:message] showWithBlock:nil];
                [self failureAliHUD:message delay:1.5];
            }
            return;
        }
        if (responseData.length==0) {
            NSString *message = (NSString *)error.userInfo[@"NSLocalizedDescription"];
            if (message.length>0 && error.code != -1003) {
                [StateBarMsgView getStateBarMsgView].message = message;
            }
            if (error.code == -1003) {
                // 找不到指定域名的主机, 通常为域名解析错误
                NSString *ipUrl = [str stringByReplacingOccurrencesOfString:HEADHOST withString:IPHOST];
                AFHTTPSessionManager *ipSession = [AFHTTPSessionManager manager];
                ipSession.requestSerializer = [AFJSONRequestSerializer serializer];
                ipSession.responseSerializer = [AFJSONResponseSerializer serializer];
                [ipSession POST:ipUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [button ExitAnimationCompletion:^{
                        self.haveSuccessdeLogin = YES;
                        NSString *str = [NSString stringWithFormat:@"%@%@", self.phoneTextField.text, self.keyTextField.text];
                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
                        NSString *fullPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];// 存储用户名密码的路径
                        NSString *fullPath2 = [documentsPath stringByAppendingPathComponent:@"aa2.txt"];// 存储token的路径
                        [str writeToFile:fullPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
                          [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@", [responseObject objectForKey:@"token_type"], [responseObject objectForKey:@"access_token"]] forKey:@"token"];
                        [JSESSIONID getJSESSIONID].token = [NSString stringWithFormat:@"%@ %@", [responseObject objectForKey:@"token_type"], [responseObject objectForKey:@"access_token"]];
                        [self casualAction];
                        if (self.personBlock != nil) {
                            self.personBlock(@"1");
                        }
                        [[JSESSIONID getJSESSIONID].token writeToFile:fullPath2 atomically:NO encoding:NSUTF8StringEncoding error:nil];
                        NSLog(@"登陆成功%@", responseObject);
                    }];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [button ErrorRevertAnimationCompletion:nil];
                    NSData *responseData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (responseData>0) {
                        NSString *message = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
                        message = [[message stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
                        NSRange range;
                        range = [message rangeOfString:@":"];
                        if (range.location != NSNotFound) {
                            message = [message substringFromIndex:range.location+1];
                        }
                        if (message.length>0) {
//                            [[[MMAlertView alloc] initWithConfirmTitle:@"错误" detail:message] showWithBlock:nil];
                            [self failureAliHUD:message delay:1.5];
                        }
                        return;
                    }
                    if (responseData.length==0) {
                        NSString *message = (NSString *)error.userInfo[@"NSLocalizedDescription"];
                        if (message.length>0 && error.code != -1003) {
                            [StateBarMsgView getStateBarMsgView].message = message;
                        }
                    }
                }];
            }
        }
    }];
    [self.phoneTextField resignFirstResponder];
    [self.keyTextField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    self.getTestButton.backgroundColor = self.registerPhoneTextField.text.length == 11?[UIColor clearColor]:PLACEHOLODERCOLOR;
    self.forgetTestButton.backgroundColor = self.forgetPhoneTextField.text.length == 11?[UIColor clearColor]:PLACEHOLODERCOLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.loginView.frame = CGRectMake(0, - HEIGHT / 8 + 30, WIDTH, HEIGHT + HEIGHT / 8 - 30);
    self.getKeyView.frame = CGRectMake(0, - HEIGHT / 8 + 30, WIDTH, HEIGHT + HEIGHT / 8 - 30);
    self.forgetView.frame = CGRectMake(0, - HEIGHT / 8 + 30, WIDTH, HEIGHT + HEIGHT / 8 - 30);
}

#pragma mark - 当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.loginView.frame = self.view.bounds;
    self.getKeyView.frame = self.view.bounds;
    self.forgetView.frame = self.view.bounds;
}

#pragma mark - 微信登录
- (void)weiChatAction
{
    /*
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n\n usid = %@,\n\n token = %@,\n\n iconUrl = %@,\n\n unionId = %@,\n\n thirdPlatformUserProfile = %@,\n\n thirdPlatformResponse = %@ \n\n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
//            [[[MMAlertView alloc] initWithConfirmTitle:@"获得微信登录授权" detail:[NSString stringWithFormat:@"昵称:%@\n openid:%@\n unionId:%@\n accessToken:%@\n 头像:%@",snsAccount.userName,snsAccount.usid,snsAccount.unionId,snsAccount.accessToken,snsAccount.iconURL]]showWithBlock:nil];
            
            NSNumber *gender = [NSNumber numberWithInteger:0];
            if ([[response.thirdPlatformUserProfile objectForKey:@"sex"] integerValue] ==1) {
                gender = [NSNumber numberWithInteger:1];
            }
            if ([[response.thirdPlatformUserProfile objectForKey:@"sex"] integerValue] ==2) {
                gender = [NSNumber numberWithInteger:2];
            }
            NSDictionary *thirdInfo = @{@"name":snsAccount.userName, @"id":snsAccount.usid, @"from":@"wechat",@"gender":gender,@"avatar":snsAccount.iconURL};
            [self thirdLogin:thirdInfo];
        }
    });
    if ([snsPlatform.platformName isEqualToString:UMShareToWechatSession]) {
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *respose){
            NSLog(@"get openid  response is %@",respose);
        }];
    }
     */
    
}

#pragma mark - QQ登录
- (void)qqAction
{
    /*
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = UMShareToQzone;
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            NSLog(@"username is %@, uid is %@, token is %@, iconUrl is %@, thirdPlatformResponse = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, response.thirdPlatformUserProfile);
//            [[[MMAlertView alloc] initWithConfirmTitle:@"获得QQ登录授权" detail:[NSString stringWithFormat:@"昵称:%@\n userid:%@\n token:%@\n 头像:%@",snsAccount.userName,snsAccount.usid, snsAccount.accessToken,snsAccount.iconURL]]showWithBlock:nil];
            
            NSNumber *gender = [NSNumber numberWithInteger:0];
            if ([[response.thirdPlatformUserProfile objectForKey:@"gender"] isEqualToString:@"男"]) {
                gender = [NSNumber numberWithInteger:1];
            }
            if ([[response.thirdPlatformUserProfile objectForKey:@"gender"] isEqualToString:@"女"]) {
                gender = [NSNumber numberWithInteger:2];
            }
            NSDictionary *thirdInfo = @{@"name":snsAccount.userName, @"id":snsAccount.usid, @"from":@"qq",@"gender":gender,@"avatar":snsAccount.iconURL};
            [self thirdLogin:thirdInfo];
        }
        //这里可以获取到腾讯微博openid,Qzone的token等
     
         if ([platformName isEqualToString:UMShareToTencent]) {
         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
         NSLog(@"get openid  response is %@",respose);
         }];
         }
     
    });
      */
}
#pragma mark - 微博登录
- (void)weiBoAction
{
    /*
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = UMShareToSina;
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            NSLog(@"username is %@, uid is %@, token is %@, iconUrl is %@, thirdPlatformResponse = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,response.thirdPlatformUserProfile);
//            [[[MMAlertView alloc] initWithConfirmTitle:@"获得微博登录授权" detail:[NSString stringWithFormat:@"昵称:%@\n userid:%@\n token:%@\n 头像:%@",snsAccount.userName,snsAccount.usid, snsAccount.accessToken,snsAccount.iconURL]]showWithBlock:nil];
            
            NSNumber *gender = [NSNumber numberWithInteger:0];
            if ([[response.thirdPlatformUserProfile valueForKey:@"gender"] isEqualToString:@"m"]) {
                gender = [NSNumber numberWithInteger:1];
            }
            if ([[response.thirdPlatformUserProfile valueForKey:@"gender"] isEqualToString:@"f"]) {
                gender = [NSNumber numberWithInteger:2];
            }
            NSDictionary *thirdInfo = @{@"name":snsAccount.userName, @"id":snsAccount.usid, @"from":@"weibo",@"gender":gender,@"avatar":snsAccount.iconURL};
            [self thirdLogin:thirdInfo];
        }
        //这里可以获取到腾讯微博openid,Qzone的token等
     
         if ([platformName isEqualToString:UMShareToTencent]) {
         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
         NSLog(@"get openid  response is %@",respose);
         }];
         }
     
    });
     */
}

- (void)thirdLogin:(NSDictionary *)thirdInfo
{
    NSString *str = [NSString stringWithFormat:@"%@/access", HEADHOST];
    if ([JSESSIONID getJSESSIONID].token.length<=0) {
        return;
    }
    [NetHandler postDataWithUrl:str parameters:thirdInfo tokenKey:@"Authorization" tokenValue:[JSESSIONID getJSESSIONID].token ifCaches:NO cachesData:nil success:^(NSData *successData) {
        self.haveSuccessdeLogin = YES;
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
        NSString *fullPath2 = [documentsPath stringByAppendingPathComponent:@"aa2.txt"];// 存储token的路径
        [self casualAction];
        id dict = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
          [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"token_type"], [dict objectForKey:@"access_token"]] forKey:@"token"];
        [JSESSIONID getJSESSIONID].token = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"token_type"], [dict objectForKey:@"access_token"]];
        if (self.personBlock != nil) {
            self.personBlock(@"1");
        }
        [[JSESSIONID getJSESSIONID].token writeToFile:fullPath2 atomically:NO encoding:NSUTF8StringEncoding error:nil];
    } failure:^(NSData *failureData) {
    }];
}

- (void)eyeAction:(UIButton *)button
{
    if (button.tag == 1080) {
        self.registerKeyTextField.secureTextEntry = !self.registerKeyTextField.secureTextEntry;
        UIImage *image = self.registerKeyTextField.secureTextEntry?[UIImage imageNamed:@"eye.png"]:[UIImage imageNamed:@"shutEye.png"];
        [button setBackgroundImage:image forState:0];
    }
    if (button.tag == 1081) {
        self.keyTextField.secureTextEntry = !self.keyTextField.secureTextEntry;
        UIImage *image = self.keyTextField.secureTextEntry?[UIImage imageNamed:@"eye.png"]:[UIImage imageNamed:@"shutEye.png"];
        [button setBackgroundImage:image forState:0];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
