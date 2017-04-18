//
//  AppNetWorking.m
//  AppNetWorking
//
//  Created by 阮巧华 on 2017/4/18.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "AppNetWorking.h"
#import "AFNetworking.h"

static NSString *const Code = @"Code";
static NSString *const Data = @"Data";
static NSString *const Message = @"Msg";

@implementation AppNetWorking {
    AFHTTPSessionManager *_session;
}

+ (instancetype)shareInstance {
    
    static AppNetWorking *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AppNetWorking alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _session.requestSerializer.timeoutInterval = 10;
    }
    return self;
}

- (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCallBack)successCb failureCb:(FailureCallBack)failureCb {
    
    [_session GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        assert(responseObject);
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) {
            if (failureCb) {
                failureCb([NSError errorWithDomain:@"服务器返回错误" code:-1 userInfo:nil]);
            }
            return;
        }
        id code = [response objectForKey:Code];
        id message = [response objectForKey:Message];
        if (code && [code intValue] == 0) {
            id data = [response objectForKey:Data];
            if (successCb) {
                successCb(data);
            }
        } else {
            if (failureCb) {
                failureCb([NSError errorWithDomain:message code:-1 userInfo:nil]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureCb) {
            failureCb(error);
        }
    }];
}

- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCallBack)successCb failureCb:(FailureCallBack)failureCb {
    
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        assert(responseObject);
        NSDictionary *response = [self responseDictionary:responseObject];
        if (!response) {
            if (failureCb) {
                failureCb([NSError errorWithDomain:@"服务器返回错误" code:-1 userInfo:nil]);
            }
            return;
        }
        id code = [response objectForKey:Code];
        id message = [response objectForKey:Message];
        if (code && [code intValue] == 0) {
            id data = [response objectForKey:Data];
            if (successCb) {
                successCb(data);
            }
        } else {
            if (failureCb) {
                failureCb([NSError errorWithDomain:message code:-1 userInfo:nil]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureCb) {
            failureCb(error);
        }
    }];
}

- (NSDictionary *)responseDictionary:(id)responseObject {
    
    NSError *error;
    NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    if (!responseDictionary) {
        NSString *jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",error);
        NSLog(@"%@",jsonString);
    }
    return responseDictionary;
}

@end
