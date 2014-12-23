//
//  ServicesController.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ServicesController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HMAccessory *accessory;
@property (nonatomic, strong) NSString *name;
@end
