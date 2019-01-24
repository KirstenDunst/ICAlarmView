//
//  ViewController.m
//  AlarmView
//
//  Created by CSX on 2017/3/15.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ViewController.h"
#import "ICAlarmView.h"

@interface ViewController ()<ICAlarmViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myCreateButton.frame = CGRectMake(0, 0, 100, 100);
    [myCreateButton setBackgroundColor:[UIColor grayColor]];
    [myCreateButton setTitle:@"Choose" forState:UIControlStateNormal];
    [myCreateButton addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCreateButton];
    
}

- (void)buttonChoose:(UIButton *)sender{
    //提醒消息显示
//    ICAlarmView *alermView = [ICAlarmView alarmWithTitle:@"请输入密码" message:@"卡拉斯啊是阔贝洛夫来的快吧发布你的房间看吧女出版年出版 v 艰苦奋斗报告放荡不羁发吧解放碑 v手动奉公守法的方法等\n\n卡拉斯啊是阔贝洛夫来的快吧发布你的房间看吧女出版年出版 v 艰苦奋斗报告放荡不羁发吧解放碑 v手动奉公守法的方法等" messageType:NSTextAlignmentLeft delegate:self btnTitles:@[@"其他",@"测试",@"other"].copy btnColors:@[[UIColor redColor],[UIColor redColor],[UIColor redColor]].copy andButtonStateIsVertica:NO andIsContentTextfield:NO];
    
    //带输入框的弹出框显示
//    ICAlarmView *alermView = [ICAlarmView alarmWithTitle:@"请输入密码" message:@"" messageType:NSTextAlignmentLeft delegate:self btnTitles:@[@"其他",@"测试",@"other"].copy btnColors:@[[UIColor redColor],[UIColor redColor],[UIColor redColor]].copy andButtonStateIsVertica:NO andIsContentTextfield:YES];
    
    NSArray *tempArr = @[@{@"title":@"姓名",@"content":@"曹世鑫"},@{@"title":@"手机号",@"content":@"15036142573"},@{@"title":@"性别",@"content":@"男"},@{@"title":@"地址",@"content":@"杭州首展科技"},@{@"title":@"测试",@"content":@"你猜猜看"}];
    //动画显示图片
    ICAlarmView *alermView = [ICAlarmView alarmWithAnimationTitle:@"标题内容" messageArr:tempArr messageType:NSTextAlignmentLeft timeInterval:0.4 delegate:self btnTitles:@[@"取消",@"去验证"] btnColors:@[[UIColor redColor],[UIColor redColor]] andButtonStateIsVertica:NO];
    
    [self.view addSubview:alermView];
    
}

#pragma mark-------------------ICAlarmViewDelegate方法
- (void)alertView:(ICAlarmView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"<<<<<<%ld",buttonIndex);
}

- (void)alertView:(ICAlarmView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andWithContentStr:(NSString *)text{
    NSLog(@">>>>>>>>%ld>>>>>>>%@",buttonIndex,text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
