//
//  MKBXACAccelerationHeaderView.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXACAccelerationHeaderViewDelegate <NSObject>

- (void)bxa_updateThreeAxisNotifyStatus:(BOOL)notify;

@end

@interface MKBXACAccelerationHeaderView : UIView

@property (nonatomic, weak)id <MKBXACAccelerationHeaderViewDelegate>delegate;

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData;

@end

NS_ASSUME_NONNULL_END
