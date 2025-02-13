extends Node2D

enum TargetLayer{Nothing = 0, World = 1, PlayerCol = 2, PlayerHealthHitbox = 4, EnemyCol = 8, DamageHitbox = 16, EnemyHealthHitbox = 32}

func vec_toward_mouse(from_node: Node2D)->Vector2:
	var hold_rotation: float = from_node.rotation
	from_node.look_at(get_global_mouse_position())
	var result: Vector2 = from_node.transform.x
	from_node.rotation = hold_rotation
	return result

func ray(myself: Node2D, from: Vector2, direction: Vector2, length: float, layers: int, bodies: bool = true, areas: bool = false, space_state: PhysicsDirectSpaceState2D = null)->Dictionary:
	if(space_state == null):
		space_state = myself.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, myself.global_position+direction*length, layers)
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	return space_state.intersect_ray(query)

func shape(myself: Node2D ,shape2d: Shape2D, layers: int, max_results: int = 1, bodies: bool = true, areas: bool = false, new_tran: Transform2D = myself.transform ,space_state: PhysicsDirectSpaceState2D = null)->Array[Dictionary]:
	if(space_state == null):
		space_state = myself.get_world_2d().direct_space_state
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.transform = new_tran
	query.set_collision_mask(layers); 
	query.set_shape(shape2d); 
	query.set_transform(myself.transform); 
	query.set_margin(0.01); 
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	var result: Array[Dictionary] = space_state.intersect_shape(query, max_results)
	if(result.size() > 0):
		return result
	else: 
		return [{}]
