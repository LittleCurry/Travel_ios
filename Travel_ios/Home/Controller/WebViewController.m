//
//  WebViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/15.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic ,retain) MBProgressHUD *hud;

@end

@implementation WebViewController

#pragma mark - Life Cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    [self.view addSubview:self.webView];
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.hud == nil) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    [self.view addSubview:self.hud];
    self.hud.labelFont = WORDFONT;
    self.hud.labelText = @"Loading";
    [self.hud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud removeFromSuperview];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.hud.labelText = @"抱歉,加载失败";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
