function config = create_figures_and_load_saved_position(number_of_figures, number_of_axes)
  # for standard plots (plot, plot2, surf, contourf, scatter etc.) use number_of_figures = n and number_of_axes = 1
  # for subplots use number_of_figures = 1 (or more) und number_of_axes = 2 (or more)
  # subplots created with this program are positioned in a single column and moved together so that there will be only a single x axis 

  for idx = 1:number_of_figures
    config{idx} = fig_config(idx, number_of_axes);
    handle_figure_positions(config, idx);
  end
end

function config = fig_config(fig_number, ax_number_per_fig)

  config.fig(fig_number) = figure(fig_number);

  if ax_number_per_fig == 1
    config.ax(1) = axes('parent', config.fig(fig_number));
    hold(config.ax(1), 'on');

    pbaspect(config.ax(1), [1 1 1]);
    colormap(config.ax(1), 'jet');

    grid(config.ax(1), 'on');
    grid(config.ax(1), 'minor', 'on');
    set(config.ax(1), 'GridLineStyle', '--');
    set(config.ax(1), 'TickDir', 'out');
    box(config.ax(1), 'on');    
    set(config.ax(1), "boxstyle", "full");
    set(config.ax(1), 'FontSize', 12);
  end

  if ax_number_per_fig >= 2
    for idx = 1:ax_number_per_fig
      config.ax(idx) = subplot(ax_number_per_fig, 1 ,idx);
      hold(config.ax(idx), 'on');

      grid(config.ax(idx), 'on');
      grid(config.ax(idx), 'minor', 'on');
      set(config.ax(idx), 'GridLineStyle', '--');
      set(config.ax(idx), 'TickDir', 'out');
      box(config.ax(idx), 'on');
      set(config.ax(idx), "boxstyle", "full"); % use 'full' or 'open'
      set(config.ax(idx), 'FontSize', 12);
    end
  end
end
