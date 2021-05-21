local tiled = {}

function tiled.load(filename)
	local str = love.filesystem.read(filename)
	local map, pos, err = json.decode(str, 1, nil)
	for i = 1, #map.tilesets do
		local tileset = map.tilesets[i]
		tileset.surface = love.graphics.newImage("assets/" .. tileset.image)
	end
  return map
end

function tiled.get_tileset(map, id)
	local t
	for k = 1, #map.tilesets do
		local tileset = map.tilesets[k]
		if (id >= tileset.firstgid) then
			t = tileset
		end
	end
	return t
end

function tiled.draw_layer(layer, map)
	local data = layer.data
	for j = 1, #data do
		local id = data[j]
		if (id > 0) then
			local y = math.floor((j-1) / layer.width) * map.tileheight
			local x = ((j-1) % layer.width) * map.tilewidth
			if (
				x >= map.viewport.x and x <= (map.viewport.x + map.viewport.width + 32) and
				y >= map.viewport.y and y <= (map.viewport.y + map.viewport.height + 32)
			) then
				local t = tiled.get_tileset(map, id)
				local tw = map.tilewidth
				local th = map.tileheight
				local sw = t.surface:getWidth()
				local sh = t.surface:getHeight()
				local tid = id - t.firstgid+1
				local q = love.graphics.newQuad(
					((tid-1)%(sw/tw))*tw,
					math.floor((tid-1)/(sw/tw))*tw,
					tw, th,
					sw, sh
				)
				love.graphics.draw(t.surface, q, x, y)
			end
		end
	end
end

function tiled.draw(map)
	for i = 1, #map.layers do
		local layer = map.layers[i]
		if (layer.type == "tilelayer") then
			tiled.draw_layer(layer, map)
		elseif (layer.type == "objectgroup") then
			for _,object in pairs(layer.objects) do
				if object.draw then
					object.draw(object, map)
				end
			end
		end
	end
end

function tiled.load_objectgroup(layer, callback)
	for i = 1, #layer.objects do
		local object = layer.objects[i]
		callback(object)
	end
end

function tiled.load_objects(map, callback)
	for i = 1, #map.layers do
		local layer = map.layers[i]
		if (layer.type == "objectgroup") then
			tiled.load_objectgroup(layer, callback)
		end
	end
end

return tiled