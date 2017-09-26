//
//  IMHomeViewController.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/8/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMHomeViewController.h"
#import "IMRoomCollectionViewCell.h"
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

@interface IMHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WYPopoverControllerDelegate, MenuProtocolDelegate, LogoutProtocolDelegate> {
    NSInteger selectedItemIndex;
    WYPopoverController* popoverController;
    
    //Temp variables to hold the frames of views
    BOOL isByRoomView, isLeftOptionViewOpen,isRightOptionViewOpen,isBottomOptionViewOpen;
    
}

@property (weak, nonatomic) IBOutlet UIButton *upFloorNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *downFloorNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *floorCountLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomFloorCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *leftOptionButton;
@property (weak, nonatomic) IBOutlet UIButton *rightOptionButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomOptionButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonViewBy;
@property (weak, nonatomic) IBOutlet UIView *viewBottomFloor;

//Dropdown options
@property (weak, nonatomic) IBOutlet UIView *leftOptionsView;
@property (weak, nonatomic) IBOutlet UIView *rightOptionsView;
@property (weak, nonatomic) IBOutlet UIView *bottomOptionsView;

//Manage Constraint to animate the button
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOptionsViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOptionsViewConstraint;

@property (weak, nonatomic) IBOutlet UIButton *buttonHome;
@property (weak, nonatomic) IBOutlet UIButton *buttonAway;
@property (weak, nonatomic) IBOutlet UIButton *buttonStay;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogout;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotifications;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavourite;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnergy;

//Manages Navigation and load view on container
@property (strong, nonatomic) UINavigationController *homeNavigationController;
@property (strong, nonatomic) UIViewController *currentViewController;

//Holds count of floor
@property (assign, nonatomic) NSInteger currentFloorCount;

//Array to hold title and images collection view
@property (strong, nonatomic) NSMutableArray *arrayCollectionViewTitle;
@property (strong, nonatomic) NSMutableArray *arrayCollectionViewImages;

@end

@implementation IMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialLoadingHomeViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.currentViewController.view.frame = self.containerView.bounds;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -******************* Helper Methods **********************-
- (void)setUpInitialLoadingHomeViewController {
    
    self.currentFloorCount = 0;
    selectedItemIndex = 0;
    if(self.currentFloorCount <= 0)
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor 0%ld",(long)self.currentFloorCount];
    else
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor 0%ld",(long)self.currentFloorCount];
    
    //Setting Up bottom CollectionView
    [self.bottomFloorCollectionView registerNib:[UINib nibWithNibName:@"IMRoomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IMRoomCollectionViewCell"];
    
    //Array allocation
    self.arrayCollectionViewTitle = [NSMutableArray arrayWithObjects:@"Kitchen",@"Guest Room",@"Drawing Room",@"Study Room",@"Bath Room",@"Bed Room", nil];
    self.arrayCollectionViewImages = [NSMutableArray arrayWithObjects:@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png", nil];
    
    [self.upFloorNumberButton setTitleColor:AppTextColor forState:UIControlStateNormal];
    [self.downFloorNumberButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.currentViewController = [UIViewController new];
    [self settingUpNavigationToLoadManageNavigation];
    
    //Setting corner Radius for view of options
    setCornerForView(self.leftOptionsView, RGBCOLOR(97, 174, 224, 1.0), 1.0, 90);
    setCornerForView(self.rightOptionsView, RGBCOLOR(97, 174, 224, 1.0), 1.0, 90);
    setCornerForView(self.bottomOptionsView, RGBCOLOR(97, 174, 224, 1.0), 1.0, 100);
    
    [self.leftOptionsView setBackgroundColor:RGBCOLOR(60, 167, 227, 0.7)];
    [self.rightOptionsView setBackgroundColor:RGBCOLOR(60, 167, 227, 0.7)];
    [self.bottomOptionsView setBackgroundColor:RGBCOLOR(60, 167, 227, 0.7)];
    
    isByRoomView = YES;
    isLeftOptionViewOpen = NO;
    isRightOptionViewOpen = NO;
    isBottomOptionViewOpen = NO;
    
    //Observer to check the homeDevice VC Load
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHiddenListByButton) name:@"HomeDeviceVCLoaded" object:nil];
    
    //Set corner radius of options button
    [self setCornerRadiusOfOptionButtons];
}


/**
 UINavigation Allocation and flow management
 */
- (void)settingUpNavigationToLoadManageNavigation {
    
    IMHomeDeviceViewController *customerSupprtVC = [[IMHomeDeviceViewController alloc]initWithNibName:@"IMHomeDeviceViewController" bundle:nil];
    self.homeNavigationController = [[UINavigationController alloc]initWithRootViewController:customerSupprtVC];
    [self.homeNavigationController.navigationBar setHidden:YES];
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = self.homeNavigationController;
    [self addChildViewController:self.homeNavigationController];
    [self.containerView addSubview:self.currentViewController.view];
    self.currentViewController.view.frame = self.containerView.bounds;
    [self.currentViewController didMoveToParentViewController:self];
    
}


/**
 Set corner radius for different buttons on option views
 */
- (void)setCornerRadiusOfOptionButtons {
    
    setCornerForView(self.buttonHome, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonAway, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonStay, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonEnergy, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonLogout, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonNotifications, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    setCornerForView(self.buttonFavourite, RGBCOLOR(17, 106, 152, 1), 0.8, 5);
    
}

/**
 Notification Observer Selectror method. called when home is loaded
 */
- (void)showHiddenListByButton {
    
    [self.buttonViewBy setHidden:NO];
    [self.bottomViewHeightConstraint setConstant:80.0];
    [self.leftOptionButton setHidden:NO];
    [self.rightOptionButton setHidden:NO];
    [self.bottomOptionButton setHidden:NO];
    [self.bottomOptionsView setHidden:NO];
    [self.downFloorNumberButton setHidden:NO];
}


/**
 Method to call when user navigate to other screen
 */
- (void)hideContentOnMoveToOtherScreens{
    
    [self.buttonViewBy setHidden:YES];
    [self.bottomViewHeightConstraint setConstant:1.0];
    
    [self.leftOptionButton setHidden:YES];
    [self.rightOptionButton setHidden:YES];
    [self.bottomOptionButton setHidden:YES];
    
    [self.bottomOptionsView setHidden:YES];
    [self.downFloorNumberButton setHidden:YES];

}


/**
 Closing opened options view
 */
- (void)resetOptionViewsToClose {
    
    //Hiding option views
    if(isBottomOptionViewOpen) {
        isBottomOptionViewOpen = NO;
        [self animateView:self.bottomOptionsView andIsToShow:isBottomOptionViewOpen andType:3];
    }
    
    if(isRightOptionViewOpen) {
        isRightOptionViewOpen = NO;
        [self animateView:self.rightOptionsView andIsToShow:isRightOptionViewOpen andType:2];
    }
    if(isLeftOptionViewOpen) {
        isLeftOptionViewOpen = NO;
        [self animateView:self.leftOptionsView andIsToShow:isLeftOptionViewOpen andType:1];
    }
}

#pragma mark -***************** UICollectionViewDataSource Methods ****************-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayCollectionViewTitle.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IMRoomCollectionViewCell *roomCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMRoomCollectionViewCell" forIndexPath:indexPath];
    
    if (selectedItemIndex == indexPath.item)
        roomCollectionCell.cellContainerView.layer.borderColor = AppTextColor.CGColor;
    else
        roomCollectionCell.cellContainerView.layer.borderColor =  [UIColor darkGrayColor].CGColor;
    
    [roomCollectionCell.roomNameLabel setText:[self.arrayCollectionViewTitle objectAtIndex:indexPath.item]];
    [roomCollectionCell.roomImageView setImage:[UIImage imageNamed:[self.arrayCollectionViewImages objectAtIndex:indexPath.item]]];
    
    return roomCollectionCell;
}

#pragma mark -****************** UICollectionViewDelegate Methods ******************-
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
     selectedItemIndex = indexPath.item;
    [self.bottomFloorCollectionView reloadData];

}

#pragma mark -******************* UICollectionViewDelegateFlowLayout Methods *****************
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(70, 70);
    return cellSize;
}


#pragma mark-******************* Button Action & Selector Methods ****************-
- (IBAction)commonButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 91:{
            //Back Button
            [self.homeNavigationController popViewControllerAnimated:YES];
        }
            break;
        case 92:{
            //Menu Button
            [FTPopOverMenu showForSender:sender withMenuArray:@[@"Home", @"About Us", @"Enquiry", @"Refer a Friend", @"Sync Device Status", @"DeviceModel Refresh", @"Customer Support"] imageArray:@[@"v",@"w",@"x",@"y",@"z",@"A",@"B"] headerTitle:@"Hello Ratan!!" doneBlock:^(NSInteger selectedIndex) {
                
                //Reset the view
                [self resetOptionViewsToClose];
                [self hideContentOnMoveToOtherScreens];
                
                switch (selectedIndex) {
                    case 0: {
                        [self.buttonViewBy setHidden:NO];
                        
                        [self showHiddenListByButton];
                        
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
                        
                        [self showHiddenListByButton];
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
                        
                         [self showHiddenListByButton];
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
            break;
        case 93:{
            //List by options Button
            [FTPopOverMenu showForSender:sender withMenuArray:@[@"By Room", @"By Appliance", @"Enable Advance View"] imageArray:([APPDELEGATE roomType] == isRoom) ? @[@"e",@"d",([APPDELEGATE isAdvancedView] == YES)?@"D":@"2"]:@[@"d",@"e",([APPDELEGATE isAdvancedView] == YES)?@"D":@"2"]  headerTitle:@"CHANGE VIEW" doneBlock:^(NSInteger selectedIndex) {
                
                [self byRoomApplianceItemClick:selectedIndex];
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if(selectedIndex == 2) {
                    appDelegate.isAdvancedView = !appDelegate.isAdvancedView;
                }
            } dismissBlock:^{
            }];
        }
            break;
        case 94:{
         
            
        }
            break;
        case 95:{
        }
            break;
        case 96:{
            //Dropdown Left
        }
            break;
        case 97:{
            //Dropdown right
        }
            break;
        case 98:{
            //Dropdown Bottom
        }
            break;
        default:
            break;
    }
}


/**
 Left options button to show left options

 @param sender button tapped
 */
- (IBAction)leftOptionButtonAction: (UIButton *)sender {
    
    isLeftOptionViewOpen = !isLeftOptionViewOpen;
    [self animateView:self.leftOptionsView andIsToShow:isLeftOptionViewOpen andType:1];
    
    //Hiding other option views
    if(isRightOptionViewOpen) {
        isRightOptionViewOpen = NO;
        [self animateView:self.rightOptionsView andIsToShow:isRightOptionViewOpen andType:2];
    }
    
    if(isBottomOptionViewOpen) {
        isBottomOptionViewOpen = NO;
        [self animateView:self.bottomOptionsView andIsToShow:isBottomOptionViewOpen andType:3];
    }
}


- (IBAction)rightOptionButtonAction: (UIButton *)sender {
    
    isRightOptionViewOpen = !isRightOptionViewOpen;
    [self animateView:self.rightOptionsView andIsToShow:isRightOptionViewOpen andType:2];
    
    //Hiding other option views
    if(isLeftOptionViewOpen) {
        isLeftOptionViewOpen = NO;
        [self animateView:self.leftOptionsView andIsToShow:isLeftOptionViewOpen andType:1];
    }
    
    if(isBottomOptionViewOpen) {
        isBottomOptionViewOpen = NO;
        [self animateView:self.bottomOptionsView andIsToShow:isBottomOptionViewOpen andType:3];
    }
}

- (IBAction)bottomOptionButtonAction: (UIButton *)sender {
    
    isBottomOptionViewOpen = !isBottomOptionViewOpen;
    [self animateView:self.bottomOptionsView andIsToShow:isBottomOptionViewOpen andType:3];
    
    //Hiding other option views
    if(isRightOptionViewOpen) {
        isRightOptionViewOpen = NO;
        [self animateView:self.rightOptionsView andIsToShow:isRightOptionViewOpen andType:2];
    }
    if(isLeftOptionViewOpen) {
        isLeftOptionViewOpen = NO;
        [self animateView:self.leftOptionsView andIsToShow:isLeftOptionViewOpen andType:1];
    }
}


/**
 Up and down button action

 @param sender button tapped
 */
- (IBAction)floorButtonUpAction:(UIButton *)sender {
    
    //Reset the view
    [self resetOptionViewsToClose];
    
    //Floor Up
    [self.downFloorNumberButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.upFloorNumberButton setTitleColor:AppTextColor forState:UIControlStateNormal];
    
    self.currentFloorCount++;
    if(self.currentFloorCount <= 9)
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor 0%ld",(long)self.currentFloorCount];
    else
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor %ld",(long)self.currentFloorCount];

}

- (IBAction)floorButtonDownAction:(UIButton *)sender {
    
    //Reset the view
    [self resetOptionViewsToClose];

    //Floor Down
    [self.upFloorNumberButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.downFloorNumberButton setTitleColor:AppTextColor forState:UIControlStateNormal];
    
    if(self.currentFloorCount > 0)
        self.currentFloorCount--;
    
    if(self.currentFloorCount <= 9)
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor 0%ld",(long)self.currentFloorCount];
    else
        self.floorCountLabel.text = [NSString stringWithFormat:@"Floor %ld",(long)self.currentFloorCount];
}


/**
 Button action handles tap on Options buttons placed on left, right and bottom views

 @param sender tapped button obj
 */
- (IBAction)commonButtonActionForOptions:(UIButton *)sender {
    
    //Reset the view
    [self resetOptionViewsToClose];
    switch (sender.tag) {
            //Home
        case 151: {
            IMLogoutViewController *objVC = [[IMLogoutViewController alloc] initWithNibName:@"IMLogoutViewController" bundle:nil];
            objVC.typeOfPopUp = 2;
            objVC.delegate = self;
            objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
            break;
            //Away
        case 152: {
            IMLogoutViewController *objVC = [[IMLogoutViewController alloc] initWithNibName:@"IMLogoutViewController" bundle:nil];
            objVC.typeOfPopUp = 3;
            objVC.delegate = self;
            objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
            break;
            //Stay
        case 153: {
            IMLogoutViewController *objVC = [[IMLogoutViewController alloc] initWithNibName:@"IMLogoutViewController" bundle:nil];
            objVC.typeOfPopUp = 4;
            objVC.delegate = self;
            objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
            break;
            //Logout
        case 154: {
            IMLogoutViewController *objVC = [[IMLogoutViewController alloc] initWithNibName:@"IMLogoutViewController" bundle:nil];
            objVC.typeOfPopUp = 1;
            objVC.delegate = self;
            objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:objVC animated:NO completion:nil];

        }
            break;
            //Notifications
        case 155: {
            
            IMNotificationViewController *notificationObjVC = [[IMNotificationViewController alloc]initWithNibName:@"IMNotificationViewController" bundle:nil];
            [self.navigationController pushViewController:notificationObjVC animated:YES];
        }
            break;
            //Favourite
        case 156: {
            IMFavouriteViewController *notificationObjVC = [[IMFavouriteViewController alloc]initWithNibName:@"IMFavouriteViewController" bundle:nil];
            [self.navigationController pushViewController:notificationObjVC animated:YES];
        }
            break;
            //Energy
        case 157: {
            IMEnergyViewController *objVC = [[IMEnergyViewController alloc] initWithNibName:@"IMEnergyViewController" bundle:nil];
            objVC.homeNavigationController = self.homeNavigationController;
            [self.navigationController pushViewController:objVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - Custom Delegate Method
- (void)menuItemClick:(NSInteger)index {
    
    switch (index) {
        case 0: {
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [appDelegate setupHomeVC];
        }
            break;
            
        case 1:{
            IMStaticViewController *objVC = [[IMStaticViewController alloc] initWithNibName:@"IMStaticViewController" bundle:nil];
            [self.homeNavigationController pushViewController:objVC animated:YES];
        }
            break;
            
        case 2:{
            IMEnquiryViewController *objVC = [[IMEnquiryViewController alloc] initWithNibName:@"IMEnquiryViewController" bundle:nil];
            [self.homeNavigationController pushViewController:objVC animated:YES];
        }
            break;
            
        case 3:{
            // Refer a friend
            NSString * message = @"Testing message";
           // UIImage * image = [UIImage imageNamed:@"boyOnBeach"];
            NSArray * shareItems = @[message];
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            [self presentViewController:avc animated:YES completion:nil];
            
        }
            break;
        case 4:{
            // Sync
            [IMAppUtility alertWithTitle:BLANK andMessage:WORKING_PROGRESS andController:self];

        }
            break;
            
        case 5:{
            // Device model
            [IMAppUtility alertWithTitle:BLANK andMessage:WORKING_PROGRESS andController:self];

        }
            break;
            
        case 6:{
            //Customer Support Controller
            IMCustomerSupportViewController *objVC = [[IMCustomerSupportViewController alloc]initWithNibName:@"IMCustomerSupportViewController" bundle:nil];
            [self.homeNavigationController pushViewController:objVC animated:YES];
        }
            break;
            
        case 7:{
            //Logout Option
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


/**
 item click for home screen

 @param index indexSelected
 */
- (void)byRoomApplianceItemClick:(NSInteger)index {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (index == 0) {
        // This is the room type
        appDelegate.roomType = isRoom;
       // [self.bottomViewHeightConstraint setConstant:80.0];
      //  [self.bottomOptionsViewConstraint setConstant:-120];
      //  [self.viewBottomFloor setHidden:NO];
        //Array allocation
        self.arrayCollectionViewTitle = [NSMutableArray arrayWithObjects:@"Kitchen",@"Guest Room",@"Drawing Room",@"Study Room",@"Bath Room",@"Bed Room", nil];
        self.arrayCollectionViewImages = [NSMutableArray arrayWithObjects:@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png",@"customer_support.png", nil];

    }
    else if(index == 1) {
        // This is the appliance type
        appDelegate.roomType = isAppliance;
    //    [self.bottomViewHeightConstraint setConstant:1.0];
     //   [self.bottomOptionsViewConstraint setConstant:-200];
      //  [self.viewBottomFloor setHidden:YES];
        //Array allocation
        self.arrayCollectionViewTitle = [NSMutableArray arrayWithObjects:@"SWITCH",@"AV BLASTER",@"MOTOR",@"MULTI SENSOR",@"CAMERA",@"SIREN",@"AC",@"DIMMER", nil];
        self.arrayCollectionViewImages = [NSMutableArray arrayWithObjects:@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png",@"BackgroundImage.png", nil];
    }
    
    [self.bottomFloorCollectionView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeViewNotification" object:nil];
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
            [self.leftOptionsView setHidden:YES];
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


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark -************************** Animating View ***********************-

/**
 This method is used to make the view animated

 @param animatingView view which need to animate
 @param isToShow managed to show hide and show of view
 @param optionType 1: LeftOptionView, 2: Right Option View, 3: Bottom Option View
 */
- (void)animateView: (UIView *)animatingView andIsToShow:(BOOL)isToShow andType:(NSInteger)optionType{
    
    if (isToShow) {
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{
                                      switch (optionType) {
                                              //Left
                                          case 1: {
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x + 140, animatingView.frame.origin.y, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.leftOptionButton.frame = CGRectMake(self.leftOptionButton.frame.origin.x + 140, self.leftOptionButton.frame.origin.y, self.leftOptionButton.frame.size.width, self.leftOptionButton.frame.size.height);
                                          }
                                              break;
                                          case 2: {
                                              //Right
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x - 140, animatingView.frame.origin.y, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.rightOptionButton.frame = CGRectMake(self.rightOptionButton.frame.origin.x - 140, self.rightOptionButton.frame.origin.y, self.rightOptionButton.frame.size.width, self.rightOptionButton.frame.size.height);
                                          }
                                              break;
                                          case 3: {
                                              //Bottom
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x , animatingView.frame.origin.y - 160, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.bottomOptionButton.frame = CGRectMake(self.bottomOptionButton.frame.origin.x, self.bottomOptionButton.frame.origin.y - 160, self.bottomOptionButton.frame.size.width, self.bottomOptionButton.frame.size.height);
                                          }
                                              break;
                                          default:
                                              break;
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                  }];
    }
    else {
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{
                                      switch (optionType) {
                                          case 1: {
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x - 140, animatingView.frame.origin.y, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.leftOptionButton.frame = CGRectMake(self.leftOptionButton.frame.origin.x-140, self.leftOptionButton.frame.origin.y, self.leftOptionButton.frame.size.width, self.leftOptionButton.frame.size.height);
                                          }
                                              break;
                                          case 2: {
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x + 140, animatingView.frame.origin.y, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.rightOptionButton.frame = CGRectMake(self.rightOptionButton.frame.origin.x+140, self.rightOptionButton.frame.origin.y, self.rightOptionButton.frame.size.width, self.rightOptionButton.frame.size.height);
                                          }
                                              break;
                                          case 3: {
                                              animatingView.frame = CGRectMake(animatingView.frame.origin.x, animatingView.frame.origin.y + 160, animatingView.frame.size.width, animatingView.frame.size.height);
                                              self.bottomOptionButton.frame = CGRectMake(self.bottomOptionButton.frame.origin.x,self.bottomOptionButton.frame.origin.y + 160 , self.bottomOptionButton.frame.size.width, self.bottomOptionButton.frame.size.height);
                                          }
                                              break;
                                          default:
                                              break;
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                  }];
    }
}

@end
