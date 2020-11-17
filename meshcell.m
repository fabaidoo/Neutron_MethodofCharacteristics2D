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
            else
                error('material type not available')
            end
            
        end
        
        
        
    end
        
        
end

