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
//    ICAlarmView *alermView = [ICAlarmView alarmWithTitle:@"请输入密码" message:@"卡拉斯京规划接口数量分别 v 啊数据的哈世界第八接收代购哈白色的俱乐部嘎介绍东莞巴士单机版 v 成功把接口势单力薄 v 风景阿里斯顿科技部佛教萨的脸部肌肤可不是 v 啊独立思考就把接口被流感病毒数据库啦思考就把 v 就撒开了饭" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"其他",@"测试",@"other"].copy andButtonStateIsVertica:NO andIsContentTextfield:NO];
    
    //带输入框的弹出框显示
    ICAlarmView *alermView = [ICAlarmView alarmWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"其他",@"other"].copy andButtonStateIsVertica:NO andIsContentTextfield:YES];
    
    
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
