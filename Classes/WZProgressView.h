//
//  WZProgressView.h
//  12
//
//  Created by 王吉吉 on 2016/11/30.
//  Copyright © 2016年 王喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZProgressView : UIView
@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) float progress;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) float progressValue;
@property (strong, nonatomic) NSNumber *num;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;
- (void)changeSliderValue;
@end
