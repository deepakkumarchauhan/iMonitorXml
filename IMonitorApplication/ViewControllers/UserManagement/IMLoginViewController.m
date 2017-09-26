//
//  IMLoginViewController.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/7/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMLoginViewController.h"
#import "IMLoginTableCell.h"
#import "Macro.h"
#import "IMUserManagement.h"
#import "VSDropdown.h"
#import "IMAppUtility.h"
#import "IMLabelClass.h"
#import "IMForgotViewController.h"
#import "IMHomeViewController.h"
#import "KeychainWrapper.h"
#import "IMAppConstants.h"
#import "AESCrypto.h"
#import <QuartzCore/QuartzCore.h>
#import "IMSoapEnvelope.h"
#import "IMServiceHelper.h"
#import "NSDictionary+NullChecker.h"
#import "AppDelegate.h"
#import "IMDBHelper.h"


#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>



@interface IMLoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, VSDropdownDelegate> {
    BOOL isLoginWithInternet;
}

@property (weak, nonatomic) IBOutlet UITableView *loginTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintServerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintServerLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonServer;
@property (weak, nonatomic) IBOutlet IMLabelClass *selectedServerLabel;
@property (weak, nonatomic) IBOutlet UIButton *internetButton;
@property (weak, nonatomic) IBOutlet UIButton *localButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;

@property (strong, nonatomic) IMUserManagement *userObj;
@property (strong, nonatomic) VSDropdown *dropDownList;

@end


@implementation IMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpIntialLoadingLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [IMAppUtility addGradientOnButtonWithStartColor:RGBCOLOR(139, 215, 247, 1) mediumColor:RGBCOLOR(65, 176, 231, 1) andEndColor:RGBCOLOR(139, 215, 247, 1) forButton:self.submitButton andTitle:@"SUBMIT"];
    setCornerForView(self.submitButton, RGBCOLOR(139, 215, 247, 1), 2, 15);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.loginTableView reloadData];
}

#pragma mark -********************** Helper Methods ********************-
- (void)setUpIntialLoadingLogin {
    
    [self.loginTableView registerNib:[UINib nibWithNibName:@"IMLoginTableCell" bundle:nil] forCellReuseIdentifier:@"IMLoginTableCell"];
    
    //Adding header and footer for table
    self.loginTableView.tableFooterView = self.tableFooterView;
    self.loginTableView.tableHeaderView = self.tableHeaderView;
    
    self.buttonServer.layer.borderColor = RGBCOLOR(180, 180, 180, 1).CGColor;
    self.buttonServer.layer.borderWidth = 1.0;

    //Modal Class Allocation
    self.userObj = [[IMUserManagement alloc]init];
    
    self.dropDownList = [[VSDropdown alloc]initWithDelegate:self];
    [self.dropDownList setAdoptParentTheme:YES];
    setCornerForView(self.dropDownList, RGBCOLOR(180, 180, 180, 1), 1.0, 2.0);
    [self.internetButton setSelected:YES];
    [self getSavedKeychainDataInCaseOfRememberMe];
    
    //Server button round corner set
    self.buttonServer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buttonServer.layer.borderWidth = 1.0;
    self.buttonServer.layer.cornerRadius = 5.0;

    //Setting the base url for application
    AppDelegate *appDelegateObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegateObj setStrSelectedServerUrl:@"myhomeeqi.com"];
    [appDelegateObj defaultDataSetUpForWebServiceIntegration];
    
    isLoginWithInternet = YES;
}


/**
 Access saved values from KeyChain
 */
- (void)getSavedKeychainDataInCaseOfRememberMe {
    
    NSString *strCustomerID = [AESCrypto AES128DecryptString:[NSString stringWithFormat:@"%@",[NSUSERDEFAULT valueForKey:kCustomerID]] withKey:kEncryptionKey];
    NSString *strUserName = [AESCrypto AES128DecryptString:[NSString stringWithFormat:@"%@",[NSUSERDEFAULT valueForKey:kUserName]] withKey:kEncryptionKey];
    NSString *strPassword =[AESCrypto AES128DecryptString:[NSString stringWithFormat:@"%@",[NSUSERDEFAULT valueForKey:kPassword]] withKey:kEncryptionKey];
    NSString *strIsRemember = [NSUSERDEFAULT valueForKey:kIsRememberMeYes];
    self.userObj.stringCustomerID = strCustomerID;
    self.userObj.stringUserName = strUserName;
    self.userObj.stringPassword= strPassword;
    if([strIsRemember isEqualToString:@"yes"]) {
        [self.rememberMeButton setSelected:YES];
        self.userObj.isRememberMeMarked = YES;
    }
    [self.loginTableView reloadData];
}

/**
 Validate the input field on submit button

 @return validation result
 */
- (BOOL)isInputValuesAreValid {
    
    BOOL isValid = NO;
    if(!self.userObj.stringCustomerID.length) {
       [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter customer id." andController:self];
    }
   else if(!self.userObj.stringUserName.length) {
        [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter username." andController:self];
    }
   else if(!self.userObj.stringPassword.length) {
       [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter password." andController:self];
   }
   else if(self.userObj.stringPassword.length < 8) {
       [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter valid password. Password should be minimum 8 digits." andController:self];
   }
   else {
       if(self.userObj.isRememberMeMarked) {
           [NSUSERDEFAULT setValue: [AESCrypto AES128EncryptString:self.userObj.stringCustomerID withKey:kEncryptionKey]  forKey:kCustomerID];
           [NSUSERDEFAULT setValue:[AESCrypto AES128EncryptString:self.userObj.stringUserName withKey:kEncryptionKey] forKey:kUserName];
           [NSUSERDEFAULT setValue:[AESCrypto AES128EncryptString:self.userObj.stringPassword withKey:kEncryptionKey] forKey:kPassword];
           [NSUSERDEFAULT setValue:@"yes" forKey:kIsRememberMeYes];
           [NSUSERDEFAULT synchronize];
       }
        isValid = YES;
   }
    return isValid;
}

#pragma mark -********************* UITableViewDataSource Methods *****************-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IMLoginTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMLoginTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.loginCellTextField.delegate = self;
    cell.loginCellTextField.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:{
            cell.loginCellTextField.returnKeyType = UIReturnKeyNext;
            [cell.loginCellTextField placeHolderTextWithColor:@"Enter Customer ID" :RGBCOLOR(179, 180, 180, 1)];
            [cell.loginCellTextField setText:self.userObj.stringCustomerID];
            
        }
            break;
        case 1:{
            cell.loginCellTextField.returnKeyType = UIReturnKeyNext;
            [cell.loginCellTextField placeHolderTextWithColor:@"Enter Username" :RGBCOLOR(179, 180, 180, 1)];
            [cell.loginCellTextField setText:self.userObj.stringUserName];

        }
            break;
        case 2: {
            cell.loginCellTextField.secureTextEntry = YES;
            cell.loginCellTextField.returnKeyType = UIReturnKeyDone;
            [cell.loginCellTextField placeHolderTextWithColor:@"Enter Password" :RGBCOLOR(179, 180, 180, 1)];
            [cell.loginCellTextField setText:self.userObj.stringPassword];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -********************** TableViewDelegate Methods ***********************-
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -*********************** TextFieldDelegate Methods ****************************-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UIResponder *responderObj = ViewWithTag(textField.tag+1);
    if(textField.returnKeyType == UIReturnKeyNext)
        [responderObj becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        return NO;
    
    NSString *completeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0:
            self.userObj.stringCustomerID = TRIM_SPACE(completeString);
            return (completeString.length >= 40 && range.length == 0) ? NO : YES;
            break;
        case 1:
            self.userObj.stringUserName =  TRIM_SPACE(completeString);
            return (completeString.length >= 40 && range.length == 0) ? NO : YES;
            break;
        case 2:
            self.userObj.stringPassword =  TRIM_SPACE(completeString);
            return (completeString.length >= 16 && range.length == 0) ? NO : YES;
            break;
        default:
            return NO;
            break;
    }
    
}

#pragma mark -*********************** Button Action & Selector Methods *********************-
- (IBAction)commonButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 91: {
            isLoginWithInternet = YES;
            //Internet
            self.userObj.isInternetSelected = YES;
            self.heightConstraintServerButton.constant = 41.0;
            self.heightConstraintServerLabel.constant = 41.0;
            [self.selectedServerLabel setHidden:NO];
            [self.buttonServer setHidden:NO];
            [self.internetButton setSelected:YES];
            [self.localButton setSelected:NO];
        }
            break;
        case 92: {
            
            isLoginWithInternet = NO;
            self.userObj.isInternetSelected = NO;
            self.heightConstraintServerButton.constant = 0.0;
            self.heightConstraintServerLabel.constant = 0.0;
            [self.selectedServerLabel setHidden:YES];
            [self.buttonServer setHidden:YES];
            [self.internetButton setSelected:NO];
            [self.localButton setSelected:YES];
        }
            break;
        case 93: {
            //Server (myhomeeqi.com)
            [self showDropDownForButton:self.buttonServer adContents:[NSArray arrayWithObjects:@"myhomeeqi.com",@"eurovigilmonitor.com", nil] multipleSelection:NO];
        }
            break;
        case 94: {
            sender.selected = !sender.selected;
            self.userObj.isRememberMeMarked =  !self.userObj.isRememberMeMarked;
        }
            break;
        case 95: {
            //Forgot Password
            IMForgotViewController *forgotPasswordVC = [[IMForgotViewController alloc]initWithNibName:@"IMForgotViewController" bundle:nil];
            [self.navigationController pushViewController:forgotPasswordVC animated:YES];
        }
            break;
        case 96: {
            //Submit
            if([self isInputValuesAreValid]) {
                
                //Clearing the fields
                NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
                [dictParams setValue:self.userObj.stringCustomerID forKey:@"customerid"];
                [dictParams setValue:self.userObj.stringUserName forKey:@"userid"];
                [dictParams setValue:self.userObj.stringPassword forKey:@"password"];
               // [self webAPICallToGetUserLoginWithStringRequest:[IMSoapEnvelope loginUserWithDictionary:dictParams]];
                
//                //Clearing the fields
//                self.userObj.stringCustomerID = @"";
//                self.userObj.stringUserName = @"";
//                self.userObj.stringPassword = @"";
//                
//                IMHomeViewController *homeViewVC = [[IMHomeViewController alloc]initWithNibName:@"IMHomeViewController" bundle:nil];
//                [self.navigationController pushViewController:homeViewVC animated:YES];
                
                //Creating request
                if(isLoginWithInternet) {
                    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
                    [dictParams setValue:self.userObj.stringCustomerID forKey:@"customerid"];
                    [dictParams setValue:self.userObj.stringUserName forKey:@"userid"];
                    [dictParams setValue:self.userObj.stringPassword forKey:@"password"];
                    [self webAPICallToGetUserLoginWithStringRequest:[IMSoapEnvelope loginUserWithDictionary:dictParams]];
                }
                else {
                    //Check whether core database hai previously saved data
                    NSPredicate *predicateObj = [NSPredicate predicateWithFormat:@"customer_id == %@ AND customer_name == %@ AND customer_password == %@", self.userObj.stringCustomerID,self.userObj.stringUserName,self.userObj.stringPassword ];
                    TBL_GatewayMO *gatewayObj = [[IMDBHelper instance] searchOrGetNewObjectForEntity:@"TBL_Gateway" withPredicate:predicateObj];
                    if(gatewayObj) {
                        //Local
                        [self sendBroadcastPacketWithIPAddress:gatewayObj.local_ip];
                    }
                    else {
                        [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please login with the internet for first time." andController:self];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - VSDropdown Delegate Methods
-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [self.dropDownList setDrodownAnimation:rand()%2];
    [self.dropDownList setAllowMultipleSelection:multipleSelection];
    [self.dropDownList setupDropdownForView:sender];
    [self.dropDownList setSeparatorColor:[UIColor darkGrayColor]];
    [self.dropDownList reloadDropdownWithContents:contents andSelectedItems:nil];
    
}

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {

    AppDelegate *appDelegateObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.selectedServerLabel setText:str];
    [appDelegateObj setStrSelectedServerUrl:str];
    [appDelegateObj defaultDataSetUpForWebServiceIntegration];
    [self.view endEditing:YES];
}

#pragma mark - * * * * Webservices Calling * * * *
- (void)webAPICallToGetUserLoginWithStringRequest: (NSString *)strRequest {
    
    [[IMServiceHelper sharedServiceHelper] webAPICallWithSoapRequest:strRequest httpMethodType:post apiName:loginAPI controller:self withComptionBlock:^(id result, NSError *error) {
        
        IMLog(@"result:%@ Error: %@", result, error);
        NSDictionary *resultDict = [result objectForKeyNotNull:@"imonitor" expectedObj:[NSDictionary dictionary]];
        NSString *strSuccess = [resultDict getTextValueForKey:@"status"];
        if ([strSuccess isEqualToString:@"success"]) {
            
        NSDictionary *userIdDict = [resultDict objectForKeyNotNull:kUserId expectedObj:[NSDictionary dictionary]];

        [NSUSERDEFAULT setValue: [AESCrypto AES128EncryptString:[userIdDict valueForKey:@"text"] withKey:kEncryptionKey]  forKey:kCustomerID];

            [self webAPIToGetDeviceDetails];
        }
        else {
            [IMAppUtility alertWithTitle:@"Error!" andMessage:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andController:self];
        }
    }];
}



/**
 get device details for mac id and ip address of controller
 */
- (void)webAPIToGetDeviceDetails {
    
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setValue:self.userObj.stringCustomerID forKey:@"customer"];
    [dictParams setValue:self.userObj.stringUserName forKey:@"userid"];
    [dictParams setValue:self.userObj.stringPassword forKey:@"password"];
    NSString *requestString = [IMSoapEnvelope getDeviceDetailsRequestWithDict:dictParams];
    
    [[IMServiceHelper sharedServiceHelper] webAPICallWithSoapRequest:requestString httpMethodType:post apiName:synchronizegatewaydetails controller:self withComptionBlock:^(id result, NSError *error) {
        
        NSDictionary *resultDict = [result objectForKeyNotNull:kImonitor expectedObj:[NSDictionary dictionary]];
        
        //Saves server data in local database
        [self saveDataInLocalDBWithResultDict:resultDict];
        
        //Clearing the fields
        self.userObj.stringCustomerID = @"";
        self.userObj.stringUserName = @"";
        self.userObj.stringPassword = @"";
        IMHomeViewController *homeViewVC = [[IMHomeViewController alloc]initWithNibName:@"IMHomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeViewVC animated:YES];
        
    }];
}

#pragma mark *************************** Local Braodcast message set up **************************-
- (void)sendBroadcastPacketWithIPAddress: (NSString *)ipAddress {
    
    const char *ipAddressChar = [ipAddress UTF8String];
    
    // Open a socket
    int sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sd<=0) {
        NSLog(@"Error: Could not open socket");
        return;
    }
    
    // Set socket options
    // Enable broadcast
    int broadcastEnable=1;
    int ret=setsockopt(sd, SOL_SOCKET, SO_BROADCAST, &broadcastEnable, sizeof(broadcastEnable));
    if (ret) {
        NSLog(@"Error: Could not open set socket to broadcast mode");
        close(sd);
        return;
    }
    
    // Since we don't call bind() here, the system decides on the port for us, which is what we want.
    
    // Configure the port and ip we want to send to
    struct sockaddr_in broadcastAddr; // Make an endpoint
    memset(&broadcastAddr, 0, sizeof broadcastAddr);
    broadcastAddr.sin_family = AF_INET;
    inet_pton(AF_INET, ipAddressChar, &broadcastAddr.sin_addr); // Set the broadcast IP address
    broadcastAddr.sin_port = htons(1900); // Set port 1900
    
    // Send the broadcast request, ie "Any upnp devices out there?"
  //  char *request = "M-SEARCH * HTTP/1.1\r\nHOST:239.255.255.250:1900\r\nMAN:\"ssdp:discover\"\r\nST:ssdp:all\r\nMX:1\r\n\r\n";
    char *request = "iMonitorSolutions iMVGMasterController discovery request";
    ret = sendto(sd, request, strlen(request), 0, (struct sockaddr*)&broadcastAddr, sizeof broadcastAddr);
    if (ret<0) {
        NSLog(@"Error: Could not open send broadcast");
        close(sd);
        return;
    }
    
    // Get responses here using recvfrom if you want...
    close(sd);
    
    //Clearing the fields
    self.userObj.stringCustomerID = @"";
    self.userObj.stringUserName = @"";
    self.userObj.stringPassword = @"";
    IMHomeViewController *homeViewVC = [[IMHomeViewController alloc]initWithNibName:@"IMHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeViewVC animated:YES];

}


#pragma mark -*************************** Local DB Save *****************************-
- (void)saveDataInLocalDBWithResultDict:(NSDictionary *)resultDict {
    
    //clearing previously saved data
    [[IMDBHelper instance] removeAllRowsFromTable:@"TBL_Gateway"];
    [[IMDBHelper instance] removeAllRowsFromTable:@"TBL_Device"];
    
    
    NSDictionary *dictGateways = [resultDict objectForKeyNotNull:kGateways expectedObj:[NSDictionary dictionary]];
    NSDictionary *dictGateway = [dictGateways objectForKeyNotNull:kGateway expectedObj:[NSDictionary dictionary]];
    
    NSString *strMacID = [dictGateway getTextValueForKey:kMacid];
    
    TBL_GatewayMO *tblGateway = [[IMDBHelper instance]insertNewObjectForEntity:@"TBL_Gateway"];
    tblGateway.all_on_status =  [dictGateway getTextValueForKey:kAllonStatus];
    tblGateway.mac_id = strMacID;
    tblGateway.local_ip = [dictGateway getTextValueForKey:kLocalip];
    tblGateway.customer_id = self.userObj.stringCustomerID;
    tblGateway.customer_name = self.userObj.stringUserName;
    tblGateway.customer_password = self.userObj.stringPassword;
    tblGateway.gateway_mode = [dictGateway getTextValueForKey:kMode];
    tblGateway.gateway_status = [dictGateway getTextValueForKey:kStatus];
    
    NSDictionary *dictDevices = [dictGateway objectForKeyNotNull:kDevices expectedObj:[NSDictionary dictionary]];
    NSArray *arrayDevices = [dictDevices objectForKeyNotNull:kDevice expectedObj:[NSArray array]];
    for (NSDictionary *dictDevice in arrayDevices) {
        
        TBL_DeviceMO *tblDevice = [[IMDBHelper instance]insertNewObjectForEntity:@"TBL_Device"];
        tblDevice.armstatus = [dictDevice getTextValueForKey:kArmstatus];
        tblDevice.batteryLevel = [dictDevice getTextValueForKey:kBatterylevel];
        tblDevice.device_position = [dictDevice getTextValueForKey:kDevicePosition];
        tblDevice.armstatus = [dictDevice getTextValueForKey:kArmstatus];
        tblDevice.enableStatus = [dictDevice getTextValueForKey:kEnablestatus];
        tblDevice.icon = [dictDevice getTextValueForKey:kIcon];
        tblDevice.idDevice = [dictDevice getTextValueForKey:kId];
        tblDevice.left = [dictDevice getTextValueForKey:kLeft];
        tblDevice.levelStatus = [dictDevice getTextValueForKey:kLevelstatus];
        tblDevice.lIcon = [dictDevice getTextValueForKey:kLicon];
        tblDevice.location = [dictDevice getTextValueForKey:kLocation];
        tblDevice.mac_id = strMacID;
        tblDevice.modelNumber = [dictDevice getTextValueForKey:kModelNumber];
        tblDevice.name = [dictDevice getTextValueForKey:kName];
        tblDevice.status = [dictDevice getTextValueForKey:kStatus];
        tblDevice.top = [dictDevice getTextValueForKey:kTop];
        tblDevice.type = [dictDevice getTextValueForKey:kType];
        [tblGateway addGatewayToDeviceObject:tblDevice];
    }
    
    [[IMDBHelper instance]saveContext];
}

@end
