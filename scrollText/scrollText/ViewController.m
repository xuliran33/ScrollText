//
//  ViewController.m
//  scrollText
//
//  Created by gdj003 on 16/5/16.
//  Copyright (c) 2016年 xuliran. All rights reserved.
//

#import "ViewController.h"
#import "SAdView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@"111111111111", @"222222222222", @"3333333333", @"44444444444444"];
    
    SAdView *view = [[SAdView alloc] initWithTitles:array];
    view.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    view.textAlignment = NSTextAlignmentLeft;
    view.labelFont = [UIFont systemFontOfSize:17];
    view.color = [UIColor redColor];
    view.time = 2.0f;
    
    // 创建block匿名函数之前一般要对self进行weak化, 否则造成循环引用, 无法释放controller
    __weak typeof(self) weakself = self;
    view.isHaveTouchEvent = YES;
    view.clickAdBlock = ^(NSInteger index){
        NSLog(@"%ld", (long)index);
    };
    
    
    [self.view addSubview:view];
    
    [view beginScroll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
