//
//  ICAlarmView.m
//  AlarmView
//
//  Created by CSX on 2017/3/15.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ICAlarmView.h"

//告警框宽度
#define ALARM_WITH 320-40
//内容距离边距
#define CONTENT_DIS 20

#define KMAINBOUNDS  [UIScreen mainScreen].bounds

//竖向每个点击按钮的高度
#define BTNHEIGHT  40

typedef enum :NSInteger{
    btnTag = 10000000,
}buttonTags;

@interface ICAlarmView () {
    //白色框背景view
    UIView *bgView;
    //输入文本
    UITextField *textfield;
    //
    CGFloat max_Content;
}
@property(nonatomic , strong)NSMutableArray *buttonTitleArr;
//设置message内容显示的
@property (nonatomic, assign)NSTextAlignment stateType;
@end

@implementation ICAlarmView

- (NSMutableArray *)buttonTitleArr{
    if (!_buttonTitleArr) {
        _buttonTitleArr = [NSMutableArray array];
    }
    return _buttonTitleArr;
}

- (void)createViewWithTitle:(NSString *)title andMessage:(NSString *)message andIsContentTextfield:(BOOL)isContent{
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
    
    bgView = [[UIView alloc]init];
    bgView.center = CGPointMake(KMAINBOUNDS.size.width/2, KMAINBOUNDS.size.height/2);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    CGSize size = [label sizeThatFits:CGSizeMake(ALARM_WITH-2*CONTENT_DIS, 0)];
    label.frame = CGRectMake(CONTENT_DIS, 10, ALARM_WITH-2*CONTENT_DIS, size.height);
    label.textAlignment = 1;
    [bgView addSubview:label];
    max_Content = CGRectGetMaxY(label.frame)+10;
    
    if (message.length>0) {
        UILabel *mess_label = [[UILabel alloc]init];
        mess_label.font = [UIFont systemFontOfSize:15];
        mess_label.text = message;
        mess_label.textColor = [UIColor grayColor];
        mess_label.textAlignment = self.stateType;
        mess_label.numberOfLines = 0;
        CGSize sizeMes = [mess_label sizeThatFits:CGSizeMake(ALARM_WITH-2*CONTENT_DIS, 0)];
        mess_label.frame = CGRectMake(CONTENT_DIS, max_Content, ALARM_WITH-2*CONTENT_DIS, sizeMes.height);
        [bgView addSubview:mess_label];
        max_Content = CGRectGetMaxY(mess_label.frame)+10;
    }else{
        if (isContent) {     //这里有需要可以使用textview替代
            textfield = [[UITextField alloc]initWithFrame:CGRectMake(CONTENT_DIS, max_Content, ALARM_WITH-2*CONTENT_DIS, 40)];
            textfield.borderStyle = UITextBorderStyleRoundedRect;
            [bgView addSubview:textfield];
            max_Content = CGRectGetMaxY(textfield.frame)+10;
        }
    }
}

- (void)buttonTitleArr:(NSMutableArray *)titleArr btnColors:(NSArray *)btnColors andIsVertical:(BOOL)isVertical{
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
        [bgView addSubview:btnBgView];
        bgView.bounds = CGRectMake(0, 0, ALARM_WITH, CGRectGetMaxY(btnBgView.frame));
    }else{
        bgView.bounds = CGRectMake(0, 0, ALARM_WITH, max_Content);
    }
    [self addSubview:bgView];
}

//竖列button的排布
- (UIView *)verticalButtonViewBackWithTitleArr:(NSMutableArray *)titleArr btnColors:(NSArray *)btnColors{
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
- (UIView *)horizonButtonViewBackWithTitleArr:(NSMutableArray *)titleArr btnColors:(NSArray *)btnColors{
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
    if (self) {
        self.delegate = object;
        [self createViewWithTitle:title andMessage:message andIsContentTextfield:isContent];
        if (titleArr.count>0) {
            [self.buttonTitleArr addObjectsFromArray:titleArr];
        }
        [self buttonTitleArr:self.buttonTitleArr btnColors:btnColors andIsVertical:isVertical];
    }
    return self;
}



- (void)show{
    UIWindow *keyv=[[UIApplication sharedApplication] keyWindow];
    [keyv addSubview:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
