function iccd = inscribed_central_composite_design()
  k = 3;
  alpha = (2^k)^(1/4);
  a = permn([-1 1], 3)*(1/alpha);
  b = perms([1 0 0],'unique');
  c = perms([-1 0 0],'unique');  
  iccd = cat(1, a, b, c, zeros(10,3));
end
