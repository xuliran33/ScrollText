//
//  SAdView.m
//  
//
//  Created by gdj003 on 16/5/16.
//
//

#import "SAdView.h"

#define ViewWidth self.bounds.size.width
#define ViewHeight self.bounds.size.height

@interface SAdView ()

/**
    文字广告条前面的图标
 */

@property(nonatomic, retain) UIImageView *headImageView;

/**
    两个轮流显示的label
 */
@property(nonatomic, retain)UILabel *oneLabel;
@property(nonatomic, retain) UILabel *twoLabel;

/**
    计时器
 */

@property(nonatomic, retain) NSTimer *timer;

@end

@implementation SAdView
{
    NSUInteger index;
    CGFloat margin;
    BOOL isBegin;
}

- (instancetype)initWithTitles:(NSArray *)titles{
    if (self = [super init]){
        margin = 0;
        self.clipsToBounds = YES;
        self.adTitles = titles;
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:16];
        self.color = [UIColor blackColor];
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveHeadImg = NO;
        self.isHaveTouchEvent = NO;
        
        index = 0;
        if (!_headImageView){
            _headImageView = [[UIImageView alloc] init];
        }
        if (!_oneLabel){
            _oneLabel = [UILabel new];
            _oneLabel.text = [NSString stringWithFormat:@"%@", self.adTitles[index]];
            _oneLabel.font = self.labelFont;
            _oneLabel.textAlignment = self.textAlignment;
            _oneLabel.textColor = self.color;
            [self addSubview:_oneLabel];
        }
        if (!_twoLabel){
            _twoLabel = [UILabel new];
            _twoLabel.font = self.labelFont;
            _twoLabel.textColor = self.color;
            _twoLabel.textAlignment = self.textAlignment;
            [self addSubview:_twoLabel];
        }
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isHaveHeadImg){
        [self addSubview:self.headImageView];
        self.headImageView.frame = CGRectMake(0, 0, ViewHeight, ViewHeight);
        margin = ViewHeight + 10;
    }else{
        if (self.headImageView){
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 0;
    }
    self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
    self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
}

// 轮播实现
- (void)timeRepeat{
    if (self.adTitles.count == 0) {
        return;
    }
    if (index != self.adTitles.count - 1){
        index++;
    }else{
        index = 0;
    }
    
    if (index == 0) {
        self.oneLabel.text = [NSString stringWithFormat:@"%@", self.adTitles[index]];
    }else{
        switch (index % 2) {
            case 0:
            {
                self.oneLabel.text = [NSString stringWithFormat:@"%@", self.adTitles[index]];
                break;
            }
            default:
            {
                self.twoLabel.text = [NSString stringWithFormat:@"%@", self.adTitles[index]];
                break;
            }
        }
        NSLog(@"%d", index);
        if (index % 2 == 0) {
           
            [UIView animateWithDuration:1 animations:^{
                self.twoLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
                self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
                
            } completion:^(BOOL finished) {
                self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
                self.twoLabel.text = self.adTitles[index];
                
            }];
        }else{
            [UIView animateWithDuration:1 animations:^{
                self.oneLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
                self.twoLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
                
            } completion:^(BOOL finished) {
                self.oneLabel.frame = CGRectMake(margin, ViewHeight, ViewHeight, ViewHeight);
                self.oneLabel.text = self.adTitles[index];
            }];
            
        }
    }
}

// 文字开始滚动
- (void)beginScroll{
    if (self.timer.isValid){
        // 如果计时器处于活动状态, 停止计时器, 并将其置空
        [self.timer invalidate];
        // 防止内存泄漏
        self.timer = nil;
    }
    
    // 把计时器添加到runloop中, 若用sce...方法初始化的计时器可以自动释放, 不用加入runloop中, 计时器加入runloop中之后, 可以在加入runloop后time的时间内运行
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

// 文字停止滚动
- (void)closeScroll{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -------- 重写setter方法
// 是否有点击时间
- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    if (isHaveTouchEvent){
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;
    }
}

// 滚动时间
- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 设置头image
- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    
    self.headImageView.image = headImg;
}

// 设置文字的对齐方式
- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    self.oneLabel.textAlignment = _textAlignment;
    self.twoLabel.textAlignment = _textAlignment;
}

// 设置文字颜色
- (void)setColor:(UIColor *)color{
    _color = color;
    self.oneLabel.textColor = _color;
    self.twoLabel.textColor = _color;
}

// 设置字体
- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.oneLabel.font = _labelFont;
    self.twoLabel.font = _labelFont;
}

#pragma mark -------- 懒加载
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}

#pragma mark -------- 点击事件
- (void)clickEvent:(UITapGestureRecognizer *)tap{
    [self.adTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (index % 2 == 0 && [self.oneLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }else if (index % 2 != 0 && [self.twoLabel.text isEqualToString:obj]){
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
    }];

}


 



@end
