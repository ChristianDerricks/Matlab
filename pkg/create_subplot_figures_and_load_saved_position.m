function config = create_subplot_figures_and_load_saved_position(number_of_figures, number_of_axes)
  for idx = 1:number_of_figures
    config{idx} = fig_subplot_config(idx, number_of_axes);
    handle_figure_positions(config, idx);
  end
end
