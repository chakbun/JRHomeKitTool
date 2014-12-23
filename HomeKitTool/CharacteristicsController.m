//
//  CharacteristicsController.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "CharacteristicsController.h"
#import "CharacteriticDetailController.h"

@interface CharacteristicsController ()
@property (nonatomic, strong) HMCharacteristic *characteristic;
@end

@implementation CharacteristicsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Characteristics";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HMCharacteristic *characteristic = _characteristic;
    CharacteriticDetailController *characteristcsDetailController = segue.destinationViewController;
    if ([characteristcsDetailController respondsToSelector:@selector(setCharacteristic:)]) {
        [characteristcsDetailController setCharacteristic:characteristic];
    }
}

#pragma mark --TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.characteristics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"AccessoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    HMCharacteristic *characteristic = self.service.characteristics[indexPath.row];
    [characteristic enableNotification:YES completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"enableNotification error: %@",error);
        }
    }];
    cell.textLabel.text = [NSString stringWithFormat:@"characteritic %d",(int)(indexPath.row)];
    if ([characteristic.characteristicType isEqualToString:(HMCharacteristicTypePowerState)]) {
        cell.detailTextLabel.text = @"TypePowerState";
    }else {
        cell.detailTextLabel.text = characteristic.characteristicType;
    }
    return cell;
}

#pragma mark --TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _characteristic = self.service.characteristics[indexPath.row];
    [self performSegueWithIdentifier:@"characteriticDetailSegue" sender:self];
}

@end
