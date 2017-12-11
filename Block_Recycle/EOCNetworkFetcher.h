//
//  EOCNetworkFetcher.h
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/8.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EOCNetworkFetcherCompletionHandler)(NSData *data);

typedef void (^EOCNetworkFetcherRequestHandler)(NSData *data);

typedef void (^EOCNetworkFetcherThreeHandler)(NSData *data);  // 

@protocol  EOCNetworkFetcherDelegate;

@interface EOCNetworkFetcher : NSObject

-(instancetype)initWithURL:(NSURL *)url;


/**
 这是一个 错误的示例 会引起 内存泄漏

 @param handler handler description
 */
- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler )handler;


/**
 为了对比上个 block的方法 没有内存泄漏

 @param handler handler description
 */
- (void)startHandler:(EOCNetworkFetcherRequestHandler )handler;

/**
 开始 第三个  handler

 @param handler handler description
 */
- (void)startThreeHandler:(EOCNetworkFetcherThreeHandler )handler;


@property (nonatomic,weak)id<EOCNetworkFetcherDelegate>delegate;

@property (nonatomic,strong,readonly)NSURL *url;

- (void)start;


@end


@protocol EOCNetworkFetcherDelegate <NSObject>

- (void)networkFetcher:(EOCNetworkFetcher *)networkFetcher
   didFinishedWithData:(NSData *)data;

@end
