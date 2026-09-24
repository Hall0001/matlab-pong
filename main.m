%% Game of pong
% Edmund Hall

% The standard game of pong for two players 

function main
% Allows values of variables to be changed across functions

 global ball_speed_increase  player_movement_speed score_l score_r m RightUp RightDown LeftUp LeftDown


 %% User can change properties of game 
     % How quickly the ball speed increases after every hit
     ball_speed_increase = 1.04;

     % How far one button will move the bars (above 2.2 there will be
     % points on the axis not covered by the bars)
     player_movement_speed = 0.75;

     % Key binds for movement 
     RightUp = 'uparrow';
     RightDown = 'downarrow';
     LeftUp = 'w';
     LeftDown = 's';



% Initiating the game

    set_up
    ColourLoop_TransferToGame

% Game will run until stopped

%% Functions for the game

%% Sets up axis and background for welcome screen 
function set_up

% sets scores to 0
score_l = 0;
score_r = 0;

    % Sets fig colour to dark green, removes the menu bar, 
    % stops user from scrolling
    figure('Color','#006400', MenuBar='none',Scrollable='off');
    % Produces axis on figure 
    axis([-10,10,-10,10])
    % Hides values of Axis and sets graph to balck
    set(gca,'XTick',[],'YTick', [],'color','black')

    % Adds text to figure
    text(-5.6,4,'Pong','color','w','FontSize',100,'FontWeight','bold')
    text(-6,-2,'Press Space to start','color','w','FontSize',30)
    text(-1.3,-7,'Q to quit', 'color','w','FontSize',15)
    text(-2.5,-8,'H for how to play', 'color','w','FontSize',15)
end




%% Sets up a flashing loop until the user moves the game on
function ColourLoop_TransferToGame

% Sets the key binds of the current figure to the fucntion
% 'inital_key_binds'
set(gcf, 'KeyPressFcn', @inital_key_binds)

% Sets the value of 'Pressed' to the key pressed on the keyboard
Pressed = get(gcf,'CurrentKey');

% Creates a loop which repeats as long as space or q are not pressed
while ~ strcmp(Pressed,'space') & ~ strcmp(Pressed,'q') 

    % ColourChange function allows you to imput text and the colours you
    % want it to flash between 
    colourChange('Press Space to start',-6,-2.1,30,0.4,'w','black')

    % Only here to make sure colourChange function fully closes
    if strcmp(Pressed,'q')
        close all
    end
end


% Sets what the key binds do during the function ColourLoop_TransferToGame
% varargins (variable arguments) allows the function to accept a variable
% number of inputs (multiple different key presses)
    function inital_key_binds(varargin)
        Pressed = get(gcf,'CurrentKey');

        % If space is pressed
        if strcmp(Pressed,'space')
            % The game will start by clearing the current axis
            cla
            % Calling upon the render function bellow
            render
            % Displaying Game Started in Command window
            disp('Game Started')
            % Calling upon the gameplay0 function to intiate the game
            % 'm' Helps the game to quit without opening new figures
            m=0;
            gameplay0

        % If h is pressed    
        elseif strcmp(Pressed,'h')
            % Produces a message box with how to play 
            % Without closing the loop
            msgbox(["Simple game of Pong" ...
                " "...
                "2 players:" ...
                "Left hand block uses: " LeftUp LeftDown...
                " "...
                "Right hand block uses: " RightUp RightDown...
                " "...
                "If the ball hits the oppents side you score a point"]);

        % If q is pressed
        elseif strcmp(Pressed,'q')
            % The game will close displaying a Goodbye message
            close all
            msgbox('Goodbye')
            waitforbuttonpress
            close all

        end
    end
end




%% Creates the background for the game
function render 
hold on
% Produces text around the screen
text(-2.4,10.75,'Space to Restart','FontSize',15)
text(-10.65,12.25,'-','FontSize',275,'Color','black')
text(5.65,12.25,'-','FontSize',275,'Color','black')
text(-0.5,-10.75,'Q to quit','FontSize',10)

% Reads and displays the score of each side
% Converts the numbers to a string and displays it
score_lmsg = join(['Score = ',num2str(score_l)]);
text(-9.75,10.9,score_lmsg,'FontSize',15,'Color','b')
score_rmsg= join(['Score = ',num2str(score_r)]);
text(6.65,10.9,score_rmsg,'FontSize',15,'Color','r')

% Coordinates for boundary
pitch = [-9.9 -9.9 0 0 -9.9 9.9 9.9 0
    -9.9 9.9 9.9 -9.9 -9.9 -9.9 9.9 9.9];
% Coordinates for left boxes
boxleft = [-5 -5 0 -5 -5
    9.9 0 0 0 -9.9];
% Reflects left box using reflectShape
boxright = reflectShape(boxleft,'y');

% drawshape plots the coordiantes of the shapes
drawshape(pitch,'g')
drawshape(boxleft,'#4D4D4D')
drawshape(boxright,'#4D4D4D')
end




%% Controls the movement of bar and ball the interactions between them
function gameplay0
    
% Controls how much differnt areas of the bar change the balls direction
close_bb = 0.02;
far_bb = 0.04;


% Set key binds of the figure to a new function of 'Game_controls'
set(gcf, 'KeyPressFcn', @Game_controls);

% Initial X and Y coordinates of each bar
xCr = [9.5 9.8 9.8 9.5 9.5];
yCr = [-0.75 -0.75 0.75 0.75 -0.75];
xCl = [-9.8 -9.5 -9.5 -9.8 -9.8];
yCl = [-0.75 -0.75 0.75 0.75 -0.75];

% Plots initial position of bars
Rbar = plot(xCr, yCr,'r');
Lbar = plot(xCl,yCl,'b');

% Creates vectors of numbers for starting X and Y velocities 
xvel = [-0.1 0.1];
yvel = -0.1:0.005:0.1;

% Works out number of values in vector and randomly picks a value
nx = numel(xvel);
rnx = randi(nx);
xrand = xvel(rnx);

ny = numel(yvel);
rny = randi(ny);
yrand = yvel(rny);

pause(1)

% Plots the ball and gives it the initial velocity
BallVel= [xrand,yrand];
BallPos = [0,0];
Ball = line(BallPos(1),BallPos(2),'marker','.','markersize',20,'color','w');

% m=0 until q is pressed meaing while loop will run until quit
while ~ m==1




    % Flips balls Y velocity if the ball reaches the upper or lower limit
    % of axes
    if BallPos(2)<-9.6 || BallPos(2)>9.6
        BallVel(2) = -BallVel(2);
    end




    % If ball position reaches the left
    if BallPos(1) < -9.25
        % Y values of left bar retrived and centre of the bar worked out
        CYl = get(Lbar,'YData');
        limyl = CYl(1,1);
        BlockCenterL = (limyl+0.75);

        % Works out difference in Y value of ball and left bar centre
        ldif = (BallPos(2)-BlockCenterL);


        % If the absolute difference is less than 1.1
        if abs(ldif)<1.1
            % X velocity of ball reverses
            BallVel(1) = -BallVel(1)*ball_speed_increase;



            % If the ball hits the top middle of the bar
            if ldif<0.75 && ldif>0.25
                % If the ball is traveling up
                if BallVel(2)>0
                    % X velocity made more positive
                    BallVel(2) = BallVel(2)+close_bb;
                end
                % If the ball is traveling down
                if BallVel(2)<=0
                    % X velocity is reversed and made less positive
                    BallVel(2) = (BallVel(2)*-1)-close_bb;
                end
            end

            % If the ball hits the top of the bar
            if ldif<1.1 && ldif>=0.75
                % If the ball is traveling up
                if BallVel(2)>0
                    % X velocity made more positive
                    BallVel(2) = BallVel(2)+far_bb;
                end
                % If the ball is traveling down
                if BallVel(2)<=0
                    % X velocity is reversed and made less positive
                    BallVel(2) = (BallVel(2)*-1)+far_bb;
                end
            end


            % If the ball hits the bottom middle of the bar
            if ldif>-0.75 && ldif<-0.25
                % If the ball is traveling up
                if BallVel(2)>0
                    % X velocity is reversed and made less negative
                    BallVel(2) = (BallVel(2)*-1)+close_bb;
                end
                % If the ball is traveling down
                if BallVel(2)<=0
                    % X velocity and made more negative
                    BallVel(2) = BallVel(2)-close_bb;
                end
            end

            % If the ball hits the bottom of the bar
            if ldif>-1.1 && ldif<=-0.75
                % If the ball is traveling up
                if BallVel(2)>0
                    % X velocity is reversed and made less negative
                    BallVel(2) = (BallVel(2)*-1)-far_bb;
                end
                % If the ball is traveling down
                if BallVel(2)<=0
                    % X velocity and made more negative
                    BallVel(2) = BallVel(2)-far_bb;
                end
            end



        % If the ball hits anywhere else on the left
        else
            % Axis clear
            cla
            % Adds one to red score
            score_r = score_r +1;
            % Sets up again
            render
            gameplay0
        end
    end
    


    
    % If ball position reaches the right
    if BallPos(1)>9.25
        % Y values of left bar retrived and centre of the br worked out
        CYr = get(Rbar,'YData');
        limyr = CYr(1,1);
        BlockCenterR = (limyr+0.75);

        % Works out difference in Y value of ball and right bar centre
        rdif = (BallPos(2)- BlockCenterR);

        % If the absolute difference is less than 1.1
        if abs(rdif)<1.1
            % X velocity of ball reverses
            BallVel(1) = -BallVel(1)*ball_speed_increase;

                % If the ball hits the top middle of the bar
                if rdif<0.75 && rdif>0.25
                    % If the ball is traveling up
                    if BallVel(2)>0
                        % X velocity made more positive
                        BallVel(2) = BallVel(2)+close_bb;
                    end
                    % If the ball is traveling down
                    if BallVel(2)<=0
                        % X velocity is reversed and made less positive
                        BallVel(2) = (BallVel(2)*-1)-close_bb;
                    end
                end
                % If the ball hits the top of the bar
                if rdif<1.1 && rdif>=0.75
                    % If the ball is traveling up
                    if BallVel(2)>0
                        % X velocity made more positive
                        BallVel(2) = BallVel(2)+far_bb;
                    end
                    % If the ball is traveling down
                    if BallVel(2)<=0
                        % X velocity is reversed and made less positive
                        BallVel(2) = (BallVel(2)*-1)+far_bb;
                    end
                end


                % If the ball hits the bottom middle of the bar
                if rdif>-0.75 && rdif<-0.25
                    % If the ball is traveling up
                    if BallVel(2)>0
                        % X velocity is reversed and made less negative
                        BallVel(2) = (BallVel(2)*-1)+close_bb;
                    end
                    % If the ball is traveling down
                    if BallVel(2)<=0
                        % X velocity and made more negative
                        BallVel(2) = BallVel(2)-close_bb;
                    end
                end

                % If the ball hits the bottom of the bar
                if rdif>-1.1 && rdif<=-0.75
                    % If the ball is traveling up
                    if BallVel(2)>0
                        % X velocity is reversed and made less negative
                        BallVel(2) = (BallVel(2)*-1)-far_bb;
                    end
                    % If the ball is traveling down
                    if BallVel(2)<=0
                    % X velocity and made more negative
                        BallVel(2) = BallVel(2)-far_bb;
                    end
                end
        % If the ball hits anywhere else on the right        
        else
            % Axis clear
            cla
            % Adds one to red score
            score_l = score_l + 1;
            % Sets up again
            render
            gameplay0
        end
    end
% While the game is running the balls position is updated on the fig every 0.03
% seconds
if ~ m==1
    BallPos = BallPos + BallVel;
    set(Ball,'XData',BallPos(1),'YData',BallPos(2));
    pause(.03);
end
end








% Keyboard controls for Game
    function Game_controls(varargin)
        % Sets Pressedn to output of the key press
        Pressedn = get(gcf,'CurrentKey');
        % Uses switch as more efficient as it doesnt check which cases are
        % satisfied it only decides which case has to be executed
        switch Pressedn

            % If LeftUp key bind pressed
            case LeftUp
                % Current Y data for left bar retreived
                CoYl = get(Lbar,'YData');
                % limYl set to the bottom y coordinate of the bar
                limYl = CoYl(1,1);
                    % Stops the bar leaving the top of the axis 
                    if limYl > 8
                    else
                        % If within the axis the y values increase by the
                        % value set for player_movement_speed
                        set(Lbar,'YData',get(Lbar,'YData')+player_movement_speed)
                    end

            % If LeftDown key bind pressed        
            case LeftDown
                % Current Y data for left bar retreived
                CoYl = get(Lbar,'YData');
                % limYl set to the bottom y coordinate of the bar
                limYl = CoYl(1,1);
                    % Stops the bar leaving the bottom of the axis 
                    if limYl < -9.5
                    else
                        % If within the axis the y values decreases by the
                        % value set for player_movement_speed
                        set(Lbar,'YData',get(Lbar,'YData')-player_movement_speed)
                    end


            % If RightUp key bind pressed        
            case RightUp
                % Current Y data for right bar retreived
                CoUpYr = get(Rbar,'YData');
                % limYr set to the bottom y coordinate of the bar
                limYr = CoUpYr(1,1);
                    % Stops the bar leaving the top of the axis
                    if limYr > 8
                    else
                        % If within the axis the y values increases by the
                        % value set for player_movement_speed
                        set(Rbar,'YData',get(Rbar,'YData')+player_movement_speed);
                    end
            % If RightDown key bind pressed 
            case RightDown
                % Current Y data for right bar retreived
                CoDownYr = get(Rbar,'YData');
                % limYr set to the bottom y coordinate of the bar
                limYr = CoDownYr(1,1);
                    % Stops the bar leaving the bottom of the axis
                    if limYr < -9.5
                    else
                        % If within the axis the y values decreases by the
                        % value set for player_movement_speed
                        set(Rbar,'YData',get(Rbar,'YData')-player_movement_speed);
                    end


            % If Space pressed 
            case 'space'
                % Displays current score in Command Window
                score_message = ("Blue= "+ num2str(score_l)+"  Red= "+num2str(score_r));
                disp(score_message)
                % Clears axis and score
                cla
                score_l=0;
                score_r=0;
                % Displays 'new game'
                text(-5.5,4,'New Game','color','w','FontSize',50)
                pause (2)
                cla
                % Restarts the game 
                render
                gameplay0

            % If q is pressed
            case 'q'
                % While and if loop stopped
                m=1;
                close all
                % Message saying goodbye produced
                msgbox('Goodbye')
                % After button press the game closes 
                waitforbuttonpress
                close all
        end
    end
end



close all
end