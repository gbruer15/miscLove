

function rotateCamera(Camera, axis, sign)
	sign = sign or 1
	local Angle = Camera.rotatespeed*sign or 0.01*sign
	
	local rotationq = {}
	rotationq.w  = math.cos( Angle/2)
	
	if axis.x then
		rotationq.x = axis.x * math.sin( Angle/2 )
		rotationq.y = axis.y * math.sin( Angle/2 )
		rotationq.z = axis.z * math.sin( Angle/2 ) 
	else
		rotationq.x = axis[1] * math.sin( Angle/2 ) 
		rotationq.y = axis[2] * math.sin( Angle/2 ) 
		rotationq.z = axis[3] * math.sin( Angle/2 ) 
	end
	
	
	Camera.quaternion = multiplyQuaternion(Camera.quaternion, rotationq)
	
	
	
	Camera.rotationmatrix = getRotationMatrix(Camera.quaternion)
	
	
	
	return Camera
end


function updateCameraPoints(Camera)
		
	Camera.forwardpoint = multiplyMatrix({{0,0,1,0}}, Camera.rotationmatrix)[1]
	Camera.forwardpoint[1] = -Camera.forwardpoint[1]
	Camera.forwardpoint[2] = -Camera.forwardpoint[2]
	
	Camera.horizontalpoint = multiplyMatrix({{1,0,0,0}}, Camera.rotationmatrix)[1]
	Camera.horizontalpoint[2] = -Camera.horizontalpoint[2]
	Camera.horizontalpoint[3] = -Camera.horizontalpoint[3]
	
	Camera.verticalpoint = multiplyMatrix({{0,1,0,0}}, Camera.rotationmatrix)[1]
	Camera.verticalpoint[2] = -Camera.verticalpoint[2]
	
	return Camera
end

function moveCamera(Camera, unitvector, distance)
	if unitvector.x then
		Camera.x = Camera.x+unitvector.x*distance
		Camera.y = Camera.y+unitvector.y*distance
		Camera.z = Camera.z+unitvector.z*distance
	else
		Camera.x = Camera.x+unitvector[1]*distance
		Camera.y = Camera.y+unitvector[2]*distance
		Camera.z = Camera.z+unitvector[3]*distance	
	end

	return Camera

end