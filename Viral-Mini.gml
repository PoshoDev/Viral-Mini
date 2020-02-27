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
enum ent { id, x, y, hp, spd, range };


// Blank entity list
entity_max = 64;
for (i=0; i<entity_max; i++)
    entity[i, 0] = NULL;


// ENTITY DEFAULTS
entity_default[0, ent.id] = "zombie";
entity_default[0, ent.hp] = 100;
entity_default[0, ent.spd] = 2;
entity_default[0, ent.range] = 400;


// Sandbox
entity_create(entity_type.zombie, 100, 100);
build_house_8(300, 300);


#define step
// step event code
window_set_cursor(cr_none)
frame += delta_time/1000000;


m_angle = point_direction(x, y, mouse_x, mouse_y);
m_len = 10;


if (keyboard_check(ord("W")))
    y -= spd_max;
if (keyboard_check(ord("S")))
    y += spd_max;
if (keyboard_check(ord("A")))
    x -= spd_max;
if (keyboard_check(ord("D")))
    x += spd_max;




/// ENTITY UPDATE


for(i=0; i<entity_max; i++)
{
    switch(entity[i,0])
    {
        case entity_type.zombie:
            if (point_distance(entity[i,1], entity[i,2], x, y) < entity[i,5])
            {
                if (entity[i, 1] < x)
                    entity[i, 1] += entity[i, 4];
                else
                    entity[i, 1] -= entity[i, 4];
                    
                if (entity[i, 2] < y)
                    entity[i, 2] += entity[i, 4];
                else
                    entity[i, 2] -= entity[i, 4];
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


for(i=0; entity[i, ent.id]!=NULL && i<entity_max; i++){} // Find an empty spot on the list.


if (i==entity_max)
{
    if (debug)
        trace("ERROR: Could not create instance. Array is too small.");
    return;
}


entity[i, ent.id] = argument0;
entity[i, ent.x] = argument1;
entity[i, ent.y] = argument2;
entity[i, ent.hp] = 100;
entity[i, ent.spd] = 2;
entity[i, ent.range] = 400;


if (debug)
    trace("Entity created. ID:"+i+" type: "+entity[i, ent.id]+
    " at ("+entity[i, ent.x]+", "+entity[i, ent.y]+")");


return;


    
#define build //(design, x, y)
{
    var px = argument1;
    var py = argument2;
    var i=0, j=0, k=0, pick, put;
    
    if (debug)
        trace("/!\ Loaded building map. Size: "+string_length(argument0))
    
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
                trace("jump")
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
"XXX||XXX\"


build(design[0], argument0, argument1);


return;
}