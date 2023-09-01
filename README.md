# CustomPaletteExtender
A modding tool for extending and editing the bootleg colors for monsters in Cassette Beasts

# Installation Instructions
Download this repository and place the ```palette_extender``` folder inside your project's ```tools``` folder.

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


# Let's Talk About Glitter
Making edits to the glitter palette is a little different from the other types, because of the sparkle effect normally used there. The default behavior for the glitter sparkle is to apply its effect only to the first 5 colors of the palette. In order to get around this, the tool has a ```Glitter Region``` dropdown that appears when making edits to the glitter palette. By choosing a region from the dropdown, you can change where the sparkle effect will display. This is done by temporarily reorganizing the ```swap_colors``` palette to move the chosen region's colors to the top before assigning the type palette. 

When you change glitter region you may see your palette shift order, this is just so the monster preview doesn't mess up the colors.

https://github.com/ninaforce13/CustomPaletteExtender/assets/68625676/df0da5c3-6180-4543-b3ad-cb01064e0478

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



