//
//  WZScrollView.m
//  12
//
//  Created by 王吉吉 on 2016/11/18.
//  Copyright © 2016年 王喆. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "WZScrollView.h"
//宽
#define kWidthFrame self.frame.size.width
//高a
#define kHeightFrame self.frame.size.height


@interface WZScrollView()<UIScrollViewDelegate>
//滚动视图
@property(nonatomic,strong)UIScrollView *scrollView;
//左图片
@property(nonatomic,strong)UIImageView *leftImageView;
//右图片
@property(nonatomic,strong)UIImageView *rightImageView;
//小圆点
@property(nonatomic,strong)UIPageControl *pageControl;

//当前下标
@property(nonatomic,assign)NSInteger index;

//定时器
@property(nonatomic,strong)NSTimer *timer;

//图片数组
@property(nonatomic,strong)NSArray *imageArray;

@end


@implementation WZScrollView

//定时器懒加载
-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
//定时器方法
-(void)timerAction{
    [self.scrollView setContentOffset:CGPointMake(kWidthFrame, 0) animated:YES];
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        //开始创建滚动视图及属性
        _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidthFrame, 245)];
        _scrollView.contentSize = CGSizeMake(kWidthFrame*2, 245);
        [self addSubview:self.scrollView];
        _scrollView.delegate =self;
        _scrollView.pagingEnabled =YES;
        _scrollView.bounces = NO;
        _scrollView.bouncesZoom =NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        //创建小圆点
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kWidthFrame/2 -100, kHeightFrame-40, 200, 50)];
        _pageControl.numberOfPages =self.imageArray.count;
        _pageControl.pageIndicatorTintColor =[UIColor colorWithRed:219/255.0f green:205/255.0f blue:189/255.0f alpha:1];
        _pageControl.currentPageIndicatorTintColor =[UIColor redColor];
    }
    return _pageControl;
}
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]]];
    }
    return _leftImageView;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[self.index]]];
    }
    return _rightImageView;
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 1;
        //给数组赋值
        self.imageArray =imageArray;
        
        //设置视图
        [self createUI];
        
    }
    return self;
}



-(void)createUI{
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [self addSubview:self.pageControl];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer fire];
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == kWidthFrame) {
        scrollView.contentOffset = CGPointZero;
        self.pageControl.currentPage= self.index;
        
        
        self.index++;
        if (self.index == self.imageArray.count) {
            self.index =0;
        }
        self.leftImageView.image =self.rightImageView.image;
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[self.index]]];
        
    }
}


@end
