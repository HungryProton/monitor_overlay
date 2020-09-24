# Monitor Overlay

Displays the data you can find on the Monitor panel at runtime on top of your game.

![image](https://user-images.githubusercontent.com/52043844/94171965-310f7b80-fe92-11ea-9420-602d4777389b.png)

## How to install

- Clone this repository in your `addons` folders.
- After installation, you should have something like this:  
![image](https://user-images.githubusercontent.com/52043844/94172261-92cfe580-fe92-11ea-9f09-1d529382e2b7.png)
- Do **not** rename the folder, it has to be **monitor_overlay**.
  + If you downloaded a zip file of this repository, chances are this folder will be named `monitor_overlay-master`.
  + If that's the case, make sure you rename it as **monitor_overlay**.


## How to use

- Right click in your scene tree and click `Add child node`.
- Search for a node called `MonitorOverlay` and add it to the scene.
- Make sure it's the last node on the tree otherwise it may be drawn behind other objects.
![image](https://user-images.githubusercontent.com/52043844/94172724-22759400-fe93-11ea-89c7-6f6e894e0064.png)

- Select this node and in the inspector panel, enable the options you need.
![image](https://user-images.githubusercontent.com/52043844/94172856-53ee5f80-fe93-11ea-82c4-a1c2d40a3f38.png)


### Changing the position and size

- The whole overlay is a Control node so you can adjust its width in the inspector under `Rect > Min Size`.
  + Default is 300 pixels wide.
- If you prefer it to be on the right side of the screen, select the `Monitor Overlay` node, click on `Layout > Right Wide`.
- To change the vertical size of the graphs, adjust the `Graph Height` properties in the inspector.


## Important note
- The overlay is a 2D node that contains other nodes (one for each graph). Because of this, the reported amount of
objects / nodes / memory used and others will differ if the overlay is enabled or not. While the difference is not
significant, keep in mind that it exists.
- Don't turn on all the graphs at once. Not only there's not enough room to display them all, keeping track of the
values history and drawing them can impact performance.

## Licence
MIT
