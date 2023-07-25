
#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKBXACCentralManager

typedef NS_ENUM(NSInteger, mk_bxa_centralConnectStatus) {
    mk_bxa_centralConnectStatusUnknow,                                           //未知状态
    mk_bxa_centralConnectStatusConnecting,                                       //正在连接
    mk_bxa_centralConnectStatusConnected,                                        //连接成功
    mk_bxa_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bxa_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_bxa_centralManagerStatus) {
    mk_bxa_centralManagerStatusUnable,                           //不可用
    mk_bxa_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bxa_threeAxisDataRate) {
    mk_bxa_threeAxisDataRate1hz,           //1hz
    mk_bxa_threeAxisDataRate10hz,          //10hz
    mk_bxa_threeAxisDataRate25hz,          //25hz
    mk_bxa_threeAxisDataRate50hz,          //50hz
    mk_bxa_threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_bxa_threeAxisDataAG) {
    mk_bxa_threeAxisDataAG0,               //±2g
    mk_bxa_threeAxisDataAG1,               //±4g
    mk_bxa_threeAxisDataAG2,               //±8g
    mk_bxa_threeAxisDataAG3                //±16g
};

typedef NS_ENUM(NSInteger, mk_bxa_txPower) {
    mk_bxa_txPowerNeg40dBm,   //-40dBm
    mk_bxa_txPowerNeg30dBm,   //-30dBm
    mk_bxa_txPowerNeg20dBm,   //-20dBm
    mk_bxa_txPowerNeg16dBm,   //-16dBm
    mk_bxa_txPowerNeg12dBm,   //-12dBm
    mk_bxa_txPowerNeg8dBm,    //-8dBm
    mk_bxa_txPowerNeg4dBm,    //-4dBm
    mk_bxa_txPower0dBm,       //0dBm
    mk_bxa_txPower3dBm,       //3dBm
    mk_bxa_txPower4dBm,       //4dBm
};

typedef NS_ENUM(NSInteger, mk_bxa_advChannel) {
    mk_bxa_advChannel_2401,   //2401MHZ
    mk_bxa_advChannel_2402,   //2402MHZ
    mk_bxa_advChannel_2426,   //2426MHZ
    mk_bxa_advChannel_2480,   //2480MHZ
    mk_bxa_advChannel_2481,   //2481MHZ
};

typedef NS_ENUM(NSInteger, mk_bxa_buttonTriggerType) {
    mk_bxa_buttonTriggerType_noTrigger,     //No trigger
    mk_bxa_buttonTriggerType_single,        //Single click button.
    mk_bxa_buttonTriggerType_twice,         //Press button twice.
    mk_bxa_buttonTriggerType_three,         //Press button three times.
};




@protocol mk_bxa_normalAdvModeParamProtocol <NSObject>

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


@protocol mk_bxa_buttonTriggerAdvModeParamProtocol <NSObject>

/// Device advertising interval.0ms ~ 65535ms.
@property (nonatomic, assign)NSInteger advInterval;

/// Device broadcast power.
@property (nonatomic, assign)mk_bxa_txPower txPower;

/// Device broadcast duration.1s ~ 65535s.
@property (nonatomic, assign)NSInteger advDuration;

/// Trigger Type.
@property (nonatomic, assign)mk_bxa_buttonTriggerType triggerType;

@end


#pragma mark ****************************************Delegate************************************************

@class MKBXACBaseBeacon;
@protocol mk_bxa_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param beaconList device
- (void)mk_bxa_receiveBeacon:(MKBXACBaseBeacon *)beacon;

@optional

/// Starts scanning equipment.
- (void)mk_bxa_startScan;

/// Stops scanning equipment.
- (void)mk_bxa_stopScan;

@end
