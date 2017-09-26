//
//  IMStaticViewController.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 08/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMStaticViewController.h"
#import "IMAppUtility.h"

@interface IMStaticViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation IMStaticViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Call Initial Method
    [self initialMethod];
}

#pragma mark - Custom Method
-(void)initialMethod {
    
    self.aboutLabel.attributedText = [IMAppUtility getAttributeString:@"ABOUT IMONITOR" colorRange:NSMakeRange(6, 8)];
        
    [self.webView loadHTMLString:@"iMonitor solutions LLC was founded in November 2009 in the USA to create an an innovative solution for Emerging Life Style requirements. Product development was continued by iMonitor Solutions India Pvt Limited, establishedm March 2011. The Product has been engineered to meet the challanges of infrastructure of emerging nations. \n \n \n The Company is commited to keeping a competitive edge with enchance features and functionallities. It will continue to work with leading technologies and create patentable solutions. The process has been initiated with filling of a few patent applications which are pending approval." baseURL:nil];
}

#pragma mark - UIMemory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
