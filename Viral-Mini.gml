/*
V I R A L
by Posho
*/


// init
trace("V I R A L");
trace("by Posho")

NULL = -1;
debug = true;

frame = 0;
background_color = c_black;

x=room_width/2;
y=room_height/2;
spd_max = 10;
spd_init = 2;


/// ENTITIES!
enum ent { id, x, y, solid, health, speed, range };


// Blank entity list
entity_max = 64;
for (i=0; i<entity_max; i++)
    entity[i, 0] = NULL;


// ENTITY DEFAULTS
entity_default[entity_type.wall, ent.id] = entity_type.wall;
entity_default[entity_type.wall, ent.solid] = true;

entity_default[entity_type.zombie, ent.id] = entity_type.zombie;
entity_default[entity_type.zombie, ent.solid] = false;
entity_default[entity_type.zombie, ent.health] = 100;
entity_default[entity_type.zombie, ent.speed] = 2;
entity_default[entity_type.zombie, ent.range] = 400;


// Sandbox
entity_create(entity_type.zombie, 100, 100);
build_house_8(300, 300);



#define step
// step event code
window_set_cursor(cr_none)
frame += delta_time/1000000;

m_angle = point_direction(x, y, mouse_x, mouse_y);
m_len = 10;

if (keyboard_check(ord("W")) && !collision_check_solid_all(x, y-spd_max))
    y -= spd_max;
if (keyboard_check(ord("S")) && !collision_check_solid_all(x, y+spd_max))
    y += spd_max;
if (keyboard_check(ord("A")) && !collision_check_solid_all(x-spd_max, y))
    x -= spd_max;
if (keyboard_check(ord("D")) && !collision_check_solid_all(x+spd_max, y))
    x += spd_max;


/* ENTITY UPDATE */

for(i=0; i<entity_max; i++)
{
    switch(entity[i, ent.id])
    {
        case entity_type.zombie:
            if (point_distance(entity[i, ent.x], entity[i, ent.y], x, y)
            < entity[i, ent.range])
            {
                if (entity[i, ent.x] < x)
                    entity[i, ent.x] += entity[i, ent.speed];
                else
                    entity[i, ent.x] -= entity[i, ent.speed];
                    
                if (entity[i, ent.y] < y)
                    entity[i, ent.y] += entity[i, ent.speed];
                else
                    entity[i, ent.y] -= entity[i, ent.speed];
            }
                
        break;
    }
}



#define draw

// Draw Player!
draw_triangle(x, y, x-20, y-20, x+20, y-20, false);


/// ENTITY DRAW
enum entity_type { wall, zombie }

for(i=0; i<entity_max; i++)
{
    switch(entity[i, 0])
    {
        case entity_type.wall:
            draw_roundrect_color(entity[i, ent.x]-20, entity[i, ent.y]-20,
            entity[i, ent.x]+20, entity[i, ent.y]+20, c_gray, c_gray, false);
        break;
        
        case entity_type.zombie:
            draw_roundrect_color(entity[i, ent.x]-20, entity[i, ent.y]-20,
            entity[i, ent.x]+20, entity[i, ent.y]+20, c_red, c_red, false);
        break;
    }
}

draw_line_color(x, y, mouse_x, mouse_y, c_white, c_white);


// Cursor
draw_set_color(c_white);
draw_triangle(mouse_x, mouse_y-m_len/2, mouse_x-m_len, mouse_y-m_len,
mouse_x+m_len, mouse_y-m_len, false);
draw_triangle(mouse_x, mouse_y+m_len/2, mouse_x-m_len, mouse_y+m_len,
mouse_x+m_len, mouse_y+m_len, false);
draw_triangle(mouse_x-m_len/2, mouse_y, mouse_x-m_len, mouse_y-m_len,
mouse_x-m_len, mouse_y+m_len, false);
draw_triangle(mouse_x+m_len/2, mouse_y, mouse_x+m_len, mouse_y-m_len,
mouse_x+m_len, mouse_y+m_len, false);



#define entity_create //(id, x, y)
// Create an object, I think!

for(i=0; entity[i, ent.id]!=NULL && i<entity_max; i++){} // Find empty on list.

if (i==entity_max)
{
    if (debug)
        trace("ERROR: Could not create instance. Array is too small.");
    return;
}

entity[i, ent.id] =     argument0;
entity[i, ent.x] =      argument1;
entity[i, ent.y] =      argument2;
entity[i, ent.solid] =  entity_default[argument0, ent.solid];
entity[i, ent.health] = entity_default[argument0, ent.health];
entity[i, ent.speed] =  entity_default[argument0, ent.speed];
entity[i, ent.range] =  entity_default[argument0, ent.range];

/*if (debug)
    trace("Entity created. ID:"+i+" type: "+entity[i, ent.id]+
    " at ("+entity[i, ent.x]+", "+entity[i, ent.y]+")");*/

return;



#define build //(design, x, y)
{
    var px = argument1;
    var py = argument2;
    var i=0, j=0, k=0, pick, put;
    
    /*if (debug)
        trace("/!\ Loaded building map. Size: "+string_length(argument0))*/
    
    for(i=0; i<string_length(argument0); i++)
    {
        pick = string_char_at(argument0, i);
        
        switch(pick)
        {
            case 'X': place=entity_type.wall;   break;
            case '|': break;
        }
        
        switch (pick)
        {
            case '\':
                j = 0;
                k++;
                /*trace("jump")*/
            break;
            
            case ' ':
                j++;
            break;
            
            default:
                entity_create(place, px+(j*40), py+(k*40))
                j++;
            break;
        }
    }
    
    return;
}



#define build_house_8 //(x, y)
{

design[0] =
"XXXXXXXX\"+
"X      X\"+
"X      X\"+
"X      X\"+
"X      X\"+
"X      X\"+
"X      X\"+
"XXX  XXX\"

    build(design[0], argument0, argument1);

    return;
}



#define collision_check_solid_all //(at_x, at_y)

var at_x = argument0;
var at_y = argument1;

for (i=0; i<entity_max; i++)
{
    if (entity[i, ent.solid])
    {
        /*if (debug)
            trace("/!\ Entity "+i+" is solid.")*/
        
        if (rectangle_in_circle(entity[i, ent.x]-20, entity[i, ent.y]-20,
        entity[i, ent.x]+20, entity[i, ent.y]+20, at_x, at_y, 10))
        {
            /*if (debug)
                trace("/!\ Collision.")*/
                
            return true;
        }
    }
}

return false;