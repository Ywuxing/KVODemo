//
//  Person.h
//  腾讯课堂Demo
//
//  Created by mhj on 2018/12/5.
//  Copyright © 2018年 ymj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
@interface Person : NSObject
@property(nonatomic,assign)NSInteger height;//测试手动触发
@property(nonatomic,copy)NSString * name;//测试自动触发
@property(nonatomic,strong)NSString * name1;//自定义KVO
@property(nonatomic,strong)Dog * dog;//测试属性依赖
@property(nonatomic,strong)NSMutableArray * dataArr;
@end
