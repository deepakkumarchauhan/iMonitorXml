//
//  IMEnergyViewController.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/13/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMEnergyViewController.h"
#import "Macro.h"
#import "FTPopOverMenu.h"
#import "WYPopoverController.h"
#import "IMMenuViewController.h"
#import "IMStaticViewController.h"
#import "IMCustomerSupportViewController.h"
#import "IMNotificationViewController.h"
#import "IMAppUtility.h"
#import "IMEnquiryViewController.h"
#import "IMLogoutViewController.h"
#import "IMHomeDeviceViewController.h"
#import "AppDelegate.h"
#import "IMLogoutViewController.h"
#import "IMSynchDeviceModelViewController.h"
#import "IMEnergyViewController.h"
#import "IMFavouriteViewController.h"

@interface IMEnergyViewController ()<WYPopoverControllerDelegate, LogoutProtocolDelegate> {
    WYPopoverController* popoverController;
}

@end

@implementation IMEnergyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuButtonAction :(UIButton *)sender {
    
    [FTPopOverMenu showForSender:sender withMenuArray:@[@"Home", @"About Us", @"Enquiry", @"Refer a Friend", @"Sync Device Status", @"DeviceModel Refresh", @"Customer Support"] imageArray:@[@"v",@"w",@"x",@"y",@"z",@"A",@"B"] headerTitle:@"Hello Ratan!!" doneBlock:^(NSInteger selectedIndex) {
        
        //Reset the view
        switch (selectedIndex) {
            case 0: {
                BOOL isControllerFound = NO;
                NSArray *viewControllerArray = [self.homeNavigationController viewControllers];
                for (UIViewController *viewControllerObj in viewControllerArray) {
                    if([viewControllerObj isKindOfClass:[IMHomeDeviceViewController class]]) {
                        [self.homeNavigationController popToViewController:viewControllerObj animated:YES];
                        isControllerFound = YES;
                        break;
                    }
                }
                if(!isControllerFound) {
                    IMHomeDeviceViewController *objVC = [[IMHomeDeviceViewController alloc] initWithNibName:@"IMHomeDeviceViewController" bundle:nil];
                    [self.homeNavigationController pushViewController:objVC animated:YES];
                }
            }
                break;
                
            case 1:{
                BOOL isControllerFound = NO;
                NSArray *viewControllerArray = [self.homeNavigationController viewControllers];
                for (UIViewController *viewControllerObj in viewControllerArray) {
                    if([viewControllerObj isKindOfClass:[IMStaticViewController class]]) {
                        [self.homeNavigationController popToViewController:viewControllerObj animated:YES];
                        isControllerFound = YES;
                        break;
                    }
                }
                if(!isControllerFound) {
                    IMStaticViewController *objVC = [[IMStaticViewController alloc] initWithNibName:@"IMStaticViewController" bundle:nil];
                    [self.homeNavigationController pushViewController:objVC animated:YES];
                }
            }
                break;
                
            case 2:{
                
                BOOL isControllerFound = NO;
                NSArray *viewControllerArray = [self.homeNavigationController viewControllers];
                for (UIViewController *viewControllerObj in viewControllerArray) {
                    if([viewControllerObj isKindOfClass:[IMEnquiryViewController class]]) {
                        [self.homeNavigationController popToViewController:viewControllerObj animated:YES];
                        isControllerFound = YES;
                        break;
                    }
                }
                if(!isControllerFound) {
                    IMEnquiryViewController *objVC = [[IMEnquiryViewController alloc] initWithNibName:@"IMEnquiryViewController" bundle:nil];
                    [self.homeNavigationController pushViewController:objVC animated:YES];
                }
            }
                break;
                
            case 3:{
                
                // Refer a friend
                NSString * message = @"We are doing IOT Application.";
                // UIImage * image = [UIImage imageNamed:@"boyOnBeach"];
                NSArray * shareItems = @[message];
                UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                [self presentViewController:avc animated:YES completion:nil];
                
            }
                break;
            case 4:{
                // Sync Device Model Status
                BOOL isControllerFound = NO;
                NSArray *viewControllerArray = [self.homeNavigationController viewControllers];
                for (UIViewController *viewControllerObj in viewControllerArray) {
                    if([viewControllerObj isKindOfClass:[IMSynchDeviceModelViewController class]]) {
                        [self.homeNavigationController popToViewController:viewControllerObj animated:YES];
                        isControllerFound = YES;
                        break;
                    }
                }
                if(!isControllerFound) {
                    IMSynchDeviceModelViewController *objVC = [[IMSynchDeviceModelViewController alloc] initWithNibName:@"IMSynchDeviceModelViewController" bundle:nil];
                    [self.homeNavigationController pushViewController:objVC animated:YES];
                }
                
            }
                break;
                
            case 5:{
                
                // Device model
                [IMAppUtility alertWithTitle:BLANK andMessage:WORKING_PROGRESS andController:self];
                
            }
                break;
                
            case 6:{
                BOOL isControllerFound = NO;
                NSArray *viewControllerArray = [self.homeNavigationController viewControllers];
                for (UIViewController *viewControllerObj in viewControllerArray) {
                    if([viewControllerObj isKindOfClass:[IMCustomerSupportViewController class]]) {
                        [self.homeNavigationController popToViewController:viewControllerObj animated:YES];
                        isControllerFound = YES;
                        break;
                    }
                }
                if(!isControllerFound) {
                    IMCustomerSupportViewController *objVC = [[IMCustomerSupportViewController alloc]initWithNibName:@"IMCustomerSupportViewController" bundle:nil];
                    [self.homeNavigationController pushViewController:objVC animated:YES];
                }
            }
                break;
                
            case 7:{
                
                IMLogoutViewController *objVC = [[IMLogoutViewController alloc] initWithNibName:@"IMLogoutViewController" bundle:nil];
                objVC.delegate = self;
                objVC.typeOfPopUp = 1;
                objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self.navigationController presentViewController:objVC animated:NO completion:nil];
            }
                break;
            default:
                break;
        }
    }
                    dismissBlock:^{
                    }];
}


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
    popoverController.delegate = nil;
    popoverController = nil;
}

/**
 Back Delegate method from Logout Screen
 
 @param popUpType type of Pop Up shown basically
 1: Logout
 2: Home
 3: Away
 4: Stay
 */
- (void)logOutButtonDelegateWithPopUpType:(NSInteger)popUpType {
    
    switch (popUpType) {
        case 1: {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }
    
}
@end
