//
//  ViewController.m
//  KVODemo
//
//  Created by mhj on 2018/12/10.
//  Copyright © 2018年 ymj. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+ymjCusomKVO.h"

@interface ViewController ()
@property(nonatomic,strong)Person * p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _p = [[Person alloc]init];
    _p.dog = [[Dog alloc]init];
    _p.dataArr = [[NSMutableArray alloc]init];
    _p.name = @"a";
    _p.name1 = @"y";
    _p.height = 0;
    //在touchesBegan修改属性值
    
    //1、触发模式
    [self AotoAnNotAoto];
    //2、属性依赖
    [self attributeDependency];
    //3、最容器类的监听
    [self observerArray];
    
    //4、自定义KVO，测试这个最好放最后单独测试，测试时候屏蔽上面的方法，因为自定义KVO新建了Person的子类，把类的isa指向修改了，影响了系统的KVO，会使得内部没有实现的方法受影响，比如对容器的监听，内部没有实现，不会执行observeValueForKeyPath方法
//    [self customKVO];
   
   
}
#pragma mark----1、触发模式
-(void)AotoAnNotAoto{
    //结合Person中的automaticallyNotifiesObserversForKey关闭自动触发方法使用
    //我在automaticallyNotifiesObserversForKey以“height”关闭了自动触发
    
    //1、自动触发name
    [self.p addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    
    
    //2、手动触发height
     [self.p addObserver:self forKeyPath:@"height" options:(NSKeyValueObservingOptionNew) context:nil];
}

#pragma mark----2、属性依赖
-(void)attributeDependency{
    //结合Person类中的keyPathsForValuesAffectingValueForKey方法测试
     [self.p addObserver:self forKeyPath:@"dog" options:(NSKeyValueObservingOptionNew) context:nil];
    
    //如果不使用上述方法，则需要为dog的每个属性添加观察者
//    [self.p addObserver:self forKeyPath:@"dog.age" options:(NSKeyValueObservingOptionNew) context:nil];
//    [self.p addObserver:self forKeyPath:@"dog.level" options:(NSKeyValueObservingOptionNew) context:nil];
}
#pragma mark----3、对容器类的监听
-(void)observerArray{
    [self.p addObserver:self forKeyPath:@"dataArr" options:(NSKeyValueObservingOptionNew) context:nil];
}
#pragma maark----4、自定义KVO
-(void)customKVO{
    //自定义KVO在NSObject+ymjCusomKVO分类中实现
    [self.p ymj_addObserver:self forKeyPath:@"name1" options:(NSKeyValueObservingOptionNew) context:nil];
}



#pragma mark----被观察这属性改变后会执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keypath=%@,change=%@",keyPath,change);
}

#pragma mark---通过点击屏幕，修改值触发观察者回调
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //1、触发模式，自动和手动
    self.p.name = [NSString stringWithFormat:@"%@+",self.p.name];

    [self.p willChangeValueForKey:@"height"];
    self.p.height = self.p.height + 10;
    [self.p didChangeValueForKey:@"height"];

    //2、属性依赖
    self.p.dog.age++;
    self.p.dog.level = self.p.dog.age/3;
    

    //3、对容器类的监听
    NSMutableArray * arr = [self.p mutableArrayValueForKey:@"dataArr"];
    [arr addObject:self.p.name];
//    //下面这种方法也行，但是change值不同
//    [self.p willChangeValueForKey:@"dataArr"];
//    [self.p.dataArr addObject:self.p.name];
//    [self.p didChangeValueForKey:@"dataArr"];
    
    //4、自定义KVO，测试这个最好放最后单独测试，测试时候屏蔽上面的方法，因为自定义KVO新建了Person的子类，把类的isa指向修改了，影响了系统的KVO，会使得内部没有实现的方法受影响，比如对容器的监听，内部没有实现，不会执行observeValueForKeyPath方法
    self.p.name1 = [NSString stringWithFormat:@"%@-",self.p.name1];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
