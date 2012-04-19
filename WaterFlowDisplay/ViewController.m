//
//  ViewController.m
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "AsyncImageView.h"

#define NUMBER_OF_COLUMNS 3

@interface ViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation ViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    flowView = [[WaterflowView alloc] initWithFrame:self.view.frame];
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    
    self.currentPage = 1;
    
    self.imageUrls = [NSMutableArray array];
    self.imageUrls = [NSArray arrayWithObjects:@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",@"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",@"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",@"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",nil];
}

- (void)dealloc
{
    self.imageUrls = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 6;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
    
    float height = [self flowView:nil heightForCellAtIndex:index];
    
    AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS, height);
    
    [imageView loadImage:[self.imageUrls objectAtIndex:index % 5]];
	
	return cell;
    
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, height);
    [imageView loadImage:[self.imageUrls objectAtIndex:(indexPath.row + indexPath.section) % 5]];
	
	return cell;
    
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    float height = 0;
	switch (index  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	return height;
}

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.section;
	
	return height;
    
}

//- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"did select at %@",indexPath);
//}

- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    
}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
    [flowView reloadData];
}

@end
