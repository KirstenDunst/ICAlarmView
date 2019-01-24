//
//  ICAlarmView.h
//  AlarmView
//
//  Created by CSX on 2017/3/15.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlartBtnBlock)(NSInteger index,NSString *contentStr);

@protocol ICAlarmViewDelegate;

@interface ICAlarmView : UIView
@property(nonatomic, assign)id<ICAlarmViewDelegate>delegate;
@property (nonatomic, copy)AlartBtnBlock alartBlock;


/* 实例化一次显示的方法 （调用show，是加载在window上的，也可直接当做一个view添加在任意组建上）
 @param  title          标题
 @param  message        内容
 @param  state          内容显示类型
 @param  object         代理的对象，如果使用block，这里可以不用传，写nil
 @param  titleArr       按钮的标题集数组
 @param  btnColors      按钮标题的颜色数组
 @param  isVertical     button按钮的排列方式，是否为竖排
 @param  isContent      是否包含输入框。    message会约束这个输入框的存在，只有当message为nil的时候参数才有效（这里是这样设置的，有需要可以自定义）
 */
- (instancetype)initWithAlarmWithTitle:(NSString *)title message:(NSString *)message messageType:(NSTextAlignment)state delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical andIsContentTextfield:(BOOL)isContent;

+ (instancetype)alarmWithTitle:(NSString *)title message:(NSString *)message messageType:(NSTextAlignment)state delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical andIsContentTextfield:(BOOL)isContent;



/* 实例化动画显示，从上到下一条一条信息显示的方法（调用show，是加载在window上的，也可直接当做一个view添加在任意组建上）
 @param  title          标题
 @param  messageArr     内容数组，内部是一个个的json,[{title:"",content:""}]
 @param  state          内容显示类型
 @param  timeInterval   每一条显示显示的时间间隔
 @param  object         代理的对象，如果使用block，这里可以不用传，写nil
 @param  titleArr       按钮的标题集数组
 @param  btnColors      按钮标题的颜色数组
 @param  isVertical     button按钮的排列方式，是否为竖排
 */
- (instancetype)initWithAnimationAlarmWithTitle:(NSString *)title messageArr:(NSArray *)messageArr messageType:(NSTextAlignment)state timeInterval:(NSTimeInterval)timeInterval delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical;

+ (instancetype)alarmWithAnimationTitle:(NSString *)title messageArr:(NSArray *)messageArr messageType:(NSTextAlignment)state timeInterval:(NSTimeInterval)timeInterval delegate:(id)object btnTitles:(NSArray *)titleArr btnColors:(NSArray *)btnColors andButtonStateIsVertica:(BOOL)isVertical;

//针对于类方法加载视图在window上面显示，
- (void)show;
@end



//代理方法
@protocol ICAlarmViewDelegate <NSObject>

@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(ICAlarmView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


//处理带返回输入框文字的时候调用，   点击任意按钮都会自动dismissed。
//返回方式：点击任意按钮都会返回输入框的文字信息，可以根据buttonIndex来决定什么时候使用这个文字。
- (void)alertView:(ICAlarmView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andWithContentStr:(NSString *)text;

@end

