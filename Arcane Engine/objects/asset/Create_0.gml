#region Initialize 

//Default Asset Type
type = asset_types.empty;

//Stores vBuffer for 3D models
model = undefined;

//Stores Texture/Sprite for Maps & Art
art = undefined;

//Stores the name of the Asset as a String
name = "undefined";

//Asset Loading 
file_path = undefined;
file_loaded = false;
file_requested = false; 
file_request_id = undefined;

//Store Collision shape
col_shape = undefined;

#endregion 