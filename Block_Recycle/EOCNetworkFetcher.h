//
//  EOCNetworkFetcher.h
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/8.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EOCNetworkFetcherCompletionHandler)(NSData *data);

@protocol  EOCNetworkFetcherDelegate;

@interface EOCNetworkFetcher : NSObject

-(instancetype)initWithURL:(NSURL *)url;

- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler )handler;

@property (nonatomic,weak)id<EOCNetworkFetcherDelegate>delegate;

@property (nonatomic,strong,readonly)NSURL *url;


- (void)start;


@end


@protocol EOCNetworkFetcherDelegate <NSObject>

- (void)networkFetcher:(EOCNetworkFetcher *)networkFetcher
   didFinishedWithData:(NSData *)data;

@end
