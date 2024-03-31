#region Undefined 

//Check Type
if type = asset_types.empty {
}

//Art
if type = asset_types.art{
	if art = undefined {
	//Draw Nothing
	} else {
	draw_sprite(art, 0, 0, 0);
	//Rebuild to draw map onto a plane
	}
}

#endregion