# Monitor Overlay

Displays data from the Monitor panel at runtime in the game window.

![image](https://user-images.githubusercontent.com/52043844/94171965-310f7b80-fe92-11ea-9420-602d4777389b.png)

## How to install

### From the asset library
- Search for `Monitor overlay` and click the install button.
- Enable the addon in `Project > Project Settings > Plugins`


### Manually from this repository
- Clone or download the project.
- Copy the contents of the `addons/monitor_overlay` folder in your project folder as follow:  
![image](https://user-images.githubusercontent.com/52043844/157983933-7b58573d-d04d-428e-9842-a89fed7999bf.png)
- Enable the addon in `Project > Project Settings > Plugins`


## How to use

- Add a new `MonitorOverlay` node to a scene.
  + Make sure it's the last node on the tree otherwise it may be drawn behind other objects.
- Select the node and enable turn on the monitors you need in the inspector under the `Active monitors` group.

![image](https://user-images.githubusercontent.com/52043844/157984315-183cbc72-98e8-4b34-bb47-49f00ac9f28c.png)


### Changing the position and size

- The whole overlay is a regular Control node. You have access to all the options available on UI nodes.
- Default width is 300px. This can be ajusted from the inspector under `Control > Layout > Minimum Size`.
- To change the vertical size of the graphs, adjust the `Graph Height` property in the inspector under `Monitor Overlay > Options > Graph Height` 


## Important notes
- The overlay is a control node that contains other nodes (one for each graph). Because of this, the reported amount of
objects / nodes / memory used / primitives drawn (and potentially others too) will differ if the overlay is enabled or not.
Although the difference is not significant, keep in mind it exists.
- Plotting a graph requires to keep track of the values history and can impact performance.
  + If you don't need this feature, you can turn it off by disabling the `Plot Graphs` option in the inspector.
  + Lowering the `History` parameter also helps.


## Licence
MIT
