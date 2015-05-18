if posx == nil then posx = 1 end
if posy == nil then posy = 0 end

if north == nil then north = 1 end
if east == nil then east = 2 end
if south == nil then south = 3 end
if west == nil then west = 4 end

if crashcount == nil then crashcount = 0 end

if fieldx == nil then fieldx = 9 end
if fieldy == nil then fieldy = 9 end

if wait == nil then wait = 4200 end
if waitafter == nil then waitafter = true end



function refuel()
  if turtle.getFuelLevel() < 324 then
    turtle.select(16)
    turtle.refuel()
    turtle.select(1)
  end
end

if direction == nil then direction = 0 end

function turn(newdirection)
    if newdirection==direction then
        return true
    else
        while not (direction==newdirection) do
          if newdirection > direction then 
              turtle.turnLeft((newdirection - direction))
              direction = direction + 1
          else turtle.turnRight((newdirection - direction)) 
              direction = direction + 1
          end
        end
    end
end

function coord()
print("Position: "..posx.." / "..posy)
end

function iposx()
posx = posx + 1
end

function iposy()
posy = posy + 1
end

function dposx()
posx = posx - 1
end

function dposy()
posy = posy - 1
end

function mine()
    print("doing stuff here")
    turtle.select(1)
    turtle.placeDown()
    turtle.digDown()
    
    for i=14,9,-1 do
      turtle.select(i)
      turtle.placeDown()
    end
    turtle.select(1)
end

function move(dx, dy)
--coord()
  retr = nil
  if dy >= posy then
    retr = (moveDirY(posy, dy) and moveDirX(posx, dx))
  else
    retr = (moveDirX(posx, dx) and moveDirY(posy, dy))
  end
 
  --print("move() :: "..tostring(retr).." ::")
return retr  
  --coord()
end

function moveDirX(ax, dx)
    if ax==dx then return (not detect()) end
    if ax == 0 then return step(dx,0) else
        delta = dx - ax
        --print("dX: "..tostring(delta))
        return step(delta, 0)
    end
end

function moveDirY(ay, dy)
    if (ay==dy) then return (not detect())
    else
        if ay == 0 then return step(dy, 1)
          else
            delta = dy - ay
            --print("dY: "..tostring(delta))
            return step(delta, 1)
        end
    end
end

function betrag(zahl1)
    if zahl1 < 0 then return zahl1 * -1
    else return zahl1
    end
end

function step(count, axis)
    refuel()
    retr = nil
    if axis == 0 then
        if count < 0 then
            retr = moveLeft(betrag(count))
        else
            retr = moveRight(betrag(count))
        end
    else
        if count > 0 then
            retr = moveForward(betrag(count))
        else
            retr = moveBack(betrag(count))
        end
    end

--print("step() :: "..tostring(retr).." ::")
--sleep(3)
return retr    
end

function problem()
    if turtle.getFuelLevel() < (fieldx*fieldy) and turtle.getItemCount(16) == 0 then
        print("not enough fuel. Homing!")
        return true
    else
      return false
    end
end

function detect()
    if turtle.detect() then
        crashcount = crashcount + 1
        return true
    else
        return false
    end
end

function moveRight(ci)
    if problem() then return false end

    refuel()
    turtle.turnRight(1)
        for i=1, ci do
            print("Moving right. New: "..(posx+1).." / "..posy)
            if not detect() and turtle.forward() then
                iposx()
            else
              return false
            end
        end
    turtle.turnLeft(1)
    return true
end

function moveLeft(ci)
    if problem() then return false end

    refuel()
    turtle.turnLeft(1)
        for i=1, ci do
            print("Moving left. New: "..(posx-1).." / "..posy)
            if not detect() and turtle.forward() then
              dposx()
            else
              return false
         
            end
        end
    turtle.turnRight(1)
    return true
end

function moveForward(ci)
    if problem() then return false end

    refuel()
    for i=1, ci do
        print("Moving forward. New: "..posx.." / "..(posy+1))
        if not detect() and turtle.forward() then
            iposy()
        else return false
        end
    end
    return true
end

function moveBack(ci)
    if problem() then return false end

    refuel()
    turn180()
    for i=1, ci do
        print("Moving back. New: "..posx.." / "..(posy-1))
        if not detect() and turtle.forward() then
            dposy()
        else return false
        end
    end
    
    turn180()
    return true
end

function turn180()
    turtle.turnRight()
    turtle.turnRight()
end

function moveup(uct)
    for i=1, uct do
      if turtle.up() then iposz(1)
      else storystep = -1 return false end
    end
    return true
end

function movedown(dct)
    for i=1, dct do
      if turtle.down(1) then dposz(1) 
      else storystep = 1 return false end
    end
return true
end

function homing()
    print("Assuming crash. Homing...")
    turtle.select(15)
    while not turtle.compareDown() do
      if not turtle.forward(1) then
      turtle.turnLeft(1)
      
      end
      
    end
    turtle.turnLeft(1)
    turtle.forward(1)
    turtle.turnLeft(1)  
    posx=1
    posy=0
    direction = 0
    crashcount= -1
    print("Sending -true- to caller")
    return true
    
end

function unlocked()
  if turtle.getItemCount(15) > 0 then
    return true
  else
    return false
  end

end

function empty()
  turtle.turnLeft(1)
  turtle.forward(1)
  turtle.turnRight(1)
  
  turtle.select(15)
  checked = turtle.compareDown()
  if checked then
    turtle.select(16)
  
    
    for fi=14,9,-1 do
    turtle.select(fi)
      turtle.dropDown()
    end
   
    
    turtle.turnRight(1)
    turtle.forward(1)
    turtle.turnLeft(1)
    
    turtle.select(1)
    return checked
   
  else 
  
  turtle.turnRight(1)
  turtle.forward(1)
  turtle.select(1)
  turtle.turnLeft(1)
  return checked
  end
end

function restock()
  turtle.turnRight(1)
  turtle.forward(1)
  turtle.turnLeft(1)
  
  if not turtle.down(1) then return false end
  turtle.select(15)
  if turtle.compareDown() then
    turtle.select(16)
    --Loop 1k range for each lava bucket
    tkm = 4
    for g=0,(tkm-1) do
     
      turtle.select(1)
      if not turtle.suckDown() then return false end
      turtle.select(16)
      turtle.refuel()
    end
    turtle.select(16)
    turtle.refuel()
    for i=14,9,-1 do
      turtle.select(i)
      turtle.refuel()
    end
    
    turtle.up(1)
    
    turtle.turnLeft(1)
    turtle.forward(1)
    turtle.turnRight(1)
    --[[ print("Emptying? ->>"..tostring(empty())) 
    ]]--
    turtle.select(1)
    return true
  else
    turtle.up(1)
    turtle.turnLeft(1)
    turtle.forward(1)
    turtle.turnRight(1)
    empty()
    turtle.select(1)
    return false
  end
  
end

--Here goes the Z-Story Management /w CD
story = 1
stories = 8
sheight = 4
storystep = 1
posz = story * 1
zNegBoundary = 0
zPosBoundary = 31

function iposz(i)
  if (posz+i) <= zPosBoundary then
    posz = posz+i
  else
    posz = zPosBoundary
    storystep = -1
  end
end

function dposz(i)
  if (posz-i) >= zNegBoundary then
    posz = posz-i
  else
    posz = zNegBoundary
    storystep = 1
  end
end

function zChangePos(cnt,stStep)
  if stStep >= 0 then
    succ = moveup(cnt)
    print("Moveup: "..tostring(succ).." . "..tostring(cnt))
    return succ
    else
    succ = movedown(stories*sheight)
    print("Movedown: "..tostring(succ).." . "..tostring(cnt))
    return succ
    end

end

function loop1()
print("Your personal farm beast.")
print("Initializing GPS alpha 1.12")
sleep(3)
print("Empty? ->>"..tostring(empty()))

while unlocked() do

for d=1,stories do

   for i=1, fieldx do
    for j=1, fieldy do
      --if crashcount > 4 then homing() end
      if ((i==5) and (j==5)) then
        
        if not move(i,j) then return false end
        
      else
        if not move(i,j) then return false end
        mine()
      end
    end
    refuel()
  end
  
  --posx=1
  --posy=0
  move(1,0)
  if not empty() then print("chest not found") return false end
  restock()
  if not empty() then print("chest not found") return false end
  storystep = 1
  zAssert = zChangePos(sheight,storystep)
  print("zAssert: "..tostring(zAssert))
  if not zAssert then
    movedown((sheight*stories)+1)
  else
    
    iposz(sheight)
  end
end
end

end


while true do

if not waitafter then 
    print("Sleep before farming...")
else
    print("\\")
    --print("Getting shit done.")
end


if not waitafter then
    sleep(wait)
end

while(loop1()) do end
print("loop1 just got killed")
while not homing() do
 if not unlocked() then
  return false 
 end 
 
 end
print("Homing done.")
print("Restarting Harvester...")

if restock() then storystep = 1 empty() zChangePos(4,1)
else storystep = -1 crashcount = -1 move(1,0) empty() zChangePos(4,1) end

if waitafter and (crashcount >= 0) then
 print("Sleeping after...") sleep(wait)
 else print("sleep is for the poor." )
 crashcount = 0
 storystep = 1
 end

end
