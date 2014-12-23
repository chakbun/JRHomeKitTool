//
//  AppDelegate.m
//  HomeKitTool
//
//  Created by Jaben on 14-12-1.
//  Copyright (c) 2014年 Jaben. All rights reserved.
//

#import "AppDelegate.h"
#import <HomeKit/HomeKit.h>
#import "ViewController.h"
#import "JRHomeKitManager.h"


//static NSString *const HOME_NAME = @"My home";
//static NSString *const ROOM_NAME = @"My room";
//static NSString *const ACCESSORY_NAME = @"MY accessory";
//static NSString *const ACCESSORY_NAME = @"電灯";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [JRHomeKitManager shareManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

//#pragma mark --HomeKit Callback
//
//- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
//    NSLog(@"homeManagerDidUpdatePrimaryHome: %@", manager.primaryHome.name);
//}
//
//- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home {
//    NSLog(@"Home added ");
//}
//
//- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
//    
//    NSLog(@"============ homeManagerDidUpdateHomes ============");
//
//    NSLog(@"Homes Description: %@", manager.homes.debugDescription);
//    
//    NSLog(@"Romms Description: %@", manager.primaryHome.rooms.debugDescription);
//    
//    HMHome *primaryHome = self.homeManager.primaryHome;
//    
//    bool found = NO; // find room ?
//    
//    if ([primaryHome.name isEqualToString:HOME_NAME]) {
//        NSLog(@"Home : %@ already exists", HOME_NAME);
//        for (HMRoom* room in primaryHome.rooms) {
//            if ([room.name isEqualToString:ROOM_NAME]) {
//                NSLog(@"Room : %@ already exists", ROOM_NAME);
//                found = YES;
//                break;
//            }
//        }
//        if (!found) {
//            [self addRoom:ROOM_NAME];
//        }
//    }else {
//        NSLog(@"Home : %@ does not exists", HOME_NAME);
//        [self addHome:HOME_NAME];
//        return;
//    }
//    
//    found = NO;
//    for (HMAccessory *accessory in primaryHome.accessories) {
//        if ([accessory.name isEqualToString:ACCESSORY_NAME]) {
//            NSLog(@"Accessory : %@ already exists", ACCESSORY_NAME);
//            found = YES;
//            self.accessory = accessory;
//            [self setAccessory];
//            break;
//        }
//    }
//    if (!found) {
//        [self addAccessory];
//    }
//}
//
//#pragma mark --Accessory CallBack
//- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
//    NSLog(@"============ didUpdateValueForCharacteristic ============");
//    NSLog(@"Server:%@ Have Change Value %@", service.name,characteristic.value);
//}
//
//- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
//    NSLog(@"============ didFindNewAccessory ============");
//    NSLog(@"NewAccessory: %@", accessory.debugDescription);
//    NSLog(@"services Count %d",(int)accessory.services.count);
//    
//    UINavigationController *navigationViewController = (UINavigationController *)[self.window rootViewController];
//    NSArray *childControllers = [navigationViewController childViewControllers];
//    for(UIViewController *controller in childControllers) {
//        if ([controller isKindOfClass:[ViewController class]]) {
//            [((ViewController *)controller) addNewAccessory:accessory];
//            [((ViewController *)controller) setHOME:HOME_NAME room:ROOM_NAME];
//        }
//    }
//    
//    if ([accessory.name isEqualToString:ACCESSORY_NAME]) {
//        __weak __typeof(self) weakSelf = self;
//        [self.homeManager.primaryHome addAccessory:accessory completionHandler:^(NSError *error) {
//            if (error) {
//                NSLog(@"error in AddAccessory %@",error);
//            }else {
//                NSLog(@"successfully in AddAccessory");
//                NSLog(@"＋＋＋＋＋services Count %d",(int)accessory.services.count);
//                weakSelf.accessory = accessory;
//                [weakSelf setAccessory];
//            }
//        }];
//    }
//}
//
//#pragma mark --Add Home Or Room 
//
//- (void)addHome:(NSString *)homeName{
//    NSLog(@"============ addHome ============");
//
//    [self.homeManager addHomeWithName:homeName completionHandler:^(HMHome *home, NSError *error) {
//        if (error) {
//            NSLog(@"error in addHome:%@",error);
//            return;
//        }else {
//            NSLog(@"successfully in addHome!");
//        }
//    }];
//}
//
//- (void)addRoom:(NSString *)roomName {
//    
//    NSLog(@"============ addRoom ============");
//
//    [self.homeManager.primaryHome addRoomWithName:roomName completionHandler:^(HMRoom *room, NSError *error) {
//        if (error) {
//            NSLog(@"error in addRoom:%@",error);
//            return;
//        }else {
//            NSLog(@"successfully in addRoom!");
//        }
//
//    }];
//}
//
//#pragma mark --Accessory
//
//- (void)addAccessory {
//    NSLog(@"============ addAccessory ============");
//    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
//    self.accessoryBrowser.delegate = self;
//    [self.accessoryBrowser startSearchingForNewAccessories];
//}
//
//- (void)setAccessory {
//    NSLog(@"============ setAccessory ============");
//    self.accessory.delegate = self;
//    NSLog(@"accessory: %@", self.accessory);
//    [self.accessoryBrowser stopSearchingForNewAccessories];
//}

@end
