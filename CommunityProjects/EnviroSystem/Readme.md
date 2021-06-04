This is a Asset-File for the WRS-S2 which provides a basic low-impact processing for objects.

## Usage
Add all the files to your UnityProject. Don't forget adding the lua files to your assetbundle/mod.lua!
To use the object you need to add the `On Create Lua Script` and if you want to use the custom shader you need
to switch you shader to `PaulchenShaders/SmartEnviro`. For the OnCreate you have the `ToggleEnviroObject` and the
`ShaderEnviroObject`.
```lua
   --OnCreate ShaderEnviroObject
   ShaderEnviroObject:onCreate(id); 
   -- Be aware that all childs of id will also try changing, due to LOD'S 
   
   --OnCreate ToggleEnviroObject
   ToggleEnviroObject:onCreate(id, minSnowHeight, obj1, obj2, ...) 
   --Here you need to add all the snowObjects who are supposed to get visible if the snowheight at the position of the id
   --is greater than minSnowHeight
```
## Creators

- Paulchen(Paul Masan)
