//
//  NSObject+ALiHUD.m
//  ALiProgressHUD
//
//  Created by LeeWong on 16/9/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "NSObject+ALiHUD.h"
#import "SVProgressHUD.h"
#import "ALiProgressHUD.h"


@implementation NSObject (ALiHUD)

- (void)showText:(NSString *)aText
{
    [ALiProgressHUD showWithStatus:aText];
}


- (void)showErrorText:(NSString *)aText
{
    [ALiProgressHUD showErrorWithStatus:aText];
}

- (void)showSuccessText:(NSString *)aText
{
    [ALiProgressHUD showSuccessWithStatus:aText];
}

- (void)showLoading
{
    [ALiProgressHUD show];
}

- (void)dismissLoading
{
    [ALiProgressHUD dismiss];
}

- (void)showProgress:(NSInteger)progress
{
    [ALiProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

- (void)showImage:(UIImage*)image text:(NSString*)aText
{
    [ALiProgressHUD showImage:image status:aText];
}

////////////delay秒后消失
- (void)loadingAliHUD:(CGFloat)delay {
    [ALiProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ALiProgressHUD dismiss];
    });
}

- (void)normalAliHUD:(NSString *)aText delay:(CGFloat)delay {
    [ALiProgressHUD showWithStatus:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ALiProgressHUD dismiss];
    });
}

- (void)failureAliHUD:(NSString *)aText delay:(CGFloat)delay {
    [ALiProgressHUD showErrorWithStatus:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ALiProgressHUD dismiss];
    });
}

- (void)successAliHUD:(NSString *)aText delay:(CGFloat)delay {
    [ALiProgressHUD showSuccessWithStatus:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ALiProgressHUD dismiss];
    });
}

- (void)percentAliHUD {
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(showPercent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)imageAliHUD:(NSString *)aText delay:(CGFloat)delay {
    [ALiProgressHUD showImage:[UIImage imageNamed:@"emj"] status:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ALiProgressHUD dismiss];
    });
}

- (void)showPercent
{
    self.percent += 5;
    [ALiProgressHUD showProgress:self.percent/100.0 status:[NSString stringWithFormat:@"%li%%",(long)self.percent]];
    if (self.percent == 100) {
        [self.timer invalidate];
        self.timer = nil;
        [ALiProgressHUD dismiss];
    }
}

@end
