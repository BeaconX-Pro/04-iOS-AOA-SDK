//
//  MKBXACScanFilterView.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/19.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACScanFilterView : UIView

/// 加载扫描过滤页面
/// @param macAddress 过滤的macAddress
/// @param rssi 过滤的rssi
/// @param searchBlock 回调
+ (void)showSearchMac:(NSString *)macAddress
                 rssi:(NSInteger)rssi
          searchBlock:(void (^)(NSString *searchMac, NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
