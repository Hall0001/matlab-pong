function newShape = reflectShape(shape,axis)
% user decides which axis to reflect whape in 

    a=strcmpi(axis,'x');
    b=strcmpi(axis,'y');
    if a==true
        % Reflects shape in x axis
        % define matrix
        M=[1 0;0 -1] ;
        newShape=M*shape;
    elseif b==true
        % Reflects shape in y axis
        % define matrix
        M=[-1 0;0 1] ;
        newShape=M*shape;
    end
end