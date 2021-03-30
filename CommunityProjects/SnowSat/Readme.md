# SnowSat

This is a Mod-File for the WRS-S2 which provides a basic SnowSat-System for Vehicles

<img src="https://github.com/Raining-Cloud/WinterResortSimulator/blob/main/CommunityProjects/SnowSat/snow_sat.png" height="200">

## Usage
You need to download the unity package and add it to your assetbundle. Add the `"SnowSat.lua"` in you `mod.lua`file.
In the datatable of your vehicle you now need to add a few things. First you add `SnowSat,` to the `vehicleScripts`.
Finally we need the `snowSat` table with all the indexes for a working SnowSat. You can find the table below.

```lua
    snowSat = {
        root    = "SnowSat", --Prefab
        onOffId = "someButton", --object with collider!
        canvasSize = Vector2:new(1040, 780),
        -- stats
        sideRotation = "Snowsat/Display/SnowCatStats/RotationSide",
        frontRotation = "Snowsat/Display/SnowCatStats/RotationFront",
        baseHeight = "Snowsat/Display/WindowBar/SnowHeightBase",
        bladeHeightLeft = "Snowsat/Display/WindowBar/SnowHeightBlade/Left",
        bladeHeightRight = "Snowsat/Display/WindowBar/SnowHeightBlade/Right",
        bladeLeftId = "PB600_mechanics_front/PB600_aufhaengung_vorne_col/PB600_aufhaengung_front_gier/PB600_aufhaengung_front_nick/PB600_aufhaengung_front_roll/PB600_aufhaengung_front_col/PB600_SchildAttacher/Schild/Left",
        bladeRightId = "PB600_mechanics_front/PB600_aufhaengung_vorne_col/PB600_aufhaengung_front_gier/PB600_aufhaengung_front_nick/PB600_aufhaengung_front_roll/PB600_aufhaengung_front_col/PB600_SchildAttacher/Schild/Right",
        mainIcon = "Snowsat/Display/SnowCat",
        -- mesure
        mainIconLength = 150, -- |
        snowCatLength = 9, -- the length of the mainSnowCatIcon for getting the pixel coords in 3d space
        -- pixels
        master = "Snowsat/Display/Master",
        basePixel = "Snowsat/Display/Master/MainPixel",
        pixelSize = 20,
        -- chunks
        chunkX = 3,
        chunkY = 2,
	renderDistance = 3,

        --custom colors

		--due to SnowBufferPixel.height is a byte we have  a value between 0 and 255. So 1m == 128 (0.1m == 12,8)
        levels = {
            --[[ 0.0M ]]
            {level = 0,     color = Vector4:new(80, 0, 0, 255)},
            --[[ 0.1M ]]
            {level = 12.8,  color = Vector4:new(175, 0, 0, 255)},
            --[[ 0.2M ]]
            {level = 25.6,  color = Vector4:new(252, 1, 0, 255)},
            --[[ 0.5M ]]
            {level = 64,    color = Vector4:new(0, 255, 2, 255)},
            --[[ 1.0M ]]
            {level = 128,   color = Vector4:new(0, 1, 255, 255)},
            --[[ 1.5M ]]
            {level = 192,   color = Vector4:new(253, 208, 0, 255)},
            --[[ 2.0M ]]
            {level = 255,   color = Vector4:new(154, 100, 0, 255)},
        },
        groomed = Vector4:new(255,106,0,255);
    },
```

## Creators

- Paulchen(Paul Masan)
- Snowman73 [YouTube](https://www.youtube.com/channel/UCBjP9Jj0tvrrLM_dkWwsUNw)

