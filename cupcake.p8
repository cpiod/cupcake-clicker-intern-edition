pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- cupcake clicker (intern edition)
-- cpiod for gmtk game jam 2023

-- modes:
-- 0: alarm clock
-- 1: title screen
-- 10: color
-- 11: menu
-- 12: search
-- 13: machine
-- 99: game over

-- ingr: name,sprx,spry,w,h
-- model: nb,coeff

function _init()
 camera_x=0
 camera_y=0
 camera_ox=0
 day=1
 tuto=1
 search_day=2
 round_duration=30*60
 left=round_duration
 ingr={}
 nb_machines=0
 search=0
 models={}
 can_search=true
 rewards={12,12,30}
 -- more stock: id=20
 -- new machine: id=30
 -- id=40-49: ingredient plus rapide
 add(models,{id=11,name="valentine",nb=4,coeff=1})
 add(ingr,{id=1,name="strawberry",sprx=0,spry=0,w=10,h=10,spd=1})
 add(ingr,{id=2,name="blueberries",sprx=0,spry=16,w=13,h=13,spd=1})
 current_quality=0
 target=5
 current=0
 stock=0
 radio_state=0
 selected_model=1
	change_mode(0)
	poke(0x5f2d,3) -- enable mouse
	poke(0x5f5c,-1) -- no btnp autorepeat
	modified_machine=0
 current_machine=0
--	typ2spr={[0]=0}
--	typ2col={[0]=8}
	selected_ingr=1
	selected_model=1
	draw_zone_x=7
	draw_zone_y=12
	draw_zone_width=10+8*8
	draw_zone_height=10+4*8
 m=add_machine()
	-- test
-- m=add_machine()
-- m=add_machine()
-- m=add_machine()
-- m=add_machine()
-- m+="broken"
-- add(models,{id=12,name="special blue",nb=68,coeff=9})
end

-- font
poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,24,24,24,0,24,0,0,54,54,18,0,0,0,0,0,54,127,54,127,54,0,0,24,124,30,60,120,62,24,0,6,102,48,24,12,102,96,0,28,54,54,28,110,54,108,0,24,24,8,0,0,0,0,0,24,12,6,6,6,12,24,0,24,48,96,96,96,48,24,0,24,126,60,24,60,126,24,0,0,24,24,126,24,24,0,0,0,0,0,0,0,12,12,6,0,0,0,126,0,0,0,0,0,0,0,0,0,0,12,0,0,96,48,24,12,6,0,0,0,0,60,118,110,102,60,0,0,0,24,28,24,24,60,0,0,0,62,96,60,6,126,0,0,0,62,96,56,96,62,0,0,0,56,60,54,126,48,0,0,0,126,6,62,96,62,0,0,0,60,6,62,102,60,0,0,0,126,96,48,24,12,0,0,0,60,102,60,102,60,0,0,0,60,102,124,96,60,0,0,0,0,12,0,12,0,0,0,0,0,12,0,12,12,6,48,24,12,6,12,24,48,0,0,0,0,126,0,0,0,0,12,24,48,96,48,24,12,0,0,60,102,48,24,0,24,0,0,60,102,118,110,118,60,0,0,0,60,102,126,102,102,0,0,0,62,102,62,102,62,0,0,0,60,102,6,102,60,0,0,0,62,102,102,102,62,0,0,0,126,6,30,6,126,0,0,0,126,6,30,6,6,0,0,0,124,6,118,102,124,0,0,0,102,102,126,102,102,0,0,0,60,24,24,24,60,0,0,0,96,96,96,102,60,0,0,0,102,54,30,54,102,0,0,0,6,6,6,6,126,0,0,0,66,102,126,126,102,0,0,0,102,110,126,118,102,0,0,0,60,102,102,102,60,0,0,0,62,102,62,6,6,0,0,0,60,102,102,54,108,0,0,0,62,102,126,54,102,0,0,0,124,6,60,96,62,0,0,0,126,24,24,24,24,0,0,0,102,102,102,102,60,0,0,0,102,102,102,60,24,0,0,0,102,126,126,102,66,0,0,0,102,60,24,60,102,0,0,0,102,102,60,24,24,0,0,0,126,48,24,12,126,0,62,6,6,6,6,6,62,0,0,6,12,24,48,96,0,0,62,48,48,48,48,48,62,0,24,60,102,0,0,0,0,0,0,0,0,0,0,0,0,126,12,24,48,0,0,0,0,0,0,60,102,102,126,102,102,0,0,62,102,62,102,102,62,0,0,60,102,6,6,102,60,0,0,62,102,102,102,102,62,0,0,126,6,30,6,6,126,0,0,126,6,30,6,6,6,0,0,124,6,118,102,102,124,0,0,102,102,126,102,102,102,0,0,60,24,24,24,24,60,0,0,96,96,96,96,102,60,0,0,102,54,30,54,102,102,0,0,6,6,6,6,6,126,0,0,66,102,126,126,102,102,0,0,102,110,126,118,102,102,0,0,60,102,102,102,102,60,0,0,62,102,102,62,6,6,0,0,60,102,102,102,54,108,0,0,62,102,102,62,54,102,0,0,124,6,60,96,96,62,0,0,126,24,24,24,24,24,0,0,102,102,102,102,102,60,0,0,102,102,102,102,60,24,0,0,102,102,126,126,102,66,0,0,102,60,24,60,102,102,0,0,102,102,60,24,24,24,0,0,126,48,24,12,6,126,0,56,12,12,6,12,12,56,0,24,24,24,24,24,24,24,24,14,24,24,48,24,24,14,0,44,26,0,0,0,0,0,0,0,28,54,28,0,0,0,0,255,255,255,255,255,255,255,255,85,170,85,170,85,170,85,170,0,195,255,189,189,255,126,0,60,126,255,129,195,231,126,60,17,68,17,68,17,68,17,0,4,12,252,124,62,63,48,32,60,110,223,255,255,255,126,60,102,255,255,255,126,60,24,0,24,60,102,231,102,60,24,0,24,24,0,60,90,24,60,102,60,126,255,126,82,82,94,0,60,110,231,227,227,231,110,60,0,255,153,153,255,129,255,0,56,120,216,24,30,31,14,0,0,126,195,219,219,195,126,0,8,28,62,127,62,28,8,0,0,0,0,0,85,0,0,0,60,118,231,199,199,231,118,60,0,8,28,127,62,28,54,0,127,34,20,8,8,20,42,127,60,126,231,195,129,255,126,60,0,5,82,32,0,0,0,0,0,17,42,68,0,0,0,0,0,126,219,231,231,219,126,0,255,0,255,0,255,0,255,0,85,85,85,85,85,85,85,85,255,129,129,129,129,129,129,255,255,195,165,153,153,165,195,255,0,126,62,30,62,118,34,0,8,28,62,127,127,62,8,62,8,28,28,107,127,107,8,28,28,34,73,93,73,34,28,0"))

-- version with asserts (238 tokens)

-- renaming and world
cmp,has,_ents=pack,rawget,{}

function ent()
 -- find the value in components
 function _find(self,a)
 	 for _,t in pairs(self) do
	   if(t[a]!=nil) return t
	  end
	  assert(false,"field not found:"..a)
 end
 
 -- you can remove this function
 -- if you delete the asserts
 function check_no_duplicates(self)
  for k1,t1 in pairs(self) do
   for k2,t2 in pairs(self) do
    if k1<k2 then
	    for f1,_ in pairs(t1) do
	     for f2,_ in pairs(t2) do
	      assert(f1!=f2,"duplicated field "..f1.." in "..k1.." and in "..k2)
	     end
	    end
    end
   end
  end
 end
 
 return add(_ents,
  setmetatable({},{
  -- check value in components
  -- components cannot be accessed directly
  __index=function(self,a)
   return _find(self,a)[a]
  end,
  __newindex=function(self,a,v)
   _find(self,a)[a]=v
  end,
  __add=function(self,cmp)
   -- two cases: string or table
   if type(cmp)=="string" then
--    assert(rawget(self,cmp)==nil,"already existing: "..cmp)
    rawset(self,cmp,{})
   else
    -- check if already existing
    local cn=cmp[1]
--    assert(rawget(self,cn)==nil,"already existing: "..cn)
    rawset(self,cn,cmp[2])
    check_no_duplicates(self)
   end
   return self
  end,
  __sub=function(self,cn)
   -- double removal is not a problem
   return rawset(self,cn,nil)
  end}))
end

function sys(cmps,f)
 return function(...)
  for e in all(_ents) do
   for cn in all(cmps) do
    if(not has(e,cn)) goto _
   end
   f(e,...)
   ::_::
  end
 end
end

-- machine: nb
-- running
-- broken
-- recipe: ingr quality time rem coeff
-->8
-- draw

function _draw()
 mouse_already_drawn=false
 if camera_x<camera_ox then
  camera_x+=4
 elseif camera_x>camera_ox then
  camera_x-=4
 end
 camera(camera_x,camera_y)
 if mode==0 then
  draw_phone() 
 elseif mode==1 then
  draw_title_screen_base()
  draw_title_screen_ui()
 elseif mode==10 then
  draw_color()
  if(tuto==3) draw_tuto()
 elseif mode>=11 and mode<90 then
		palt(14,true)
  draw_menu()
  draw_search()
  draw_kitchen()
  if tuto==1 then
   draw_tuto()
  elseif camera_ox==128 and tuto==2 then
   draw_tuto()
  end
 elseif mode==99 then
  draw_game_over()
 end
 if mode>=10 and mode<90 then
  local l=ceil(left/60*10)
  local t=(l/10).."S"
  if l%10==0 then
   t=(l/10)..".0S"
  end
  palt(14,true)
  palt(0,false)
  spr(199,2+camera_x,1)
  palt()
  nice_print(t,10+camera_x,0,9)
  local t="$"..min(target,current\1).."/"..target
  nice_print(t,126+camera_x-8*#t,0,current>=target and 11 or 8)
 end
 draw_mouse()
 
-- ?mode,110,110
end

function nice_print(t,x,y,c,big,c2)
 if(big==nil) big=true
 if big then
  x=x or 64-#t*4
  t="\014"..t
 else
  x=x or 64-#t*2
 end
 for dx=-1,1 do
  for dy=-1,1 do
   if dx==0 or dy==0 then
	   ?t,x+dx,y+dy,c2 or 0
   end
  end
 end
 ?t,x,y,c or 7
end

function draw_kitchen()
 palt(14,true)
 palt(0,false)
 if camera_x>0 then
  draw_one_kitchen(current_machine)
  if camera_x<camera_ox then
   draw_one_kitchen(current_machine-1)
  elseif camera_x>camera_ox then
   draw_one_kitchen(current_machine+1)
  end
 end
 palt()
end

function draw_one_kitchen(nb_m)
 if nb_m>0 then
  sspr(0,72,24,32,47+128*nb_m,15,24*3,32*3)
  for e in all(_ents) do
   if has(e,"machine") then
    if e.nb==nb_m then
     local x=0
     if(has(e,"running")) x=16
     sspr(x,104,16,24,12+128*nb_m,50,16*3,24*3)
     if has(e,"running") then
      nice_print(get_yield(e).."$/s",12+128*nb_m,60,12)
--     else
--      nice_print("click on\nthe oven\nto use it",55+128*nb_m,80,12)     
     end
     break
    end
   end
  end
  spr(200,128*nb_m+5+3*abs(cos(t())),98,1,2)
  if nb_m<nb_machines then
   spr(200,128*nb_m+115-3*abs(cos(t())),98,1,2,true)
  end
 end
end

function draw_game_over()
 draw_title_screen_base()
 nice_print("you failed to",nil,70,9)
 nice_print("meet the",nil,79,9)
 nice_print("expectations",nil,88,9)
 nice_print("game over",nil,110,8)
end

function draw_menu()
 for x=0,100 do
  for y=0,7 do
   spr(229,16*x,16*y,2,2)
  end
 end
 palt(0,false)
 palt(14,true)
 nice_print("sEARCH",2,110,9)
 spr(200,5+3*abs(cos(t())),98,1,2)
 nice_print("kITCHEN",70,110,9)
 spr(200,115-3*abs(cos(t())),98,1,2,true)
 palt()
 local l=ceil(left/60*10)
 local text=(l/10).."S"
 if l%10==0 then
  text=(l/10)..".0S"
 end
 nice_print("player stats",10,30)
 nice_print("gOAL:$"..target,10,50,7)
 nice_print("cURRENT:$"..min(target,current\1),10,60,7)

 if current>target then
  nice_print("fRIDGE: $"..(current\1-target),10,40,7)
 end 
-- nice_print("tIME:"..text,10,20,9)

 if current>=target then
  nice_print("target reached!",nil,80,10)
-- elseif t()%1<.8 then
--  nice_print("need cupcakes!",nil,80,8) 
 end
-- local y=50
-- for e in all(_ents) do
--  if has(e,"machine") then
--   if has(e,"running") then
--    ?"machine is running "..(ceil(100*60*e.quality/e.time)/100).."$/s",20,y
--   else
--    ?"machine has no recipe",20,y
--   end
--   y+=10
--  end
-- end
end

function draw_color()
	-- drops
--	for d in all(drops) do
--	 pal(14,typ2col[d.typ])
--	 spr(typ2spr[d.typ],d.x,d.y)
--	end
 cls(6)
 palt(0,false)
 palt(14,true)
	-- model
 rect(2+camera_x,84,65+camera_x,126,5)
	spr(current_base,17+camera_x,93,4,2)
	spr(36,17+camera_x,93+16,4,2)
	local text=models[selected_model].name.." "..models[selected_model].coeff.."$"
	nice_print(text,camera_x+33-#text*2,87,10,false)
	if #models>1 then
  spr(200,7-3*abs(cos(t()))+camera_x,105,1,2)
  spr(200,53+3*abs(cos(t()))+camera_x,105,1,2,true)
 end
	-- drawing
 rect(2+camera_x,9,90+camera_x,82,5)
	spr(8,draw_zone_x+5+camera_x,draw_zone_y+5,8,4)
	sspr(32,16,32,16,draw_zone_x+5+camera_x,draw_zone_y+5+8*4,64,32)
	palt(0,true)
	-- ingredients
	rect(92+camera_x,9,125+camera_x,82)
 for k,i in ipairs(ingr) do
  sspr(i.sprx,i.spry,i.w,i.h,109+camera_x-i.w/2,18*k-4)
 end
	-- mouse
	if selected_ingr==nil or not in_draw_zone then
  -- pass
	else
		fillp(░+0b.01) -- to sprite too
		local i=ingr[selected_ingr]
  sspr(i.sprx,i.spry,i.w,i.h,mouse_x-i.w\2+camera_x,mouse_y-i.h\2)
 	fillp()
 	pal()
 	mouse_already_drawn=true
 end
 palt(0,false)
 palt(14,true)
 rect(67+camera_x,84,125+camera_x,126)
 nice_print("oven yield",77+camera_x,87,7,false)
-- if previous_recipe then
--	 nice_print(get_yield(previous_recipe).."$/s",77+camera_x,97,7,false)
-- end
 nice_print(" (paused)",77+camera_x,95,7,false)
 spr(215,7+camera_x,71)
 nice_print("back",1+camera_x,122,8,false)
 if current_recipe.quality>0 then
  rectfill(70+camera_x,66,88+camera_x,80,9)
	 nice_print("bake\n"..get_manual().."$",72+camera_x,68,8,false)
	 nice_print("quality "..ceil(current_recipe.quality*100).."%",camera_x+5,12,7,false)
	 local text=current_recipe.time.." steps"
	 nice_print(text,camera_x+89-4*#text,12,7,false)
	 nice_print("new:"..get_yield(current_recipe).."$/s",70+camera_x,105,7,false)
	 rectfill(80+camera_x,115,110+camera_x,123,9)
	 local text=previous_recipe and "replace" or " save! "
	 nice_print(text,82+camera_x,117,8,false)
 end
 palt()
end

function draw_search()
 pal()
 rectfill(-128,0,0,128,0x5)
 nice_print("storage",64-4*7-128,10,4)
 rectfill(-110,20,-20,128,4)
 fillp(░\1)
 rectfill(-105,25,-25,128,0x01)
 fillp()
 x_sliding=-105
 local wait=day<search_day or not can_search
 if t12 and day>=search_day and can_search then
  x_sliding=-105+50*(t()-.8-t12)
  if x_sliding<-105 then
   wait=true
  end
  x_sliding=max(-105,x_sliding)
 end
 if not wait then
  clip(-105+128,25,81,110)
 end
 if x_sliding<=-25 then
  rectfill(x_sliding,25,-25,128,13)
--  ?"slide to open",x+5,50,6
  if mode==12 then
   ?"use a flashlight!",x_sliding+5,50,6
   ?"finders keepers",x_sliding+5,58,6   
   if day<search_day then
    ?"closed today",x_sliding+5,66,5
   elseif not can_search then
    ?"one search a day",x_sliding+5,66,5
   end
  end
  circfill(x_sliding+5,90,3,6)
 end
 clip()

 palt(0,false)
 palt(14,true)
 spr(200,-13-3*abs(cos(t())),98,1,2,true)
 palt()
 
 if search_found then
  spr(217,goal_x,goal_y)
	 if flash==nil then
	  assert(false)
	 elseif type(flash)=="string" then
	  nice_print("you find a",64-128-4*10,50,10)
	  nice_print(flash,64-128-4*#flash,60,9)
	 elseif flash<10 then
	  for i in all(ingr) do
	   if i.id==flash then
	    nice_print("new ingredient!",64-128-4*15,50,10)
	    nice_print(i.name,64-128-4*#i.name,60,9)
     sspr(i.sprx,i.spry,i.w,i.h,64-i.w-128,80,2*i.w,2*i.h)
	    break
	   end
	  end
	 elseif flash<20 then
	  for m in all(models) do
	   if m.id==flash then
	    local t="new $"..m.coeff.." flavor!"
	    nice_print(t,64-128-4*#t,50,10)
	    nice_print(m.name,64-128-4*#m.name,60,9)
	    palt(14,true)
	    palt(0,false)
  			spr(m.nb,-128+64-16,80,4,2)
	    spr(36,-128+64-16,80+16,4,2)
	    palt()
	    break
	   end
	  end
  elseif flash<50 then
	  for i in all(ingr) do
	   if i.id+40==flash then
	    nice_print(i.name,64-128-4*#i.name,50,10)
	    nice_print("processed faster",64-128-4*16,60,9)
     sspr(i.sprx,i.spry,i.w,i.h,64-i.w-128,80,2*i.w,2*i.h)
	    break
	   end
	  end
	 end 
	end
end

function draw_mouse()
 if not mouse_already_drawn then
	 if mode==12 and day>=search_day and mouse_x+camera_x>=-105 and mouse_x+camera_x<-105+81 and mouse_y>25 then
		 fillp(◆)
		 circfill(mouse_x+camera_x,mouse_y,3,9)
		 fillp()
		else
	 	spr(2,mouse_x+camera_x,mouse_y)
	 end
 end
end
-->8
-- update

function change_mode(new_mode)
 printh("new mode:"..new_mode)
 -- exit
 if mode==10 then
  current_recipe=nil
  for e in all(_ents) do
   if has(e,"machine") and has(e,"recipe") and e.nb==current_machine then
    e+="running"
    break
   end
  end
 elseif mode==12 then
  can_search=false
  search_found=false
 elseif mode==0 or mode==1 then
  left=round_duration
 end
 
 -- enter
 if new_mode==11 then
  camera_ox=max(0,camera_ox)
 elseif new_mode==10 then
  for e in all(_ents) do
   if has(e,"machine") and e.nb==current_machine then
    e-="running"
    previous_recipe=has(e,"recipe")
    break
   end
  end
	 current_base=models[selected_model].nb
  setbase()
  current_recipe={ingr={},quality=0}
 elseif new_mode==0 then
  t0=t()
  camera_ox=0
  camera_x=0
  can_search=true
 elseif new_mode==99 then
  camera_ox=0
  camera_x=0
 elseif new_mode==12 then
  camera_ox=-128
  t12=t()
  goal_x=ceil(-107+rnd(76))
  goal_y=ceil(27+rnd(99))
  search_found=false
 end
 mode=new_mode
end

function _update60()
 if left==0 then
  left=-1
  if current<target then
   change_mode(99)
  else
   day+=1
   current-=target
   target=5*day*day
   change_mode(0)
  end
 end
	mouse_x=stat(32)-1
	mouse_y=stat(33)-1
	lclick=btnp(5)
	rclick=btnp(4)
	if(lclick and tuto==1 and mode==11) tuto=2 return
	if(lclick and tuto==2 and camera_ox==128) tuto=3 return
	if(lclick and mode==10 and tuto==3) tuto=nil return
	if tuto==nil and mode>=10 and mode<20 and not search_found then
	 produce()
	 left-=1
	end
	if mode==0 then
  if t()-t0>3 and lclick then
   if day==1 then
    change_mode(1)
   else
    -- directly to intern access from day 2
    change_mode(11)
   end
 	end
 elseif mode==1 then
  update_title_screen(lclick)
 elseif mode==10 then
  update_color(lclick)
  if(rclick) change_mode(13)
 elseif mode==12 then
  update_search()
  if (lclick and mouse_x+camera_x>-20 and mouse_x+camera_x<-1 and mouse_y>96 and mouse_y<120) or btnp(➡️) then
    change_mode(11)
  end
 elseif mode==11 then
  if (lclick and mouse_x>1 and mouse_x<50 and mouse_y>96 and mouse_y<120) or btnp(⬅️) then
   change_mode(12)
  elseif (lclick and mouse_x<127 and mouse_x>83 and mouse_y>96 and mouse_y<120) or btnp(➡️) then
   change_mode(13)
   camera_ox=128
   current_machine=1
  end
 elseif mode==13 then
  if camera_ox==camera_x then 
   if lclick and mouse_x>10 and mouse_x<50 and mouse_y>60 then
    change_mode(10)
   elseif (lclick and mouse_x>1 and mouse_x<50 and mouse_y>96 and mouse_y<120) or btnp(⬅️) then
    current_machine-=1
    camera_ox-=128
    if current_machine==0 then
     change_mode(11)
    end
   elseif (lclick and mouse_x<127 and mouse_x>83 and mouse_y>96 and mouse_y<120) or btnp(➡️) then
    if current_machine<nb_machines then
     camera_ox+=128
     current_machine+=1
    end
   end
  end
 end
end
-->8
-- production

function add_machine()
 nb_machines+=1
	machine=ent()
	machine+=cmp("machine",{nb=nb_machines})
	return machine
end

function update_all_compute_time()
 for e in all(_ents) do
  if has(e,"recipe") then
   e.time=compute_time(e.ingr)
  end
 end
end

function compute_time(i)
 local out=0
 for k,v in pairs(i) do
  out+=v*ingr[k].spd
	end
	return out
end

function create_cupcakes(nb)
 current+=nb
	if(current>target+stock) current=target+stock
end

produce=sys({"machine","running","recipe"},
 function (e)
  if e.rem==0 then
	  e.rem=compute_time(e.ingr)
	  create_cupcakes(e.quality*e.coeff)
	 else
	  e.rem-=1
	 end
 end)
-->8
-- coloring
function get_manual()
 return flr(current_recipe.quality*20)
end

function mix(c1,c2)
 if(c1==c2) return c1
 if(c1==7) return c2
 if(c2==7) return c1
 if(c1==4 or c2==4) return 4
 if(c1>c2) c1,c2=c2,c1
 if c1==2 then
  local t={[3]=4,[8]=2,[9]=4,[10]=4,[12]=2}
  return t[c2] 
 elseif c1==3 then
  local t={[10]=3,[9]=4,[8]=4,[12]=3}
  return t[c2] 
 elseif c1==8 then
  local t={[10]=9,[12]=2,[9]=9}
  return t[c2]
 elseif c1==9 then
  local t={[10]=9,[12]=4}
  return t[c2] 
 elseif c1==10 then
  local t={[12]=3}
  return t[c2] 
 else
  assert(false)
 end
end

function update_color(lclick)
 -- also used in draw
	in_draw_zone=mouse_x>=draw_zone_x
 	and mouse_y>=draw_zone_y
 	and mouse_x<draw_zone_x+draw_zone_width
 	and mouse_y<draw_zone_y+draw_zone_height

	if lclick then
	 for k,i in ipairs(ingr) do
	  if mouse_x>=107-i.w/2 and mouse_x<111+i.w/2
 	  and mouse_y>=18*k-6 and mouse_y<18*k-2+i.h then
	   selected_ingr=k
	   break
	  end
  end
  
  if mouse_x>=1 and mouse_x<=18 and mouse_y>=122 then
   change_mode(13)
   return
  elseif mouse_x>=7 and mouse_x<=15 and mouse_y>=71 and mouse_y<79 then
   change_mode(10)
   return
  end
 end

	if lclick and in_draw_zone then
		local i=ingr[selected_ingr]
	 applydrop(mouse_x-i.w\2-draw_zone_x-5,mouse_y-i.h\2-draw_zone_y-5,i)
	elseif lclick and mouse_x>=70 and mouse_x<88 and mouse_y>=66 and mouse_y<80 then
	 -- bake
	 create_cupcakes(get_manual())
		change_mode(10) -- reset recipe
 elseif lclick and mouse_x>=80 and mouse_x<110 and mouse_y>=115 and mouse_y<123 then
	  -- save
  for e in all(_ents) do
   if has(e,"machine") and e.nb==current_machine then
 	  m=_ents[current_machine]
 	  m-="recipe"
   	m+="running"
   	current_recipe.rem=current_recipe.time
 	  m+=cmp("recipe",current_recipe)
    break
	  end
  end
  change_mode(13)
 elseif #models>1 then
	 if (lclick and mouse_x>=3 and mouse_x<13 and mouse_y>=105 and mouse_y<=115) or btnp(⬅️) then
	  selected_model+=1
	  if selected_model>#models then
	   selected_model=1
	  end
	 elseif (lclick and mouse_x>=53 and mouse_x<63 and mouse_y>=105 and mouse_y<=115) or btnp(➡️) then
	  selected_model-=1
	  if selected_model==0 then
	   selected_model=#models
	  end
	 end
	 local old=current_base
	 current_base=models[selected_model].nb
	 if current_base!=old then
 	 setbase()
 	 update_recipe()
 	end
 end
end

function pgetspr(x,y)
 if x&1==0 then
  return @(x\2+(y<<6))&15
 else
  return @(x\2+(y<<6))\16
 end
end

function psetspr(x,y,c)
 if x>=0 and x<128 and y>=0 and y<32 then
	 if x&1==0 then
	  poke(x\2+(y<<6),
	   c+(@(x\2+(y<<6))&240))
	 else
	  poke(x\2+(y<<6),
	   (c<<4)+(@(x\2+(y<<6))&15))
	 end
 end
end

function setbase()
 local base_x=(current_base&15)<<3
 local base_y=(current_base\16)<<3
 for dx=0,63 do
  for dy=0,31 do
   local c=pgetspr(base_x+dx\2,base_y+dy\2)
   if c==6 or c==5 or c==0 or c==14 or c==13 then
    psetspr(64+dx,dy,c)
   else
    psetspr(64+dx,dy,7)
   end
  end
 end
end

function applydrop(x,y,d)
 for dy=0,d.h-1 do
  for dx=0,d.w-1 do
   local cbase=pgetspr(64+x+dx,y+dy) or 0
   local cdrop=pgetspr(d.sprx+dx,d.spry+dy) or 0
   if cbase!=0 and cbase!=14 and cbase!=6 and cbase!=5 and cdrop!=0 and cbase!=13 then
    psetspr(64+x+dx,y+dy,mix(cbase,cdrop))
   end
  end
 end
 
	local i=current_recipe.ingr
 if i[selected_ingr] then
  i[selected_ingr]+=1
 else
  i[selected_ingr]=1
 end
 update_recipe()
end

function update_recipe()
 local ok=0
 local total=0
 local base_x=(current_base&15)<<3
 local base_y=(current_base\16)<<3
 for dx=0,63 do
  for dy=0,31 do
   local cbase=pgetspr(base_x+dx\2,base_y+dy\2)
   local cdraw=pgetspr(64+dx,dy)
   if cbase!=0 and cbase!=6 and cbase!=5 and cbase!=14 and cbase!=13 then
    total+=1
    if(cbase==cdraw) ok+=1
   end
  end
 end
-- printh("ok:"..ok.." total:"..total)
 local q=ok/total
 current_recipe.coeff=models[selected_model].coeff
 current_recipe.quality=q*q
 current_recipe.time=compute_time(current_recipe.ingr)
end

function get_yield(recipe)
 return ceil(recipe.coeff*100/recipe.time*60*recipe.quality)/100
end
-->8
-- search

function update_search()
 local dx=mouse_x+camera_x-goal_x
 local dy=mouse_y-goal_y
 if mouse_x+camera_x<x_sliding and dx*dx+dy*dy<14 and not search_found then
  search_found=true
  id=rnd(rewards)
  flash=id -- by default
--  printh("reward:"..id)
  if id!=20 and id!=30 then
   while del(rewards,id)!=nil do end
  end
  if id==2 then
   add(ingr,{id=2,name="blueberries",sprx=0,spry=16,w=13,h=13,spd=1})
   add(rewards,12)
   add(rewards,12)
  elseif id==12 then
   add(models,{id=12,name="special blue",nb=68,coeff=9})
   add(rewards,3)
   add(rewards,3)
  elseif id==3 then
   add(ingr,{id=3,name="moon",sprx=16,spry=8,w=14,h=13,spd=3})
   add(rewards,13)
   add(rewards,13)
   add(rewards,41)
   add(rewards,42)
   add(rewards,43)
  elseif id==13 then
   add(models,{id=13,name="desert dessert",nb=72,coeff=3})
  elseif id==20 then
   stock+=target/2
   flash="bigger fridge!"
  elseif id==30 then
   add_machine()
   flash="cupcake oven!"
  elseif id<50 then
   for i in all(ingr) do
    if i.id==(id-40) then
     i.spd*=0.8
     update_all_compute_time()
     break
    end
   end
  end
	end
end
-->8
-- phone+title

function draw_phone()
 cls(0)
 -- ui
 local x,y=0,0
 if day<2 then 
  x,y=72,120
 elseif day<3 then
  x,y=72,124
 elseif day<5 then
  x,y=80,120
 else
  x,y=80,124
 end
 sspr(x,y,8,4,120,2)
 if(rnd()<0.02) radio_state=1-radio_state
 if radio_state==0 then
  sspr(88,120,7,5,111,1)
 else
  sspr(88,125,7,3,111,3)
 end

 -- time
 if t()%2<1.5 then
  rectfill(57,28,59,30,1)
  rectfill(57,34,59,36,1)
 end
 spr(222,40,20,2,3)
 spr(220,60,20,2,3)
 spr(220,75,20,2,3)
 nice_print((7+day).." jULY 2023",nil,45,1,true)
 
 -- alarm
 if t()-t0<1 then
  spr(218,64-8+10*cos(2*t()),70,2,2)
 else
	 local notifs={}
	 if day==1 then
	  add(notifs,pack("'grats for the internship!",7,8))
	  add(notifs,pack("re:gmtk game jam w/ cpiod",6,10))
	  add(notifs,pack("news:crypto falling again",6,10))
	 elseif day==2 then
	  add(notifs,pack("cupcake malicieux:+86%!",6,10))
	  add(notifs,pack("are you addicted to phones?",6,10))
	  add(notifs,pack("[spam] enhance your life",6,10))
	 elseif day==3 then
	  add(notifs,pack("re:re:please answer",6,10))
	  add(notifs,pack("news:cupcake's alleged hack",6,10))
	  add(notifs,pack("players cannot connect",7,8))
   target=0
	 elseif day==4 then
	  add(notifs,pack("cupcake malicieux in court",6,10))
	  add(notifs,pack("news:massive strike",6,10))
	  add(notifs,pack("hr:report suspicious behavior",7,8))	  
	 elseif day==4 then
	  add(notifs,pack("cupcake malicieux in court",6,10))
	  add(notifs,pack("news:massive strike",6,10))
	  add(notifs,pack("hr:report suspicious behavior",7,8))	  
	 elseif day==5 then
	  add(notifs,pack("news:crypto on the rise",6,10))
	  add(notifs,pack("re:career advice",6,10))
	 elseif day==6 then
	  add(notifs,pack("your packages arrived",6,10))
	  add(notifs,pack("re:cupcake malicieux hq",6,10))
	 end
	 if #notifs==0 then
	  add(notifs,pack("you have (0) notifications",6,10))
	 end
	 y=60
	 for n in all(notifs) do
	  local text,c,c2=unpack(n)
	  local x=min(10,300*(t()-t0-1)-10*y+500)
	  rect(x-2,y-2,x+#text*4,y+6,c)
	  if x==10 then
	   ?"◆",1,y,c2
	  end
	  nice_print(text,x,y,c,false)
	  y+=10
	 end
 end
 if t()-t0>3 then
  if (2*t())%2<1.5 then
   nice_print("click to unlock",nil,100,13)
  end
		spr(2,mouse_x,mouse_y)
 end
end

function draw_title_screen_base()
 cls(9)
 for x=0,17 do
  for y=0,17 do
   if (x+y)&1==0 then
    local t0=t()
    local sx=x*8+10*t0
    local sy=y*8-10*t0
    sx%=144
    sy%=144
    spr(233,sx-16,sy-16,1,1,(t0+x/2)%1<.5)
   end
  end
 end
 title={{s=101,w=11,h=4,x=10,y=15,c=9,f=false},
 {s=150,w=10,h=3,x=45,y=39,c=10,f=true}}
 for s in all(title) do
  palt(10,true)
  palt(9,true)
  palt(s.c,false)
	 pal(10,4)
	 pal(9,4)
	 for dx=-1,1 do
	  for dy=-1,1 do
	   if dx==0 or dy==0 then
	    spr(s.s,s.x+dx,s.y+dy,s.w,s.h,s.f)
	   end
	  end
	 end
  pal(10,10)
  pal(9,10)
  spr(s.s,s.x,s.y,s.w,s.h,s.f)
 end
 pal()
end

function draw_title_screen_ui()
 rectfill(64-4*6,78,64+4*6-2,90,14)
 circfill(64-4*6,84,5)
 circfill(64+4*6-2,84,5)
 nice_print("sTART!",nil,80,10)
 nice_print("INTERN ACCESS",75,113,10,false,9)
 nice_print("(c) cupcake malicieux 2002-2023",2,121,10,false,4)
 if t1 and t()<t1 then
  nice_print("sTART!",nil,80,5)
  rectfill(64-30,83,64+28,84,0)
  nice_print("an intern",nil,50,8)
  nice_print("must work,",nil,59,8)
  nice_print("not play!!",nil,68,8)
  nice_print("use intern access",nil,91,8,false)
  palt(0,false)
  palt(14,true)
  spr(231,60,98,2,2)
  palt()
 end
	spr(3,mouse_x,mouse_y)
end

function update_title_screen(lclick)
 if lclick then
	 if mouse_x>=64-20 and mouse_x<64+20 and mouse_y>78 and mouse_y<90 then
	  t1=t()+3
	 end
	 if mouse_x>=70 and mouse_x<124 and mouse_y>110 and mouse_y<120 then
	  change_mode(11)
	 end
	end
end
-->8
-- tuto

function draw_tuto()
 msgs={}
 if tuto==1 then
  msgs={"wELCOME TO","THE cUPCAKE","cLICKER STAFF","","yOU HAVE BEEN","ASSIGNED A","PLAYER.","","yOU MUST BAKE","EVERY CUPCAKE","THEY CREATE.",""}
 elseif tuto==2 then
  msgs={"cLICK ON THE","OVEN TO START","BAKING","","bAKE ALL","THE CUPCAKES","IN TIME!",""}
 elseif tuto==3 then
  msgs={"cOLOR THE","CUPCAKE TO","INCREASE ITS","QUALITY.","","yOU CAN BAKE","IT MANUALLY","OR SAVE IT","IN THE OVEN","FOR AUTOMATIC","BAKING.","","gOOD LUCK!",""}
 end
 rectfill(camera_ox+8,64-#msgs*4-4,camera_ox+120,64+#msgs*4+4,9)
 rectfill(camera_ox+10,64-#msgs*4-2,camera_ox+118,64+#msgs*4+2,0x16)
 for k,m in ipairs(msgs) do
  nice_print(m,camera_ox+64-4*#m,64-8-#msgs*4+k*8)
 end
 local m="click to close"
 nice_print(m,camera_ox+64-2*#m,64-4+#msgs*4,7,false)
end
__gfx__
0000880000000000010000000e000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
008888880000000017100000e7e00000eeeeee88888eeeeeeeee88888eeeeeeec00000000000000000000000000000000000000000000000000000000000000c
088888888000000017710000e77e0000eeeee8888888eeeeeee88888888eeeeec00000000000000000000000000000000000000000000000000000000000000c
888888888800000017771000e777e000eeee888888888eeeee8888888888eeeec00000000000000000777777777770000000000000000000000000000000000c
888888888800000017777100e7777e00eeee888888888eeeee8888888888eeeec0000000000000007788877977aaa7700000000000000000000000000000000c
888888888800000017711000e77ee000eee88888888888eee888888888888eeec00000000000000788887999997aaaa70000000000000000000000000000000c
88888888880000000017100000e7e000ee888888888888eee8888888888888eec000000000000078888799999997aaaa7000000000000000000000000000000c
08888888800000000000000000000000e88888888888888e888888888888888ec0000000000007888879999999997aaaa700000000000000000000000000000c
008888880000000000000aaaa0000000e888888888888888888888888888888ec0000000000007888879999999997aaaa700000000000000000000000000000c
0008888000000000000aaaaaaaa00000e888888888888888888888888888888ec00000000000788887997777779997aaaa70000000000000000000000000000c
00008800000000000000000aaaaa0000e888888888888888888888888888888ec00000000000788887774444447797aaaa70000000000000000000000000000c
000000000000000000000000aaaaa000e888888888888888888888888888888ec00000000000788887444444444477aaaa70000000000000000000000000000c
0000000000000000a00000000aaaaa00ee88888888888888888888888888888ec00000000000788877444444444447aaaa70000000000000000000000000000c
0000000000000000a00000000aaaaa00ee8888888888888888888888888888eec000000000007887274444444444477aaa70000000000000000000000000000c
0000000000000000aa000000aaaaaa00ee08880888088808880888088808880ec000000000000787227444444444737aa700000000000000000000000000000c
0000000000000000aaaa000aaaaaaa00ee0080d080d080d080d080d080d0800ec0000000000007722274444444447337a700000000000000000000000000000c
000cc00000000000aaaaaaaaaaaaaa00ee0d0ddd0ddd0ddd0ddd0ddd0ddd0d0ec00000000000007222274444444733377000000000000000000000000000000c
00cccc00000000000aaaaaaaaaaaa000ee0dddddd0dddddddddddddddddddd0ec00000000000007722227444447333370000000000000000000000000000000c
00cccc0ccc00000000aaaaaaaaaa0000eee0ddddd0ddddddddddddddd0ddd0eec00000000000007c77222774773337770000000000000000000000000000000c
000cc0ccccc00000000aaaaaaaa00000eee0ddddd0ddddddddddddddd0ddd0eec00000000000007ccc77777777777cc70000000000000000000000000000000c
000000ccccc0000000000aaaaa000000eeee0ddddd0dddddddd0dddd0ddd0eeec000000000000007cccccccccccccc700000000000000000000000000000000c
0cc000ccccc000000000000000000000eeee0ddddd0dddddddd0dddd0ddd0eeec000000000000007cccccccccccccc700000000000000000000000000000000c
cccc000ccc0000000000000000000000eeeee0dddd0ddddddd0dddd0ddd0eeeec0000000000000007cccccccccccc7000000000000000000000000000000000c
cccc000000cc00000000000000000000eeeee0dddddddddddd0dddd0ddd0eeeec00000000000000007cccccccccc70000000000000000000000000000000000c
0cc0ccc00cccc0000000000000000000eeeeee0ddddddddddd0ddddddd0eeeeec0000000000000000077cccccc7700000000000000000000000000000000000c
000ccccc0cccc0000000000000000000eeeeee0ddddddddddd0ddddddd0eeeeec00000000000000000007777770000000000000000000000000000000000000c
000ccccc00cc00000000000000000000eeeeeee0ddddddddddddddddd0eeeeeec00000000000000000000000000000000000000000000000000000000000000c
000ccccc000000000000000000000000eeeeeee0ddddddddddddddddd0eeeeeec00000000000000000000000000000000000000000000000000000000000000c
0000ccc0000000000000000000000000eeeeeeee0ddd0dddd0dddddd0eeeeeeec00000000000000000000000000000000000000000000000000000000000000c
00000000000000000000000000000000eeeeeeee0ddd0dddd0dddddd0eeeeeeec00000000000000000000000000000000000000000000000000000000000000c
00000000000000000000000000000000eeeeeeeee0dd0dddddddddd0eeeeeeeec00000000000000000000000000000000000000000000000000000000000000c
00000000000000000000000000000000eeeeeeeeee0000000000000eeeeeeeeecccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000000000000000000000000000eeeeeeeeeeeeecccccceeeeeeeeeeeeeeeeeeeeeeeeee444444eeeeeeeeeeeeeeeeeeeeeeeeee333333eeeeeeeeeeeee
00000000000000000000000000000000eeeeeeecccccccccccccccceeeeeeeeeeeeeeee4444444444444444eeeeeeeeeeeeeeee3333333333333333eeeeeeeee
00000000000000000000000000000000eeeeeccccccccccccccccccceeeeeeeeeeeee44444c4444444444444eeeeeeeeeeeee3333333333333333333eeeeeeee
00000000000000000000000000000000eeeecccccccccccccccccccccceeeeeeeeee444aaccaaaaaaacc444444eeeeeeeeee3333333333333333333333eeeeee
00000000000000000000000000000000eeee222222ccccccccccccc22222eeeeeeee44aaacaaaaaaaccaaaaaa444eeeeeeee333333333333333333333333eeee
00000000000000000000000000000000eee22222222ccccccccccc2222222eeeeeeaaaaaaaaaaaaaaaaaaaaaaa444eeeeee33333333333333333333333333eee
00000000000000000000000000000000ee222222222cccccccccc222222222eeeeaaaaaaaaaaaaaaaaaaaacaaaaaaaeeee3333333333333333333333333333ee
00000000000000000000000000000000e222222222222ccccccc22222222222eeaaacaaaaaaaaaaaaaaaaccaaaaaaaaee333333333333333333333333333333e
00000000000000000000000000000000e222cc222222222222222222222cccceeaaaccaaaaaaaaaaaaaaacaaaaacaaaee333333333333333333333333333333e
00000000000000000000000000000000ecccccc22222222222222222ccccccceeaaaacaaaccaaaaaaaaaaaaaaaaccaaee333333333333333333333333333333e
00000000000000000000000000000000eccccccc22222222222222ccccccccceeaaaaaaaaaccaaaaaaaaaaaaaaaacaaee333333333333333333333333333333e
00000000000000000000000000000000eeccccccccc2222222cccccccccccceeeeaaaaaaaaaaaaaaaaaaaaaaaaaaaaeeee3333333333333333333333333333ee
00000000000000000000000000000000eecccccccccccccccccccccccccccceeeeaaaaaaaaaaaaaaaaaaaaaaaaaaaaeeee3333333333333333333333333333ee
00000000000000000000000000000000ee0ccc0ccc0ccc0ccc0ccc0ccc0cce0eee0aaa0aaa0aaa0aaa0aaa0aaa0aae0eee033303330333033303330333033e0e
00000000000000000000000000000000ee00c0d0c0d0c0d0c0d0c0d0c0d0c00eee00a0d0a0d0a0d0a0d0a0d0a0d0a00eee0030d030d030d030d030d030d0300e
00000000000000000000000000000000000000000000000000999900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000099999990000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000999999990000000000000000000000000000000000000000000000000000009000000000000000000
00000000000000000000000000000000000000000000009999909990000000000000000000000000000000000000000000000000000999990000000000000000
00000000000000000000000000000000000000000000009999000990000000000000000000000000000000000000000000000000009999990000000000000000
00000000000000000000000000000000000000000000099990009990000000000000000000000000000000000000000000000000099999999000000000000000
00000000000000000000000000000000000000000000999990009900000000000000000000000000000000000000000000000000099990990000000000000000
00000000000000000000000000000000000000000000999900009900000000000000000000000000000000000000000000000000999990990000000000000000
00000000000000000000000000000000000000000009999900090000000000000000000000099990000000099900000090000000999990990000000000000000
00000000000000000000000000000000000000000009999000000000000000000000099900999999000000999990000999900000999999900000000099990000
00000000000000000000000000000000000000000009999000000000999000000000099909999099900009990990009990909000999999000000000999990000
00000000000000000000000000000000000000000009999000000009999000990000999999900099900099900990099900999900999900009000009999999000
00000000000000000000000000000000000000000099990000000009999009990000999999900099900099900000099900999900999900999900009990990000
00000000000000000000000000000000000000000099990000000099999099999000999999999999000999900000999009999900999909999990099999990009
00000000000000000000000000000000000000000099990000000099990999999009999999999999999999900000999099999000999999909990099999900099
00000000000000000000000000000000000000000099990000000099990999999009999999999999990999000000999090999000999999099900099900000090
00000000000000000000000000000000000000000099990000000099999999990009999990009990000999000009999990999009999990999900099900000990
00000000000000000000000000000000000000000099990000000099999999990099999990999900000999000009099900999009999999990000999900000900
00000000000000000000000000000000000000000009990000000099999909990099999999999000000099900099000000999009099990999000999900009900
00000000000000000000000000000000000000000009990000000999999009990099999999990000000099900990000000999099099900099909999900099000
00000000000000000000000000000000000000000009999000009900990009990999999900000000000099999900000000999099000000099999909990990000
00000000000000000000000000000000000000000000999000009900000009999999999900000000000009999000000000999090000000009999909999990000
00000000000000000000000000000000000000000000999900999000000000999999999900000000000000090000000000099990000000000999000999900000
00000000000000000000000000000000000000000000099999990000000000099909999900000000000000000000000000009990000000000000aaaa00000000
eeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000999990000000000000000999990000000000000000000000000000000000000000000aaaaaaa000000
eeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000099999000000000a00000000000000000000000000a000000aaaaaaaa00000
0000000000000000000000000000000000000000000000000000000000000000000999990000000aaaaa0000000000000000aa00000aaaaa000aaa0aaaaa0000
0535555555555555355555500000000000000000000000000000000000000000000999990000000aaaaaa00000000000000aaa00000aaaaaa00aa000aaaa0000
033355555555555333555550000000000000000000000000000000000000000000009999000000aaaaaaaa0000000000000aaaa000aaa0aaaa0aaa000aaaa000
033b55555555555b33544450000000000000000000000000000000000000aaa0000099990000000aa0aaaa00000000000000aaa000aaa0aaaa00aa000aaaaa00
033b55555555555b33566650000000000000000000000000000000000000aaaaa00099990000000aa0aaaaa0000000000000aa00000aa00aaaa0aa0000aaaa00
033b55555d55555b3356665000000000000000000000000000000000000aaaaaa00009900000000aa0aaaaa00aaa000000000000000aaa0aaaa000a000aaaaa0
03335dd55d5555533356665000000000000000000000000000000000000aaaaaa00aaaa000000000aaaaaaa0aaaaa00000000000000aaa00aaa00000000aaaa0
000000000000000000000000000000000000000000000000000000000000aaaaaa0aaaaa000000000aaaaaa0aa0aaa000000aaa00000aaa0aaaa0000000aaaa0
0555555555555555535555500000000000000000000000000000a0000000aaaaa0aaaaaaa00000a0000aaaa0aa00aaa0000aaaaa0000aaa0aaaa0000000aaaa0
0555555555555555333555500000000000000000000000000000a0000000aaaaa00aa0aaa0000aaaa00aaaa00000aaa00000aaaa00000aaaaaaa00000000aaaa
055444555444555533b555500000000000000000000000000000a000000aaaaaa00aaaaaaa00aaaaaa0aaaa00000aaaa0000aaaa000000aaaaaa00000000aaaa
055666555666555533b555500000000000000000000000000000aa0000aaaaaaa000aaaaaa00aaa0aaaaaaa00000aaaa0000aaaaa000000aaaaa00000000aaaa
0d56665556665d5533b55d500000000000000000000000000000aa0000aaaa00a000000aaa000aaa0aaaaaa000000aaa0000aaaaaa0000000aaa00000000aaaa
0d56665556665d5533355d5000000000000000000000000000000a0000aaa000aa00000aaa000aaaa0aaaaaa00000aaaa000aaaaaa0000000aaa00000000aaaa
00000000000000000000000000000000000000000000000000000aa000aaa0000a00000aaaa0000aaaaaaaaa00000aaaa0000aaaaaa000000aaa00000000aaaa
05555555555555555555555000000000000000000000000000000aa000aaa0000aa0000aaaa000aaa0aaaa0aa000aaa0a0000aaaa0a000000aaa00000000aaa0
055555555555577755555550000000000000000000000000000000a000aaa00000aa000aaaaa0aaa000aaa00aa00aaa0aa000aaa00aa00000aaaa0000000aaa0
055555555555777777555550000000000000000000000000000000aa00aaa000000aa0aaa0aaaaaa000000000aaaaaa0aa000aaa00aa00000aaaaa00000aaaa0
055555555566677777755550000000000000000000000000000000aa00aaa000000aaaaaa0aaaaa00000000000aaaa000aa0aaa0000aa000aaa0aa00000aaa00
0555555555444667776655500000000000000000000000000000000aa0aaa0000000aaaa000aaa0000000000000a00000aaaaaa0000aaa00aaa00aaa00aaaa00
0555555554999446664445500000000000000000000000000000000aaaaa00000000000000000000000000000000000000aaaa000000aaaaaa0000aaaaaaa000
05555555554999944499455000000000000000000000000000000000aaa00000000000000000000000000000000000000000000000000aaaa000000aaaaa0000
05555555554999999994555000000000000000000000000000000000ee000eeeeeee00ee00000000000000000000000000000000000000000000000000000000
0555555554999a9a9a94555000000000000000000000000000000000e0e0e0eeeee0990e00000000000000000000000000000000000000000000000000000000
055555555499aaaaa9945550000000000000000000000000000000000ee0ee0eee099a0e00000000000000000000000000000000000000000000000000000000
0555555549999a9a9a994550000000000000000000000000000000000000ee0ee0999a0e00000000000000000000000000000000000000000000000000000000
055555555449999999945550000000000000000000000000000000000eeeee0e09999a0e00000000000000000000000000000000000000000000000000000000
05555555555444444445555000000000000000000000000000000000e0eee0ee09999a0e00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ee000eeee0999a0e00000000000000000000000000000000000000000000000000000000
ee000eeeeeeeeeeeeeee000e00000000000000000000000000000000eeeeeeeeee099a0e00000000000000000000000000000000000000000000000000000000
eee555eeee555eeeeee555eeee555eee000000000000000000000000ee000eeeeee0aa0e88980000000000000000000000000000000000000000000000000000
e00000000000000ee00000000000000e0000000000000000000000000000000eeeee00ee99990000000660000066000000000011111000000011111111111110
055555555555555005555555555555500000000000000000000000000555550eeeeeeeee88980000006600000006600000001111111110000011111111111110
055755557557575005575555755757500000000000000000000000000656560eeeeeeeee88980000066606666606660000011111111111000011111111111110
057075570755555005707557075555500000000000000000000000000656560eeeeeeeee00000000060060000060060000011110001111000000000000011100
055555555555555005555555555555500000000000000000000000000656560eeeeeeeee00000000000600060006000000011110001111000000000000011100
000000000000000000000000000000000000000000000000000000000656560eeeeeeeee00000000006000060000600000111100000111100000000000111100
06666666666666600666666666666660000000000000000000000000e00000eeeeeeeeee00000000006000060000600000111100000111100000000000111000
06666666666666600666666666666660000000007777777766666665ee00eeeeeeeeeeee000ee7e0006000060000600000111100000111100000000001111000
06000000000000600600000000000060000000007666666666666665e0880eeeeeeeeeee008e7e0e006000600000600000111100000111100000000001111000
0605dddddddd50600609aaaaaaaa906000000000766666666666666508880eeeeeeeeeee08ee7000006006000000600000111100000111100000000001110000
0605d0dddd0d50600609a0aaaa0a906000000000766666666666666508880eeeeeeeeeeeee7ee7e0000600000006000000111100000111100000000011110000
0605dd0000dd50600609aa0000aa906000000000766666666666666508880eeeeeeeeeeeeee7ee70000060000060000000111100000111100000000011110000
0605dddddddd50600609aaaaaaaa906000000000766666666666666508880eeeeeeeeeee44ee7440000606666606000000111100000111100000000011100000
0605dddddddd50600609aaaaaaaa9060000000006666666666666665e08880eeeee0eeee04444400006000000000600000111100000111100000000111100000
0605dddddddd50600609aaaaaaaa9060000000006666666666666665e088880eee080eee00444000000000000000000000111100000111100000000111100000
0605dddddddd50600609aaaaaaaa9060000000006666666666666665ee088880e0880eee66666660666666600066600000111100000111100000001111000000
0605dddddddd50600609aaaaaaaa9060000000006666666666666665eee0888808880eee6bbbbb66699900660600060000111100000111100000001111000000
06055555555550600609999999999060000000006666666666666665eeee088888880eee6bbbbb66699900666066606000011110001111000000001110000000
06000000000000600600000000000060000000006666666666666665eeeee08888880eee66666660666666600600060000011110001111000000011110000000
06666666666666600666666666666660000000006666666666666665eeeeee0088880eee66666660666666600006000000011111111110000000011110000000
06666666666666600666666666666660000000006666666666666665eeeeee0888880eee6bbbb066680000660066600000001111111110000000011100000000
e00000000000000ee00000000000000e000000006666666666666665eeeee08888880eee6bbbb066680000660600060000000011111000000000111100000000
ee000eeeeeee000eee000eeeeeee000e000000005555555555555555eeeeee000000eeee66666660666666600006000000000000000000000000000000000000
__label__
666666666666666666666666666666666666666666666666666666666666666666666666666666660bb006666666666666666666666006666666666666666666
66660006666660006666666666666006666600000666666666666666666666666666666666666660bbbbb0600000666600006666660bb0600000666600006666
6660606066660999066666666666099066609999906666666666666666666666666666666666660bbbb0060bbbbb0660bbbb066660bb060bbbbb0660bbbb0666
66066066066099990666666666609990660990000666666666666666666666666666666666666660bbbb0660000bb00bb0bbb0660bb06660000bb00bb0bbb066
660000660609909906666666666609906660999906666666666666666666666666666666666666600bbbb060bbbb060bbb0bb060bb066660bbbb060bbb0bb066
6606666606099999906600666666099066600009906666666666666666666666666666666666660bbbbb060bb000060bb00bb00bb066660bb000060bb00bb066
666066606660009906609906666099990609999906666666666666666666666666666666666666600bb0660bbbbbb060bbbb06600666660bbbbbb060bbbb0666
66660006666666006666006666660000666000006666666666666666666666666666666666666666600666600000066600006666666666600000066600006666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66555555555555555555555555555555555555555555555555555555555555555555555555555555555555555556555555555555555555555555555555555566
66566666666666666666666666666666666666666666666666666666666666666666666666666666666666666656566666666666666666666666666666666566
66566606606060006066600060006060666660606006606066666666600060006666660060006000600066006656566666666666666666666666666666666566
66566070070707770706077707770707066607070770070706666666077707770666607707770777077700770656566666666666666666666666666666666566
66560707070707070706607060700707066607070070600706666666600700070666070060700700070707006656566666666666666666666666666666666566
66560707070707770706607060700777066607770070607066666666607700770666077700700770077707770656566666666666666688666666666666666566
66560770070707070700607060706007066660070070070066666666600700070666600700700700070060070656566666666666668888886666666666666566
66566077007707070777077700700777066666070777070706666666077707770666077060700777070607706656566666666666688888888666666666666566
66566600660060606000600066066000666666606000606066666666600060006666600666066000606660066656566666666666888888888866666666666566
66566666666666666666666666666666666666666666666666666666666666666666666666666666666666666656566666666666888888888866666666666566
665666666666666666666666666666666666667cc77777777c666666666666666666666666666666666666666656566666666666888888888866666666666566
66566666666666666666666666666666666666cccc777777cc666666666666666666666666666666666666666656566666666666888888888866666666666566
665666666666666666666666667cc77777777ccccc7ccc77cccccccc7c6666666666666666666666666666666656566666666666688888888666666666666566
66566666666666666666666666cccc7777777cccc7ccccc77cc7cccccc6666666666666666666666666666666656566666666666668888886666666666666566
66566666666666666666667777cccc7ccc7777ccccccccc77777cccccccc66666666666666666666666666666656566666666666666888866666666666666566
665666666666666666666677777cc7ccccc77cccccccccccc77ccccccccc66666666666666666666666666666656566666666666666666666666666666666566
6656666666666666666677cccc7777ccccc7cccccccccccccccccccccccc77776666666666666666666666666656566666666666666666666666666666666566
665666666666666666667cccccc777cccccccccccccccccccccccc77cccccccc6666666666666666666666666656566666666666666666666666666666666566
665666666666666666667ccccccccccc227cccccccccccccc7ccc7ccccccccc22888666666666666666666666656566666666666666666666666666666666566
6656666666666666666677c22ccccc228822cccccccccccccccccccccccccc222888666666666666666666666656566666666666666666666666666666666566
665666666666666666cc7888822cc22282222ccccccccccccccccccccc77c2222882226666666666666666666656566666666666666666666666666666666566
665666666666666666cc222282222222822222cccccccccccccccccccc8872228882226666666666666666666656566666666666666666666666666666666566
66566666666666667cc22222282222228822222ccccc77cccccccccc228888882288228c66666666666666666656566666666666666666666666666666666566
66566666666666667722222222822222282222822cccccccccccccc2282228822228822c666666666666666666565666666666666cc666666666666666666566
665666666666667778882222222222222282282222ccccccccccc22282222282222822cccc666666666666666656566666666666cccc66666666666666666566
6656666666666677228822222222222222288222222ccc22ccc882282222228822882ccccc666666666666666656566666666666cccc6ccc6666666666666566
665666666666667c222222222222cc2222282222222c2282222822222222228222887ccccc6666666666666666565666666666666cc6ccccc666666666666566
665666666666667c22222222222cc77222822222228888222222222222222222ccc77777cc6666666666666666565666666666666666ccccc666666666666566
66566666666666772222222222cc77ccc282222222222822222222228222222cccccc777cc66666666666666665656666666666cc666ccccc666666666666566
6656666666666677722222222ccc77cccc8222222222222222222222822222cccccccc777c6666666666666666565666666666cccc666ccc6666666666666566
665666666666667777222222cccc7cccc7c22228222222222282222222222ccccccccc77776666666666666666565666666666cccc666666cc66666666666566
665666666666667cccc2222cccc77cccc7cc2222222222222888822222ccccccccccc7ccc766666666666666665656666666666cc6ccc66cccc6666666666566
6656666666666666cccccccc777ccccc7ccc222222222222822282222ccccccccccccccc666666666666666666565666666666666ccccc6cccc6666666666566
6656666666666666cccc7cccccccccccccccc2222288222822cc2222cccccccc7ccccccc666666666666666666565666666666666ccccc66cc66666666666566
6656666666666666c7cccccccccccccccccccc222288c2222cccc7cccccccccc7ccccccc666666666666666666565666666666666ccccc666666666666666566
66566666666666667cccccccccccccc7ccccccc2222cccccccccc777777ccccc7cccc7cc6666666666666666665656666666666666ccc6666666666666666566
665666666666666600cccccc0077777c00cc7ccc00cccccc00cc7777007ccccc00cc776600666666666666666656566666666666666666666666666666666566
665666666666666600cccccc0077777c00cc77cc00ccc77c00777777007ccccc0077776600666666666666666656566666666666666666666666666666666566
66566666666666660000c700dd007700dd007700dd00c700dd007700dd00cc00dd00770000666666666666666656566666666666666666666666666666666566
665666666666666600007700dd007700dd007700dd007700dd007700dd007700dd00770000666666666666666656566666666666666666666666666666666566
665666666666666600dd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dd00666666666666666656566666666666666666666666666666666566
665666666666666600dd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dd00666666666666666656566666666666666666666666666666666566
665666666666666600dddddddddddd00dddddddddddddddddddddddddddddddddddddddd00666666666666666656566666666666666666666666666666666566
665666666666666600dddddddddddd00dddddddddddddddddddddddddddddddddddddddd00666666666666666656566666666666666666666666666666666566
66566666666666666600dddddddddd00dddddddddddddddddddddddddddddd00dddddd0066666666666666666656566666666666666666666666666666666566
66566666666666666600dddddddddd00dddddddddddddddddddddddddddddd00dddddd0066666666666666666656566666666666666666666666666666666566
66566666666666666600dddddddddd00dddddddddddddddddddddddddddddd00dddddd0066666666666666666656566666666666666666666666666666666566
66566666666666666600dddddddddd00dddddddddddddddddddddddddddddd00dddddd0066666666666666666656566666666666666666666666666666666566
6656666666666666666600dddddddddd00dddddddddddddddd00dddddddd00dddddd006666666666666666666656566666666666666666666666666666666566
6656666666666666666600dddddddddd00dddddddddddddddd00dddddddd00dddddd006666666666666666666656566666666666666666666666666666666566
6656666666666666666600dddddddddd00dddddddddddddddd00dddddddd00dddddd006666666666666666666656566666666666666666666666666666666566
6656666666666666666600dddddddddd00dddddddddddddddd00dddddddd00dddddd006666666666666666666656566666666666666666666666666666666566
665666666666666666666600dddddddd00dddddddddddddd00dddddddd00dddddd00666666666666666666666656566666666666666666666666666666666566
665666666666666666666600dddddddd00dddddddddddddd00dddddddd00dddddd00666666666666666666666656566666666666666666666666666666666566
665666666666666666666600dddddddddddddddddddddddd00dddddddd00dddddd00666666666666666666666656566666666666666666666666666666666566
665666666666666666666600dddddddddddddddddddddddd00dddddddd00dddddd00666666666666666666666656566666666666666666666666666666666566
66566666666666666666666600dddddddddddddddddddddd00dddddddddddddd0066666666666666666666666656566666666666666666666666666666666566
66566666666666666666666600dddddddddddddddddddddd00dddddddddddddd0066669999999999999999999656566666666666666666666666666666666566
66566666666666666666666600dddddddddddddddddddddd00dddddddddddddd0066669900090009090900099656566666666666666666666666666666666566
66566666666666666666666600dddddddddddddddddddddd00dddddddddddddd0066669088808880808088809656566666666666666666666666666666666566
6656666666666666666666666600dddddddddddddddddddddddddddddddddd006666669080808080808080099656566666666666666666666666666666666566
6656666666666666666666666600dddddddddddddddddddddddddddddddddd006666669088008880880088099656566666666666666666666666666666666566
6656666660006666666666666600dddddddddddddddddddddddddddddddddd006666669080808080808080099656566666666666666666666666666666666566
6656666000000066666666666600dddddddddddddddddddddddddddddddddd006666669088808080808088809656566666666666666666666666666666666566
665666605555506666666666666600dddddd00dddddddd00dddddddddddd00666666669900090009090900099656566666666666666666666666666666666566
665666606565606666666666666600dddddd00dddddddd00dddddddddddd00666666669088808880999999999656566666666666666666666666666666666566
665666606565606666666666666600dddddd00dddddddd00dddddddddddd00666666669080808809999999999656566666666666666666666666666666666566
665666606565606666666666666600dddddd00dddddddd00dddddddddddd00666666669088800880999999999656566666666666666666666666666666666566
66566660656560666666666666666600dddd00dddddddddddddddddddd0066666666669080808880999999999656566666666666666666666666666666666566
66566666000006666666666666666600dddd00dddddddddddddddddddd0066666666669088800809999999999656566666666666666666666666666666666566
66566666666666666666666666666666000000000000000000000000006666666666669900099099999999999656566666666666666666666666666666666566
66566666666666666666666666666666000000000000000000000000006666666666669999999999999999999656566666666666666666666666666666666566
66566666666666666666666666666666666666666666666666666666666666666661666666666666666666666656566666666666666666666666666666666566
66555555555555555555555555555555555555555555555555555555555555555517155555555555555555555556555555555555555555555555555555555566
66666666666666666666666666666666666666666666666666666666666666666617716666666666666666666666666666666666666666666666666666666666
66555555555555555555555555555555555555555555555555555555555555555517771555555555555555555555555555555555555555555555555555555566
66566666666666666666666666666666666666666666666666666666666666666517777166666666666666666666666666666666666666666666666666666566
66560060006000660060006000606666666000606660606000666660006000666517711666666600606060006006666660606000600060666006666666666566
6650aa0aaa0aaa00aa0aaa0aaa0a0666660aaa0a060a0a0aaa06660aaa0aaa066565171666666077070707770770666607070777077707060770666666666566
660a000a0a0a000a0060a00a0a0a0666660a0a0a060a0a0a0066660a0a0aa0666565666666660707070707000707066607070070070007060707066666666566
660aaa0aaa0aa00a0660a00aaa0a0666660aa00a060a0a0aa066660aaa00aa066565666666660707070707700707066607770070077007060707066666666566
66500a0a000a000a0060a00a0a0a0066660a0a0a000a0a0a006666600a0aaa066565666666660707077707000707066660070070070007000707066666666566
660aa00a060aaa00aa0aaa0a0a0aaa06660aaa0aaa00aa0aaa0666660a00a0666565666666660770607007770707066607770777077707770777066666666566
66500660666000660060006060600066666000600066006000666666606606666565666666666006660660006060666660006000600060006000666666666566
66566666666666666666666666666666666666666666666666666666666666666565666666666666666666666666666666666666666666666666666666666566
665666666666666666666666666666cccccc66666666666666666666666666666565666666666666660660006000606066006000600666066666666666666566
665666666666666666666666cccccccccccccccc6666666666666666666666666565666666666666607007770777070700770777077060706666666666666566
6656666666666666666666ccccccccccccccccccc666666666666666666666666565666666666666070607070707070707000700070706070666666666666566
665666666666666666666cccccccccccccccccccccc6666666666666666666666565666666666666070607770777070707770770070706070666666666666566
665666666666666666666222222ccccccccccccc2222266666666666666666666565666666666666070607000707070700070700070706070666666666666566
6656666666666666666622222222ccccccccccc22222226666666666666666666565666666666666607007060707007707700777077700706666666666666566
6656666666666666666222222222cccccccccc222222222666666666666666666565666666666666660660666060660060066000600066066666666666666566
665666666666666666222222222222ccccccc2222222222266666666666666666565666666666666666666666666666666666666666666666666666666666566
665666666666666666222cc222222222222222222222cccc66666666666666666565666666666666666666666666666666666666666666666666666666666566
665666666666666666cccccc22222222222222222ccccccc66666666666666666565666666666666666666666666666666666666666666666666666666666566
665666666666666666ccccccc22222222222222ccccccccc66666666666666666565660066000606066666066666660006000600066606600666666666666566
6656666660066666666ccccccccc2222222cccccccccccc666666666006666666565607700777070706060706666607770777077706070077066666666666566
6656666609906666666cccccccccccccccccccccccccccc666666660990666666565607070700070700700700666607000707077060700700666666666666566
6656666099a066666660ccc0ccc0ccc0ccc0ccc0ccc0cc6066666660a99066666565607070770070706060777066607770777007700700777066666666666566
6656660999a0666666600c0d0c0d0c0d0c0d0c0d0c0d0c0066666660a99906666565607070700077700700707060660070007077700706007066666666666566
6656609999a066666660d0ddd0ddd0ddd0ddd0ddd0ddd0d066666660a99990666565607070777077706060777007007770607007007060770666666666666566
6656609999a066666660dddddd0dddddddddddddddddddd066666660a99990666565660606000600066666000660660006660660660666006666666666666566
6656660999a0666666660ddddd0ddddddddddddddd0ddd0666666660a99906666565666666666666666666666666666666666666666666666666666666666566
6656666099a0666666660ddddd0ddddddddddddddd0ddd0666666660a99066666565666666666666666666666666666666666666666666666666666666666566
665666660aa06666666660ddddd0dddddddd0dddd0ddd06666666660aa0666666565666666666666666666666666666666666666666666666666666666666566
6656666660066666666660ddddd0dddddddd0dddd0ddd06666666666006666666565666666666666666666666666666666666666666666666666666666666566
66566666666666666666660dddd0ddddddd0dddd0ddd066666666666666666666565666666666666999999999999999999999999999999966666666666666566
66566666666666666666660dddddddddddd0dddd0ddd066666666666666666666565666666666666990009000900090999000990090009966666666666666566
665666666666666666666660ddddddddddd0ddddddd0666666666666666666666565666666666666908880888088808090888008808880966666666666666566
665666666666666666666660ddddddddddd0ddddddd0666666666666666666666565666666666666908080800080808090808080008009966666666666666566
6656666666666666666666660ddddddddddddddddd06666666666666666666666565666666666666908800880088808090888080908809966666666666666566
6656666666666666666666660ddddddddddddddddd06666666666666666666666565666666666666908080800080008000808080008009966666666666666566
60006000660060606666666660ddd0dddd0dddddd066666666666666666666666565666666666666908080888080908880808008808880966666666666666566
08880888008808080666666660ddd0dddd0dddddd066666666666666666666666565666666666666990909000909990009090990090009966666666666666566
080808080800080806666666660dd0dddddddddd0666666666666666666666666565666666666666999999999999999999999999999999966666666666666566
08800888080608806666666666600000000000006666666666666666666666666565666666666666666666666666666666666666666666666666666666666566
08080808080008080666666666666666666666666666666666666666666666666565666666666666666666666666666666666666666666666666666666666566
08880808008808080555555555555555555555555555555555555555555555555565555555555555555555555555555555555555555555555555555555555566
60006060660060606666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666

