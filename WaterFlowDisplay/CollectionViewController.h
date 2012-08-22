//
//  CollectionViewController.h
//  WaterFlowDisplay
//
//  Created by B.H.Liu on 12-8-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowLayout.h"

@interface WaterflowCollectionViewController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollecitonViewDelegateWaterFlowLayout,UICollectionViewDataSourceWaterFlowLayout>

@end
