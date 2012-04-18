#WaterflowView 

<img src="https://github.com/aceisScope/WaterflowView/raw/master/screenshot.png"/>  
<img src="https://github.com/aceisScope/WaterflowView/raw/master/screenshot2.png"/> 

##Description
===
Resembled datasource and delegate of UITableView, and mainly intended to make a display in the waterflow way of Pinterest. 
Each cell could be simply initialized with cellAtIndexPath way.
It is based on LLWaterflow and  I've tested it with AsyncImageView.

The WaterflowViewNew is based on a new layout pattern i.e. whenever to place a new cell, find the shortest column and insert the cell into the column, rather than layout by rows in column in the old one. To imply the new one in project, just change the name of file...
Yet if the images for display are mostly of normal size (not super long), the old WaterflowView is still suggested.

