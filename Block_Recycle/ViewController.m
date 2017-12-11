//
//  ViewController.m
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/8.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "ViewController.h"
#import "EOCNetworkFetcher.h"

@interface ViewController ()<EOCNetworkFetcherDelegate>

@property (nonatomic,strong)EOCNetworkFetcher *fetcher;

@property (nonatomic,strong)NSMutableSet *set;

@property (nonatomic,strong)NSData *fetchedData;

@end

@implementation ViewController
{
//    NSData *_fetc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retainCycleBlock];
}

- (void)dealloc
{
    NSLog(@"view controll  dealloc ");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _fetchedData=data;
        NSLog(@"request completion url is %@",_fetcher.url);
        
    }];
    
    // @property (nonatomic,strong)EOCNetworkFetcher *fetcher;
    
    // handler block  保留了 self  因为要获取 _fetchedData
    // self 通过 strong 保留了 _fetcher
    // 而 _fetcher  又保留了 hander 块 那么三者都无法释放
    
}

#pragma mark ----

- (void)networkFetcher:(EOCNetworkFetcher *)networkFetcher didFinishedWithData:(NSData *)data
{
    
}


@end
