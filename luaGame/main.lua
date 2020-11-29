debug = true

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

-- Player Object
player = { x = 200, y = 710, speed = 150, img = nil }
isAlive = true
score  = 0

-- Image Storage
bulletImg = nil
enemyImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated
enemies = {} -- array of current enemies on screen

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- Loading
function love.load(arg)
	player.img = love.graphics.newImage('assets/plane.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	waterImg = love.graphics.newImage('assets/water.png')
	bridge1Img = love.graphics.newImage('assets/bridge1.png')
	bridge2Img = love.graphics.newImage('assets/bridge2.png')
	bridge3Img = love.graphics.newImage('assets/bridge3.png')
	bridge4Img = love.graphics.newImage('assets/bridge4.png')

	tilemap = {
        {1, 1, 2, 3, 4, 5, 5, 1, 1, 1},
        {1, 1, 1, 1, 4, 5, 5, 1, 1, 1},
        {1, 1, 1, 1, 4, 5, 5, 1, 1, 1},
        {1, 1, 1, 1, 4, 5, 5, 1, 1, 1},
        {1, 1, 1, 1, 4, 5, 5, 1, 1, 1}
    }	
end


-- Updating
function love.update(dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	-- Time out how far apart our shots can be.
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
		canShoot = true
	end

	-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax

		-- Create an enemy
		randomNumber = math.random(10, love.graphics.getWidth() - 10)
		newEnemy = { x = randomNumber, y = -10, img = enemyImg }
		table.insert(enemies, newEnemy)
	end


	-- update the positions of bullets
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

		if bullet.y < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end

	-- update the positions of enemies
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (50 * dt)

		if enemy.y > 850 then -- remove enemies when they pass off the screen
			table.remove(enemies, i)
		end
	end

	-- run our collision detection
	-- Since there will be fewer enemies on screen than bullets we'll loop them first
	-- Also, we need to see if the enemies hit our player
	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end

		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
		and isAlive then
			table.remove(enemies, i)
			isAlive = false
		end
	end


	if love.keyboard.isDown('left','a') then
		if player.x > 0 then -- binds us to the map
			player.x = player.x - (player.speed*dt)
		end
	elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
	end

	if love.keyboard.isDown('space') and canShoot then
		-- Create some bullets
		newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	if not isAlive and love.keyboard.isDown('r') then
		-- remove all our bullets and enemies from screen
		bullets = {}
		enemies = {}

		-- reset timers
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax

		-- move player back to default position
		player.x = 50
		player.y = 710

		-- reset our game state
		score = 0
		isAlive = true
	end
end

-- Drawing
function love.draw(dt)
	
	for i,row in ipairs(tilemap) do
        for j,tile in ipairs(row) do
            --First check if the tile is not zero
            if tile ~= 0 then

                --Set the color based on the tile number
                if tile == 1 then
                    --setColor uses RGB, A is optional
                    --Red, Green, Blue, Alpha
                    --love.graphics.setColor(1, 1, 1)
					love.graphics.draw(waterImg, (j-1) * 16, (i-1) * 16)
                elseif tile == 2 then
					love.graphics.draw(bridge1Img, (j-1) * 16, (i-1) * 16)
                elseif tile == 3 then
					love.graphics.draw(bridge2Img, (j-1) * 16, (i-1) * 16)
                elseif tile == 4 then
					love.graphics.draw(bridge3Img, (j-1) * 16, (i-1) * 16)
                elseif tile == 5 then
					love.graphics.draw(bridge4Img, (j-1) * 16, (i-1) * 16)
                end

                --Draw the tile
                --love.graphics.rectangle("fill", j * 25, i * 25, 25, 25)
				--love.graphics.draw(waterImg, j * 16, i * 16)
            end 
        end
    end
	
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("SCORE: " .. tostring(score), 400, 10)

	if isAlive then
		love.graphics.draw(player.img, player.x, player.y)
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end	

	if debug then
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
	end
end
