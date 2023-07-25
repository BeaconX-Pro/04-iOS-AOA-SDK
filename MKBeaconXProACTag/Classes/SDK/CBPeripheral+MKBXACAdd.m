//
//  CBPeripheral+MKBXACAdd.m
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import "CBPeripheral+MKBXACAdd.h"

#import <objc/runtime.h>

#import "MKBXACSDKNormalDefines.h"

static const char *bxa_manufacturerKey = "bxa_manufacturerKey";
static const char *bxa_deviceModelKey = "bxa_deviceModelKey";
static const char *bxa_productDateKey = "bxa_productDateKey";
static const char *bxa_hardwareKey = "bxa_hardwareKey";
static const char *bxa_softwareKey = "bxa_softwareKey";
static const char *bxa_firmwareKey = "bxa_firmwareKey";

static const char *bxa_customKey = "bxa_customKey";
static const char *bxa_disconnectTypeKey = "bxa_disconnectTypeKey";
static const char *bxa_threeSensorKey = "bxa_threeSensorKey";
static const char *bxa_passwordKey = "bxa_passwordKey";

static const char *bxa_passwordNotifySuccessKey = "bxa_passwordNotifySuccessKey";
static const char *bxa_disconnectTypeNotifySuccessKey = "bxa_disconnectTypeNotifySuccessKey";
static const char *bxa_customNotifySuccessKey = "bxa_customNotifySuccessKey";

@implementation CBPeripheral (MKMTAdd)

- (void)bxa_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &bxa_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &bxa_productDateKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &bxa_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &bxa_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &bxa_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &bxa_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &bxa_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &bxa_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                [self setNotifyValue:YES forCharacteristic:characteristic];
                objc_setAssociatedObject(self, &bxa_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &bxa_threeSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)bxa_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &bxa_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &bxa_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &bxa_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bxa_connectSuccess {
    if (![objc_getAssociatedObject(self, &bxa_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxa_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxa_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.bxa_manufacturer || !self.bxa_deviceModel || !self.bxa_hardware || !self.bxa_software || !self.bxa_firmware || !self.bxa_productDate) {
        return NO;
    }
    if (!self.bxa_password || !self.bxa_disconnectType || !self.bxa_custom || !self.bxa_threeSensor) {
        return NO;
    }
    return YES;
}

- (void)bxa_setNil {
    objc_setAssociatedObject(self, &bxa_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_productDateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxa_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_threeSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    objc_setAssociatedObject(self, &bxa_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxa_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)bxa_manufacturer {
    return objc_getAssociatedObject(self, &bxa_manufacturerKey);
}

- (CBCharacteristic *)bxa_deviceModel {
    return objc_getAssociatedObject(self, &bxa_deviceModelKey);
}

- (CBCharacteristic *)bxa_productDate {
    return objc_getAssociatedObject(self, &bxa_productDateKey);
}

- (CBCharacteristic *)bxa_hardware {
    return objc_getAssociatedObject(self, &bxa_hardwareKey);
}

- (CBCharacteristic *)bxa_software {
    return objc_getAssociatedObject(self, &bxa_softwareKey);
}

- (CBCharacteristic *)bxa_firmware {
    return objc_getAssociatedObject(self, &bxa_firmwareKey);
}

- (CBCharacteristic *)bxa_password {
    return objc_getAssociatedObject(self, &bxa_passwordKey);
}

- (CBCharacteristic *)bxa_disconnectType {
    return objc_getAssociatedObject(self, &bxa_disconnectTypeKey);
}

- (CBCharacteristic *)bxa_custom {
    return objc_getAssociatedObject(self, &bxa_customKey);
}

- (CBCharacteristic *)bxa_threeSensor {
    return objc_getAssociatedObject(self, &bxa_threeSensorKey);
}

@end
