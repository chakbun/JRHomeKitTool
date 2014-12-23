//
//  ViewController.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "ViewController.h"
#import "ServicesController.h"
#import "JRHomeKitManager.h"
#import "ControlPanelController.h"

#define Test_Search


@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) HMAccessory *accessory;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Accessories";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNewAccessoryFound:) name:kNotificationAccessoryFound object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[JRHomeKitManager shareManager] startScanAccessory];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)scanAccessoryButtonAction:(id)sender {
    
    [self.accessoryArray removeAllObjects];
    [self.accessoryTableView reloadData];
    
    [[JRHomeKitManager shareManager] startScanAccessory];
}

- (IBAction)homeAccessoriesButtonAction:(id)sender {
    [self.accessoryArray removeAllObjects];
    self.accessoryArray = [NSMutableArray arrayWithArray:[[JRHomeKitManager shareManager] accessoriesOfHome:[JRHomeKitManager shareManager].primaryHome]];
    [self.accessoryTableView reloadData];
}

- (IBAction)addHomeButtonAction:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Home" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 100;
    [alertView show];
}

- (IBAction)addRoomButtonAction:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Room" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 101;
    [alertView show];
}

- (IBAction)removeAccessoryButtonAction:(id)sender {
    if (self.accessoryArray.count >0) {
        HMAccessory *firstAcc = self.accessoryArray[0];
        [[JRHomeKitManager shareManager] removeAccessory:firstAcc fromHome:[[JRHomeKitManager shareManager] primaryHome] completionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark --AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        
        // add home
        if (buttonIndex == 1) {
            NSString *homeName = [alertView textFieldAtIndex:0].text;
            [[JRHomeKitManager shareManager] addHome:homeName? homeName:@"" completionHandler:^(BOOL success) {
                NSString *resultString = success?@"Add Home successful":@"Add Home fail";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:resultString message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }];
        }
    }else if(alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSString *roomName = [alertView textFieldAtIndex:0].text;
            [[JRHomeKitManager shareManager] addRoom:roomName?:@"" completionHandler:^(BOOL success) {
                NSString *resultString = success?@"Add room successful":@"Add room fail";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:resultString message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
        }

    }
}

#pragma mark --Public 

- (void)setHOME:(NSString *)homeName room:(NSString *)roomName {
    [self.HomeInformationLabel setText:[NSString stringWithFormat:@"Home: %@ Room: %@",homeName,roomName]];
}

- (NSMutableArray *)accessoryArray {
    if (!_accessoryArray) {
        _accessoryArray = [[NSMutableArray alloc] init];
    }
    return _accessoryArray;
}

- (void)addNewAccessory:(HMAccessory *)accessory {
    [self.accessoryArray addObject:accessory];
    [self.accessoryTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HMAccessory *accessory = _accessory;

    if ([segue.identifier isEqualToString:@"serviceSegue"]) {
        ServicesController *servicesController = segue.destinationViewController;
        if ([servicesController respondsToSelector:@selector(setName:)]) {
            [servicesController setName:@"Services"];
        }
        if ([servicesController respondsToSelector:@selector(setAccessory:)]) {
            [servicesController setAccessory:accessory];
        }
    }else if([segue.identifier isEqualToString:@"controlSegue"]){
        ControlPanelController *controlPanelController = segue.destinationViewController;
        if ([controlPanelController respondsToSelector:@selector(setAccessory:)]) {
            [controlPanelController setAccessory:accessory];
        }
    }
}

#pragma mark --TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"AccessoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    HMAccessory *accessory = self.accessoryArray[indexPath.row];
    cell.textLabel.text = accessory.name;
    cell.detailTextLabel.text = [accessory.identifier UUIDString];
    return cell;
}

#pragma mark --TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _accessory = self.accessoryArray[indexPath.row];
    if ([[[JRHomeKitManager shareManager] accessoriesOfHome:[[JRHomeKitManager shareManager] primaryHome]] containsObject:_accessory]) {
#ifdef Test_Search
        [self performSegueWithIdentifier:@"serviceSegue" sender:self];
#else
        [[JRHomeKitManager shareManager] enableCharacteristicsOfServicesInAccessory:_accessory];
        [self performSegueWithIdentifier:@"controlSegue" sender:self];
#endif
    }else {
        [[JRHomeKitManager shareManager] addAccessory:_accessory toHome:[[JRHomeKitManager shareManager] primaryHome] completionHandler:^(BOOL success) {
            if (success) {
#ifdef Test_Search
                [self performSegueWithIdentifier:@"serviceSegue" sender:self];
#else
//                [self enableCharacteristicsOfServicesInAccessory:_accessory];
                [self performSegueWithIdentifier:@"controlSegue" sender:self];
#endif           
            }
        }];
    }
}

- (void)enableCharacteristicsOfServicesInAccessory:(HMAccessory *)accessory {
    for(HMService *service in accessory.services) {
        for(HMCharacteristic *characteristic in service.characteristics) {
            [characteristic enableNotification:YES completionHandler:^(NSError *error) {
                if (error) {
                    NSLog(@"Error in enbaleCharacteristic : %@",error);
                }
            }];
        }
    }
}

#pragma mark --JRHomeKit Notification

- (void)didNewAccessoryFound:(NSNotification *)notify {
    HMAccessory *newFoundAccessory = notify.object;
    [self.accessoryArray addObject:newFoundAccessory];
    [self.accessoryTableView reloadData];
}

@end
