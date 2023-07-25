//
//  MKBXACSlotConfigTriggerCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACSlotConfigTriggerCellModel : NSObject

@property (nonatomic, assign)BOOL trigger;

/// 0:Single click button   1:Press button twice  2:Press button three times
@property (nonatomic, assign)NSInteger triggerType;

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
@property (nonatomic, assign)NSInteger triggerInterval;

@property (nonatomic, copy)NSString *triggerDuration;

/*
 0:-40dBm
 1:-30dBm
 2:-20dBm
 3:-16dBm
 4:-12dBm
 5:-8dBm
 6:-4dBm
 7:0dBm
 8:3dBm
 9:4dBm
 */
@property (nonatomic, assign)NSInteger triggerTxPower;

@end


@protocol MKBXACSlotConfigTriggerCellDelegate <NSObject>

- (void)bxa_slotConfigTriggerCell_triggerStatusChanged:(BOOL)isOn;

- (void)bxa_slotConfigTriggerCell_triggerTypeChanged:(NSInteger)type;

- (void)bxa_slotConfigTriggerCell_intervalChanged:(NSInteger)interval;

- (void)bxa_slotConfigTriggerCell_durationChanged:(NSString *)duration;

- (void)bxa_slotConfigTriggerCell_txPowerChanged:(NSInteger)txPower;

@end

@interface MKBXACSlotConfigTriggerCell : MKBaseCell

@property (nonatomic, strong)MKBXACSlotConfigTriggerCellModel *dataModel;

@property (nonatomic, weak)id <MKBXACSlotConfigTriggerCellDelegate>delegate;

+ (MKBXACSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
