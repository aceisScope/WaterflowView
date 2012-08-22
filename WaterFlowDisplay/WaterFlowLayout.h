//
//  WaterFlowLayout.h
//  WaterFlowDisplay
//
//  Created by B.H.Liu on 12-8-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol UICollecitonViewDelegateWaterFlowLayout <UICollectionViewDelegate>

- (CGFloat)flowLayout:(WaterFlowLayout *)flowView heightForRowAtIndex:(int)i;

@end

@protocol UICollectionViewDataSourceWaterFlowLayout <UICollectionViewDataSource>

- (NSInteger)numberOfColumnsInFlowLayout:(WaterFlowLayout*)flowlayout;

@end

@interface WaterFlowLayout : UICollectionViewLayout
{
    NSInteger numberOfColumns ;
    NSInteger currentPage;

	id <UICollecitonViewDelegateWaterFlowLayout> __weak _flowdelegate;
    id <UICollectionViewDataSourceWaterFlowLayout> __weak _flowdatasource;
    
    CGFloat cellWidth;
    CGFloat padding;
    CGFloat contentHeight;
}

@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, retain) NSMutableArray *cellHeight; //array of cells height arrays, count = numberofcolumns, and elements in each single child array represents is a total height from this cell to the top
@property (nonatomic, retain) NSMutableArray *cellIndex; //array of cells index arrays, count = numberofcolumns
@property (nonatomic, strong) NSMutableArray *cellPosition;
@property (nonatomic, weak) id <UICollecitonViewDelegateWaterFlowLayout> flowdelegate;
@property (nonatomic, weak) id <UICollectionViewDataSourceWaterFlowLayout> flowdatasource;

@end
