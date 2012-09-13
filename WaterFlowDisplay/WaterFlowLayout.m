//
//  WaterFlowLayout.m
//  WaterFlowDisplay
//
//  Created by B.H.Liu on 12-8-22.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "WaterFlowLayout.h"

@implementation WaterFlowLayout

- (void)setFlowdatasource:(id<UICollectionViewDataSourceWaterFlowLayout>)flowdatasource
{
    _flowdatasource = flowdatasource;
    //[self initialize];
}

- (void)setFlowdelegate:(id<UICollecitonViewDelegateWaterFlowLayout>)flowdelegate
{
    _flowdelegate = flowdelegate;
    //[self initialize];
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    
    currentPage = 1;
    
    contentHeight = [self initialize];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, contentHeight);
}

- (CGFloat)initialize
{
    numberOfColumns = [_flowdatasource numberOfColumnsInFlowLayout:self];
    self.cellHeight = [NSMutableArray arrayWithCapacity:numberOfColumns];
    self.cellIndex = [NSMutableArray arrayWithCapacity:numberOfColumns];
    self.cellPosition = [NSMutableArray arrayWithCapacity:_cellCount];
    
    padding = 5;
    cellWidth = (self.collectionView.frame.size.width - (numberOfColumns-1)*padding)/numberOfColumns;
    
    CGFloat minHeight = 0.f;
    
    CGFloat scrollHeight = 0.f;
    
    NSInteger minHeightAtColumn = 0;
    for (int i = 0; i< _cellCount ; i++)
    {
        //the first pics
        if(self.cellHeight.count < numberOfColumns)
        {
            [self.cellHeight addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithFloat:[self.flowdelegate flowLayout:self heightForRowAtIndex:i]]]];
            [self.cellIndex addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:i]]];
            minHeight = [self.flowdelegate flowLayout:self heightForRowAtIndex:i];
            [self.cellPosition addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:minHeightAtColumn*(cellWidth+padding)],@"x",[NSNumber numberWithFloat:[self.flowdelegate flowLayout:self heightForRowAtIndex:i]],@"y", nil]];
            minHeightAtColumn ++;
            continue;
        }
        
        //find the column with the shortest height and insert the cell height into self.cellHeight[column]
        for (int j = 0; j< numberOfColumns; j++)
        {
            NSMutableArray *cellHeightInPresentColumn = [NSMutableArray arrayWithArray:[self.cellHeight objectAtIndex:j]];
            if (floor([[cellHeightInPresentColumn lastObject]floatValue]) <= minHeight)
            {
                minHeight = [[cellHeightInPresentColumn lastObject]floatValue];
                minHeightAtColumn = j;
            }
        }
        
        [[self.cellHeight objectAtIndex:minHeightAtColumn] addObject:[NSNumber numberWithFloat:minHeight+=[self.flowdelegate flowLayout:self heightForRowAtIndex:i]]];
        [[self.cellIndex objectAtIndex:minHeightAtColumn]addObject:[NSNumber numberWithInt:i]];
        [self.cellPosition addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(cellWidth+padding)*minHeightAtColumn],@"x",[NSNumber numberWithFloat:minHeight],@"y", nil]];
    }
    
    for (int j = 0; j< numberOfColumns; j++)
    {
        if(self.cellHeight.count < numberOfColumns ||self.cellHeight.count == 0) break;
        CGFloat columnHeight = [[[self.cellHeight objectAtIndex:j] lastObject] floatValue];
        scrollHeight = scrollHeight>columnHeight?scrollHeight:columnHeight;
    }

    return scrollHeight;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    CGFloat x = [[[self.cellPosition objectAtIndex:path.item] objectForKey:@"x"] floatValue];
    CGFloat y = [[[self.cellPosition objectAtIndex:path.item] objectForKey:@"y"] floatValue];
    CGFloat height = [_flowdelegate flowLayout:self heightForRowAtIndex:path.item];
    attributes.size = CGSizeMake(cellWidth, height);
    attributes.center = CGPointMake(x + cellWidth/2, y - height/2);
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < _cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	return NO;
}

@end
