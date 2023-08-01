//
//  Target_BXPAC_Module.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_BXPAC_Module : NSObject

/// 扫描页面
- (UIViewController *)Action_BXAC_Module_ScanController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
