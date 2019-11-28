function my_closereq(~, ~, config, idx)
  save_window_position(config, idx);
  delete(config{idx}.fig(idx));
end
