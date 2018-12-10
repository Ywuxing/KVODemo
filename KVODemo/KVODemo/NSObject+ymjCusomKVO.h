//
//  NSObject+ymjCusomKVO.h
//  KVODemo
//
//  Created by mhj on 2018/12/10.
//  Copyright © 2018年 ymj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ymjCusomKVO)
- (void)ymj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end
