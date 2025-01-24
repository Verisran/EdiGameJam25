extends CharacterBody2D
class_name BaseKinematic

enum PushType{NULL = 0, REPEL = 1, PULL = 2, AMPLIFY = 3}

func impulse(vector: Vector2, strength: float, use_current_dir: bool = false)->void:
	if(use_current_dir):
		vector = velocity.normalized()
	velocity += vector*strength

func amplify(strength: float)->void:
	velocity = velocity.normalized()*strength
