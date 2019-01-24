//
//  ICAlarmView.m
//  AlarmView
//
//  Created by CSX on 2017/3/15.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ICAlarmView.h"
#import "NSString+Extends.h"

//告警框宽度
#define ALARM_WITH 320-40
//内容距离边距
#define CONTENT_DIS 20

#define KMAINBOUNDS  [UIScreen mainScreen].bounds

//竖向每个点击按钮的高度
#define BTNHEIGHT  40

//label的字号大小
#define TitleFont [UIFont systemFontOfSize:15]

typedef enum :NSInteger{
    btnTag = 10000000,
}buttonTags;

@interface ICAlarmView () {
    //输入文本
    UITextField *textfield;
    //z记录最大的高度
    CGFloat max_Content;
    //动画的间隔时间
    NSTimeInterval interval;
}
//白色框背景view
@property (nonatomic, strong)UIView *bgView;
//设置message内容显示的
@property (nonatomic, assign)NSTextAlignment stateType;
//message动画循环的次数
@property (nonatomic, assign)int messageCount;
@end

@implementation ICAlarmView

- (void)createTitleWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    CGSize size = [label sizeThatFits:CGSizeMake(ALARM_WITH-2*CONTENT_DIS, 0)];
    label.frame = CGRectMake(CONTENT_DIS, 10, ALARM_WITH-2*CONTENT_DIS, size.height);
    label.textAlignment = 1;
    [self.bgView addSubview:label];
    max_Content = CGRectGetMaxY(label.frame)+10;
}

//显示单个message内容显示
- (void)createViewWithTitle:(NSString *)title andMessage:(NSString *)message andIsContentTextfield:(BOOL)isContent{
    [self createTitleWithTitle:title];
    if (message.length>0) {
        UILabel *mess_label = [[UILabel alloc]init];
        mess_label.font = TitleFont;
        mess_label.text = message;
        mess_label.textColor = [UIColor grayColor];
        mess_label.textAlignment = self.stateType;
        mess_label.numberOfLines = 0;
        CGSize sizeMes = [mess_label.text sizeWithFont:TitleFont maxW:ALARM_WITH-2*CONTENT_DIS];
        mess_label.frame = CGRectMake(CONTENT_DIS, max_Content, ALARM_WITH-2*CONTENT_DIS, sizeMes.height);
        [self.bgView addSubview:mess_label];
        max_Content = CGRectGetMaxY(mess_label.frame)+10;
    }else{
        if (isContent) {     //这里有需要可以使用textview替代
            textfield = [[UITextField alloc]initWithFrame:CGRectMake(CONTENT_DIS, max_Content, ALARM_WITH-2*CONTENT_DIS, 40)];
            textfield.borderStyle = UITextBorderStyleRoundedRect;
            [self.bgView addSubview:textfield];
            max_Content = CGRectGetMaxY(textfield.frame)+10;
        }
    }
}

//显示多个动画显示message内容
- (void)createAnimationViewWithTitle:(NSString *)title andMessageArr:(NSArray *)messageArr {
    [self createTitleWithTitle:title];
    CGFloat nowHeight = max_Content;
    for (int i = 0; i < messageArr.count; i++) {
        NSDictionary *tempDic = messageArr[i];
        NSString *str = tempDic[@"content"];
        CGSize sizeMes = [str sizeWithFont:TitleFont maxW:ALARM_WITH-2*CONTENT_DIS];
        if (sizeMes.height < 23) {
            sizeMes = CGSizeMake(sizeMes.width, 23);
        }
        max_Content += sizeMes.height+3;
    }
    max_Content += 20;
    [self showAnimationMessageWithMessageArr:messageArr begainY:nowHeight];
}

- (void)showAnimationMessageWithMessageArr:(NSArray *)messageArr begainY:(CGFloat)begainY {
    self.messageCount += 1;
    //创建显示label； 修改begainy
    //动画一
    __block CGFloat NowY = begainY;
    NSDictionary *tempDic = messageArr[self.messageCount-1];
    
    UIView *cellView = [[UIView alloc]init];
    cellView.alpha = 0.0;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(CONTENT_DIS, 0, 60, 23);
    titleLabel.text = tempDic[@"title"];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = TitleFont;
    titleLabel.textAlignment = self.stateType;
    [cellView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = tempDic[@"content"];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = TitleFont;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = self.stateType;
    CGSize sizeMes = [contentLabel.text sizeWithFont:TitleFont maxW:ALARM_WITH-2*CONTENT_DIS-70];
    if (sizeMes.height < 23) {
        sizeMes = CGSizeMake(sizeMes.width, 23);
    }
    contentLabel.frame = CGRectMake(CONTENT_DIS+70, 0, ALARM_WITH-2*CONTENT_DIS-70, sizeMes.height);
    [cellView addSubview:contentLabel];
    
    cellView.frame = CGRectMake(0, NowY, ALARM_WITH-2*CONTENT_DIS, sizeMes.height);
    [self.bgView addSubview:cellView];
    
    NowY = CGRectGetMaxY(cellView.frame)+3;
    [UIView animateWithDuration:interval animations:^{
        cellView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.messageCount >= messageArr.count) {
            return;
        }else {
            [self showAnimationMessageWithMessageArr:messageArr begainY:NowY];
        }
    });
    
    
//    //动画二
//    UILabel *label = [[UILabel alloc] init];
//    label.text = messageArr[messageCount-1];
//    label.textColor = [UIColor grayColor];
//    label.font = TitleFont;
//    label.numberOfLines = 0;
//    label.textAlignment = self.stateType;
//    CGSize sizeMes = [label.text sizeWithFont:TitleFont maxW:ALARM_WITH-2*CONTENT_DIS];
//    label.frame = CGRectMake(CONTENT_DIS, begainY, ALARM_WITH-2*CONTENT_DIS, sizeMes.height);
//    [self.bgView addSubview:label];
//    begainY = CGRectGetMaxY(label.frame)+3;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (messageCount >= messageArr.count) {
//            return;
//        }else {
//            [self showAnimationMessageWithMessageArr:messageArr begainY:begainY];
//        }
//    });
}

- (void)buttonTitleArr:(NSArray *)titleArr btnColors:(NSArray *)btnColors andIsVertical:(BOOL)isVertical{
    if (titleArr.count>0) {
        UIView *btnBgView;
        if (isVertical) {
            //竖列排布button
            btnBgView = [self verticalButtonViewBackWithTitleArr:titleArr btnColors:btnColors];
        }else{
            //横列排布button       可以在此添加一个判断，当数组元素大于多少的时候让它数列排布
            btnBgView = [self horizonButtonViewBackWithTitleArr:titleArr btnColors:btnColors];
        }
        btnBgView.frame = CGRectMake(0, max_Content, btnBgView.frame.size.width, btnBgView.frame.size.height);
        [self.bgView addSubview:btnBgView];
        self.bgView.bounds = CGRectMake(0, 0, ALARM_WITH, CGRectGetMaxY(btnBgView.frame));
    }else{
        self.bgView.bounds = CGRectMake(0, 0, ALARM_WITH, max_Content);
    }
    [self addSubview:self.bgView];
}

//竖列button的排布
- (UIView *)verticalButtonViewBackWithTitleArr:(NSArray *)titleArr btnColors:(NSArray *)btnColors{
    UIView *btnBgView = [[UIView alloc]init];
    btnBgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    btnBgView.frame = CGRectMake(0, 0, ALARM_WITH, BTNHEIGHT*titleArr.count);
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myCreateButton.frame = CGRectMake(0, 1+BTNHEIGHT*i, btnBgView.frame.size.width, BTNHEIGHT-1);
        [myCreateButton setBackgroundColor:[UIColor whiteColor]];
        [myCreateButton setTitle:titleArr[i] forState:UIControlStateNormal];
        UIColor *titleColor = [UIColor grayColor];
        if (i < btnColors.count) {
            titleColor = btnColors[i];
        }
        [myCreateButton setTitleColor:titleColor forState:UIControlStateNormal];
        [myCreateButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        myCreateButton.tag = btnTag+i;
        [myCreateButton addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:myCreateButton];
    }
    return btnBgView;
}


//横向button排布。       button按钮的高度这里取50，如有需要自行修改
- (UIView *)horizonButtonViewBackWithTitleArr:(NSArray *)titleArr btnColors:(NSArray *)btnColors{
    UIView *btnBgView = [[UIView alloc]init];
    btnBgView.frame = CGRectMake(0, 0, ALARM_WITH, 50);
    btnBgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    CGFloat cellWidth = btnBgView.frame.size.width/titleArr.count;
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myCreateButton.frame = CGRectMake(cellWidth*i, 1, cellWidth-1, btnBgView.frame.size.height-1);
        [myCreateButton setBackgroundColor:[UIColor whiteColor]];
        [myCreateButton setTitle:titleArr[i] forState:UIControlStateNormal];
        UIColor *titleColor = [UIColor grayColor];
        if (i < btnColors.count) {
            titleColor = btnColors[i];
        }
        [myCreateButton setTitleColor:titleColor forState:UIControlStateNormal];
        [myCreateButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        myCreateButton.tag = btnTag+i;
        [myCreateButton addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:myCreateButton];
    }
    return btnBgView;
}

- (void)buttonChoose:(UIButton *)sender{
    NSInteger index = sender.tag-btnTag;
    NSString *titleStr = nil;
    if (textfield) {
        titleStr = textfield.text;
    }
    //这里做点击返回处理
    if (self.alartBlock) {
        self.alartBlock(index, titleStr);
    }
    
    if (self.delegate) {
        [self.delegate alertView:self clickedButtonAtIndex:index];
        if (textfield) {
            [self.delegate alertView:self clickedButtonAtIndex:index andWithContentStr:titleStr];
        }
    }
    [self removeFromSuperview];
}

//颜色转背景图片
- (UIImage *)imageWithColor:(UIColor *)color{
        CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage;  
}

+ (instancetype)alarmWithTitle:(NSString *)title message:(NSString *)message messageType:(NSTextAlignment)state delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical andIsContentTextfield:(BOOL)isContent{
    return [[self alloc]initWithAlarmWithTitle:title message:message  messageType:state delegate:object btnTitles:titleArr btnColors:btnColors andButtonStateIsVertica:isVertical andIsContentTextfield:isContent];
}
- (instancetype)initWithAlarmWithTitle:(NSString *)title message:(NSString *)message messageType:(NSTextAlignment)state delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical andIsContentTextfield:(BOOL)isContent {
    self = [super initWithFrame:CGRectMake(0, 0, KMAINBOUNDS.size.width , KMAINBOUNDS.size.height)];
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
    self.stateType = state;
    max_Content = 0;
    if (self) {
        self.delegate = object;
        [self createViewWithTitle:title andMessage:message andIsContentTextfield:isContent];
        [self buttonTitleArr:titleArr btnColors:btnColors andIsVertical:isVertical];
    }
    return self;
}


+ (instancetype)alarmWithAnimationTitle:(NSString *)title messageArr:(NSArray *)messageArr messageType:(NSTextAlignment)state timeInterval:(NSTimeInterval)timeInterval delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical {
    return [[self alloc]initWithAnimationAlarmWithTitle:title messageArr:messageArr messageType:state timeInterval:timeInterval delegate:object btnTitles:titleArr btnColors:btnColors andButtonStateIsVertica:isVertical];
}
- (instancetype)initWithAnimationAlarmWithTitle:(NSString *)title messageArr:(NSArray *)messageArr messageType:(NSTextAlignment)state timeInterval:(NSTimeInterval)timeInterval delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical {
    self = [super initWithFrame:CGRectMake(0, 0, KMAINBOUNDS.size.width , KMAINBOUNDS.size.height)];
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
    self.stateType = state;
    max_Content = 0;
    interval = timeInterval;
    self.messageCount = 0;
    if (self) {
        self.delegate = object;
        [self createAnimationViewWithTitle:title andMessageArr:messageArr];
        [self buttonTitleArr:titleArr btnColors:btnColors andIsVertical:isVertical];
    }
    return self;
}

- (void)show{
    UIWindow *keyv=[[UIApplication sharedApplication] keyWindow];
    [keyv addSubview:self];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.center = CGPointMake(KMAINBOUNDS.size.width/2, KMAINBOUNDS.size.height/2);
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
