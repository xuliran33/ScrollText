//
//  SAdView.h
//  
//
//  Created by gdj003 on 16/5/16.
//
//

#import <UIKit/UIKit.h>

@interface SAdView : UIView

/**
    广告内容数组
 */
@property(nonatomic, retain) NSArray *adTitles;

/**
    头部图片, 默认为nil
 */
@property(nonatomic, retain) UIImage *headImg;

/**
    广告字体 默认为16号系统字体
 */
@property(nonatomic, retain) UIFont *labelFont;

/**
    广告文字颜色 默认为黑色
 */
@property(nonatomic, retain) UIColor *color;

/**
    轮播时间间隔 默认2s
 */
@property(nonatomic, assign) NSTimeInterval time;

/**
    是否自动滚动
 */
@property(nonatomic, assign) BOOL isAautoScroll;

/**
    是否含有Img头 默认为NO
 */
@property(nonatomic, assign) BOOL isHaveHeadImg;

/**
    是否开启点击事件 默认为NO
 */
@property(nonatomic, assign) BOOL isHaveTouchEvent;

/**
    点击事件响应
 */
@property(nonatomic, copy) void (^clickAdBlock)(NSInteger index);

/**
    文本对齐方式
 */
@property(nonatomic, assign)NSTextAlignment textAlignment;

/**
    开始轮播
 */

- (void)beginScroll;

/**
    关闭轮播
 */
- (void)closeScroll;

/**
    实例化方法
 */

- (instancetype)initWithTitles: (NSArray *)titles;
@end
