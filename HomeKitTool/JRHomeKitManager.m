//
//  JRHomeKitManager.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "JRHomeKitManager.h"


static NSString *const HOME_NAME = @"My home";
static NSString *const ROOM_NAME = @"My room";
static NSString *const ACCESSORY_NAME = @"Midea";


@interface JRHomeKitManager ()

@property (nonatomic, retain) HMHomeManager *homeManager;
@property (nonatomic, retain) HMAccessoryBrowser *accessoryBrowser;
@property (nonatomic, retain) HMAccessory *accessory;
@property (nonatomic, retain) NSMutableArray *blocksArray;

@property (nonatomic, strong) HMCharacteristic *powerCharacteristic;
@property (nonatomic, strong) HMCharacteristic *targetModeCharacteristic;
@property (nonatomic, strong) HMCharacteristic *targetTempCharacteristic;

@property (nonatomic, strong) HMCharacteristic *targetHumidityCharacteristic;
@property (nonatomic, strong) HMCharacteristic *tempUnitCharacteristic;
@property (nonatomic, strong) HMCharacteristic *coolingThresholdTempCharacteristic;
@property (nonatomic, strong) HMCharacteristic *heatingThresholdTempCharacteristic;

@property (nonatomic, strong) HMCharacteristic *fanPowerCharacteristic;
@property (nonatomic, strong) HMCharacteristic *rotationDirectCharacteristic;
@property (nonatomic, strong) HMCharacteristic *rotateionSpeedCharacteristic;

@property (nonatomic, strong) HMCharacteristic *nameCharacteristic;
@property (nonatomic, strong) HMCharacteristic *manufacturerCharacteristic;
@property (nonatomic, strong) HMCharacteristic *modelCharacteristic;
@property (nonatomic, strong) HMCharacteristic *serialCharacteristic;
@property (nonatomic, strong) HMCharacteristic *identifyCharacteristic;

@property (nonatomic, strong) NSMutableDictionary *foundAccessories;

@end

@implementation JRHomeKitManager

+ (instancetype)shareManager {
    
    static JRHomeKitManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareManager =[[JRHomeKitManager alloc] init];
        
    });
    
    return shareManager;
}

- (instancetype)init {
    
    @synchronized(self) {
        if (self = [super init]) {
            _homeManager = [[HMHomeManager alloc] init];
            _homeManager.delegate = self;
            _accessoryBrowser = [[HMAccessoryBrowser alloc] init];
            _accessoryBrowser.delegate = self;
            _blocksArray = [[NSMutableArray alloc] init];
            _foundAccessories = [[NSMutableDictionary alloc] init];
            return self;
        }
    }
    return nil;
}

#pragma mark --Misc

- (HMHome *)primaryHome {
    
    if(self.homeManager.primaryHome) {
        return self.homeManager.primaryHome;
    }
    return nil;
}

- (NSArray *)homes {
    return self.homeManager.homes;
}

- (int)limitedValue:(NSInteger)value fromMin:(NSInteger)min toMax:(NSInteger)max {
    NSInteger limitedValue = value;
    
    if (limitedValue > max) {
        limitedValue = max;
    }else if(limitedValue < min) {
        limitedValue = min;
    }
    return (int)limitedValue;
}

- (MediaAC_RotationSpeed)modeOfRotationSpeedWithValue:(NSInteger)value
{
    MediaAC_RotationSpeed rotationSpeedMode = 0;
    
    if (value >= 0 && value <= 20)
    {
        rotationSpeedMode = MediaAC_RotationSpeedMute;
    }
    else if (value >= 21 && value <= 40)
    {
        rotationSpeedMode = MediaAC_RotationSpeedLow;
    }
    else if (value >= 41 && value <= 60)
    {
        rotationSpeedMode = MediaAC_RotationSpeedMidden;
    }
    else if (value >= 61 && value <= 80)
    {
        rotationSpeedMode = MediaAC_RotationSpeedHigh;
    }
    else if (value >= 81 && value <= 102)
    {
        rotationSpeedMode = MediaAC_RotationSpeedAuto;
    }
    
    return rotationSpeedMode;
}

- (NSInteger)modeToWindSpeedValue:(MediaAC_RotationSpeed)rotateSpeed{
    switch (rotateSpeed) {
        case MediaAC_RotationSpeedMute:{
            return 10;
            break;
        }
        case MediaAC_RotationSpeedLow:{
            return 30;
            break;
        }
        case MediaAC_RotationSpeedMidden:{
            return 50;
            break;
        }
        case MediaAC_RotationSpeedHigh:{
            return 70;
            break;
        }
        case MediaAC_RotationSpeedAuto:{
            return 90;
            break;
        }
        default:
            break;
    }
}

- (void)enableCharacteristicsOfServicesInAccessory:(HMAccessory *)accessory {
    
    accessory.delegate = self;
    
    for(HMService *service in accessory.services) {
        NSLog(@"serviceType : %@",service.serviceType);
        for(HMCharacteristic *characteristic in service.characteristics) {
            NSLog(@"charaType : %@",characteristic.characteristicType);
            if ([characteristic.characteristicType isEqualToString:CHARACTERISTIC_DEVICE_IDENTIFY]) {
                NSLog(@"============ CHARACTERISTIC_DEVICE_IDENTIFY ============");

                self.identifyCharacteristic = characteristic;
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_DEVICE_MANUFACTURER]){
                NSLog(@"============ CHARACTERISTIC_DEVICE_MANUFACTURER ============");

                self.manufacturerCharacteristic = characteristic;

            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_DEVICE_MODEL]){
                NSLog(@"============ CHARACTERISTIC_DEVICE_MODEL ============");

                self.modelCharacteristic = characteristic;

            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_DEVICE_NAME]){
                NSLog(@"============ CHARACTERISTIC_DEVICE_NAME ============");

                self.nameCharacteristic = characteristic;

            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_DEVICE_SERIAL_NUMBER]){
                NSLog(@"============ CHARACTERISTIC_DEVICE_SERIAL_NUMBER ============");

                self.serialCharacteristic = characteristic;

            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_POWER_STATE] && [service.serviceType isEqualToString:SERVICE_ID_POWER_STATE]){
                NSLog(@"============ CHARACTERISTIC_POWER_STATE ============");

                self.powerCharacteristic = characteristic;
                [self.powerCharacteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale POWER : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_COOLING_THRESHOLD_TEMP]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_COOLING_THRESHOLD_TEMP ============");

                self.coolingThresholdTempCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale COOLING_THRESHOLD_TEMP : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_HEATING_THRESHOLD_TEMP]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_HEATING_THRESHOLD_TEMP ============");

                self.heatingThresholdTempCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale HEATTING_THRESHOLD_TEMP : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_TARGET_MODE]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_TARGET_MODE ============");

                self.targetModeCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale TARGET_MODE : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_TARGET_RELATIVE_HUMIDITY]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_TARGET_RELATIVE_HUMIDITY ============");

                self.targetHumidityCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale TARGET_HUMIDITY : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_TARGET_TEMPRATURE]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_TARGET_TEMPRATURE ============");

                self.targetTempCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale TARGET_TEMP : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_TEMPERATURE_UNIT]){
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_TEMPERATURE_UNIT ============");

                self.tempUnitCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale TEMP_UNIT : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_FAN_POWER_STATE]&& [service.serviceType isEqualToString:SERVICE_ID_FAN]){
                NSLog(@"============ CHARACTERISTIC_FAN_POWER_STATE ============");

                self.fanPowerCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale FAN_POWER : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_FAN_ROTATION_DIRECTION]){
                NSLog(@"============ CHARACTERISTIC_FAN_ROTATION_DIRECTION ============");

                self.rotationDirectCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale ROTATE_DIRECTION : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_FAN_ROTATION_SPEED]){
                NSLog(@"============ CHARACTERISTIC_FAN_ROTATION_SPEED ============");

                self.rotateionSpeedCharacteristic = characteristic;
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale ROTATE_SPEED : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_CURRENT_MODE]) {
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_CURRENT_MODE ============");
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale CURRENT_MODE : %@",error);
                    }
                }];
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_CURRENT_RELATIVE_HUMIDITY]) {
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_CURRENT_RELATIVE_HUMIDITY ============");
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale CURRENT_HUMIDITY : %@",error);
                    }
                }];
                
            }else if([characteristic.characteristicType isEqualToString:CHARACTERISTIC_THERMOSTAT_CURRENT_TEMPERATURE]) {
                NSLog(@"============ CHARACTERISTIC_THERMOSTAT_CURRENT_TEMPERATURE ============");
                [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"Error in enbale CURRENT_TEMPERATURE : %@",error);
                    }
                }];
            }
        }
    }
}

#pragma mark --Home Manager

- (void)addHome:(NSString *)homeName completionHandler:(JRBooleanResultBlock)completed {
    NSLog(@"============ addHome ============");
    
    
    [self.homeManager addHomeWithName:homeName completionHandler:^(HMHome *home, NSError *error) {
        if (error) {
            NSLog(@"error in addHome:%@",error);
            completed(NO);
            return;
        }else {
            NSLog(@"successfully in addHome!");
            completed(YES);
        }
    }];
}

- (void)addRoom:(NSString *)roomName completionHandler:(JRBooleanResultBlock)completed {
    NSLog(@"============ addRoom ============");
    
    [self.homeManager.primaryHome addRoomWithName:roomName completionHandler:^(HMRoom *room, NSError *error) {
        if (error) {
            NSLog(@"error in addRoom:%@",error);
            completed(NO);
            return;
        }else {
            NSLog(@"successfully in addRoom!");
            completed(YES);
        }
        
    }];
}

#pragma mark --Home Manager Delegate


- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home {
    
    NSLog(@"============ didAddHome ============");
    NSLog(@"add Home : %@",home.name);

}

- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home {
    
    NSLog(@"============ didRemoveHome ============");
    NSLog(@"remove Home : %@",home.name);
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    NSLog(@"============ homeManagerDidUpdatePrimaryHome ============");
    NSLog(@"primary Home : %@", manager.primaryHome.name);
}

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    
    NSLog(@"============ homeManagerDidUpdateHomes ============");
    
    NSLog(@"Homes Description: %@", manager.homes.debugDescription);
    
    NSLog(@"Romms Description: %@", manager.primaryHome.rooms.debugDescription);
    
    BOOL isHomeExist = NO;
    
    for(HMHome *home in manager.homes) {
        if ([home.name isEqualToString:HOME_NAME]) {
            isHomeExist = YES;
            break;
        }
    }
    
    if (!isHomeExist) {
        [self addHome:HOME_NAME completionHandler:^(BOOL success) {}];
    }
}

#pragma mark --Accessory Browser

- (void)startScanAccessory {
    [_foundAccessories removeAllObjects];
    [self.accessoryBrowser startSearchingForNewAccessories];
}

- (void)stopScanAccessory {
    [self.accessoryBrowser stopSearchingForNewAccessories];
}


#pragma mark --Accessory Browser Delegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    NSLog(@"============ didFindNewAccessory ============");
    NSLog(@"NewAccessory: %@", accessory.debugDescription);
    NSLog(@"services Count %d",(int)accessory.services.count);
    
    HMAccessory *foundAccessory = [_foundAccessories objectForKey:[accessory.identifier UUIDString]];
    
    if (foundAccessory) {
        return;
    }
    
    [_foundAccessories setObject:accessory forKey:[accessory.identifier UUIDString]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAccessoryFound object:accessory];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    
}

#pragma mark --Accessory

- (void)initFoundAccessory {
    NSLog(@"============ initFoundAccessory ============");
    NSLog(@"accessory: %@", self.accessory);
    self.accessory.delegate = self;
    [self stopScanAccessory];
}

- (void)beginToFindAccessory {
    NSLog(@"============ beginToFindAccessory ============");
    [self startScanAccessory];
}

- (void)addAccessory:(HMAccessory *)accessory toHome:(HMHome *)home completionHandler:(JRBooleanResultBlock)completed {
    NSLog(@"============ addAccessoryToHome ============");
    [home addAccessory:accessory completionHandler:^(NSError *error) {
        if (error) {
            completed(NO);
            NSLog(@"addAccessory error : %@",error);
            return;
        }else {
            NSLog(@"addAccessory Successful");
            if ([accessory.name isEqualToString:ACCESSORY_NAME]) {
                [self enableCharacteristicsOfServicesInAccessory:accessory];
            }
            completed(YES);
        }
    }];
}

- (void)removeAccessory:(HMAccessory *)accessory fromHome:(HMHome *)home completionHandler:(JRBooleanResultBlock)completed {
    NSLog(@"============ removeAccessoryFromHome ============");
    [home removeAccessory:accessory completionHandler:^(NSError *error) {
        if (error) {
            completed(NO);
            NSLog(@"removeAccessory Error: %@",error);
        }else {
            NSLog(@"removeAccessory Successful");
            completed(YES);
        }
    }];
}

- (NSArray *)accessoriesOfHome:(HMHome *)home {
    if (self.homeManager.primaryHome) {
        return self.homeManager.primaryHome.accessories;
    }
    return nil;
}

#pragma mark --Accessory Delegate

- (void)accessoryDidUpdateName:(HMAccessory *)accessory {
    
}

- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service {
    
}

- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service {
    
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    
}

- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
    NSLog(@"============ didUpdateValueForCharacteristic ============");
    NSDictionary *parameters = @{
                                 @"accessory":accessory,
                                 @"service":service,
                                 @"characteristic":characteristic
                                 };
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationValueUpdated object:parameters];
}

#pragma mark --Contol Command


/*======================================================
    control command
 /======================================================*/

- (void)setPowerOn:(BOOL)on {
    NSLog(@"============ setPowerOn: %d ============",on);
    if (_powerCharacteristic) {
        [_powerCharacteristic writeValue:@(on) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setTargetTemperature:(NSInteger)temp {
    NSLog(@"============ setTemp:%d ============",(int)temp);

    int tempLimited = [self limitedValue:temp fromMin:17 toMax:30];
    
    if (_targetTempCharacteristic) {
        [_targetTempCharacteristic writeValue:@(tempLimited) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setTargetMode:(MediaAC_WorkingMode)mode {
    NSLog(@"============ setMode:%d ============",(int)mode);
    if (_targetModeCharacteristic) {
        [_targetModeCharacteristic writeValue:@(mode) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setTargetHumidity:(NSInteger)humidity {
    NSLog(@"============ setHumidity:%d ============",(int)humidity);
    if (_targetHumidityCharacteristic) {
        [_targetHumidityCharacteristic writeValue:@(humidity) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setTempUnit:(MediaAC_Unit)unit {
    NSLog(@"============ setUnit:%d ============",(int)unit);
    if (_tempUnitCharacteristic) {
        [_tempUnitCharacteristic writeValue:@(unit) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setHeatingThresholdTemp:(NSInteger)temp {
    NSLog(@"============ setHeatingThresholdTemp:%d ============",(int)temp);
    if (_heatingThresholdTempCharacteristic) {
        [_heatingThresholdTempCharacteristic writeValue:@(temp) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setCoolingThresholdTemp:(NSInteger)temp {
    NSLog(@"============ setCoolingThresholdTemp:%d ============",(int)temp);
    if (_coolingThresholdTempCharacteristic) {
        [_coolingThresholdTempCharacteristic writeValue:@(temp) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setFanPowerState:(BOOL)on {
    NSLog(@"============ setFanPowerState:%d ============",(int)on);
    if (_fanPowerCharacteristic) {
        [_fanPowerCharacteristic writeValue:@(on) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setWindDirection:(MediaAC_RotationDirection)direction {
    NSLog(@"============ setWindDirection:%d ============",(int)direction);
    if (_rotationDirectCharacteristic) {
        [_rotationDirectCharacteristic writeValue:@(direction) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setWindSpeed:(MediaAC_RotationSpeed)speed {
    NSLog(@"============ setWindSpeed:%d ============",(int)speed);
    NSInteger speedValue = [self modeToWindSpeedValue:speed];
    if (_rotateionSpeedCharacteristic) {
        [_rotateionSpeedCharacteristic writeValue:@(speedValue) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

- (void)setWindSpeedWithValue:(NSInteger)speedValue {
    NSLog(@"============ setWindSpeedWithValue:%d ============",(int)speedValue);
    if (_rotateionSpeedCharacteristic) {
        [_rotateionSpeedCharacteristic writeValue:@(speedValue) completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error in write: %@",error);
            }
        }];
    }
}

#pragma mark --Device Info

- (NSString *)accessoryName {
    return self.nameCharacteristic.value;
}

- (NSString *)manufacturer {
    return self.manufacturerCharacteristic.value;
}

- (NSString *)model {
    return self.modelCharacteristic.value;
}

- (NSString *)serialNumber {
    return self.serialCharacteristic.value;
}

- (NSString *)identify {
    return self.identifyCharacteristic.value;
}

@end
