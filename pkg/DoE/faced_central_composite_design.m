function fccd = faced_central_composite_design()
  a = perms([1 1 1], 'signs');
  b = perms([1 0 0],'unique');
  c = perms([-1 0 0],'unique');
  fccd = cat(1, a, b, c, zeros(10,3));
end
