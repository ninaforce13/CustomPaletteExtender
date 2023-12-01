# CustomPaletteExtender
A modding tool for extending and editing the bootleg/default colors for monsters in Cassette Beasts

# Prerequisites
Please follow the decompile instructions in the [Mod Developer Guide](https://wiki.cassettebeasts.com/wiki/Modding:Mod_Developer_Guide) to setup your project files before proceeding with this guide.

# Installation Instructions
Download this repository and place the ```palette_extender``` folder inside your project's ```tools``` folder.

# Updating The Tool
If you need to update the tool for whatever reason, just re-download this repository and replace the files from the previous installation step. 

# How the tool works
When the tool generates an extended palette for your monster, it will create a mod folder with the necessary mod files for that monster in your project. The folder is created at ```res://mods/``` and is named after the monster (i.e ```res://mods/bootleg_mod_dominoth```). 
Note that while the tool creates a ```metadata.tres``` file for you, it does not populate any of the required fields so you will need to populate those yourself before exporting your mod. 

# How to use
1) Open the CassetteBeasts project in Godot and go locate the ```ExtendedPaletteSetup.tscn``` file inside your tools folder (this was included in the ```palette_extender``` folder).
2) Click on the ```Play Scene``` button and you should see the tool open up on a monster preview scene.
3) Select the monster you want to edit from the dropdowns and click ```Generate Extended Palette```
4) Choose an Elemental Type from the dropdowns to switch to the palette for that type.
5) Edit the colors on the right hand side of the screen however you like then press ```Save Palettes``` to commit the changes (Or reset if you want to start this palette over).

https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/34b1bd7b-79e9-4b3b-a434-b11f7c22de53

# Combined Mod Project
If you're working on more than one form for a single mod, you can specify the same mod folder for each new generated extension and the mod will automatically include them in the same folder and update the necessary script references.

![2023-11-30_23-19-43](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/d554fac2-636c-4d07-a5d8-41f1f2da0875)

![2023-11-30_23-19-03](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/441b3a0d-143e-45f7-8028-a6c580715968)

If you have an existing project then you'll be prompted to assign a folder on your next save.

# Setting up Remasters
When working on several forms in the same monster family you would typically need to update their evolutions to point to the customized remastered form. You can automate this process by clicking the ```Set as Custom Remaster``` button. This will check each of the form files included in your mod's folder for references to the current remastered form and update the reference to use this customized version. This will prevent issues with forms remastering with original colors instead of the mod colors.

![2023-11-30_23-21-56](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/b892e602-00db-4588-98fb-8f8157718be7)



# Let's Talk About Glitter
Making edits to the glitter palette is a little different from the other types, because of the sparkle effect normally used there. The default behavior for the glitter sparkle is to apply its effect only to the first 5 colors of the palette. In order to get around this, the tool has a ```Glitter Region``` dropdown that appears when making edits to the glitter palette. By choosing a region from the dropdown, you can change where the sparkle effect will display. This is done by temporarily reorganizing the ```swap_colors``` palette to move the chosen region's colors to the top before assigning the type palette. 

When you change glitter region you may see your palette shift order, this is just so the monster preview doesn't mess up the colors.

https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/df0da5c3-6180-4543-b3ad-cb01064e0478

# Project File Info
Whenever you assign a form to a mod folder you will see an entry created in the tool's ```palette_info.tres``` file. This keeps track of which form belongs in which mod project.

![image](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/82557438-2160-413b-a264-dc4a730611de)


# Targeting Colors not found on the Palette
To do this you need to find the desired color's hex value and add it to the default monster palette (this is the one you see when there is no elemental type selected). Currently only 15 colors can be on a given palette, so you will need to replace another color. It's recommended that if you choose to replace one color, that you replace all 5 colors from that region since these are designed in 3 sets of 5 colors each (these sets are colors 1-5, 6-10, 11-15). You can experiment with partial replacements, as some monster's have colors present that don't appear to be targeting anything specific.

To easily find the hex value for a color found on the sprite, open the sprite's png file (found in the ```sprites/monsters/``` folder) in Aseprite/Libresprite or an image editing tool with a color picker tool. Aseprite works best for this, since opening the file there will automatically build the color palette used so you can copy from there.

# Important Notes
Before starting on a new monster, make sure you go edit the metadata for your current monster. 
By default it appears like this:

![image](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/67ee50fb-8a8e-4250-b3ae-0bec065e1573)

However you should change ```ID```, ```Name```, and ```Author``` to something unique and meaningful.

![image](https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/8009177d-14b8-41d5-95b9-9514f1dc81fe)

Also, note that you need to set all the type palettes for a monster you start working on. If you leave any at default, they will just load the monster with it's normal colors instead of any bootleg variant.

# Exporting The Mod
The standard exporting instructions apply here.
1) Go to ```Project->Tools->Export Mod...```
2) Locate and open the ```metadata.tres``` file in the mod folder for your monster. Should be something like ```res://mods/bootleg_mod_dominoth```
3) Choose a location to save the mod file (saves as a ```.pck``` file)
   
https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/341716f8-60db-4f2d-9104-6140c908511c

# The magic behind the tool
For anyone curious about what the generated mod actually does there's a few pieces:
1) The ```MonsterForm_Ext.gd``` script: This is an extension script for MonsterForm that adds new fields to store custom type palettes directly on the monster instead of just taking what's on the type element. There's edits to the ```create_type_variant``` method to assign these custom palettes as the new type palette whenever the monster is asked to change colors (coatings/bootlegs). I also included the glitter_region field here to handle temporarily changing the swap_colors to accomodate a different sparkle region. This script is assigned to a copy of the monster's .tres file to leave the original data untouched.

2) The ```mod_load.gd``` script: This one is an extension to ContentInfo so that I could set the ```_init()``` method to make the modded monster.tres file take over the original. Nothing really special to discuss here.



