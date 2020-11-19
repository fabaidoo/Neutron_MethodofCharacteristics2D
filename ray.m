function [r0, f] = ray(phi,h, plot_flag)
%Outputs starting point of rays on unit square as r0 along with the rays 
%themselves as functions. phi is the angle of slope and h is the spacing
%between rays

if nargin == 2
    plot_flag = false;   
end

if (phi > 0) && (phi < pi /2)
    x_hor = 0: (h / sin(phi)) : 1 ;
elseif (phi > pi/2) && (phi < pi)
    x_hor = 1: -h/sin(phi) : 0;
end

y_hor = zeros(1, length(x_hor));
r0_hor = [x_hor ; y_hor ];  %horizontal starting points

y_ver = 0: abs(h / cos(phi)) : 1;
if (phi > 0) && (phi < pi/2)
    x_ver = zeros(1, length(y_ver));   
elseif (phi > pi/2) && (phi < pi)
     x_ver = ones(1, length(y_ver)); 
else
    error('phi should be greater than 0 and less than pi (but not pi/2)')
end

r0_ver = [x_ver(2:end) ; y_ver(2:end)]; %vertical starting points

r0 = [r0_ver r0_hor];


f = cell(1, length(r0));
for i = 1 : length(r0)
   f{i}  = @(s) r0(:, i) + s .* [cos(phi) ; sin(phi)];
end


if plot_flag == true
   s = 0:.01:10;
   figure
  
   for i = 1: length(f)
      xy = f{i}(s);
      plot(xy(1, :), xy(2, :), '-k') 
      hold on
   end
   
   xlim([0 1])
   ylim([0 1])
    
end
    
    



end