function cccd = circumscribed_central_composite_design(alpha)
  a = permn([-1 1], 3);
  b = perms([1 0 0], 'unique')*(alpha);
  c = perms([-1 0 0], 'unique')*(alpha);  
  cccd = cat(1, a, b, c, zeros(10,3));
end
