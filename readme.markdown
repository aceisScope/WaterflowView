WaterflowView
==========================

![ScreenShot](https://github.com/aceisScope/WaterflowView/raw/master/screenshot.png)![ScreenShot](https://github.com/aceisScope/WaterflowView/raw/master/screenshot2.png)

###Description

Resembled datasource and delegate of UITableView, and mainly intended to make a display in the waterflow way of Pinterest.
Each cell could be simply initialized with cellAtIndexPath way.

###Different Versions
1. The WaterflowView(New) is based on a new layout pattern i.e. whenever to place a new cell, find the shortest column and insert the cell into the column, rather than layout by rows in column in the old one. To imply the new one in project, just change the name of file... note that only one file, WaterflowView or WaterflowView(new), should exist in a project
Yet if the images for display are mostly of normal size (not super long), the WaterflowView(old) is still recommended.
2. WaterFlowLayout is UICollectionViewLayout specially for the UICollectionView in iOS6. Note that this is not a subclass of UICollectionViewFlowLayout.

###DataSource
For WaterflowView(New)
When to load data for WaterflowView, (or not to load), should be decided in the delegate method

``` objective-c
    - (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
```

WaterflowView detects every scroll-to-bottom, and the delegate will "decide" for WaterflowView if it should reloadData or reloadFailed.

2. For WaterFlowLayout
This follows the datasource and delegate of UICollectionViewLayout.

###License
This is available under the MIT license.

###NEW
The (Swift Version)[https://github.com/aceisScope/WaterflowSwift] has the basic UICollectionView implementation but has not yet been  fully compeleted. Test and learn only.
Have fun forking.
