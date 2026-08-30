extends CatRule
class_name NearFacilityRule

@export var source_facility: Enums.Needs
@export var target_facility: Enums.Needs
@export var max_distance: float = 2.0

func evaluate(cat: Cat, grid_manager: GridManager,  cats: Array[Cat] = []) -> float:
	var source_cell = cat.current_facility.cell #Vector2i
	#print(cat.data.cat_name + " is inside " + cat.current_facility.data.facility_name + " in " + str(source_cell))
	var target_cells = grid_manager.get_facilities_by_type(target_facility) #Array[Facility] (Facility.cell)
	
	if target_cells.is_empty():
		return 0.0
	
	var min_dist = INF
	for facility in target_cells:
		var d = cell_distance(source_cell, facility.cell)
		if d == 0:
			return 0.0
		if d < min_dist: 
			min_dist = d
	
	if min_dist <= max_distance:
		return -weight if is_negative else weight   # condition MET
	else:
		return reward if is_negative else -reward   # condition NOT met
	
	#is_negative: true
	#weight: 1.0       # punish when food IS near water
	#reward: 0.5       # reward when food is NOT near water
	#is_negative: false
	#weight: 1.0       # reward when bed IS near window
	#reward: 0.0       # no penalty when it isn't (just neutral)
