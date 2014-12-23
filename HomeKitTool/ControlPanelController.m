//
//  ControlPanelController.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-4.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "ControlPanelController.h"
#import "JRHomeKitManager.h"

#define CharacteristicTypeIsEqual(_characteristic,_type) [_characteristic.characteristicType isEqualToString:(_type)]

@interface ControlPanelController ()

@property (nonatomic, strong) HMCharacteristic *powerChara;
@property (nonatomic, strong) HMCharacteristic *setTempChara;
@property (nonatomic, strong) HMCharacteristic *nowTempChara;
@property (nonatomic, strong) HMCharacteristic *setModeChara;
@property (nonatomic, strong) HMCharacteristic *nowModeChara;
@property (nonatomic, strong) HMCharacteristic *windSpeedChara;
@property (nonatomic, strong) HMCharacteristic *windDirectChara;

@end

@implementation ControlPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _setTempSlider.minimumValue =  17;
    _setTempSlider.maximumValue = 30;
    
    _nowTempSlider.minimumValue = 17;
    _nowTempSlider.maximumValue = 30;
    
    _setModeSlider.minimumValue = 0;
    _setModeSlider.maximumValue = 5;
    
    _nowModeSlider.minimumValue = 0;
    _nowModeSlider.maximumValue = 4;
    
    _heatingBoardSlider.minimumValue = 10;
    _heatingBoardSlider.maximumValue = 25;
    
    _coolingBoardSlider.minimumValue = 10;
    _coolingBoardSlider.maximumValue = 35;
    
    _humiditySlider.minimumValue = 0;
    _humiditySlider.maximumValue = 100;
    
    _windSpeedSlider.minimumValue = 0;
    _windSpeedSlider.maximumValue = 4;
    
    _windDirectionSlider.minimumValue = 0;
    _windDirectionSlider.maximumValue = 2;
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateValueFromHomeKit:) name:kNotificationValueUpdated object:nil];
    
    NSLog(@"%@",[[JRHomeKitManager shareManager] accessoryName]);
    NSLog(@"%@",[[JRHomeKitManager shareManager] model]);
    NSLog(@"%@",[[JRHomeKitManager shareManager] serialNumber]);
    NSLog(@"%@",[[JRHomeKitManager shareManager] manufacturer]);
    NSLog(@"%@",[[JRHomeKitManager shareManager] identify]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//- (void)setAccessory:(HMAccessory *)accessory {
//    _accessory = accessory;
//    for(HMService *service in accessory.services) {
//        if (![service.serviceType isEqualToString:SERVICE_ID_DEVICE_INFO]) {
//            for(HMCharacteristic *characteristic in service.characteristics) {
//                [self updateWidgetWithCharacteristic:characteristic];
//            }
//        }
//    }
//}

#pragma mark --Notification Selector

- (void)didUpdateValueFromHomeKit:(NSNotification *)notify {
    NSDictionary *parameters = notify.object;
    HMCharacteristic *characteristic = parameters[@"characteristic"];
    HMService *service = parameters[@"service"];
    [self updateWidgetWithCharacteristic:characteristic service:service];
}

#pragma mark --IBAction


- (IBAction)switch2ValueChange:(id)sender {
    UISwitch *powerSwitch = sender;
    [[JRHomeKitManager shareManager] setFanPowerState:powerSwitch.isOn];
}

- (IBAction)setTempAction:(id)sender {
    UISlider *tempSlider = sender;
    int value = (int)tempSlider.value;
    [[JRHomeKitManager shareManager] setTargetTemperature:value];
}

- (IBAction)setModeAction:(id)sender {
    UISlider *modeSlider = sender;
    int value = (int)modeSlider.value;
    
    [[JRHomeKitManager shareManager] setTargetMode:value];
}

- (IBAction)speedAction:(id)sender {
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    [[JRHomeKitManager shareManager] setWindSpeed:value];
}

- (IBAction)directAction:(id)sender {
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    [[JRHomeKitManager shareManager] setWindDirection:value];
}

- (IBAction)humidityValueChange:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    
    self.setHumidityLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)setHumidityAction:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    [[JRHomeKitManager shareManager] setTargetHumidity:value];
}

- (IBAction)heatingBoardValueChange:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    
    self.heatingBoardLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)heatingBoardAction:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    
    [[JRHomeKitManager shareManager] setHeatingThresholdTemp:value];
}

- (IBAction)coolingBoardValueChange:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    
    self.coolingBoardLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)coolingBoardAction:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    
    [[JRHomeKitManager shareManager] setCoolingThresholdTemp:value];
}

- (IBAction)powerChangeAction:(id)sender {
    
    UISwitch *powerSwitch = sender;
    [[JRHomeKitManager shareManager] setPowerOn:powerSwitch.isOn];
}

- (IBAction)setTempValueChangeAction:(id)sender {
    
    UISlider *tempSlider = sender;
    int value = (int)tempSlider.value;

    self.setTempLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)nowTempValueChangeAction:(id)sender {
    
    
    UISlider *tempSlider = sender;
    int value = (int)tempSlider.value;

    self.nowTempLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)setModeValueChangeAction:(id)sender {
    
    UISlider *modeSlider = sender;
    int value = (int)modeSlider.value;

    self.setModeLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)nowModeValueChangeAction:(id)sender {
    
    UISlider *modeSlider = sender;
    int value = (int)modeSlider.value;

    self.nowModeLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)windSpeedValueChangeAction:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    self.windSpeenLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)windDirectionValueChangeAction:(id)sender {
    
    UISlider *windSlider = sender;
    int value = (int)windSlider.value;
    self.windDirectionLabel.text = [NSString stringWithFormat:@"%d",value];
}

#pragma mark --I/O
- (void)updateWidgetWithCharacteristic:(HMCharacteristic *)characteristic service:(HMService *)service{
    if (CharacteristicTypeIsEqual(characteristic, CHARACTERISTIC_POWER_STATE) && [service.serviceType isEqualToString:SERVICE_ID_POWER_STATE]) {
        
        BOOL powerOn = [characteristic.value boolValue];
        self.powerSwitch.on = powerOn;
        
    }else if(CharacteristicTypeIsEqual(characteristic,CHARACTERISTIC_FAN_POWER_STATE) && [service.serviceType isEqualToString:SERVICE_ID_FAN]){
        
        BOOL powerOn = [characteristic.value boolValue];
        self.swtich2.on = powerOn;
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeTargetTemperature)) {
        int setTemp = [characteristic.value intValue];
        self.setTempSlider.value = setTemp;
        self.setTempLabel.text = [NSString stringWithFormat:@"%d",setTemp];
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeCurrentTemperature)) {
        /*
         -->this characteristic readOnly
         */
        
        int nowTemp = [characteristic.value intValue];
        self.nowTempSlider.value = nowTemp;
        self.nowTempLabel.text = [NSString stringWithFormat:@"%d",nowTemp];
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeTargetHeatingCooling)) {

        
        int setModeValue = [characteristic.value intValue];
        self.setModeSlider.value = setModeValue;
        self.setModeLabel.text = [NSString stringWithFormat:@"%d",setModeValue];
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeCurrentHeatingCooling)) {
        /*
         -->this characteristic readOnly
         */

        int nowModeValue = [characteristic.value intValue];
        self.nowModeSlider.value = nowModeValue;
        self.nowModeLabel.text = [NSString stringWithFormat:@"%d",nowModeValue];
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeRotationSpeed)) {

        
        int windSpeed = [characteristic.value intValue];
        self.windSpeedSlider.value = windSpeed;
        self.windSpeenLabel.text = [NSString stringWithFormat:@"%d",windSpeed];
        
    }else if(CharacteristicTypeIsEqual(characteristic, HMCharacteristicTypeRotationDirection)) {
        int windDirection = [characteristic.value intValue];
        self.windDirectionSlider.value = windDirection;
        self.windDirectionLabel.text = [NSString stringWithFormat:@"%d",windDirection];
    }else if(CharacteristicTypeIsEqual(characteristic, CHARACTERISTIC_THERMOSTAT_COOLING_THRESHOLD_TEMP)) {
        int coolingThersholdTemp = [characteristic.value intValue];
        self.coolingBoardSlider.value = coolingThersholdTemp;
        self.coolingBoardLabel.text = [NSString stringWithFormat:@"%d",coolingThersholdTemp];
    }else if(CharacteristicTypeIsEqual(characteristic, CHARACTERISTIC_THERMOSTAT_HEATING_THRESHOLD_TEMP)) {
        int heatingThersholdTemp = [characteristic.value intValue];
        self.heatingBoardSlider.value = heatingThersholdTemp;
        self.heatingBoardLabel.text = [NSString stringWithFormat:@"%d",heatingThersholdTemp];
    }else if (CharacteristicTypeIsEqual(characteristic, CHARACTERISTIC_THERMOSTAT_TEMPERATURE_UNIT)) {
        int unit = [characteristic.value intValue];
        self.unitLabel.text = [NSString stringWithFormat:@"%d",unit];
    }else if (CharacteristicTypeIsEqual(characteristic, CHARACTERISTIC_THERMOSTAT_TARGET_RELATIVE_HUMIDITY)) {
        int value = [characteristic.value intValue];
        self.humiditySlider.value = value;
        self.humidityLabel.text = [NSString stringWithFormat:@"%d",value];
        self.setHumidityLabel.text = [NSString stringWithFormat:@"%d",value];
    }
}


@end
