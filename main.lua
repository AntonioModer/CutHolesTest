function love.load()
	require("cutHolesTest")
end

function love.mousepressed(x, y, button)
	require("cutHolesTest"):mousePressed(x, y, button)
end

function love.update(dt)
	require("cutHolesTest"):update(dt)
end

function love.draw()
	require("cutHolesTest"):draw()
end