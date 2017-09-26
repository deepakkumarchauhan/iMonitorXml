//
//  IMForgotViewController.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 07/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMForgotViewController.h"
#import "IMAppUtility.h"
#import "IMUserManagement.h"
#import "NSString+IMValidation.h"
#import "Macro.h"
#import "IMServiceHelper.h"
#import "IMAppUtility.h"
#import "NSDictionary+NullChecker.h"
#import "IMSoapEnvelope.h"

@interface IMForgotViewController () {
    IMUserManagement *userInfo;
}
@property (strong, nonatomic) IBOutlet UITextField *customerIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation IMForgotViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Call Initial Method
    [self initialMethod];
}

#pragma mark - Custom Method
-(void)initialMethod {
    
    [self setCornerRadiusTextFieldsWithTextFieldName:self.userNameTextField];
    [self setCornerRadiusTextFieldsWithTextFieldName:self.customerIDTextField];
    
    // Alloc Model Class
    userInfo = [[IMUserManagement alloc] init];
    [IMAppUtility addGradientOnButtonWithStartColor:RGBCOLOR(139, 215, 247, 1) mediumColor:RGBCOLOR(65, 176, 231, 1) andEndColor:RGBCOLOR(139, 215, 247, 1) forButton:self.submitButton andTitle:@"SUBMIT"];
    setCornerForView(self.submitButton, RGBCOLOR(139, 215, 247, 1), 2, 15);
}

-(BOOL)validationMethod {
    
    if(!userInfo.stringCustomerID.length) {
        [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter customer id." andController:self];
    }
    else if(!userInfo.stringUserName.length) {
        [IMAppUtility alertWithTitle:@"Error!" andMessage:@"Please enter username." andController:self];
    }
    else {
        return YES;
    }
    return NO;
}


/**
 Sets Corner Radius and backgroud of textfields on view

 @param textField textField Obj
 */
- (void)setCornerRadiusTextFieldsWithTextFieldName:(UITextField *)textField {
    
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 5.0;
    textField.backgroundColor = RGBCOLOR(240, 240, 240, 1.0);
}


#pragma mark - UIButton Action
- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validationMethod]) {
      [self webAPICallToForgotPasswordStringRequest:[IMSoapEnvelope forgotPasswordWithCustomerID:userInfo.stringCustomerID andUserID:userInfo.stringUserName]];
    }
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIMemory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -*********************** TextField Delegate Methods *******************-
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
        case 100:
            userInfo.stringCustomerID = TRIM_SPACE(completeString);
            return (completeString.length >= 40 && range.length == 0) ? NO : YES;
            break;
        case 101:
            userInfo.stringUserName =  TRIM_SPACE(completeString);
            return (completeString.length >= 40 && range.length == 0) ? NO : YES;
            break;
        default:
            return NO;
            break;
    }
}



#pragma mark - * * * * Webservices Calling * * * *
- (void)webAPICallToForgotPasswordStringRequest: (NSString *)strRequest {
    
    [[IMServiceHelper sharedServiceHelper] webAPICallWithSoapRequest:strRequest httpMethodType:post apiName:forgotPasswordAPI controller:self withComptionBlock:^(id result, NSError *error) {
        
        NSDictionary *resultDict = [result objectForKeyNotNull:@"imonitor" expectedObj:[NSDictionary dictionary]];
        NSString *strSuccess = [resultDict getTextValueForKey:@"status"];
        if ([strSuccess isEqualToString:@"success"]) {
             [IMAppUtility alertWithTitle:@"Error!" andMessage:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andController:self];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [IMAppUtility alertWithTitle:@"Error!" andMessage:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andController:self];
        }
    }];
}

@end
