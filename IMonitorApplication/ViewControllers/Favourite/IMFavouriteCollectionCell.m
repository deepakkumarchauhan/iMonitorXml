//
//  IMFavouriteCollectionCell.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/20/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMFavouriteCollectionCell.h"
#import "IMAppUtility.h"
#import "Macro.h"

@implementation IMFavouriteCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    setCornerForView(self.contentViewCollection, AppTextColor, 0.0, 57.5);
    self.contentViewCollection.backgroundColor = AppTextColor;
    
}

@end
