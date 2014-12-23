//
//  CharacteriticDetailController.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-2.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "CharacteriticDetailController.h"

@interface CharacteriticDetailController ()

@end

@implementation CharacteriticDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_characteristicLabel) {
        _typeLabel.text = _characteristic.characteristicType;
        _valueLabel.text = [NSString stringWithFormat:@"Value : %@",_characteristic.value];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
