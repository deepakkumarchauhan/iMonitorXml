//
//  IMHomeDeviceCollectionViewCell.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 11/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMHomeDeviceCollectionViewCell.h"
#import "IMAppUtility.h"

@implementation IMHomeDeviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set Border of UILabel
//    self.homeTitleLabel.layer.borderWidth = 1.0;
//    self.homeTitleLabel.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.09]CGColor];
    [IMAppUtility setShadowOnLabel:self.shadowView];

}

- (void)setRepresentedObject:(id)representedObject {
    _representedObject = representedObject;
}
@end
