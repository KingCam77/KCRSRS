%%Material Lookup
function Output = MaterialLookup(mat)
  switch mat
    case 'LOX'
      Density=1141;
    case 'LH2'
      Density=70.85;
  endswitch
Output=Density;
end
