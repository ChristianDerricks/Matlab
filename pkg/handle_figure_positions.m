function handle_figure_positions(config, idx)    
    h = load_window_position(idx);    
    
    set(config{idx}.fig(idx), 'Position', [h.window_position_x,  ...
                                           h.window_position_y,  ...
                                           h.window_size_x    ,  ...
                                           h.window_size_y]);

    set(config{idx}.fig(idx), 'CloseRequestFcn', {@my_closereq, config, idx});
end
