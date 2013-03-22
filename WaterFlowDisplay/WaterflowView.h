//
//  WaterflowView.h
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterflowView;

////TableCell for WaterFlow
@interface WaterFlowCell:UIView
{
    NSIndexPath *_indexPath;
    NSString *_reuseIdentifier;
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

////DataSource and Delegate
@protocol WaterflowViewDatasource <NSObject>
@required
- (NSInteger)numberOfColumnsInFlowView:(WaterflowView*)flowView;
- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column;
- (WaterFlowCell *)flowView:(WaterflowView *)flowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol WaterflowViewDelegate <NSObject>
@required
- (CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)flowView:(WaterflowView *)flowView willLoadData:(int)page;
@end

////Waterflow View
@interface WaterflowView : UIScrollView<UIScrollViewDelegate>
{
    NSInteger numberOfColumns ; 
    NSInteger currentPage;
	
	NSMutableArray *_cellHeight; 
	NSMutableArray *_visibleCells; 
	NSMutableDictionary *_reusedCells; 
	
	__weak id <WaterflowViewDelegate> _flowdelegate;
    __weak id <WaterflowViewDatasource> _flowdatasource;
}

- (void)reloadData;
- (void)reloadFailed;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@property (nonatomic, retain) NSMutableArray *cellHeight; //array of cells height arrays, count = numberofcolumns, and elements in each single child array represents is a total height from this cell to the top
@property (nonatomic, retain) NSMutableArray *visibleCells;  //array of visible cell arrays, count = numberofcolumns
@property (nonatomic, retain) NSMutableDictionary *reusableCells;  //key- identifier, value- array of cells
@property (nonatomic, weak) id <WaterflowViewDelegate> flowdelegate;
@property (nonatomic, weak) id <WaterflowViewDatasource> flowdatasource;

@end
