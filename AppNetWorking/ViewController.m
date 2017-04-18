//
//  ViewController.m
//  AppNetWorking
//
//  Created by 阮巧华 on 2017/4/18.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "AppNetWorking.h"

@interface ViewController ()

@end

static NSString *const GetProvinces = @"/api/AgentTemp/GetProvinces";
static NSString *const GetCitys = @"/api/AgentTemp/GetCitys";
static NSString *const GetAreas = @"/api/AgentTemp/GetAreas";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = @"/Users/ruanqiaohua/Desktop";
    NSString *areaPath = [path stringByAppendingString:@"/area.plist"];
    [self getProvinces:^(id data) {
        
        NSArray *array = data;
        BOOL result = [array writeToFile:areaPath atomically:YES];
        if (result) {
            NSLog(@"保存成功");
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getProvinces:(SuccessCallBack)successCb {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@1 forKey:@"Id"];
    [parameters setValue:@1 forKey:@"Session"];
    [parameters setValue:@1 forKey:@"IMEI"];
    [[AppNetWorking shareInstance] GET:GetProvinces parameters:parameters successCb:^(id data) {
        
        NSArray *list = data;
        NSMutableArray *mArr = [NSMutableArray array];
        // 调度组创建
        dispatch_group_t dispatchGroup = dispatch_group_create();
        
        for (NSDictionary *dic in list) {
            NSInteger Id = [dic[@"Id"] integerValue];
            NSString *name = dic[@"Name"];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            [mDic setValue:[NSNumber numberWithInteger:Id] forKey:@"Id"];
            [mDic setValue:name forKey:@"Name"];
            // 调度组输入
            dispatch_group_enter(dispatchGroup);
            
            [self getCitys:Id successCb:^(id data) {
                [mDic setValue:data forKey:@"citys"];
                [mArr addObject:mDic];
                // 调度组输出
                dispatch_group_leave(dispatchGroup);
            }];
        }
        
        // 调度组通知
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
            if (successCb) {
                successCb(mArr);
            }
        });

    } failureCb:^(NSError *error) {
        
    }];
}

- (void)getCitys:(NSInteger)provinceId successCb:(SuccessCallBack)successCb {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@1 forKey:@"Id"];
    [parameters setValue:@1 forKey:@"Session"];
    [parameters setValue:@1 forKey:@"IMEI"];
    [parameters setValue:[NSNumber numberWithInteger:provinceId] forKey:@"ProvinceId"];
    [[AppNetWorking shareInstance] GET:GetCitys parameters:parameters successCb:^(id data) {
        
        NSArray *list = data;
        NSMutableArray *mArr = [NSMutableArray array];
        // 调度组创建
        dispatch_group_t dispatchGroup = dispatch_group_create();

        for (NSDictionary *dic in list) {
            NSInteger Id = [dic[@"Id"] integerValue];
            NSString *name = dic[@"Name"];
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            [mDic setValue:[NSNumber numberWithInteger:Id] forKey:@"Id"];
            [mDic setValue:name forKey:@"Name"];
            
            // 调度组输入
            dispatch_group_enter(dispatchGroup);

            [self getAreas:Id successCb:^(id data) {
                [mDic setValue:data forKey:@"areas"];
                [mArr addObject:mDic];
                
                // 调度组输出
                dispatch_group_leave(dispatchGroup);

            }];
        }
        // 调度组通知
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
            if (successCb) {
                successCb(mArr);
            }
        });

    } failureCb:^(NSError *error) {
        
    }];
}

- (void)getAreas:(NSInteger)cityId successCb:(SuccessCallBack)successCb {
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@1 forKey:@"Id"];
    [parameters setValue:@1 forKey:@"Session"];
    [parameters setValue:@1 forKey:@"IMEI"];
    [parameters setValue:[NSNumber numberWithInteger:cityId] forKey:@"ProvinceId"];
    [[AppNetWorking shareInstance] GET:GetCitys parameters:parameters successCb:^(id data) {
        if (successCb) {
            successCb(data);
        }
    } failureCb:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
