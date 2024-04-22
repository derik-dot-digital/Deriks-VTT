function cm_quadtree_remove(quadtree, object)
{
	var quad_size = CM_QUADTREE_SIZE;
	var quad_aabb = CM_QUADTREE_AABB;
	var obj_aabb = cm_get_aabb(object);
	if (obj_aabb[0] > quad_aabb[3] || obj_aabb[1] > quad_aabb[4] || obj_aabb[3] < quad_aabb[0] || obj_aabb[4] < quad_aabb[1]) return false;
	
	var objectlist = CM_QUADTREE_OBJECTLIST;
	var ind = array_get_index(objectlist, object, CM_LIST_NUM, - objectlist[CM_LIST.NEGATIVESIZE]);
	if (ind < 0) return false;
	
	array_delete(objectlist, ind, 1);
	objectlist[@ CM_LIST.NEGATIVESIZE] += 1;
	
	if (!CM_QUADTREE_SUBDIVIDED) return false;
	
	var rsize = CM_QUADTREE_SIZE / 2;
	var maxobjects = CM_QUADTREE_MAXOBJECTS;
	
	var x1 = (obj_aabb[0] - quad_aabb[0] > rsize);
	var y1 = (obj_aabb[1] - quad_aabb[1] > rsize);
	var x2 = (obj_aabb[3] - quad_aabb[0] > rsize);
	var y2 = (obj_aabb[4] - quad_aabb[1] > rsize);
	for (var xx = x1; xx <= x2; ++xx)
	{
		for (var yy = y1; yy <= y2; ++yy)
		{
			var ind = CM_QUADTREE.CHILD1 + xx + 2 * yy;
			var child = quadtree[ind];
			if (!is_array(child)) continue;
				
			//Remove the object from the child
			cm_quadtree_remove(child, object);
				
			//If the child is empty, remove it from this quadtree
			if (child[CM_QUADTREE.OBJECTLIST][CM_LIST.NEGATIVESIZE] == 0)
			{
				quadtree[@ ind] = undefined;
				continue;
			}
		}
	}
	
	var children = 0;
	var onlychild = 0;
	var i = CM_QUADTREE.CHILD1;
	repeat 4
	{
		var child = quadtree[i++];
		if (!is_array(child)) continue;
		++ children;
		onlychild = child;
	}
	
	//If this quadtree has no children, unsubdivide it
	if (children == 0)
	{
		CM_QUADTREE_SUBDIVIDED = false;
		for (var i = 0; i < 4; ++i)
		{
			quadtree[@ CM_QUADTREE.CHILD1 + i] = undefined;
		}
	}
	//If this quadtree contains just one region, see if it can be unsubdivided
	if (children == 1)
	{
		if (CM_QUADTREE_ISROOT)
		{
			array_copy(quadtree, 0, onlychild, 0, CM_QUADTREE.NUM);
			CM_QUADTREE_ISROOT = true;
		}
		else if (onlychild[CM_QUADTREE.SUBDIVIDED] == false)
		{
			CM_QUADTREE_SUBDIVIDED = false;
			for (var i = 0; i < 4; ++i)
			{
				quadtree[@ CM_QUADTREE.CHILD1 + i] = undefined;
			}
		}
	}
}