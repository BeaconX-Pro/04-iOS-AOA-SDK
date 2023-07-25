//
//  MKBXACSlotConfigAdvCell.h
//  MKBeaconXProACTag_Example
//
//  Created by aa on 2023/7/21.
//  Copyright © 2023 MOKO. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXACSlotConfigAdvCellModel : NSObject

/*
 0:2401MHZ
 1:2402MHZ
 2:2426MHZ
 3:2480MHZ
 4:2481MHZ
 */
@property (nonatomic, assign)NSInteger advChannel;

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
@property (nonatomic, assign)NSInteger advInterval;

@property (nonatomic, copy)NSString *advDuration;

@property (nonatomic, copy)NSString *standbyDuration;

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
@property (nonatomic, assign)NSInteger advTxPower;

@end


@protocol MKBXACSlotConfigAdvCellDelegte <NSObject>

- (void)bxa_slotConfigAdvCell_channelChanged:(NSInteger)channel;

- (void)bxa_slotConfigAdvCell_intervalChanged:(NSInteger)interval;

- (void)bxa_slotConfigAdvCell_advDurationChanged:(NSString *)duration;

- (void)bxa_slotConfigAdvCell_standbyDurationChanged:(NSString *)duration;

- (void)bxa_slotConfigAdvCell_txPowerChanged:(NSInteger)txPower;

@end

@interface MKBXACSlotConfigAdvCell : MKBaseCell

@property (nonatomic, strong)MKBXACSlotConfigAdvCellModel *dataModel;

@property (nonatomic, weak)id <MKBXACSlotConfigAdvCellDelegte>delegate;

+ (MKBXACSlotConfigAdvCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
