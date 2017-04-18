//
//  AppNetWorking.h
//  AppNetWorking
//
//  Created by 阮巧华 on 2017/4/18.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const BaseURLString = @"http://union.iqeq.cn";

typedef void(^SuccessCallBack)(id data);
typedef void(^FailureCallBack)(NSError *error);

@interface AppNetWorking : NSObject

+ (instancetype)shareInstance;

- (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCallBack)successCb failureCb:(FailureCallBack)failureCb;

- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCallBack)successCb failureCb:(FailureCallBack)failureCb;

@end
