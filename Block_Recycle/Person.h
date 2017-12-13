//
//  Person.h
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PersonHandler)(NSData *data);

@interface Person : NSObject

- (instancetype)initWithHandler:(PersonHandler )handler;

@property (nonatomic,copy)PersonHandler handler;


@end
