classdef Wall
    properties
        pos;
        vel;
        width;
        height
        
    end
    methods
        function wall = Wall(X0,w,h)
            wall.pos = X0;
            wall.vel = [-2,0];
            wall.width = w;
            wall.height = h;
        end
        
        function [wall] = wallUpdate(wall)
            wall.pos = wall.pos+wall.vel;
        end
        
    end
end
