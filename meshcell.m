classdef meshcell
    %CONSTITUENT MESH ELEMENT 
    % Must be made of one type of material. Class holds material 
    %properties as well as location in space.
    
    properties
        sig_t = 0; %TOTAL CROSS-SECTION
        sig_s = 0; %SCATTERING CROSS-SECTION (0TH MOMENT)
        Q = 0; %SOURCE TERM (0TH MOMENT)
        
        center = [0 0]; %LOCATION OF CENTER OF SQUARE ELEMENT
        sidelength = 1; %LENGTH OF SQUARE ELEMENT
        
        material = 'source'; %TYPE OF MATERIAL. Helpful for debugging
    end
    
    methods
        function obj = meshcell(material,center, sidelength)
            %Specify type of material and location in space.
            if nargin == 1
                obj.material = material;
            elseif nargin == 3
                obj.material = material;
                obj.center = center;
                obj.sidelength = sidelength;
            end
            
            if strcmpi(obj.material, 'source') == 1
                obj.sig_t = 0.1;
                obj.Q = 1;
            elseif strcmpi(obj.material, 'scatterer') == 1
                obj.sig_t = 2;
                obj.sig_s = 1.99;
            elseif strcmpi(obj.material, 'reflector') == 1
                obj.sig_t = 2;
                obj.sig_s = 1.8;
            elseif strcmpi(obj.material, 'absorber') == 1
                obj.sig_t = 10;
                obj.sig_s = 2;
            elseif strcmpi(obj.material, 'air') == 1
                obj.sig_t = 0.01;
                obj.sig_s = 0.006;
            elseif strcmpi(obj.material, 'test') == 1
                obj.sig_t = 10;
                obj.sig_s = 0;
            else
                error('material type not available')
            end
            
        end
        
        function [psibar_contrb, psi_out ] = psi_ave(obj, ds, psi_in, phi_old, Oz, w_z, w_xy)
            %calculates average psi contribution due to a ray of length ds 
            %through the cell at angle theta.Iterates through the z-axis
            %directions
            
            %psi_bar = 0;
            
            Qnew = obj.Q +  0.5 * obj.sig_s .* phi_old;
            S = Qnew / obj.sig_t;
            
            tau = obj.sig_t * ds ./ Oz;
            
            psi_z = w_z .* (psi_in .* obj.f(tau) + S .* (1 - obj.f(tau)));
            
            psibar_contrb = sum(psi_z) * w_xy;
            
            psi_out = psi_in .* exp(-tau) + S .* (1 - exp(- tau));
            
            
            
        end
        
        
    end
    
   methods(Static)
       
       function y = f(tau)
            if abs(tau) < 0.05
                y = 1 - tau ./ 2;
            else
                y = (1 - exp(- tau) ) ./ tau ;   
            end
            
            
        end
        
       
       
   end
    
  
    
        
        
end

