//
//  ControlPanelController.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-4.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ControlPanelController : UIViewController

@property (nonatomic, strong) HMAccessory *accessory;

@property (weak, nonatomic) IBOutlet UISwitch *swtich2;
@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UISlider *setTempSlider;
@property (weak, nonatomic) IBOutlet UISlider *nowTempSlider;
@property (weak, nonatomic) IBOutlet UISlider *setModeSlider;
@property (weak, nonatomic) IBOutlet UISlider *nowModeSlider;
@property (weak, nonatomic) IBOutlet UISlider *windSpeedSlider;
@property (weak, nonatomic) IBOutlet UISlider *windDirectionSlider;
@property (weak, nonatomic) IBOutlet UISlider *humiditySlider;
@property (weak, nonatomic) IBOutlet UISlider *heatingBoardSlider;
@property (weak, nonatomic) IBOutlet UISlider *coolingBoardSlider;

@property (weak, nonatomic) IBOutlet UILabel *setTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *setModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *setHumidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *heatingBoardLabel;
@property (weak, nonatomic) IBOutlet UILabel *coolingBoardLabel;

- (IBAction)powerChangeAction:(id)sender;
- (IBAction)setTempValueChangeAction:(id)sender;
- (IBAction)nowTempValueChangeAction:(id)sender;
- (IBAction)setModeValueChangeAction:(id)sender;
- (IBAction)nowModeValueChangeAction:(id)sender;
- (IBAction)windSpeedValueChangeAction:(id)sender;
- (IBAction)windDirectionValueChangeAction:(id)sender;
- (IBAction)switch2ValueChange:(id)sender;

- (IBAction)setTempAction:(id)sender;
- (IBAction)setModeAction:(id)sender;
- (IBAction)speedAction:(id)sender;
- (IBAction)directAction:(id)sender;
- (IBAction)humidityValueChange:(id)sender;
- (IBAction)setHumidityAction:(id)sender;
- (IBAction)heatingBoardValueChange:(id)sender;
- (IBAction)heatingBoardAction:(id)sender;
- (IBAction)coolingBoardValueChange:(id)sender;
- (IBAction)coolingBoardAction:(id)sender;

@end
