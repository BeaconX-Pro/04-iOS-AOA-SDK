# AOA-Tag iOS Software Development Kit Guide

* This SDK support the company's AOA-Tag series products.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let's take a look at the related classes and the relationships between them.

`MKBXACCentralManager`：global manager, check system's bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKBXACBaseBeacon`: instance of devices, MKBXACCentralManager will create an MKBXACBaseBeacon instance while it found a physical device, a device corresponds to an instance.Currently there are *Param Information Position broadcast frame*, *Triaxial Data broadcast frame*, *User Data Position broadcast frame*, *Production Test broadcast frame*;

`MKBXACInterface`: When the device is successfully connected, the device data can be read through the interface in `MKBXACInterface`;

`MKBXACInterface+MKBXACConfig.h`: When the device is successfully connected, you can configure the device data through the interface in `MKBXACInterface+MKBXACConfig.h`;


## Scanning Stage

in this stage, `MKBXACCentralManager ` will scan and analyze the advertisement data of BeaconX Pro devices, `MKBXACCentralManager ` will create `MKBXACBaseBeacon ` instance for every physical devices, developers can get all advertisement data by its property.


## Connection Stage

The device broadcast information includes whether a password is required when connecting.

1.Enter the password to connect, then call the following method to connect:
`connectPeripheral:password:sucBlock:failedBlock:`
2.You do not need to enter a password to connect, call the following method to connect:
`connectPeripheral:sucBlock:failedBlock:`


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK is available through [CocoaPods](https://cocoapods.org).To install it, simply add the following line to your Podfile, and then import `<MKBeaconXProACTag/MKBXACSDK.h>`：

**pod 'MKBeaconXProACTag/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to "info.plist" file of your project: Privacy - Bluetooth Peripheral Usage Description - "your description". as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project's info.plist file: Privacy-Bluetooth Always Usage Description-"Your usage description".</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKBXACCentralManager *manager = [MKBXACCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.`manager.delegate = self;` //Set the scan delegate and complete the related delegate methods.
* 2.you can start the scanning task in this way:`[manager startScan];`    
* 3.at the sometime, you can stop the scanning task in this way:`[manager stopScan];`

#### 2.Connect to device

The `MKBXACCentralManager ` contains the method of connecting the device.



```
/// Connect device function
/// @param peripheral peripheral
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
```

```
/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
              
```
              

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, the connection status of the device, and the lock status of the device. If you want to monitor the changes of these three states, you can register the following notifications to achieve:

*  When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_bxa_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKBXACCentralManager shared] centralStatus];
```

*  When the device connection status changes，<font color=#FF0000 face="黑体"> `mk_bxa_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

```
[MKBXACCentralManager shared].connectState;
```

#### 4.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_bv_deviceDisconnectTypeNotification` </font> notifications to monitor data.


```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_bxa_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /*
    After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.Reset the device, return 0x03.The shutdown protocol is sent to make the device shut down and return 0x04.
    */
}
```


#### 5.Monitor three-axis data.

When the device is connected, the developer can monitor the three-axis data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKBXACCentralManager shared] notifyThreeAxisAcceleration:YES];
```


*  2.Register for `mk_bxa_receiveThreeAxisAccelerometerDataNotification` notifications to monitor device three-axis data changes.


```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxa_receiveThreeAxisAccelerometerDataNotification
                                               object:nil];
```


```
#pragma mark - Notification
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSArray *tempList = dic[@"axisData"];
    if (!ValidArray(tempList)) {
        return;
    }
}
```

# Change log

* 20240815 first version;
