--[[
Copyright © Savoshchanka Anton Aleksandrovich, 2015
version 0.0.1
HELP:
	+ 
TODO:
	- 
--]]

--[[
	zlib License

	Copyright (c) 2015 Savoshchanka Anton Aleksandrovich

	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgement in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
	
--]]

local thisModule = {}

------------------------- cell
do
	thisModule.cell = {}
	thisModule.cell.polygons = {}
	thisModule.cell.polygons[1] = {
		200/2, 110,
		600/2, 110,
		600/2, 510/2,
		200/2, 510/2
	}
	thisModule.cell.polygons[1].cut = {
		result = {},
		holes = {}
	}
	
	thisModule.cell.polygons[2] = {
		200+100, 110+100,
		600+100, 110+100,
		600+100, 510,
		200+100, 510
	}
	thisModule.cell.polygons[2].cut = {
		result = {},
		holes = {}
	}	
end

-------------------------- obstacle
do
	thisModule.obstacle = {}
	thisModule.obstacle.polygons = {}
	thisModule.obstacle.polygons[1] = {
		150, 150,
		250, 150,
		250, 250,
		150, 250
	}
end

-------------------------- cut
do
	thisModule.cut = {}
	thisModule.cut.isPolygonInPolygon = require("math.itraykov.poly").polygon
	thisModule.cut.getPolygonIntersection = require("math.mlib.mlib").polygon.getPolygonIntersection
	thisModule.cut.cutHoles = require("math.itraykov.poly2").cutholes	
end

-- first run
for i, polygon in ipairs(thisModule.cell.polygons) do
	polygon.cut.result = thisModule.cut.cutHoles(polygon, polygon.cut.holes)
end	


function thisModule:update(dt)
	
	-------------------------- move obstacle
	local x, y = love.mouse.getPosition()
	thisModule.obstacle.polygons[1] = {
		x, y,
		x+50, y,
		x+50, y+50,
		x, y+50
	}
end

function thisModule:mousePressed(x, y, button)
	if button == 'l' then
		for i, polygon in ipairs(thisModule.cell.polygons) do
			if thisModule.cut.isPolygonInPolygon(polygon, thisModule.obstacle.polygons[1]) then									-- is obstacle in cell; TODO -? поменять местами аргументы для логичности
				local collisionWithHoles = false
				for i, hole in ipairs(polygon.cut.holes) do
					if thisModule.cut.getPolygonIntersection(thisModule.obstacle.polygons[1], hole) then
						collisionWithHoles = true
						break
					end
				end
				if not collisionWithHoles then
					table.insert(polygon.cut.holes, thisModule.obstacle.polygons[1])
					print('cut hole')
				end
			end
		end
		for i, polygon in ipairs(thisModule.cell.polygons) do
			polygon.cut.result = thisModule.cut.cutHoles(polygon, polygon.cut.holes)
		end			
	end	
end

function thisModule:draw()
	
	-- cell.polygons[...].cut.result
	if true then
		love.graphics.setColor(0, 255, 0, 255)
		for i, polygon in ipairs(thisModule.cell.polygons) do
			local triangles
			local ok, out = pcall(love.math.triangulate, polygon.cut.result)
			if ok then
				triangles = out
				for i, triangle in ipairs(triangles) do
					love.graphics.polygon("fill", triangle)
				end					
			else
				love.graphics.print('cant draw(triangulate) cell.polygons[...].cut.result '..i, 0, 0, 0, 1, 1)
			end
		end
	end
	if true then
		love.graphics.setLineWidth(2)
		love.graphics.setLineStyle('rough')
		love.graphics.setLineJoin('none')		
		
		love.graphics.setColor(0, 0, 255, 255)
		for i, polygon in ipairs(thisModule.cell.polygons) do
			local triangles
			local ok, out = pcall(love.math.triangulate, polygon.cut.result)
			if ok then
				triangles = out
				for i, triangle in ipairs(triangles) do
					love.graphics.polygon("line", triangle)
				end
			end
		end
		
		love.graphics.setLineStyle('smooth')
		love.graphics.setLineWidth(1)			
	end
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.polygon('fill', thisModule.obstacle.polygons[1])
	
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('#cell.polygons = '..#thisModule.cell.polygons, 0, 40, 0, 1, 1)
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.print('#cell.polygons[1].cut.holes = '..#thisModule.cell.polygons[1].cut.holes, 0, 60, 0, 1, 1)
	love.graphics.setColor(255, 255, 255, 255)
	local mx, my = love.mouse.getPosition()
	love.graphics.print('mouse position() = '..mx..', '..my, 0, 80, 0, 1, 1)
end

return thisModule