//
//  ViewController.m
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/8.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "ViewController.h"
#import "EOCNetworkFetcher.h"
#import "Person.h"

@interface ViewController ()<EOCNetworkFetcherDelegate>

@property (nonatomic,strong)EOCNetworkFetcher *fetcher;

@property (nonatomic,strong)NSMutableSet *set;

@property (nonatomic,strong)NSData *fetchedData;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong)Person *person;

@end

@implementation ViewController
{
    void (^cycleRefrenceBlock)(void);
//    __weak __typeof__(ViewController) *weakSelf;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // 第一种
//    [self retainRecycleBlockOne];
//    [self fixRetainRecycleBlockOne];
      //
//    [self noneRetainCycleBlockTwo];
    
    // 隐蔽的 retainCycle 三种方法 fix 方法
//    [self retainCycleBlock];
//    [self fixRetainCycleBlock];
//    [self fixRetainCycleBlockTwo];
//    [self fixRetainCycleBlockThree];
    
    //
//    weakSelf = self;
//    [self testPerson];
    [self testPesonTwo];
}

- (void)dealloc
{
    NSLog(@"view controll  dealloc ");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- 循环引用  及其解决方法

- (void)retainRecycleBlockOne
{
    // 编辑器会显示  Block的 错误提示
    cycleRefrenceBlock = ^{
        //        NSLog(@"%@",self.view);
        self.view.backgroundColor = [UIColor redColor];
    };
}


/**
 Apple 官方的建议是，传进 Block 之前，把 ‘self’ 转换成 weak automatic 的变量，这样在 Block 中就不会出现对 self 的强引用。如果在 Block 执行完成之前，self 被释放了，weakSelf 也会变为 nil。
 */
- (void)fixRetainRecycleBlockOne
{
    __weak typeof (*&self) weakSelf = self;
    cycleRefrenceBlock = ^{
        //        NSLog(@"%@",self.view);
        weakSelf.view.backgroundColor = [UIColor redColor];
    };
}



/**
 第一种形式的 循环引用
 */
- (void)retainCycleBlock
{
    //
    _fetcher=[[EOCNetworkFetcher alloc]initWithURL:[NSURL URLWithString:@"fooUrlString"]];
    //
    [_fetcher startWithCompletionHandler:^(NSData *data) {
        // foo handler
        self.fetchedData=data;
//        NSLog(@"request completion url is %@",_fetcher.url);
        
    }];
    
    // 这个比较隐蔽
    // @property (nonatomic,strong)EOCNetworkFetcher *fetcher;
    // handlerblock  保留了 ViewController  因为要获取 _fetchedData
    // ViewController 通过 strong 保留了 _fetcher
    // 而 _fetcher  又保留了 handlerblock

}

//
- (void)fixRetainCycleBlock
{
     __weak typeof (*&self) weakSelf = self;
    _fetcher=[[EOCNetworkFetcher alloc]initWithURL:[NSURL URLWithString:@"fooUrlString"]];
    
    [_fetcher startWithCompletionHandler:^(NSData *data) {
        weakSelf.fetchedData=data;
        NSLog(@"fetcher data fix");
    }];
}

- (void)fixRetainCycleBlockTwo
{
    _fetcher=[[EOCNetworkFetcher alloc]initWithURL:[NSURL URLWithString:@"fooUrlString"]];
    [_fetcher startHandler:^(NSData *data) {
        self.fetchedData=data;
        NSLog(@"fix retainCycle");
    }];
   
}

- (void)fixRetainCycleBlockThree
{
     _fetcher=[[EOCNetworkFetcher alloc]initWithURL:[NSURL URLWithString:@"fooUrlString"]];
    [_fetcher startThreeHandler:^(NSData *data) {
        self.fetchedData=data;
        NSLog(@"fix three  retainCycle");
    }];
}



#pragma mark ---- 没有循环引用
/**
 这个并没有引起 泄漏 
 */
- (void)noneRetainCycleBlockTwo
{
    self.fetcher = [[EOCNetworkFetcher alloc]initWithURL:[NSURL URLWithString:@"fooUrlString"]];
   
    [self.fetcher startWithCompletionHandler:^(NSData *data) {
        self.view.backgroundColor = [UIColor yellowColor];
    }];
}


#pragma mark ----   必须使用 strongSelf 和 weakSelf 的情形

/**
 weakSelf 的释放和 something是否耗时
 */
- (void)testWeakSelfNilFailure
{
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 这个 一直没搞定 weakSelf 一直没有出现 nil值
        [weakSelf doSomething];
        if (weakSelf == nil) {
            NSLog(@"weakSelf is %@",weakSelf);
        }
        //         NSLog(@"do other something ");
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//
//        });
        
        [weakSelf doOtherSomething];
        
    });
}


- (void)doSomething
{
    // 耗时的操作
    double sum = 0.0;
    for (int i = 0; i<1000; i++) {
        for (int j = 0 ; j<1000; j++) {
             sum+=i;
             sum+=j;
            for (int m = 0; m<1000; m++) {
                sum+=m;
            }
        }
    }
    
    NSLog(@"do somthing end");
//    double sum = 0.0;
//    for (int i = 0; i<100; i++) {
//        sum+=i;
//    }
//    NSLog(@"do something");
}


/**
 我们假设 doOtherthing 也是一个耗时的操作
 */
- (void)doOtherSomething
{
    NSLog(@"do other something start");
    double sum = 0.0;
    for (int i = 0; i<1000; i++) {
        for (int j = 0 ; j<1000; j++) {
            sum+=i;
            sum+=j;
            for (int m = 0; m<1000; m++) {
                sum+=m;
            }
        }
    }
    
    NSLog(@"do other thing end");
    // 我们发现 在 do other thing end  之后 才 dealloc 这是一个有意思的地方
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.activityIndicatorView.isAnimating) {
//            [self.activityIndicatorView stopAnimating];
//        }else{
//            [self.activityIndicatorView startAnimating];
//        }
//    });
    //
   
}

- (void)testStrongSelfInBlock
{
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 这个 一直没搞定 weakSelf 一直没有出现 nil值
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf doSomething];
        if (strongSelf == nil) {
            NSLog(@"strong is %@",weakSelf);
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            if (strongSelf.activityIndicatorView.isAnimating) {
//                 NSLog(@"self exe code");
//                [strongSelf.activityIndicatorView stopAnimating];
//            }else{
//                 NSLog(@"self exe code");
//                [strongSelf.activityIndicatorView startAnimating];
//            }
//        });
        
        [weakSelf doOtherSomething];
        
    });
}



#pragma mark ----   代理方法  主要用来 区分 Block 和 delegate 的区别
// 
- (void)networkFetcher:(EOCNetworkFetcher *)networkFetcher didFinishedWithData:(NSData *)data
{
    
}


#pragma mark ----  Block  test three

/**
 反复的调用 testWeakSelf

 @param sender sender description
 */
- (IBAction)blockTestThree:(id)sender
{
    [self testWeakSelfNilFailure];
}

- (IBAction)setWeakSelfNil:(id)sender
{
//    weakSelf = nil;
//    self = nil;
    //
}

- (IBAction)strongSelf:(id)sender
{
    [self testStrongSelfInBlock];
}

#pragma mark ---- Person  对比和 swift 中区别


/**
 会造成 内存泄漏
 */
- (void)testPerson
{
    self.person = [[Person alloc]initWithHandler:^(NSData *data) {
        self.fetchedData = data;
    }];
}

- (void)testPesonTwo
{
    self.person = [[Person alloc] init];
    self.person.handler = ^(NSData *data){
        _fetchedData = data;
    };
    NSLog(@"test person two");
    // 如果设置 self.person 为nil 就没有循环引用了
//    self.person = nil;
}



@end
