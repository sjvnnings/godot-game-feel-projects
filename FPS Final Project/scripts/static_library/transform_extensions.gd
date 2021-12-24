extends Object
class_name TransformExtensions

static func transform_from_point_and_normal(pos : Vector3, normal : Vector3, scale := Vector3.ONE) -> Transform:
	var basis := Basis()
	basis.z = normal
	
	if basis.z == Vector3.UP || basis.z == Vector3.DOWN:
		basis.y = basis.z.cross(Vector3.RIGHT)
		basis.x = basis.y.cross(basis.z)
	else:
		basis.x = basis.z.cross(Vector3.UP)
		basis.y = basis.x.cross(basis.z)
	
	basis = basis.orthonormalized()
	basis.x *= scale.x
	basis.y *= scale.y
	basis.z *= scale.z
	
	return Transform(basis, pos)
	
