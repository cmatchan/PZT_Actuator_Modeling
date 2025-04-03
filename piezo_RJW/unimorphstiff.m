function    [k] = unimorphstiff(Qelastic,Qpiezo,layup,plyt,len,wid)

% returns the stifffness of a cantilever as whos length
% is len, width is wid, consisting of a piezo electric layer
% and a layup of plys, hos angles are defined in the vector 
% layup, whos thicknesses (including the thicknes of thepiezo layer)
% are given in the vector plyt).  Qelsastic and Qpiezo are vectors
% containing the elastic properties of both materials

k = len;