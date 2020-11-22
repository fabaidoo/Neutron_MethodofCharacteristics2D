# Neutron_MethodofCharacteristics2D
Uses Method of Characteristics to solve 2D box problem with a central inner isometric box source

meshcell.m : class containing properties of a meshcell in space as well as the method of characteristics method.
angle.m : function providing angular discretizations and weights
ray.m: function producing a set of parallel rays at a specified angle and spacing through the domain
s_finder.m : finds the intersection points of the mesh and a given ray
MethodOfCharacteristics.m : combines above functions and classes to produce plots of the solution

figs/ : contains plots 
