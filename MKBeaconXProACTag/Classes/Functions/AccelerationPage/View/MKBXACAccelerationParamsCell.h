//
//  MKBXACAccelerationParamsCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/24.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACAccelerationParamsCellModel : NSObject

@property (nonatomic, copy)NSString *threshold;

@end

@protocol MKBXACAccelerationParamsCellDelegate <NSObject>

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxa_accelerationMotionThresholdChanged:(NSString *)threshold;

@end

@interface MKBXACAccelerationParamsCell : MKBaseCell

@property (nonatomic, weak)id <MKBXACAccelerationParamsCellDelegate>delegate;

@property (nonatomic, strong)MKBXACAccelerationParamsCellModel *dataModel;

+ (MKBXACAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
