//
//  IMHomeDeviceCircularCollectionViewCell.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 14/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMHomeDeviceCircularCollectionViewCell.h"
#import "IMAppUtility.h"

@implementation IMHomeDeviceCircularCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set Border of UILabel
//    self.homeCircularTitleLabel.layer.borderWidth = 1.0;
//    self.homeCircularTitleLabel.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.09]CGColor];

    [IMAppUtility setShadowOnLabel:self.shadowView];
    
}

- (void)setRepresentedObject:(id)representedObject {
    _representedObject = representedObject;
}
@end
