//
//  RecommendViewController.m
//  Travel_ios
//
//  Created by 李云鹏 on 17/5/12.
//  Copyright © 2017年 yunPeng. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getView];
}

- (void)getView
{
    self.navigationItem.title = @"社区";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
