//
//  CharacteriticDetailController.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-2.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface CharacteriticDetailController : UIViewController
@property (nonatomic, strong) HMCharacteristic *characteristic;

@property (weak, nonatomic) IBOutlet UILabel *characteristicLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
