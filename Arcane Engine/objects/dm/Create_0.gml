#region Initialize Game

//Spawn Controller Objects
instance_create_depth(0, 0, 0, camera);
instance_create_depth(0, 0, 0, grid);

#endregion
#region Assets

//Asset Types
enum asset_types {
	empty,
	map,
	art,
	player,
	npc,
}

//Asset Actions
enum asset_actions {
	idle,
	move,
	rotate,
	scale
}

//Selected Inst ID
global.selected_inst = noone;

//Selection Action
global.selection_action = asset_actions.idle;

//Outline Size
global.outline_size = 0.001;

#endregion
#region Colmesh

//Store a Global Array of Texcoords for a flat image
global.texcoords = [new vec2(0, 0), new vec2(0, 1), new vec2(1, 0), new vec2(1, 1)]

//Store active collision shapes
global.collision = cm_list();

#endregion
#region Scene Management

//Store if scene has been saved
scene_saved = false;

//Scene Name
scene_name = undefined;

//Directory
scene_directory = undefined;

//Scene ZIP
scene_zip = undefined;

//Asset List
dm.asset_list = ds_list_create();

#endregion