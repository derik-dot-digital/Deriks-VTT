function cm_octree_remove(octree, object)
{
	var oct_size = CM_OCTREE_SIZE;
	var oct_aabb = CM_OCTREE_AABB;
	var obj_aabb = cm_get_aabb(object);
	if (obj_aabb[0] > oct_aabb[3] || obj_aabb[1] > oct_aabb[4] || obj_aabb[2] > oct_aabb[5] || obj_aabb[3] < oct_aabb[0] || obj_aabb[4] < oct_aabb[1] || obj_aabb[5] < oct_aabb[2]) return false;
	
	var objectlist = CM_OCTREE_OBJECTLIST;
	var ind = array_get_index(objectlist, object, CM_LIST_NUM, - objectlist[CM_LIST.NEGATIVESIZE]);
	if (ind < 0) return false;
	
	array_delete(objectlist, ind, 1);
	objectlist[@ CM_LIST.NEGATIVESIZE] += 1;
	
	if (!CM_OCTREE_SUBDIVIDED) return false;
	
	var rsize = CM_OCTREE_SIZE / 2;
	var maxobjects = CM_OCTREE_MAXOBJECTS;
	
	var x1 = (obj_aabb[0] - oct_aabb[0] > rsize);
	var y1 = (obj_aabb[1] - oct_aabb[1] > rsize);
	var z1 = (obj_aabb[2] - oct_aabb[2] > rsize);
	var x2 = (obj_aabb[3] - oct_aabb[0] > rsize);
	var y2 = (obj_aabb[4] - oct_aabb[1] > rsize);
	var z2 = (obj_aabb[5] - oct_aabb[2] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			for (var zz = z1; zz <= z2; ++zz)
			{
				var ind = CM_OCTREE.CHILD1 + xx + 2 * yy + 4 * zz;
				var child = octree[ind];
				if (!is_array(child)) continue;
				
				//Remove the object from the child
				cm_octree_remove(child, object);
				
				//If the child is empty, remove it from this octree
				if (child[CM_OCTREE.OBJECTLIST][CM_LIST.NEGATIVESIZE] == 0)
				{
					octree[@ ind] = undefined;
					continue;
				}
			}
		}
	}
	
	var children = 0;
	var onlychild = 0;
	var i = CM_OCTREE.CHILD1;
	repeat 8
	{
		var child = octree[i++];
		if (!is_array(child)) continue;
		++ children;
		onlychild = child;
	}
	
	//If this octree has no children, unsubdivide it
	if (children == 0)
	{
		CM_OCTREE_SUBDIVIDED = false;
		for (var i = 0; i < 8; ++i)
		{
			octree[@ CM_OCTREE.CHILD1 + i] = undefined;
		}
	}
	//If this octree contains just one region, see if it can be unsubdivided
	if (children == 1)
	{
		if (CM_OCTREE_ISROOT)
		{
			array_copy(octree, 0, onlychild, 0, CM_OCTREE.NUM);
			CM_OCTREE_ISROOT = true;
		}
		else if (onlychild[CM_OCTREE.SUBDIVIDED] == false)
		{
			CM_OCTREE_SUBDIVIDED = false;
			for (var i = 0; i < 8; ++i)
			{
				octree[@ CM_OCTREE.CHILD1 + i] = undefined;
			}
		}
	}
}