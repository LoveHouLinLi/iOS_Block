//
//  EOCNetworkFetcher.m
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/8.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "EOCNetworkFetcher.h"

@interface EOCNetworkFetcher()

@property (nonatomic,strong,readwrite)NSURL *url;

@property (nonatomic,copy)EOCNetworkFetcherCompletionHandler completionHandler;

@property (nonatomic,strong)NSData *downloadedData;

@end

@implementation EOCNetworkFetcher

- (instancetype)initWithURL:(NSURL *)url
{
    if (self=[super init]) {
        _url=url;
    }
    
    return self;
}


- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler)handler
{
    // 这里只是设置 并没有 调起block  模拟假设3s 后返回了数据
    self.completionHandler=handler;
//    if (handler) {
//        handler(nil);
//    }
    [self performSelector:@selector(p_requestCompleted) withObject:nil afterDelay:3.0];
    
}


/**
 这段代码 看上去没什么 问题 实际上在使用的时候 会有循环引用 导致的 内存泄漏
 */
- (void)p_requestCompleted
{
    if (_completionHandler) {
        _completionHandler(_downloadedData);
    }
    
//    _completionHandler = nil;
}

- (void)start
{
    NSLog(@"start ---- ");
}

@end
