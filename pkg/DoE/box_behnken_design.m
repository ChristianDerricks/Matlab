function bbd = box_behnken_design()
  a = perms([0 -1 1], 'signs','unique');
  b = perms([-1 0 1], 'signs','unique');
  c = perms([-1 1 0], 'signs','unique');
  bbd = cat(1, a, b, c, zeros(10,3));
end
