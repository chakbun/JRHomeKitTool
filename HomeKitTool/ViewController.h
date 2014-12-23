//
//  ViewController.h
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *accessoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *HomeInformationLabel;

@property (nonatomic, strong) NSMutableArray *accessoryArray;

- (void)addNewAccessory:(HMAccessory *)accessory;
- (void)setHOME:(NSString *)homeName room:(NSString *)roomName;

- (IBAction)scanAccessoryButtonAction:(id)sender;
- (IBAction)homeAccessoriesButtonAction:(id)sender;
- (IBAction)addHomeButtonAction:(id)sender;
- (IBAction)addRoomButtonAction:(id)sender;
- (IBAction)removeAccessoryButtonAction:(id)sender;

@end

