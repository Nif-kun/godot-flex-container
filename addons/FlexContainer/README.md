# FlexContainer <img align="center" alt="icon" width="40px" src="https://github.com/Nif-kun/godot-flex-container/blob/main/addons/FlexContainer/res/icon.svg" />
### A simple flex container plugin for <a href="https://godotengine.org">Godot</a>.
 
* <a href="#installation">Installation</a></li>
* <a href="#usage">Usage</a></li>
* <a href="#properties">Properties</a></li>
* <a href="#limitations">Limitations</a></li>


## <a name="installation">Installation</a>
1. Download the latest version in <a href="https://github.com/Nif-kun/godot-flex-container-plugin/releases">releases</a> or clone the repository.
2. Copy the contents of `addons/FlexContainer` into your `res://addons/FlexContainer` directory.
3. Enable `Dialogue Manager` in your project plugins.


## <a name="usage">Usage</a>
1. Set a grid size using the `Columns` and `Rows` in `Inspector`.
2. In `Inspector` increase the amount of `Vector2` in `Blocks` property based on the *grid size* (`Columns` × `Rows`). 
<br /> This is not required but recommended. It would also be better to avoid going beyond *grid size*.
3. `Vector2`'s `x` acts as span while `y` acts as row. Customize them depending to your need.
4. Added children within the node will change size and position corresponding to the `Vector2` in `Blocks`. 
<br />The first `Vector2` corresponds to the first child and so forth.

**Note: when extending the script, add the `tool` keyword to have the exports show in the `Inspector`.**

## <a name="properties">Properties</a>
Property         | Type             | Definition
---------------- | ---------------- | -------------
Columns          | int              | the width or amount of column the *container* will have, forming a *grid*.
Rows             | int              | the height or amount of rows the *container* will have, forming a *grid*.
Blocks           | PoolVector2Array |the placeholder for child nodes within the container. Each `Vector2` represents a block within a *grid*, having its own span (`x`) and row (`y`). It moves from left to right and top to bottom.
Compact          | boolean          | it fills in the empty spaces within the *container*.
Limit Visible    | boolean          | it hides children that goes beyond the container's size or outside the size of `Blocks`.
Disable Min Size | boolean          | it sets the `rect_min_size` of children to `Vector2.ZERO`. This is currently the default as the container can't handle `rect_min_size` of children.


## <a name="Issues">Limitations</a>
* Currently has no way to properly handle `rect_min_size` of chilren.
* Adding non `Control` type nodes may cause errors or even a crash. Bypass by encapsulating it inside a control type node.
* Resizing isn't fully accurate which causes jitter and a pixel or two of misalignment. *It's annoying*.

**Said issues may be fixed in the future updates. However, if you know a way to fix it, do open up an issue or a pull request. Your contribution would be greatly apprciated**

