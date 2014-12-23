//
//  CharacteristicsController.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface CharacteristicsController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HMService *service;

@end
