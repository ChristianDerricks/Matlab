function example_for_auto_include_all_tex_files()
  % This example creates 4 figures that are exported with matlab2tikz.
  % There will be 4 standalone and 4 includeable .tex files plus one ready to use
  % all_tikz.texfilename.tex file with all includeable figures called.

  initialize(); 
  color = colorlist();

  number_of_figures = 4;
  number_of_axes    = 1;

  config = create_figures_and_load_saved_position(number_of_figures, number_of_axes);

  % some settings tikz figures
  tikz = tikzoptions();

  tikz.texfilename = 'Demo_auto_include';
  tikz.xprecision = 0;
  tikz.yprecision = 2;
  tikz.set_noSize  = true;
  tikz.axisheight  = '10cm';
  tikz.axiswidth   = '10cm';


  tikz.legendpos        = '0,1';
  tikz.legendalign      = 'left';
  tikz.legendanchor     = 'north west';  

  x = 1:1:100;
  % Marker size is a problem. There is difference between Matlab, Octave and Tikz.
  markersize = 5;

  line(   config{1}.ax(1), x, sin(x/10),                                'Color', color{2}, 'LineWidth', 1)
  line(   config{1}.ax(1), x, cos(x/10),                                'Color', color{3}, 'LineWidth', 3, 'LineStyle', '--')
  scatter(config{2}.ax(1), x, sin(x/10),          markersize, 'MarkerEdgeColor', color{4})
  scatter(config{3}.ax(1), x, x./100,             markersize, 'MarkerEdgeColor', color{5})
  scatter(config{4}.ax(1), x, -0.001*(x-50).^2+1, markersize, 'MarkerEdgeColor', color{6})

  for idx = 1:number_of_figures
    xlim(config{idx}.ax(1), [-5 105]);
    ylim(config{idx}.ax(1), [-1.2 1.2]);

    xlabel(config{idx}.ax(1), 'variable x');
    ylabel(config{idx}.ax(1), 'response y');
  end

  for idx = 1:number_of_figures
    switch idx
      case 1
        tikz.makelegend       = 1;
        tikz.legend           = 'sin(x), cos(x)';
      case 2
        tikz.makelegend       = 1;
        tikz.legend           = 'sin(x)';
      case 4
        tikz.makelegend       = 1;
        tikz.legend           = '$-\\frac{(x-50)^2}{1000}+1$'; % note the extra \ to escape the \
      otherwise
        tikz.makelegend       = 0; % no legend for number 3
    end
    m2t_export(config{idx}.ax(1), config{idx}.fig(idx), tikz.texfilename, num2str(idx), tikz);
  end
  save_all_images_in_one_tex_file(tikz.texfilename, number_of_figures);
end
