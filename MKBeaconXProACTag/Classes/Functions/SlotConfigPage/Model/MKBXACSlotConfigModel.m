//
//  MKBXACSlotConfigModel.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "MKBXACSlotConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXACInterface.h"
#import "MKBXACInterface+MKBXACConfig.h"

@interface MKBXACNormalAdvModel : NSObject<mk_bxa_normalAdvModeParamProtocol>

/// Device advertising interval.0ms ~ 65535ms.
@property (nonatomic, assign)NSInteger advInterval;

/// Device broadcast power.
@property (nonatomic, assign)mk_bxa_txPower txPower;

/// Device broadcast duration.1s ~ 65535s.
@property (nonatomic, assign)NSInteger advDuration;

/// Device standby time.0s ~ 65535s.
@property (nonatomic, assign)NSInteger standbyDuration;

/// Broadcast channel frequency.
@property (nonatomic, assign)mk_bxa_advChannel advChannel;

@end

@implementation MKBXACNormalAdvModel
@end


@interface MKBXACButtonTriggerAdvModel : NSObject<mk_bxa_buttonTriggerAdvModeParamProtocol>

/// Device advertising interval.0ms ~ 65535ms.
@property (nonatomic, assign)NSInteger advInterval;

/// Device broadcast power.
@property (nonatomic, assign)mk_bxa_txPower txPower;

/// Device broadcast duration.1s ~ 65535s.
@property (nonatomic, assign)NSInteger advDuration;

/// Trigger Type.
@property (nonatomic, assign)mk_bxa_buttonTriggerType triggerType;

@end

@implementation MKBXACButtonTriggerAdvModel
@end


@interface MKBXACSlotConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)NSArray *intervalList;

@end

@implementation MKBXACSlotConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAdvParams]) {
            [self operationFailedBlockWithMsg:@"Read Adv Parmas Error" block:failedBlock];
            return;
        }
        if (![self readTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Params Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configAdvParams]) {
            [self operationFailedBlockWithMsg:@"Config Adv Params Error" block:failedBlock];
            return;
        }
        if (![self configTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Config Trigger Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readAdvParams {
    __block BOOL success = NO;
    [MKBXACInterface bxa_readNormalAdvModeParamWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advInterval = [self parseAdvInterval:[returnData[@"result"][@"advInteravl"] integerValue]];
        self.advTxPower = [returnData[@"result"][@"txPower"] integerValue];
        self.advDuration = returnData[@"result"][@"advDuration"];
        self.advChannel = [returnData[@"result"][@"advChannel"] integerValue];
        self.standbyDuration = returnData[@"result"][@"standbyDuration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvParams {
    __block BOOL success = NO;
    
    MKBXACNormalAdvModel *model = [[MKBXACNormalAdvModel alloc] init];
    model.advInterval = [self.intervalList[self.advInterval] integerValue];
    model.txPower = self.advTxPower;
    model.advDuration = [self.advDuration integerValue];
    model.standbyDuration = [self.standbyDuration integerValue];
    model.advChannel = self.advChannel;
    
    [MKBXACInterface bxa_configNormalAdvModeParam:model sucBlock:^ {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerParams {
    __block BOOL success = NO;
    [MKBXACInterface bxa_readButtonTriggerAdvModeParamWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerInterval = [self parseAdvInterval:[returnData[@"result"][@"advInteravl"] integerValue]];
        self.triggerTxPower = [returnData[@"result"][@"txPower"] integerValue];
        self.triggerDuration = returnData[@"result"][@"advDuration"];
        NSInteger triggerType = [returnData[@"result"][@"triggerTrigger"] integerValue];
        if (triggerType == 0) {
            //无触发
            self.trigger = NO;
        }else {
            //出发
            self.trigger = YES;
            self.triggerType = triggerType - 1;
        }
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerParams {
    __block BOOL success = NO;
    
    MKBXACButtonTriggerAdvModel *model = [[MKBXACButtonTriggerAdvModel alloc] init];
    model.advInterval = [self.intervalList[self.triggerInterval] integerValue];
    model.txPower = self.triggerTxPower;
    model.advDuration = [self.triggerDuration integerValue];
    if (!self.trigger) {
        model.triggerType = 0;
    }else {
        model.triggerType = self.triggerType + 1;
    }
    
    
    [MKBXACInterface bxa_configButtonTriggerAdvModeParam:model sucBlock:^ {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"ADVERTISEMENT"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

/*
 0: 10ms
 1: 20ms
 2: 50ms
 3: 100ms
 4: 200ms
 5: 250ms
 6: 500ms
 7: 1000ms
 8: 2000ms
 9: 5000ms
 10: 10000ms
 11: 20000ms
 12: 50000ms
 */
- (NSInteger)parseAdvInterval:(NSInteger)interval {
    if (interval == 10) {
        return 0;
    }
    if (interval == 20) {
        return 1;
    }
    if (interval == 50) {
        return 2;
    }
    if (interval == 100) {
        return 3;
    }
    if (interval == 200) {
        return 4;
    }
    if (interval == 250) {
        return 5;
    }
    if (interval == 500) {
        return 6;
    }
    if (interval == 1000) {
        return 7;
    }
    if (interval == 2000) {
        return 8;
    }
    if (interval == 5000) {
        return 9;
    }
    if (interval == 10000) {
        return 10;
    }
    if (interval == 20000) {
        return 11;
    }
    if (interval == 50000) {
        return 12;
    }
    return 0;
}

- (BOOL)validParams {
    if (!ValidStr(self.advDuration) || [self.advDuration integerValue] < 1 || [self.advDuration integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.standbyDuration) || [self.standbyDuration integerValue] < 0 || [self.standbyDuration integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.triggerDuration) || [self.triggerDuration integerValue] < 0 || [self.triggerDuration integerValue] > 65535) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("ADVERTISEMENTQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

- (NSArray *)intervalList {
    if (!_intervalList) {
        _intervalList = @[@"10",@"20",@"50",@"100",@"200",@"250",@"500",@"1000",@"2000",@"5000",@"10000",@"20000",@"50000"];
    }
    return _intervalList;
}

@end
