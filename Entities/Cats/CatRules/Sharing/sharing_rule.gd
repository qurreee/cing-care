extends CatRule
class_name SharingRule

func evaluate(cat: Cat, grid_manager: GridManager,  cats: Array[Cat] = []) -> float:
	if cat.current_facility == null:
		return 0.0
	
	var sharing = false
	for other: Cat in cats:
		if other == cat:
			continue
		if other.current_facility == null:  # add this check
			continue
		if other.current_facility.cell == cat.current_facility.cell:
			sharing = true
			break
	
	if sharing:
		return -weight if is_negative else weight
	else:
		return reward if is_negative else -reward
