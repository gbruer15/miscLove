



------[[[[[[   MATH  ]]]]]]]]]----------
function distance3d(x1,y1,z1,  x2,y2,z2)
	
	return (   ((x1-x2)^2) + ((y1-y2)^2) + ((z1-z2)^2)  ) ^ 0.5

end

function multiplyMatrixColumnRow(column, row)
	if #column ~= #row then error('Incompatible Lists') end
	
	local sum = 0
	for i = 1, #column do
		sum = sum + column[i]*row[i]	
	end
	return sum
end

function multiplyMatrix(amat, bmat)
	local amatR = #amat
	local bmatR = #bmat
	
	local amatC = #amat[1]
	local bmatC = #bmat[1]

	if amatC ~= bmatR then error('Incompatible Matrices') end
		
	local matrix = {}
	
	for r = 1, amatR do
		table.insert(matrix, {})
		
		for c = 1, bmatC do
			matrix[r][c] = multiplyMatrixColumnRow(amat[r], bmat[c])		
		end	
		
	end
	
	
	
	return matrix

end

function getRotationMatrix(quat) --Camera quat
	local w = quat.w
	local x = quat.x
	local y = quat.y
	local z = quat.z
	return {
		{(w^2)+(x^2)-(y^2)-(z^2),    2*x*y-2*w*z,    2*x*z+2*w*y, 0},
		{2*x*y+2*w*z,   (w^2)-(x^2)+(y^2)-(z^2),   2*y*z+2*w*x, 0},
		{ 2*x*z-2*w*y,   2*y*z-2*w*x,   (w^2)-(x^2)-(y^2)+(z^2), 0},
		{0,                      0,             0,          1}
	
	}

end


function multiplyQuaternion(q1,q2)
	local product = {}
	product.w = (q1.w * q2.w  -  q1.x * q2.x  -  q1.y * q2.y  - q1.z * q2.z)
	product.x = (q1.w * q2.x  +  q1.x * q2.w  +  q1.y * q2.z  - q1.z * q2.y)
	product.y = (q1.w * q2.y  -  q1.x * q2.z  +  q1.y*q2.w +  q1.z * q2.x)
	product.z = (q1.w * q2.z  +  q1.x * q2.y  -  q1.y*q2.x +  q1.z * q2.w)

	return product
end

function inverseQuaternion(qu)
	local qconjugate = qu.w-qu.x-qu.y-qu.z
	for i,v in pairs(qu) do
		v = v*qconjugate	
	end
	
	for i,v in pairs(qu) do
		v = qconjugate/v	
	end

	return qu
end
---------------------------------------------------------------------------------------------

-- Returns 'n' rounded to the nearest 'deci'th. --
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end

--This function has been brought to you by Drew Cage--

---------------------------------------------------------------------------------------------


function math.getSign(n)
	if n >= 0 then	
		return 1
	elseif n < 0 then
		return -1
	end
end

function normalize(array)
	local list = array
	local magnitude = 0
	for i,v in pairs(list) do
		magnitude = magnitude + v*v
	end
	magnitude = magnitude^0.5
	
	for i,v in pairs(list) do
		list[i] = list[i]/magnitude
	end
	
	return list, magnitude
end



function math.distanceFromPlane(point, normalvector, pointonplane)
	local sum
	local distance
	if normalvector.x then
		if point.x then
			sum = normalvector.x*point.x+normalvector.y*point.y+normalvector.z*point.z
		else
			sum = normalvector.x*point[1]+normalvector.y*point[2]+normalvector.z*point[3]
		end
		
		if pointonplane.x then
			sum = sum + normalvector.x*pointonplane.x+normalvector.y*pointonplane.y+normalvector.z*pointonplane.z
		else
			sum = sum + normalvector.x*pointonplane[1]+normalvector.y*pointonplane[2]+normalvector.z*pointonplane[3]
		end
		distance = sum/(normalvector.z*normalvector.z + normalvector.y*normalvector.y + normalvector.x*normalvector.x)^0.5
	else
		if point.x then
			sum = normalvector[1]*point.x+normalvector[2]*point.y+normalvector[3]*point.z
		else
			sum = normalvector[1]*point[1]+normalvector[2]*point[2]+normalvector[3]*point[3]
		end
		if pointonplane.x then
			sum = sum + normalvector[1]*pointonplane.x+normalvector[2]*pointonplane.y+normalvector[3]*pointonplane.z
		else
			sum = sum + normalvector[1]*pointonplane[1]+normalvector[2]*pointonplane[2]+normalvector[3]*pointonplane[3]
		end
		distance = sum/(normalvector[3]*normalvector[3] + normalvector[2]*normalvector[2] + normalvector[1]*normalvector[1])^0.5
	end
	
	return distance

end


