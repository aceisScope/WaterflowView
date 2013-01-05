WaterflowView 
==========================

<img src="https://github.com/aceisScope/WaterflowView/raw/master/screenshot.png"/>  
<img src="https://github.com/aceisScope/WaterflowView/raw/master/screenshot2.png"/> 

###Description

Resembled datasource and delegate of UITableView, and mainly intended to make a display in the waterflow way of Pinterest. 
Each cell could be simply initialized with cellAtIndexPath way.

###Different Versions
1. The WaterflowView(New) is based on a new layout pattern i.e. whenever to place a new cell, find the shortest column and insert the cell into the column, rather than layout by rows in column in the old one. To imply the new one in project, just change the name of file...
Yet if the images for display are mostly of normal size (not super long), the WaterflowView(old) is still recommended.
2. WaterFlowLayout is UICollectionViewLayout specially for the UICollectionView in iOS6. Note that this is not a subclass of UICollectionViewFlowLayout.

###DataSource
1. For WaterflowView(New)
When to load data for WaterflowView, (or not to load), should be decided in the delegate method 

``` objective-c
    - (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page   
```

WaterflowView detects every scroll-to-bottom, and the delegate will "decide" for WaterflowView if it should reloadData or reloadFailed. 
2. For WaterFlowLayout
This follows the datasource and delegate of UICollectionViewLayout.

###License
This is available under the MIT license. 
 * Copyright (c) 2012 B.H.Liu  
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 
