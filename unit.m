function unit = unit(vector)
  %%Returns a unit vector from a supplied vector

    if norm(vector)==0
        unit = vector;
    else
        unit = vector/norm(vector);
    end
end
