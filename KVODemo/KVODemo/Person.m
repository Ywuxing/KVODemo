//
//  Person.m
//  腾讯课堂Demo
//
//  Created by mhj on 2018/12/5.
//  Copyright © 2018年 ymj. All rights reserved.
//

#import "Person.h"

@implementation Person
//关闭自动观察者监听回调，则需要在修改前后添加willChangeValueForKey和didChangeValueForKey
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    
    if([key isEqualToString:@"height"])return NO;
    return YES;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    if([key isEqualToString:@"dog"]){
        return [NSSet setWithObjects:@"_dog.age",@"_dog.level", nil];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end
