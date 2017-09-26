//
//  IMLoginTableCell.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/7/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMLoginTableCell.h"
#import "Macro.h"

@implementation IMLoginTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewContentCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewContentCell.layer.borderWidth = 1.0;
    self.viewContentCell.layer.cornerRadius = 5.0;
    self.viewContentCell.backgroundColor = RGBCOLOR(240, 240, 240, 1.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
