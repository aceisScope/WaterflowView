//
//  WaterflowView.m
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import "WaterflowView.h"
#import "LoadingMoreFooterView.h"
#import "EGORefreshTableHeaderView.h"

#define LOADINGVIEW_HEIGHT 44
#define REFRESHINGVIEW_HEIGHT 88

@interface WaterflowView() <EGORefreshTableHeaderDelegate>
- (void)initialize;
- (void)recycleCellIntoReusableQueue:(WaterFlowCell*)cell;
- (void)pageScroll;
- (void)cellSelected:(NSNotification*)notification;

@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView; 
@property(nonatomic,readwrite) BOOL loadingmore;

@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;  //下拉刷新
@property(nonatomic, readwrite) BOOL isRefreshing; 
@end

@implementation WaterflowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
		self.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(cellSelected:)
                                                     name:@"CellSelected"
                                                   object:nil];
        
        
        self.loadFooterView = [[LoadingMoreFooterView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.f)];
        self.loadingmore = NO;
        [self addSubview:self.loadFooterView];
        
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  -REFRESHINGVIEW_HEIGHT, self.frame.size.width,REFRESHINGVIEW_HEIGHT)];
        [self addSubview:self.refreshHeaderView];
        self.refreshHeaderView.delegate = self;
        self.isRefreshing = NO;
        
        currentPage = 1;
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CellSelected"
                                                  object:nil];
    
    self.cellHeight = nil;
    self.visibleCells = nil;
    self.reusableCells = nil;
    self.flowdatasource = nil;
    self.flowdelegate = nil;
    self.loadFooterView = nil;
}

- (void)setFlowdatasource:(id<WaterflowViewDatasource>)flowdatasource
{
    _flowdatasource = flowdatasource;
    [self initialize];
}

- (void)setFlowdelegate:(id<WaterflowViewDelegate>)flowdelegate
{
    _flowdelegate = flowdelegate;
    [self initialize];
}

#pragma mark-
#pragma mark- process notification
- (void)cellSelected:(NSNotification *)notification
{
    if ([self.flowdelegate respondsToSelector:@selector(flowView:didSelectRowAtIndexPath:)])
    {
        [self.flowdelegate flowView:self didSelectRowAtIndexPath:((WaterFlowCell*)notification.object).indexPath];
    }
}

#pragma mark-
#pragma mark - manage and reuse cells
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (!identifier || identifier == 0 ) return nil;
    
    NSArray *cellsWithIndentifier = [NSArray arrayWithArray:[self.reusableCells objectForKey:identifier]];
    if (cellsWithIndentifier &&  cellsWithIndentifier.count > 0)
    {
        WaterFlowCell *cell = [cellsWithIndentifier lastObject];
        [[self.reusableCells objectForKey:identifier] removeLastObject];
        return cell;
    }
    return nil;
}

- (void)recycleCellIntoReusableQueue:(WaterFlowCell *)cell
{
    if(!self.reusableCells)
    {
        self.reusableCells = [NSMutableDictionary dictionary];
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
        [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
    }
    
    else 
    {
        if (![self.reusableCells objectForKey:cell.reuseIdentifier])
        {
            NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
            [self.reusableCells setObject:array forKey:cell.reuseIdentifier];
        }
        else 
        {
            [[self.reusableCells objectForKey:cell.reuseIdentifier] addObject:cell];
        }
    }

}

#pragma mark-
#pragma mark- methods
- (void)initialize
{    
    numberOfColumns = [self.flowdatasource numberOfColumnsInFlowView:self];
    padding = 5.f;
    
    self.reusableCells = [NSMutableDictionary dictionary];
    self.cellHeight = [NSMutableArray arrayWithCapacity:numberOfColumns];
    self.visibleCells = [NSMutableArray arrayWithCapacity:numberOfColumns];
    
    CGFloat scrollHeight = 0.f;
    
    ////put height of cells per column into an array, then add this array into self.cellHeight
    for (int i = 0; i< numberOfColumns; i++)
    {
        [self.visibleCells addObject:[NSMutableArray array]]; 
        
        NSMutableArray *cellHeightInOneColume = [NSMutableArray array];
        NSInteger rows = [_flowdatasource flowView:self numberOfRowsInColumn:i] * currentPage;
        
        CGFloat columHeight = 0.f;
        for (int j =0; j < rows; j++)
        {
            CGFloat height = [_flowdelegate flowView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            columHeight += height;
            [cellHeightInOneColume addObject:[NSNumber numberWithFloat:columHeight]];
        }
        
        [self.cellHeight addObject:cellHeightInOneColume];
        scrollHeight = (columHeight >= scrollHeight)?columHeight:scrollHeight;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, scrollHeight + LOADINGVIEW_HEIGHT);
    
    self.loadFooterView.frame = CGRectMake(0, scrollHeight, self.frame.size.width, LOADINGVIEW_HEIGHT);
    
    [self pageScroll];
}

- (void)reloadFailed
{
    currentPage --;
    if(self.loadingmore)
    {
        self.loadingmore = NO;
        self.loadFooterView.showActivityIndicator = NO;
    }
}

- (void)reloadData
{
    //remove and recycle all visible cells
    for (int i = 0; i < numberOfColumns; i++)
    {
        NSMutableArray *array = [self.visibleCells objectAtIndex:i];
        for (int i = 0; i< array.count; i++)
        {
            WaterFlowCell* cell = array[i];
            [self recycleCellIntoReusableQueue:(WaterFlowCell*)cell];
            [cell removeFromSuperview];
        }
    }
    
    if(self.loadingmore)
    {
        self.loadingmore = NO;
        self.loadFooterView.showActivityIndicator = NO;
    }
    if (self.isRefreshing)
    {
        self.isRefreshing = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }

    [self initialize];
}

- (void)pageScroll
{
    //CGPoint offset = self.contentOffset;
    
    
    for (int i = 0 ; i< numberOfColumns; i++)
    {
        float origin_x = i * (((self.frame.size.width - (numberOfColumns-1)*padding) / numberOfColumns)+padding);
		float width = self.frame.size.width / numberOfColumns;
                
        WaterFlowCell *cell = nil;
        
        if ([self.visibleCells objectAtIndex:i] == nil || ((NSArray*)[self.visibleCells objectAtIndex:i]).count == 0) //everytime reloadData is called and no cells in visibleCellArray
        {
            int rowToDisplay = 0;
			for( int j = 0; j < [[self.cellHeight objectAtIndex:i] count] - 1; j++)  //calculate which row to display in this column
			{
				float everyCellHeight = [[[self.cellHeight objectAtIndex:i] objectAtIndex:j] floatValue];
				if(everyCellHeight < self.contentOffset.y)
				{
					rowToDisplay ++;
				}
			}
			
            #ifdef DEBUG
			NSLog(@"row to display %d", rowToDisplay);
            #endif	
            
			float origin_y = 0;
			float height = 0;
			if(rowToDisplay == 0)  
			{
				origin_y = 0;
				height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
			}
			else if(rowToDisplay < [[self.cellHeight objectAtIndex:i] count]) 
            {
				origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue];
				height  = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay ] floatValue] - origin_y;
			}
			
			cell = [_flowdatasource flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowToDisplay inSection:i]];
			cell.indexPath = [NSIndexPath indexPathForRow: rowToDisplay inSection:i];
			cell.frame = CGRectMake(origin_x, origin_y, width, height);
			[self addSubview:cell];
			[[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
       }
        else   //there are cells in visibelCellArray
        {
            cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
        }
        
        //base on this cell at rowToDisplay and process the other cells
        //1. add cell above this basic cell if there's margin between basic cell and top
        while ( cell && ((cell.frame.origin.y - self.contentOffset.y) > 0.0001)) 
        {
            float origin_y = 0;
			float height = 0;
            int rowToDisplay = cell.indexPath.row;
            
            if(rowToDisplay == 0) 
            {
                cell = nil;
                break;
            }
            else if (rowToDisplay == 1)
            {
                origin_y = 0;
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay  -1] floatValue];
            }
            else if (cell.indexPath.row < [[self.cellHeight objectAtIndex:i] count])
            {
                origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay -2] floatValue];
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay - 1] floatValue] - origin_y;
            }
            
            cell = [self.flowdatasource flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow: rowToDisplay > 0 ? (rowToDisplay  - 1) : 0 inSection:i]];
            cell.indexPath = [NSIndexPath indexPathForRow: rowToDisplay > 0 ? (rowToDisplay - 1) : 0 inSection:i];
            cell.frame = CGRectMake(origin_x,origin_y , width, height);
            [[self.visibleCells objectAtIndex:i] insertObject:cell atIndex:0];
            
            [self addSubview:cell];
        }
        //2. remove cell above this basic cell if there's no margin between basic cell and top
        while (cell &&  ((cell.frame.origin.y + cell.frame.size.height  - self.contentOffset.y) <  0.0001)) 
		{
			[cell removeFromSuperview];
			[self recycleCellIntoReusableQueue:cell];
			[[self.visibleCells objectAtIndex:i] removeObject:cell];
			
			if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
			{
				cell = [[self.visibleCells objectAtIndex:i] objectAtIndex:0];
			}
			else 
            {
				cell = nil;
			}
		}
        //3. add cells below this basic cell if there's margin between basic cell and bottom
        cell = [[self.visibleCells objectAtIndex:i] lastObject];
        while (cell &&  ((cell.frame.origin.y + cell.frame.size.height - self.frame.size.height - self.contentOffset.y) <  0.0001)) 
		{
            //NSLog(@"self.offset %@, self.frame %@, cell.frame %@, cell.indexpath %@",NSStringFromCGPoint(self.contentOffset),NSStringFromCGRect(self.frame),NSStringFromCGRect(cell.frame),cell.indexPath);
            float origin_y = 0;
			float height = 0;
            int rowToDisplay = cell.indexPath.row;
            
            if(rowToDisplay == [[self.cellHeight objectAtIndex:i] count] - 1)
			{
				origin_y = 0;
				cell = nil;
				break;;
			}
            else 
            {
                origin_y = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay] floatValue];
                height = [[[self.cellHeight objectAtIndex:i] objectAtIndex:rowToDisplay + 1] floatValue] -  origin_y;
            }
            
            cell = [self.flowdatasource flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowToDisplay + 1 inSection:i]];
            cell.indexPath = [NSIndexPath indexPathForRow:rowToDisplay + 1 inSection:i];
            cell.frame = CGRectMake(origin_x, origin_y, width, height);
            [[self.visibleCells objectAtIndex:i] addObject:cell];
            
            [self addSubview:cell];
        }
        //4. remove cells below this basic cell if there's no margin between basic cell and bottom
        while (cell &&  ((cell.frame.origin.y - self.frame.size.height - self.contentOffset.y) > 0.0001)) 
		{
			[cell removeFromSuperview];
			[self recycleCellIntoReusableQueue:cell];
			[[self.visibleCells objectAtIndex:i] removeObject:cell];
			
			if(((NSMutableArray*)[self.visibleCells objectAtIndex:i]).count > 0)
			{
				cell = [[self.visibleCells objectAtIndex:i] lastObject];
			}
			else 
            {
				cell = nil;
			}
		}
    }
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
- (void)loadMoreImages
{
    if (self.loadingmore) return;
    
    NSLog(@"load more");
    self.loadingmore = YES;
    self.loadFooterView.showActivityIndicator = YES;
    
    currentPage ++;
    if ([self.flowdelegate respondsToSelector:@selector(flowView:willLoadData:)])
    {
        [self.flowdelegate flowView:self willLoadData:currentPage];  //reloadData in delegate
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self pageScroll];
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
 
    if (bottomEdge >= scrollView.contentSize.height ) 
    {
        [self loadMoreImages];
        //[self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f]; //make a delay to show loading process for a while
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    self.isRefreshing = YES;
    
    currentPage = 1;
    [self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f];  //make a delay to show loading process for a while
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.isRefreshing; // should return if data source model is reloading
}

@end

//===================================================================
//
//*************************WaterflowCell*****************************
//
//===================================================================
@implementation WaterFlowCell
@synthesize indexPath = _indexPath;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super init])
	{
		self.reuseIdentifier = reuseIdentifier;
	}
	
	return self;
}

- (void)dealloc
{
    self.indexPath = nil;
    self.reuseIdentifier = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelected"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:self.indexPath forKey:@"IndexPath"]];
    
}

@end