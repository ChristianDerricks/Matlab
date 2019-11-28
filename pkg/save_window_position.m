function save_window_position(config, idx)
  
  if exist(['window_position_and_size', '.mat']) == 2
    load(['window_position_and_size', '.mat']);
  end

  current_window_position_and_size = get(config{idx}.fig(idx), 'position');
 
  window_position_x(idx) = current_window_position_and_size(1);
  window_position_y(idx) = current_window_position_and_size(2);
  window_size_x(idx)     = current_window_position_and_size(3);
  window_size_y(idx)     = current_window_position_and_size(4);

  save(['window_position_and_size', '.mat'], 'window_position_x', ...
                                             'window_position_y', ... 
                                             'window_size_x',     ... 
                                             'window_size_y',     ...
                                             '-v7');
end
