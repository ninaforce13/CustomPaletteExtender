extends Control

const Backgrounds = preload("res://battle/backgrounds/battle_backgrounds.tres").resources
var ElementalTypes = Datatables.load("res://data/elemental_types")
const extended_form = "MonsterForm_Ext.gd"
onready var background = $ViewportContainer / Viewport / Background
onready var monster_button = $VBoxContainer / Buttons / MonsterButton
onready var fusion_button = $VBoxContainer / Buttons / FusionButton
onready var coating_button = $VBoxContainer / Buttons / CoatingButton
onready var animation_button = $VBoxContainer / Buttons / AnimationButton
onready var background_button = $VBoxContainer / Buttons / BackgroundButton
onready var fusion_name_label = $VBoxContainer / FusionName
onready var generate_button = $VBoxContainer/GeneratePalette
onready var save_button = $VBoxContainer/SaveButton
onready var reset_button = $VBoxContainer/ResetPalette
onready var palette_container = $VBoxContainer2
onready var glitter_label = $VBoxContainer/Buttons/GlitterRegionLabel
onready var glitter_region_options = $VBoxContainer/Buttons/GlitterRegionOption
onready var color1 = $VBoxContainer2/GridContainer/VBoxContainer2/Color1
onready var color2 = $VBoxContainer2/GridContainer/VBoxContainer2/Color2
onready var color3 = $VBoxContainer2/GridContainer/VBoxContainer2/Color3
onready var color4 = $VBoxContainer2/GridContainer/VBoxContainer2/Color4
onready var color5 = $VBoxContainer2/GridContainer/VBoxContainer2/Color5
onready var color6 = $VBoxContainer2/GridContainer/VBoxContainer2/Color6
onready var color7 = $VBoxContainer2/GridContainer/VBoxContainer2/Color7
onready var color8 = $VBoxContainer2/GridContainer/VBoxContainer2/Color8
onready var color9 = $VBoxContainer2/GridContainer/VBoxContainer2/Color9
onready var color10 = $VBoxContainer2/GridContainer/VBoxContainer2/Color10
onready var color11 = $VBoxContainer2/GridContainer/VBoxContainer2/Color11
onready var color12 = $VBoxContainer2/GridContainer/VBoxContainer2/Color12
onready var color13 = $VBoxContainer2/GridContainer/VBoxContainer2/Color13
onready var color14 = $VBoxContainer2/GridContainer/VBoxContainer2/Color14
onready var color15 = $VBoxContainer2/GridContainer/VBoxContainer2/Color15
onready var color_ref_sheet = $ColorRefSheet
onready var colorref1 = $ColorRefSheet/RefColor1
onready var colorref2 = $ColorRefSheet/RefColor2
onready var colorref3 = $ColorRefSheet/RefColor3
onready var colorref4 = $ColorRefSheet/RefColor4
onready var colorref5 = $ColorRefSheet/RefColor5
onready var colorpicker_pos = $ColorPickerPos
onready var colorpicker_pos2 = $ColorPickerPos2

var monster_forms:Array = []
var slot
var glitter_region_memory = {}
func _ready():
	GlobalUI.manage_visibility($VBoxContainer)
	monster_forms = Datatables.load("res://data/monster_forms/").table.values() + Datatables.load("res://data/monster_forms_secret/").table.values() + Datatables.load("res://data/monster_forms_secret/").table.values()	

	var i = 0
	for form in monster_forms:		
		monster_button.add_item(form.name, i)
		fusion_button.add_item("x " + tr(form.name), i + 1)
		i += 1
	i = 0
	for type in ElementalTypes.table.values():
		coating_button.add_item(type.name, i)
		i += 1
	
	for bg in Backgrounds:
		background_button.add_item(Datatables.get_db_key(bg))
	
	glitter_region_options.add_item("First Region")
	glitter_region_options.add_item("Second Region")
	glitter_region_options.add_item("Third Region")
	
	update_slots()

func update_slots():
	var slots = background.get_slots()
	slot = background.get_slots()[0]
	for j in range(1, slots.size()):
		slots[j].clear()
	
	slot.translation.x = 0.0
	
	update_selection()

func update_selection():
	var tape = MonsterTape.new()	
	var form = monster_forms[monster_button.get_selected_id()]
	if form.get("extended_type_palettes"):
		generate_button.visible = false
		save_button.visible = true
		reset_button.visible = coating_button.get_selected_id() != 99
		palette_container.visible = true		
		glitter_label.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "glitter"
		glitter_region_options.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "glitter"
		color_ref_sheet.visible = coating_button.get_selected_id() != 99		
	else:
		generate_button.visible = true
		save_button.visible = false
		reset_button.visible = false		
		palette_container.visible = false
		color_ref_sheet.visible = false
		glitter_label.visible = false
		glitter_region_options.visible = false
	tape.set_form(form)
	form = tape.create_form()	
	slot.set_form(form)
	set_ui_palette(form.swap_colors)
	if coating_button.get_selected_id() != 99:
		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]
		tape.type_override = []
		tape.type_override.push_back(type)
		form = tape.create_form()
		if form.get("extended_type_palettes"):
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 0:
				glitter_region_options.select(0)
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 5:
				glitter_region_options.select(1)
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 10:
				glitter_region_options.select(2)
				
			set_ui_palette(form.extended_type_palettes[type.id])
			set_type_refsheet(type)
		slot.set_form(form)
		
	if fusion_button.get_selected_id() > 0:
		var fuse_with = monster_forms[fusion_button.get_selected_id() - 1]
		var fusion = Fusions.fuse_forms([form, fuse_with], 0)
		slot.set_form(fusion)
		fusion_name_label.text = fusion.name
	else :
		slot.set_form(form)
		fusion_name_label.text = ""	
		
	slot.sprite_container.idle = animation_button.text
	if animation_button.text != "idle":
		slot.sprite_container.alt_idle = animation_button.text
	else :
		slot.sprite_container.alt_idle = ""

func set_type_refsheet(type):
	colorref1.color = type.palette[0]
	colorref2.color = type.palette[1]
	colorref3.color = type.palette[2]
	colorref4.color = type.palette[3]
	colorref5.color = type.palette[4]

func set_ui_palette(colors):
	color1.color = colors[0]
	color2.color = colors[1]
	color3.color = colors[2]
	color4.color = colors[3]
	color5.color = colors[4]
	color6.color = colors[5]
	color7.color = colors[6]
	color8.color = colors[7]
	color9.color = colors[8]
	color10.color = colors[9]
	color11.color = colors[10]
	color12.color = colors[11]
	color13.color = colors[12]
	color14.color = colors[13]
	color15.color = colors[14]
	
func _on_item_selected(_id):
	update_selection()

func _on_SpinBox_value_changed(_value):
	update_selection()

func _on_BackgroundButton_item_selected(id):
	var bg_parent = background.get_parent()
	bg_parent.remove_child(background)
	background.queue_free()
	background = Backgrounds[id].instance()
	bg_parent.add_child(background)
	update_slots()

func duplicate_monster_data(form, original_data):	
	form.name = original_data.name
	form.swap_colors = original_data.swap_colors.duplicate()
	form.default_palette = original_data.default_palette.duplicate()
	form.emission_palette = original_data.emission_palette.duplicate()
	form.battle_cry = original_data.battle_cry
	form.defeat_cry = original_data.defeat_cry
	form.named_positions = original_data.named_positions
	form.elemental_types = original_data.elemental_types
	form.tape_sticker_texture = original_data.tape_sticker_texture
	form.exp_yield = original_data.exp_yield
	form.require_dlc = original_data.require_dlc
	form.battle_sprite_path = original_data.battle_sprite_path
	form.ui_sprite_path = original_data.ui_sprite_path
	form.pronouns = original_data.pronouns
	form.description = original_data.description
	form.max_hp = original_data.max_hp
	form.melee_attack = original_data.melee_attack
	form.melee_defense = original_data.melee_defense
	form.ranged_attack = original_data.ranged_attack
	form.ranged_defense = original_data.ranged_defense
	form.speed = original_data.speed
	form.evasion = original_data.evasion
	form.max_ap = original_data.max_ap
	form.move_slots = original_data.move_slots
	form.evolutions = original_data.evolutions.duplicate()
	form.evolution_specialization_question = original_data.evolution_specialization_question
	form.capture_rate = original_data.capture_rate
	form.exp_gradient = original_data.exp_gradient
	form.exp_base_level = original_data.exp_base_level
	form.move_tags = original_data.move_tags.duplicate()
	form.initial_moves = original_data.initial_moves.duplicate()
	form.tape_upgrades = original_data.tape_upgrades.duplicate()
	form.unlock_ability = original_data.unlock_ability
	form.fusion_name_prefix = original_data.fusion_name_prefix
	form.fusion_name_suffix = original_data.fusion_name_suffix
	form.fusion_generator_path = original_data.fusion_generator_path
	form.bestiary_index = original_data.bestiary_index
	form.bestiary_category = original_data.bestiary_category
	form.bestiary_bios = original_data.bestiary_bios.duplicate()
	form.bestiary_data_requirement = original_data.bestiary_data_requirement
	form.bestiary_data_requirement_flag = original_data.bestiary_data_requirement_flag
	form.loot_table = original_data.loot_table


func generate_extended_form()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)	
	var form_ext ="MonsterForm_Ext.gd"
	var mod_path = "res://mods/bootleg_mod_"+monster_name
	var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres"	 
	var dir = Directory.new()
	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)
	if dir.open(mod_path) == OK:			
		var new_form = MonsterForm.new()
		new_form.set_script(load(mod_path+"/"+form_ext))
		var original_data = load(original_path)
		duplicate_monster_data(new_form, original_data)
		var ElementalTypes = Datatables.load("res://data/elemental_types").table.values()
		for type in ElementalTypes:
			new_form.extended_type_palettes[type.id] = new_form.swap_colors.duplicate()	
		new_form.glitter_region = [0,1,2,3,4]
		var err = ResourceSaver.save(extended_monster_file, new_form)
		if err == OK:
			new_form.take_over_path(original_path)
			replace_default_form(new_form)
			return "Generated " + extended_monster_file +" ."
	return "Failed to Generate modded monster resource file."

func generate_metadata_file(modload_script, folder)->String:
		var metadata = ContentInfo.new()
		metadata.set_script(modload_script)			
		var err = ResourceSaver.save(folder+"/metadata.tres", metadata)
		if err != OK:
			return "Failed to create metadata.tres file."
		return "Generated " + folder+"/metadata.tres ."
			
func generate_monster_form_file()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)
	var mod_path = "res://mods/bootleg_mod_"+monster_name
	var file_name ="MonsterForm_Ext.gd"    
	var dir = Directory.new()
	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)
	if dir.open(mod_path) == OK:		
		var source_code := """extends MonsterForm

export (Dictionary) var extended_type_palettes 
export (Array, int) var glitter_region

func create_type_variant(types:Array)->Resource:
	if types.size() == 0:
		return self
	var result = duplicate()
	result._variant_of = _get_original()
	result.elemental_types = types
	var new_type = types[0].duplicate()			
	if is_glitter_type(new_type):
		var form_palette:Array = result.swap_colors.duplicate()
		var index:int = 0
		for glitter_index in glitter_region:
			result.swap_colors[index] = form_palette[glitter_index]
			result.swap_colors[glitter_index] = form_palette[index]
			index += 1			
	new_type.palette = extended_type_palettes[new_type.id]
	result.default_palette = new_type.generate_recolor_palette(result.default_palette, result.swap_colors)
	return result

func is_glitter_type(type)->bool:
	return type.id == "glitter"	
		"""

		var new_script = GDScript.new()
		new_script.source_code = source_code
		new_script.resource_path = mod_path+"/"+file_name	
		var err = ResourceSaver.save(new_script.resource_path, new_script)
		if err != OK:
			return "Failed to generate MonsterForm_Ext.gd file."
		
		return "Generated " + new_script.resource_path +" ."
	return "Failed to open mod folder path: " + mod_path +"."
	
func generate_mod_load_script()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)
	var mod_path = "res://mods/bootleg_mod_"+monster_name
	var file_name ="mod_load.gd"    
	var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres" 
	var dir = Directory.new()
	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)
	if dir.open(mod_path) == OK:		
		var source_code := """extends ContentInfo
func _init():
	var res = preload("%s")
	res.take_over_path("%s")	
		""" % [extended_monster_file, original_path]

		var new_script = GDScript.new()
		new_script.source_code = source_code
		new_script.resource_path = mod_path+"/"+file_name
		var err = ResourceSaver.save(new_script.resource_path, new_script)
		if err == OK:
			var message = generate_metadata_file(new_script, mod_path)
			return message + "\n" + "Generated " + new_script.resource_path +" ."
	return "Failed to open mod folder path: " + mod_path + " ."
	
func create_directory(dir:Directory, folder:String):
	var result = dir.make_dir(folder)
	if result != OK:
		push_error("Failed to create folder "+folder)
		return false	

func _on_GeneratePalette_pressed():
	var messages:Array = []
	validate_mod_folder()
	messages.push_back(generate_monster_form_file()) 
	messages.push_back(generate_extended_form())
	messages.push_back(generate_mod_load_script())
	update_selection()
	yield (GlobalMessageDialog.show_message("Generation results: " + "\n" + messages[0] + "\n" + messages[1] + "\n" + messages[2] ),"completed")
func replace_default_form(new_form):	
	monster_forms[monster_button.get_selected_id()] = new_form

func _on_Color_changed(color, index):
	var form = monster_forms[monster_button.get_selected_id()]
	if coating_button.get_selected_id() != 99:
		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]
		form.extended_type_palettes[type.id][index] = color
		update_selection()
	else:
		form.swap_colors[index] = color
		update_selection()

func validate_mod_folder():
	var dir = Directory.new()
	if not dir.dir_exists("res://mods"):
		create_directory(dir, "res://mods")	

func _on_SaveButton_pressed():
	var form = monster_forms[monster_button.get_selected_id()]
	if yield(MenuHelper.confirm("Are you sure you want to save changes to "+ Loc.tr(form.name)+"'s palettes?"),"completed"):
		var original_path:String = form.resource_path
		var base_name:String = original_path.get_basename()
		var monster_name = base_name.get_slice("/",4)
		var mod_path = "res://mods/bootleg_mod_"+monster_name
		var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres"
		var result = ResourceSaver.save(extended_monster_file, form)
		if result == OK:
			yield (GlobalMessageDialog.show_message("Saved all color palettes for " + Loc.tr(form.name)+"."),"completed")	
		else:
			yield (GlobalMessageDialog.show_message("Error saving " + extended_monster_file),"completed")	
func _on_Color_pressed(index):
	if index == 1:
		color1.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color1.get_picker().presets_visible = false
	if index == 2:
		color2.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color2.get_picker().presets_visible = false	
	if index == 3:
		color3.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color3.get_picker().presets_visible = false
	if index == 4:
		color4.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color4.get_picker().presets_visible = false
	if index == 5:
		color5.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color5.get_picker().presets_visible = false
	if index == 6:
		color6.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color6.get_picker().presets_visible = false
	if index == 7:
		color7.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color7.get_picker().presets_visible = false
	if index == 8:
		color8.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color8.get_picker().presets_visible = false
	if index == 9:
		color9.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color9.get_picker().presets_visible = false
	if index == 10:
		color10.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color10.get_picker().presets_visible = false
	if index == 11:
		color11.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color11.get_picker().presets_visible = false
	if index == 12:
		color12.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color12.get_picker().presets_visible = false	
	if index == 13:
		color13.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color13.get_picker().presets_visible = false
	if index == 14:
		color14.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color14.get_picker().presets_visible = false
	if index == 15:
		color15.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color15.get_picker().presets_visible = false
																						
func _on_RefColor_pressed(index):
	if index == 1:
		colorref1.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref1.get_picker().presets_visible = false
	if index == 2:
		colorref2.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref2.get_picker().presets_visible = false
	if index == 3:
		colorref3.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref3.get_picker().presets_visible = false
	if index == 4:
		colorref4.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref4.get_picker().presets_visible = false
	if index == 5:
		colorref5.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref5.get_picker().presets_visible = false


func _on_GlitterRegionOption_item_selected(index):
	var form = monster_forms[monster_button.get_selected_id()]
	if form.get("glitter_region"):
		if not glitter_region_memory.has(form) and form.glitter_region.size() > 0:
			if form.glitter_region[0] == 0:
				glitter_region_memory[form] = 0
			if form.glitter_region[0] == 5:
				glitter_region_memory[form] = 1
			if form.glitter_region[0] == 10:
				glitter_region_memory[form] = 2					
		if glitter_region_memory.has(form):
			swap_glitter_palette(glitter_region_memory[form])
		swap_glitter_palette(index)	
		glitter_region_memory[form] = index			
	update_selection()

func swap_glitter_palette(swap_region):
	var form = monster_forms[monster_button.get_selected_id()]
	var type = ElementalTypes.table.values()[coating_button.get_selected_id()]	
	var type_palette = form.extended_type_palettes[type.id].duplicate()
	var index:int = 0
	if swap_region == 0:
		form.glitter_region = [0,1,2,3,4]
	if swap_region == 1:
		form.glitter_region = [5,6,7,8,9]
	if swap_region == 2:
		form.glitter_region = [10,11,12,13,14]
			
	for glitter_index in form.glitter_region:
		form.extended_type_palettes[type.id][index] = type_palette[glitter_index]
		form.extended_type_palettes[type.id][glitter_index] = type_palette[index]
		index += 1

func _on_ResetPalette_pressed():
	if yield(MenuHelper.confirm("Are you sure you want to reset this palette?"),"completed"):
		var form = monster_forms[monster_button.get_selected_id()]
		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]	
		form.extended_type_palettes[type.id] = form.swap_colors.duplicate()
		update_selection()
		yield (GlobalMessageDialog.show_message(Loc.tr(type.name) + " color palette reset to " + Loc.tr(form.name) + "'s current default palette."),"completed")	
