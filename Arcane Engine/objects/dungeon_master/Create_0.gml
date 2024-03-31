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

#endregion
#region Colmesh

//Store active collision shapes
global.collision = cm_list();

#endregion
