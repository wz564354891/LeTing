//
//  YYWeakProxy.h
//  wupao
//
//  Created by 王吉吉 on 16/9/18.
//  Copyright © 2016年 舞泡02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYWeakProxy : NSProxy
@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end
