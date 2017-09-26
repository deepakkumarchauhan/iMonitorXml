//
//  IMHomeDeviceViewController.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 11/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMHomeDeviceViewController.h"
#import "IMHomeDeviceCollectionViewCell.h"
#import "IMCircularSlider.h"
#import "IMHomeDeviceCircularCollectionViewCell.h"
#import "IMSetACTempViewController.h"
#import "AppDelegate.h"
#import "KPDropMenu.h"
#import "Macro.h"



static NSString *cellIdentifier = @"homeDeviceCellID";
static NSString *cellCircleIdentifier = @"homeDeviceCircleCellID";


@interface IMHomeDeviceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, KPDropMenuDelegate> {
    
    NSMutableArray *deviceArray;
    BOOL selectionMode;
    NSMutableArray *selectedIndexes;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet KPDropMenu *searchView;

@end

@implementation IMHomeDeviceViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Call Initial Method
    [self initialMethod];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeDeviceVCLoaded" object:nil];
}


#pragma mark - Custom Method
-(void)initialMethod {
    
    
    // Register TableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMHomeDeviceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMHomeDeviceCircularCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellCircleIdentifier];

    // Set SearchView Border
    self.searchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchView.layer.borderWidth = 1.0;
    
    
    self.searchView.items = @[@"AC", @"Fan", @"TV", @"Light", @"Door", @"Tube Light"];
    self.searchView.itemsIDs = @[@"0", @"1", @"2", @"3", @"4", @"5"];
    self.searchView.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    self.searchView.titleTextAlignment = NSTextAlignmentCenter;
    self.searchView.delegate = self;

    // Alloc Array
    deviceArray = [[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"AC Extender",@"title",@"customer_support",@"image",@"0",@"progressValue", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Motor Controller",@"title",@"customer_support",@"image",@"0",@"progressValue", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"LCD Remote",@"title",@"customer_support",@"image",@"0",@"progressValue", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Multi Sensor",@"title",@"customer_support",@"image",@"0",@"progressValue", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Shock Detector",@"title",@"customer_support",@"image",@"0",@"progressValue", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Smoke Sensor",@"title",@"customer_support",@"image",@"0",@"progressValue", nil],nil];
    
    [self manageViewBasedOnRoomTypeSelected];
    
    //Notification Observer for changing the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageViewBasedOnRoomTypeSelected) name:@"ChangeViewNotification" object:nil];
    
    selectedIndexes = [NSMutableArray array];
}

/**
 Notification Observer selector method
 */
- (void)manageViewBasedOnRoomTypeSelected {
    
 //   AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     self.searchView.hidden = YES;
//    if ([appDelegate roomType] == isRoom) {
     //   self.collectionViewTopConstraint.constant = 0.0;
        self.searchView.hidden = YES;
//    }
//    else {
//        self.collectionViewTopConstraint.constant = 55.0;
//        self.searchView.hidden = NO;
//    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return deviceArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IMHomeDeviceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    IMHomeDeviceCircularCollectionViewCell *circularCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellCircleIdentifier forIndexPath:indexPath];

    [circularCell.sliderView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [circularCell.sliderView addTarget:self action:@selector(valueStop:) forControlEvents:UIControlEventTouchCancel];
    circularCell.sliderView.tag = indexPath.row + 100;
    [circularCell.sliderView setCurrentValue:0];
    
    // Add Double Tap Gesture On Cell
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    cell.homeImageView.userInteractionEnabled = YES;
    [cell.homeImageView addGestureRecognizer:doubleTapFolderGesture];
    
    if (indexPath.item%2 == 0) {
        NSDictionary *infoDict = [deviceArray objectAtIndex:indexPath.row];
        cell.homeTitleLabel.text = [infoDict valueForKey:@"title"];
        cell.homeImageView.image = [UIImage imageNamed:[infoDict valueForKey:@"image"]];
        return cell;
    }
    else {
        NSDictionary *infoDict = [deviceArray objectAtIndex:indexPath.row];
        circularCell.homeCircularTitleLabel.text = [infoDict valueForKey:@"title"];
        circularCell.homeCirculatImageView.image = [UIImage imageNamed:[infoDict valueForKey:@"image"]];
        if ([[infoDict valueForKey:@"progressValue"] isEqualToString:@"0"]) {
            circularCell.progressLabel.hidden = YES;
        }
        circularCell.progressLabel.text = [NSString stringWithFormat:@"%@%%",[infoDict valueForKey:@"progressValue"]];
        return circularCell;
    }
  }


#pragma mark - UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0;
    CGSize size = CGSizeMake(cellWidth-30, cellWidth-30);
    
    return size;
}


-(void)valueChanged:(IMCircularSlider*)slider {
    
    CGPoint buttonPosition = [slider convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    
    IMHomeDeviceCircularCollectionViewCell *circularCell = (IMHomeDeviceCircularCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableDictionary *infoDict = [[deviceArray objectAtIndex:slider.tag - 100] mutableCopy];

    if (slider.currentValue == 101) {
        [infoDict setValue:[NSString stringWithFormat:@"%d",0] forKey:@"progressValue"];
    }else {
        [infoDict setValue:[NSString stringWithFormat:@"%d",slider.currentValue] forKey:@"progressValue"];
    }
    circularCell.progressLabel.hidden = NO;
    [deviceArray replaceObjectAtIndex:slider.tag - 100 withObject:[infoDict copy]];
    circularCell.progressLabel.text = [NSString stringWithFormat:@"%@%%",[infoDict valueForKey:@"progressValue"]];
}

-(void)processDoubleTap:(UITapGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath)
        {
            
            IMSetACTempViewController *acObj = [[IMSetACTempViewController alloc] initWithNibName:@"IMSetACTempViewController" bundle:nil];
            acObj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [[APPDELEGATE appNavigationController] presentViewController:acObj animated:NO completion:nil];
            
            NSLog(@"Image was double tapped");
        }
        else
        {
            NSLog(@"Image");
        }
    }
}




-(void)valueStop:(IMCircularSlider*)slider {
    
    NSMutableDictionary *infoDict = [[deviceArray objectAtIndex:slider.tag - 100] mutableCopy];
    [infoDict setValue:[NSString stringWithFormat:@"%d",slider.currentValue] forKey:@"progressValue"];
    [deviceArray replaceObjectAtIndex:slider.tag - 100 withObject:[infoDict copy]];
    
    CGPoint buttonPosition = [slider convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    
    IMHomeDeviceCircularCollectionViewCell *circularCell = (IMHomeDeviceCircularCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    circularCell.progressLabel.hidden = YES;
    
    IMLog(@"Drag stop");
    
}


#pragma mark - KPDropMenu Delegate Methods
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex{
    
    if(dropMenu == self.searchView) {
        IMLog(@"%@ with TAG : %ld", dropMenu.items[atIntedex], (long)dropMenu.tag)
    }
    else
        IMLog(@"%@", dropMenu.items[atIntedex]);
}

-(void)didShow:(KPDropMenu *)dropMenu{
    IMLog(@"didShow");
}

-(void)didHide:(KPDropMenu *)dropMenu{
    IMLog(@"didHide");
}

#pragma mark - UIButton Action
- (IBAction)searchButtonAction:(UIButton *)sender {
    
}

#pragma mark - NBReorderCollectionViewDelegate

- (void)finishReorderingItem:(id)fromItem toItemAtIndexPath:( NSIndexPath *)toIndexPath needReorder:(BOOL)needReorder {
    if (needReorder) {
        IMLog(@"Reorder");
        
    } else {
        IMLog(@"Copy or Move");
    }
}


#pragma mark - UIMemory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
