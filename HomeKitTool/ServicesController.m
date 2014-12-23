//
//  ServicesController.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "ServicesController.h"
#import "CharacteristicsController.h"

@interface ServicesController ()
@property (nonatomic, strong) HMService *service;
@end

@implementation ServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HMService *service = _service;
    if ([segue.identifier isEqualToString:@"characteriticSegue"]) {
        CharacteristicsController *characteristcsController = segue.destinationViewController;
        if ([characteristcsController respondsToSelector:@selector(setService:)]) {
            [characteristcsController setService:service];
        }
    }
}

#pragma mark --TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessory.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"AccessoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    HMService *accessorySevice = self.accessory.services[indexPath.row];
    cell.textLabel.text = accessorySevice.name;
    cell.detailTextLabel.text = accessorySevice.serviceType;
    return cell;
}

#pragma mark --TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _service = self.accessory.services[indexPath.row];
    [self performSegueWithIdentifier:@"characteriticSegue" sender:self];
}


@end
