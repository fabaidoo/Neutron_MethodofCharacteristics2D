function info = MethodOfCharacteristics(meshnum, n_xy, n_z, h_ray)
innerbox = .1; % size of inner box with source
outerbox = 1; %size of outer box
material = 'scatterer'; %material in outer box 


%CREATE DOMAIN AND MESH
h = outerbox/meshnum; %meshsize
edges = 0: h : outerbox; %ALSO: linspace(0,outerbox, meshnum + 1)

cent = edges(1:meshnum) + diff(edges)/2; %coordinates of mesh elements

mesh = cell(meshnum); %mesh elements go here
for i = 1:meshnum
    for j = 1: meshnum
        center = [cent(i), cent(j)];
        x_dist = abs(cent(i) - outerbox/2);
        y_dist = abs(cent(j) - outerbox/2);
        if max(x_dist, y_dist) < innerbox/2
            mat = 'source';
        else
            mat = material;
        end
        mesh{i,j} = meshcell(mat, center, h);     
    end 
end

[theta, Oz, w_xy, w_z] = angle(n_xy, n_z); %angular discretization

lenxy = length(theta);
phi = zeros(meshnum, meshnum); %solution goes here

err = 50  ; %error in calculated phis
max_iter = 3e03; %break while loop after max_iter iterations 
iter = 0; %iteration count
tol = 1e-5;

while iter <= max_iter && err > tol 
    phi_ang = zeros(lenxy, meshnum, meshnum);
   
    for i = 1 : lenxy
       [rays, wid] = ray(theta(i), h_ray); %rays thru the domain
       len_ray = length(rays);
       for j = 1: len_ray
           r = rays{j}; %select a ray
           s = s_finder(r, meshnum); %intersection of rays and mesh
           ds = diff(s); %distance travelled through mesh
           psi_f = zeros(length(Oz), length(s)); % forward psi go here
           psi_b = zeros(length(Oz), length(s)); % backward psi go here
           
           %FIND MESH CELL THROUGH WHICH RAY SEGMENT PASSES
           s_mean = s(1:length(s) - 1) + ds / 2;
           R_half = r(s_mean) / h; %use discretize to find mesh indices
           
           %Forward sweep through ray
           for k = 1: length(ds)
               loc = discretize(R_half(:, k), 0:1:meshnum);  %location of meshcell
               if  (R_half(1, k) <= meshnum) && (R_half(1, k) >= 0)...
                       && (R_half(2, k) <= meshnum) && (R_half(2, k) >= 0)
                   m = loc(1);
                   n = loc(2);
               elseif  (R_half(1, k) > meshnum)
                   m = meshnum;
               elseif (R_half(1, k) < 0)
                   m = 1;
               elseif (R_half(2, k) > meshnum)
                   n = meshnum;
               elseif (R_half(2, k) < 0)
                   n = 1;
               end
               
               obj = mesh{m, n}; %meshcell the ray is passing thru
               
               [phi_ang_ray, psi_f( :, k+1)] = ...
                   obj.psi_ave(ds(k), psi_f(:,k), phi(m,n), Oz, w_z, w_xy ); 
                    
               phi_ang(i, m, n) = phi_ang(i, m, n) + phi_ang_ray*wid;
           end 
           
           %Backward sweep through ray
           for k = 1: length(ds)
               l = length(ds) + 1 - k;
               loc = discretize(R_half(:, l), 0:1:meshnum);
               if  (R_half(1, k) <= meshnum) && (R_half(1, k) >= 0)...
                       && (R_half(2, k) <= meshnum) && (R_half(2, k) >= 0)
                   m = loc(1);
                   n = loc(2);
               elseif  (R_half(1, k) > meshnum)
                   m = meshnum;
               elseif (R_half(1, k) < 0)
                   m = 1;
               elseif (R_half(2, k) > meshnum)
                   n = meshnum;
               elseif (R_half(2, k) < 0)
                   n = 1;
               end
               
               obj = mesh{m, n}; %meshcell the ray is passing thru
               
               [phi_ang_ray, psi_b(:, l)] = ...
                   obj.psi_ave(ds(l), psi_b(:,l + 1), phi(m,n), Oz, w_z, w_xy); 
                    
               phi_ang(i, m, n) = phi_ang(i, m, n) + phi_ang_ray * wid;
           end 
           
           
       end
    end
    
    phi_old = phi;
    phi = reshape(sum(phi_ang), [meshnum, meshnum] );
    
    err = norm(phi_old - phi, 'fro');
    iter = iter + 1;

    % 
   if iter == max_iter
       error('Maximum number of iterations reached before convergence. Error = %.6f', err)
   end
   
    if err > 5e07 
        disp(err)
        error('Solution is blowing up. iter = %i', iter)
      
   end
  %}    
end

info = sprintf('Error = %.3g  |  Iterations = %i', err, iter);

str = sprintf('%s | Space: %i cells/edge. | Angular: m_{xy} = %i, m_z = %i ', upper(material), meshnum,  n_xy, n_z);
figure
surf(cent, cent, phi)
xlabel('x')
ylabel('y')
zlabel('\phi(x,y)')
title(str)

phi_diag = diag(phi);
phi_bottom = phi(:, end);

figure
plot(cent, phi_diag, '.-', 'MarkerSize', 11, 'LineWidth', 1.5)
ylabel('\phi(x, x)')
xlabel('(x, x)')
title(str)

figure
plot(cent, phi_bottom, '.-r','MarkerSize', 11, 'LineWidth', 1.5)
xlabel('(x, 0)')
ylabel('\phi(x, 0)')
title(str)



end