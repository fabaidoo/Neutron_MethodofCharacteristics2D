function s = s_finder(f, meshnum, plot_flag)
%finds the value of s for which a ray (defined by function f)
%intersects various square meshcells of length 1/meshnum

if nargin == 2
    plot_flag = false;
    
end

h = 1 / meshnum; %length of meshcell

r0 = f(0) / h; %starting point rescaled by h;
O_hat = f(1) - f(0); %direction vector of ray
tan_phi = O_hat(2) / O_hat(1); %slope

bins = 0:1:meshnum; %edges of the meshcell

loc_x = discretize(r0(1), bins);  
loc_y = discretize(r0(2), bins); %location of r(0)

%determine if starting point is at bottom of outerbox or side of outerbox

if r0(2) == 0
    point_type = 'bottom';   
elseif (r0(1) == 0) || (r0(1) == meshnum)
    point_type = 'side';
end


if tan_phi > 0
    if strcmp(point_type, 'bottom')
        Nx = loc_x: 1:meshnum; %vertical mesh edges to the right x-starting point  
        t_y = (Nx(end) - r0(1)) * tan_phi;
        Ny = 0:1:t_y; %horizontal mesh edges below y-ending point
        
        s = zeros(1, length(Nx) + length(Ny)); %values of s go here
        for i = 1:length(Nx)
            r1 = [Nx(i) ; (Nx(i) - r0(1)) * tan_phi]; %intersection of vertical meshcell edge and ray
            
            s(i) = dot(O_hat, (r1 - r0) );
        end
        
        for i = 1: length(Ny)
            j = length(Nx) + i;
            r1 = [Ny(i)/tan_phi + r0(1) ; Ny(i)];%intersection of horizontal meshcell edge and ray
            
            s(j) = dot(O_hat, (r1 - r0) );
        end
        s = sort(s);
        
    elseif strcmp(point_type, 'side') 
        Ny = loc_y: 1: meshnum; %horizontal mesh edges above y-starting point
        t_x = (meshnum - r0(2)) / tan_phi;
        Nx = 0: 1: t_x; %vertical meshes to the left of x-ending point
       
        s = zeros(1,length(Nx) + length(Ny));
        for i = 1: length(Ny)
            r1 = [(Ny(i) - r0(2)) / tan_phi ; Ny(i)]; %intersection of ray with horizontal mesh edge
            s(i) = dot( (r1 - r0), O_hat);
        end
        
        for i = 1: length(Nx)
            j = length(Ny) + i;
            r1 = [Nx(i) ; Nx(i)*tan_phi + r0(2)]; %intersection of ray and vertical mesh edge
            
            s(j) = dot(O_hat, (r1 - r0));
        end
        s = sort(s);
        
    end
        
        
        
elseif tan_phi < 0
    if strcmp(point_type, 'bottom')
        Nx = (loc_x - 1): -1: 0; %vertical mesh edges to the left of x-starting point
        t_y = - r0(1) * tan_phi;
        Ny = 0: 1: t_y; %horizontal mesh edges below y-ending point
        
        s = zeros(1, length(Nx) + length(Ny));
        for i = 1:length(Nx)
           r1 = [Nx(i) ; (Nx(i) - r0(1)) * tan_phi ]; %intersection of ray and vertical mesh edge
           
           s(i) = dot( O_hat, (r1 - r0));
        end
        
        for i = 1: length(Ny)
            r1 = [ r0(1) + Ny(i) / tan_phi; Ny(i)]; %intersection of ray and horizonatal mesh edge
           
            j = length(Nx) + i;
            s(j) = dot( O_hat, (r1 - r0));
        end
        
        s = sort(s);
        
    elseif strcmp(point_type, 'side') 
        Ny = loc_y: 1: meshnum ; %horizontal edges above y-starting point
        t_x = (meshnum - r0(2)) / tan_phi;
        Nx = meshnum: -1: t_x; %vertical edges to the right of x-end point
        
        s = zeros(1, length(Nx) + length(Ny));
        for i = 1: length(Ny)
            r1 = [meshnum + (Ny(i) - r0(2))/tan_phi ; Ny(i)];
            
            j = length(Nx) + i;
            s(j) = dot( O_hat, (r1 - r0)); 
        end
        
        for i = 1: length(Nx)
            r1 = [Nx(i) ; r0(2) - (meshnum - Nx(i)) * tan_phi];
            
            s(i) = dot( O_hat, (r1 - r0));
        end
        s = sort(s);
        
    end
end

s = s * h; %rescale s to the true dimensions of the problem

 if plot_flag == true
     figure
     ax = gca;
     
     r1 = f(s);
     plot(r1(1,:), r1(2, :), '*r')
    
     ax.XTick = 0:h:1;
     ax.YTick = 0:h:1;
     grid
     xlim([0 1])
     ylim([0 1])
 end


 len = length(s);
 for i = 1: len
     j = len + 1 - i;
     r1 = f(s(j));
 
     if (r1(1) < eps ) || (r1(1) > 1 + eps) || (r1(2) > 1 + eps) || (r1(2) < eps) %check whether point is outside outerbox
         s = s(1: j-1); %delete offending point
     else
         break
     end
    
 end


 

 
 
 
end