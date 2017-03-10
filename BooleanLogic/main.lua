function love.load()
	local n = 3
	list = {}
	for i=0,n-1 do
		list[i] = false
	end
	
	answers = {}
	for j=0,2^n-1 do
		local args = {}
		local m = j
		for i=0,n-1 do
			if m >= 2^(n-1-i)  then
				args[i] = true
				m = m - 2^(n-1-i)
			else
				args[i] = false
			end
		end
		local string = "j=" .. j .. ": "
		for i=0,n-1 do
			string = string .. " " .. boolToInt(args[i])
		end
		print(string)
		answers[j] = boolExp(args[0],args[1], args[2])
	end
	
	for i=0,2^n-1  do
		print("i=" .. i .. ": " .. boolToInt(answers[i]))
	end
end


function love.update(dt)
	love.event.quit()
end


function love.draw()

end

function love.keypressed(k)
	if k=='escape' then
		love.event.quit()
	end
end


function boolExp(a,b,c)
	print("j=?: " .. boolToInt(a) .. " " .. boolToInt(b) .. " " .. boolToInt(c) .. "\n")
	--return implies(not (a or (not b)), not p)	--1
	--return implies(a, implies(b,c))			--2
	--return implies(implies(a,b), c)		--3
	--return implies(implies(a,b),implies(b,a))
	--return implies((a and implies(a,b)), b)		--e
	--return implies(a and b, a)	--f
--	return biconditional(b, not a or not b)	--g
	--return implies((implies(a,b) and implies(b,c)), implies(a,c)) --h

	return implies(implies(a,implies(b,c)), implies(implies(a,b),implies(a,c)))
end

function implies(a,b)
	if a and not b then
		return false
	else
		return true
	end
end

function biconditional(a,b)
	return implies(a,b) and implies(b,a)
end

function boolToInt(b)
	return b and 1 or 0
end
