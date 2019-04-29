classdef Ball
    %% Properties
    properties
        pos;
        vel;
        acc;
        r;
    end
    methods
    %% Constructor
    function b = Ball(X0,V0,rad)
        b.pos = X0;
        b.vel = V0;
        b.acc = [0,0];
        b.r = rad; 
    end
    
    function [b] = ballUpdate(b)
        b.pos = b.pos + b.vel;
        b.vel = b.vel + b.acc;
        b.acc = [0,0];
    end
    
    function [b] = applyForce(b,force)
        f = force;
        b.acc = b.acc + f;
    end
    
    end
end