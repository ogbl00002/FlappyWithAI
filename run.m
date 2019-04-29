%% Flappy bird 
% Ognjen Blagojevic
% Umeå Universitet - Teknisk Fysik
% oggu39@gmail.com


clear;clc;close all;


global key;
global finished;
global score;
global s;
global ax;
score = 0;
key = 0;
finished = false;
s = 100;
start = true;
choice1 = input('1) Play by yourself    2)Play against AI   3) Watch AI\n');

choice = input('\nChoose difficulty:\n 1. Easy  2. Medium   3.Hard  4.Do not try\n');
switch choice
    case 1
        fr = 0.015;
    case 2
        fr = 0.01;
    case 3
        fr = 0.0075;
    case 4
        fr = 0.005;
    otherwise
        error('Choose a valid difficulty');
        finished = true;
end



walls = cell(1,1);
walls{1,1} = cell(1,2);
w = cell(1,1);
w{1,1} = cell(1,2);






AIball = Ball([100,150],[0,0],75);
ball = Ball([100,150],[0,0],75); % Make a ball
canvas = figure('color',[0.5,0.5,0.8],'KeyPressFcn',@keyPressed,...
    'Position',[200 200 800 400]);

ax = axes('color','black','XLim',[0 600],'YLim',[0 400]);
b = line(ball.pos(1),ball.pos(2),...
    'marker','.','color','red','markerSize',ball.r);
AIb = line(AIball.pos(1),AIball.pos(2),...
    'marker','.','color','blue','markerSize',AIball.r);

load('bestAI100.mat');
AI = bestBrain;

walls{1}{1,1} = Wall([650,0],50,300*rand()); % Test ......................
walls{1}{1,2} = Wall([walls{1}{1,1}.pos(1),(walls{1}{1,1}.height+s)],50,(400-(walls{1}{1,1}.height+s)));
w{1}{1,1} = rectangle('Position',[walls{1}{1,1}.pos,walls{1}{1,1}.width,walls{1}{1,1}.height],'faceColor','white');
w{1}{1,2} = rectangle('Position',[walls{1}{1,2}.pos,walls{1}{1,1}.width,walls{1}{1,1}.height],'faceColor','white');
inputs = zeros(1,AI.numInputs);
action = zeros(1,AI.numOutputs);
 % ...................... Loop ..............................
count = 1;
while true
    if(choice1 == 1)
    crashed(ball,walls{1}{1,1}); %% Crash into walls
    %crashed(AIball,walls{1}{1,1});
    elseif(choice1 == 2)
    crashed(ball,walls{1}{1,1}); %% Crash into walls
    crashed(AIball,walls{1}{1,1});
    else
    %crashed(ball,walls{1}{1,1}); %% Crash into walls
    crashed(AIball,walls{1}{1,1});
    end
    % ------------- Wait 3 seconds before starting
    if(start)
        for i = 1:3
            str = string(4-i);
            title(str);
            pause(1); % Count 1 second
        end
        start = false;
        tic;
    end
    % --------------------------------------------
    
    if(choice1 ~= 1)
    % Calculate inputs for AI
        inputs(1) = AIball.vel(2)/10;
        inputs(2) = (walls{1}{1,1}.pos(1)+walls{1}{1,1}.width)/300;
        inputs(3) = (walls{1}{1,1}.height-AIball.pos(2))/50;
        inputs(4) = (walls{1}{1,2}.pos(2)-AIball.pos(2))/50;
        inputs(5) = AIball.pos(2)/400;
        action = AI.query(inputs');


        % --------------------- Motion of ball -------------
        if(action(1) < action(2))
            AIball.vel = [0,4.54];
        end
    end
    
    if(key == 1)
        ball.vel = [0,4.54];
        key = 0;
    end
    if(choice1 == 1)
%         AIball = AIball.applyForce([0,-0.25]);
%         AIball = AIball.ballUpdate();
%         set(AIb,'XData',AIball.pos(1),'YData',AIball.pos(2));
        delete(AIb);

        ball = ball.applyForce([0,-0.25]); % Apply gravity;
        ball = ball.ballUpdate();
        set(b,'XData',ball.pos(1),'YData',ball.pos(2)); % Ball
    elseif(choice1 == 2)
        AIball = AIball.applyForce([0,-0.25]);
        AIball = AIball.ballUpdate();
        set(AIb,'XData',AIball.pos(1),'YData',AIball.pos(2));

        ball = ball.applyForce([0,-0.25]); % Apply gravity;
        ball = ball.ballUpdate();
        set(b,'XData',ball.pos(1),'YData',ball.pos(2)); % Ball
    else
        AIball = AIball.applyForce([0,-0.25]);
        AIball = AIball.ballUpdate();
        set(AIb,'XData',AIball.pos(1),'YData',AIball.pos(2));

%         ball = ball.applyForce([0,-0.25]); % Apply gravity;
%         ball = ball.ballUpdate();
%         set(b,'XData',ball.pos(1),'YData',ball.pos(2)); % Ball
delete(b);
        
    end
    % ...................................................
    
    
    
 

    % .................Motion of walls --------------------------------
    
    for i = 1:length(walls)
        walls{i}{1,1} = walls{i}{1,1}.wallUpdate();
        walls{i}{1,2} = walls{i}{1,2}.wallUpdate();
        set(w{i}{1,1},'Position',[walls{i}{1,1}.pos,walls{i}{1,1}.width,walls{i}{1,1}.height]);
        set(w{i}{1,2},'Position',[walls{i}{1,2}.pos,walls{i}{1,2}.width,walls{i}{1,2}.height]);
    end
   
    % ........................................................................
    
    
    
    
    % -------------------------- Crash ---------------------------
    if(choice1 == 1)
        if((ball.pos(2)-20) <= 0 || (ball.pos(2)+20) >=ax.YLim(2))
            disp('................Game Over, you crashed........................');
            break;
        end
    end
    % -----------------------------------------------
    
    
    % ............................Game Over ..................
    if finished
        disp('................Game Over, you crashed........................');
        break;
    end
    
   % ................................................
 

      
     if toc >= 1.75*(fr/0.005)  % Make a new wall every two seconds     
        walls{end + 1}{1,1} = Wall([650,0],50,200*rand()); % Test ......................
        walls{end}{1,2} = Wall([walls{end}{1,1}.pos(1),(walls{end}{1,1}.height+s)],50,(ax.YLim(2)-(walls{end}{1,1}.height+s)));
        w{end + 1}{1,1} = rectangle('Position',[walls{end}{1,1}.pos,walls{end}{1,1}.width,walls{end}{1,1}.height],'faceColor','white');
        w{end}{1,2} = rectangle('Position',[walls{end}{1,2}.pos,walls{end}{1,1}.width,walls{end}{1,1}.height],'faceColor','white');
        tic
     end
    
     if walls{1}{1,1}.pos(1) <= - 50
         walls = walls(2:end);
         w = w(2:end);
         score = score + 1;
         clc;
         fprintf('Score: %d\n',score);
     end
     
    pause(fr);
    title('Go');
    
end
restart = input('Restart: 1.Yes   2.No\n');
switch restart
    case 1
        run;
    case 2
        fprintf('Your score is: \n')
        disp(score);
    otherwise
        error('Invalid choice');
end



% ------------------------- Functions ------------------------

function keyPressed(canvas,event)
    global key
    global finished
    
    switch event.Key
        case 'w'
            key = 1;
        case 'space'
            finished = true;
    end
    

end



function crashed(ball,wall)
    global finished
    global s
    global ax
    if(ball.pos(1)+15 >= wall.pos(1) & ball.pos(1)-15 <= (wall.pos(1)+wall.width))    %  wall.x<ball.x<(wall.x+wall.width
        if (ball.pos(2)+17 >= 0 & ball.pos(2)-15 <= wall.height) || (ball.pos(2)+17<=ax.YLim(2) & ball.pos(2)+15 >= (wall.height+s))
        finished = true;
        end
    end
end
    
    
    
    
    
    
    
