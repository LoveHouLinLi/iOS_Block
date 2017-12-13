//
//  Person.m
//  Block_Recycle
//
//  Created by meitianhui2 on 2017/12/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "Person.h"


@implementation Person

- (instancetype)initWithHandler:(PersonHandler)handler
{
    if (self = [super init]) {
        self.handler = handler;
    }
    return self;
}

@end
