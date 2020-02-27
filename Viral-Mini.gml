/*
Hello!


Double-click the top panel to add a code tab.
Ctrl+Enter or F5 to run your code.


Also check out Help in the main menu.


Try copying the following to a new code tab for a test:
*/
//scripts






// init
trace("hi!");
frame = 0;
background_color = c_black;


x=room_width/2;
y=room_height/2;


spd_max = 10;
spd_init = 2;


/// ENTITY LIST
// 0 type
// 1 x
// 2 y
// 3 health
// 4 speed
// 5 range


entity_max = 64;
for (i=0; i<entity_max; i++)
    entity[i, 0] = "none";
    
entity[0, 0] = "zombie";
entity[0, 1] = room_width/2+200;
entity[0, 2] = room_height/2+200;
entity[0, 3] = 100;
entity[0, 4] = 2;
entity[0, 5] = 100;


entity[1, 0] = "zombie";
entity[1, 1] = room_width/2-200;
entity[1, 2] = room_height/2+200;
entity[1, 3] = 100;
entity[1, 4] = 2;
entity[1, 5] = 100;


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
        case "zombie":
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
// draw event codesd
scr_show("hi!");
//draw_rectangle(x-20, y-20, x+20, y+20, false)
image_angle=32
draw_triangle(x, y, x-20, y-20, x+20, y-20, false);




/// ENTITY DRAW


for(i=0; i<entity_max; i++)
{
    switch(entity[i,0])
    {
        case "zombie":
            draw_roundrect_color(entity[i, 1]-20, entity[i, 2]-20, entity[i, 1]+20, entity[i, 2]+20, c_red, c_white, false);
        break;
    }
}




//draw_triangle_color(x+10, y-10, x-10, y-10, x*(10*cos(m_angle)), y+sin(m_angle), c_white, c_white, c_white, false);


draw_line_color(x, y, mouse_x, mouse_y, c_white, c_white);


// Cursor
draw_set_color(c_white);
draw_triangle(mouse_x, mouse_y-m_len/2, mouse_x-m_len, mouse_y-m_len, mouse_x+m_len, mouse_y-m_len, false);
draw_triangle(mouse_x, mouse_y+m_len/2, mouse_x-m_len, mouse_y+m_len, mouse_x+m_len, mouse_y+m_len, false);
draw_triangle(mouse_x-m_len/2, mouse_y, mouse_x-m_len, mouse_y-m_len, mouse_x-m_len, mouse_y+m_len, false);
draw_triangle(mouse_x+m_len/2, mouse_y, mouse_x+m_len, mouse_y-m_len, mouse_x+m_len, mouse_y+m_len, false);






    




#define scr_show
// define scripts like this
draw_text(10, 10 + sin(frame / 0.7) * 3, argument0);
draw_text(10, 32 + sin(frame / 0.7) * 3, "y = "+y);
draw_text(10, 64 + sin(frame / 0.7) * 3, "angle = "+point_direction(x, y, mouse_x, mouse_y));