function [h] = load_window_position(fig)
  try
    if exist(['window_position_and_size', '.mat']) == 2
      load(['window_position_and_size', '.mat']);
      if max(size(window_position_x)) >= fig && max(size(window_position_y)) >= fig
          disp('found fig position')
          h.window_position_x = window_position_x(fig);
          h.window_position_y = window_position_y(fig);
          h.window_size_x     = window_size_x(fig);
          h.window_size_y     = window_size_y(fig);
      else
          disp('no fig position found, loading default window position');
          h = get_default_figure_position;
      end
    else
      disp('no file found, loading default window position');
      h = get_default_figure_position;
    end
  catch
      disp('unknown problem, loading default window position');
      h = get_default_figure_position;
  end
end

function h = get_default_figure_position
  dfp = get(0,'defaultfigureposition');
  h.window_position_x = dfp(1);
  h.window_position_y = dfp(2);
  h.window_size_x     = dfp(3);
  h.window_size_y     = dfp(4);
end
