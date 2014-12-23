//
//  JRHomeKitManager.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>

typedef NS_ENUM(NSInteger, MediaAC_WorkingMode) {
    MediaAC_WorkingModeOff = 0,
    MediaAC_WorkingModeHeating,
    MediaAC_WorkingModeCooling,
    MediaAC_WorkingModeDehumidification,
};

typedef NS_ENUM(NSInteger, MediaAC_RotationDirection) {
    MediaAC_RotationDirectionCounterClockwise = 0,
    MediaAC_RotationDirectionClockwise,
};

typedef NS_ENUM(NSInteger, MediaAC_RotationSpeed) {
    MediaAC_RotationSpeedMute = 0,
    MediaAC_RotationSpeedLow,
    MediaAC_RotationSpeedMidden,
    MediaAC_RotationSpeedHigh,
    MediaAC_RotationSpeedAuto,
};

typedef NS_ENUM(NSInteger, MediaAC_Unit) {
    MediaAC_Unit_C = 0,
    MediaAC_Unit_F,
};

static NSString *const kNotificationAccessoryFound = @"kNotificationAccessoryFound";
static NSString *const kNotificationValueUpdated = @"kNotificationValueUpdated";

static NSString *const SERVICE_ID_DEVICE_INFO = @"0000003E-0000-1000-8000-0026BB765291";// 设备信息
static NSString *const SERVICE_ID_POWER_STATE = @"00000049-0000-1000-8000-0026BB765291"; // 开关？
static NSString *const SERVICE_ID_THERMOSTAT = @"0000004A-0000-1000-8000-0026BB765291"; //
static NSString *const SERVICE_ID_FAN = @"00000040-0000-1000-8000-0026BB765291"; //

static NSString *const CHARACTERISTIC_DEVICE_NAME = @"00000023-0000-1000-8000-0026BB765291"; // Device name
static NSString *const CHARACTERISTIC_DEVICE_MANUFACTURER = @"00000020-0000-1000-8000-0026BB765291"; // Manufacturer
static NSString *const CHARACTERISTIC_DEVICE_MODEL = @"00000021-0000-1000-8000-0026BB765291"; // Model
static NSString *const CHARACTERISTIC_DEVICE_SERIAL_NUMBER = @"00000030-0000-1000-8000-0026BB765291"; // Serial number
static NSString *const CHARACTERISTIC_DEVICE_IDENTIFY = @"00000014-0000-1000-8000-0026BB765291"; // Identify

static NSString *const CHARACTERISTIC_POWER_STATE = @"00000025-0000-1000-8000-0026BB765291"; // Power state

static NSString *const CHARACTERISTIC_THERMOSTAT_COOLING_THRESHOLD_TEMP = @"0000000D-0000-1000-8000-0026BB765291"; // Cooling threshold
static NSString *const CHARACTERISTIC_THERMOSTAT_CURRENT_MODE = @"0000000F-0000-1000-8000-0026BB765291"; // Current mode : 0:off,1:heating,2:cooling
static NSString *const CHARACTERISTIC_THERMOSTAT_CURRENT_RELATIVE_HUMIDITY = @"00000010-0000-1000-8000-0026BB765291"; // Current relative humidity
static NSString *const CHARACTERISTIC_THERMOSTAT_CURRENT_TEMPERATURE = @"00000011-0000-1000-8000-0026BB765291"; // Current temperature
static NSString *const CHARACTERISTIC_THERMOSTAT_HEATING_THRESHOLD_TEMP = @"00000012-0000-1000-8000-0026BB765291"; // Heating threshold
static NSString *const CHARACTERISTIC_THERMOSTAT_TARGET_MODE = @"00000033-0000-1000-8000-0026BB765291"; // Target mode
static NSString *const CHARACTERISTIC_THERMOSTAT_TARGET_RELATIVE_HUMIDITY = @"00000034-0000-1000-8000-0026BB765291"; // Target relative humidity
static NSString *const CHARACTERISTIC_THERMOSTAT_TARGET_TEMPRATURE = @"00000035-0000-1000-8000-0026BB765291"; // Target temperature
static NSString *const CHARACTERISTIC_THERMOSTAT_TEMPERATURE_UNIT = @"00000036-0000-1000-8000-0026BB765291"; // Temperature units

static NSString *const CHARACTERISTIC_FAN_POWER_STATE = @"00000025-0000-1000-8000-0026BB765291"; // Power state
static NSString *const CHARACTERISTIC_FAN_ROTATION_DIRECTION = @"00000028-0000-1000-8000-0026BB765291"; // Rotation direction
static NSString *const CHARACTERISTIC_FAN_ROTATION_SPEED = @"00000029-0000-1000-8000-0026BB765291"; // Rotation speed

typedef void (^JRBooleanResultBlock)(BOOL success);

@interface JRHomeKitManager : NSObject<HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMAccessoryDelegate>

+ (instancetype)shareManager;

- (void)startScanAccessory;
- (void)stopScanAccessory;

- (void)addHome:(NSString *)homeName completionHandler:(JRBooleanResultBlock)completed;
- (void)addRoom:(NSString *)roomName completionHandler:(JRBooleanResultBlock)completed;
- (void)addAccessory:(HMAccessory *)accessory toHome:(HMHome *)home completionHandler:(JRBooleanResultBlock)completed;
- (void)removeAccessory:(HMAccessory *)accessory fromHome:(HMHome *)home completionHandler:(JRBooleanResultBlock)completed;
- (void)enableCharacteristicsOfServicesInAccessory:(HMAccessory *)accessory;

- (HMHome *)primaryHome;
- (NSArray *)homes;
- (NSArray *)accessoriesOfHome:(HMHome *)home;

- (NSString *)accessoryName;
- (NSString *)manufacturer;
- (NSString *)model;
- (NSString *)serialNumber;
- (NSString *)identify;

/*======================================================
 control command
 /======================================================*/
- (void)setPowerOn:(BOOL)on;
- (void)setTargetTemperature:(NSInteger)temp;
- (void)setTargetMode:(MediaAC_WorkingMode)mode;
- (void)setFanPowerState:(BOOL)on;
- (void)setWindDirection:(MediaAC_RotationDirection)direction;
- (void)setWindSpeed:(MediaAC_RotationSpeed)speed;
- (void)setWindSpeedWithValue:(NSInteger)speedValue;


//目前不需要的
- (void)setTargetHumidity:(NSInteger)humidity;
- (void)setTempUnit:(MediaAC_Unit)unit;
- (void)setHeatingThresholdTemp:(NSInteger)temp;
- (void)setCoolingThresholdTemp:(NSInteger)temp;
@end
