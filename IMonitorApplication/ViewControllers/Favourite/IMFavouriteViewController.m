//
//  IMFavouriteViewController.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/13/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMFavouriteViewController.h"
#import "IMFavouriteCollectionCell.h"

@interface IMFavouriteViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *favCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *viewCollectionHeader;

@end

@implementation IMFavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewDidLoadSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -********************* Helper Methods ***********************-
- (void)viewDidLoadSetUp {
    [self.favCollectionView registerNib:[UINib nibWithNibName:@"IMFavouriteCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"IMFavouriteCollectionCell"];
    
}

#pragma mark -********************** UICollectionViewDataSource Method **********************-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    IMFavouriteCollectionCell *favCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMFavouriteCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.item%2 == 0) {
        [favCell.buttonCollectionView setTitle:@"ALL ON" forState:UIControlStateNormal];
        return favCell;
    }else {
        [favCell.buttonCollectionView setTitle:@"ALL OFF" forState:UIControlStateNormal];
        return favCell;
    }
    return favCell;
}

#pragma mark - UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0;
    CGSize size = CGSizeMake(cellWidth-5, cellWidth-5);
    return size;
}



@end
