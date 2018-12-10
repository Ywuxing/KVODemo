//
//  NSObject+ymjCusomKVO.m
//  KVODemo
//
//  Created by mhj on 2018/12/10.
//  Copyright © 2018年 ymj. All rights reserved.
//

#import "NSObject+ymjCusomKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (ymjCusomKVO)
- (void)ymj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
        //自定义子类的类名
    NSString * kidClassName = [NSString stringWithFormat:@"YMJKVONOtifying_%@",NSStringFromClass([self class])];
        //创建子类
    Class kidClass = objc_allocateClassPair(self.class, [kidClassName UTF8String], 0);
        //注册子类
    objc_registerClassPair(kidClass);
    
        //setter方法名
    NSString *firstString = [keyPath substringToIndex:1];
    firstString = [firstString uppercaseString];
    NSString *setterString = [keyPath substringFromIndex:1];
    NSString * setterSelName = [NSString stringWithFormat:@"set%@%@:", firstString, setterString];
        //重写setter方法，因为子类中没有父类的方法，所以重写实质是添加了一个方法
    SEL selector = NSSelectorFromString(setterSelName);
    class_addMethod(kidClass, selector, (IMP)setterMethodCustom, "v@:@");
        //v@:@ => v表示返回值void,@表示对象，:表示SEl，因为oc方法中默认有两个参数（和消息发送机制有关）,一个self,一个cmd,所以这里代表返回值为void,第一个参数self,第二个参数cmd,第三个参数要设置的新值value
    
        //修改isa指针
    object_setClass(self, kidClass);
    
        //因为属性修改时候要告诉观察者，所以给子类添加属性关联
    objc_setAssociatedObject(self, @"ymj_observer", observer, OBJC_ASSOCIATION_ASSIGN);
    
    
}



void setterMethodCustom (id self,SEL cmd,id value){
    
    NSLog(@"value=%@",value);
        //根据setter方法名获取属性key
    NSString * setterSelName = NSStringFromSelector(cmd);
    setterSelName = [setterSelName stringByReplacingOccurrencesOfString:@"set" withString:@""];
    setterSelName = [setterSelName stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * keyPath = [NSString stringWithFormat:@"%@%@",[[setterSelName substringToIndex:1] lowercaseString],[setterSelName substringFromIndex:1]];
        //获取老值
    id oldValue = [self valueForKey:keyPath];
    
        //更改isa指向父类，先执行父类的setter方法,保存属性的值
    Class kidClass = [self class];
    object_setClass(self, class_getSuperclass(kidClass));
    ((void (*)(id,SEL,id)) objc_msgSend)(self, cmd, value);
    
        //获取观察者对象
    id observer = objc_getAssociatedObject(self, @"ymj_observer");
    
    if(observer){
            //貌似是说不能直接使用objc_msgSend的原型方法来匿名调用，否则会出现异常
        ((void (*)(id, SEL,id,id,id,id))objc_msgSend)(observer, @selector(observeValueForKeyPath:ofObject:change:context:),keyPath,self,@{@"old":oldValue,@"new":value},nil);
        
    }
        //更改isa指向为子类
    object_setClass(self, kidClass);
    
    
    
    
}
@end
