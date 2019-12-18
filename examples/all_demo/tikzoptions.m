function tikz = tikzoptions()
  tikz.subplot          = 0;
  tikz.barplot          = 0;
  tikz.boxplot          = 0;
  tikz.texfilename      = 'texfilename';

  tikz.axisheight       = '10cm';
  tikz.axiswidth        = '10cm';

  tikz.makelegend       = 0;      % due to a problem (at least in Octave) there is a special regex for the the legend
  tikz.legend           = 'Variation1, Variation2, Variation3, Fit';
  tikz.legendpos        = '0,1';
  tikz.legendalign      = 'left';
  tikz.legendanchor     = 'north west';

  tikz.xprecision       = 0;
  tikz.yprecision       = 0;

  tikz.sloped           = 0;    % for 3D plots
  tikz.yticksonlyleft   = 1;    % show yticks on the left
  tikz.xticksonlybottom = 1;    % show xticks at the bottom
  tikz.decimalseperator = '.';  % can by any string including of course , and .
  tikz.thousandsep      = '';
  tikz.set_noSize       = true;

  tikz.customboxplotlegend = 0; % use predefined general legend entries for the boxplot
  tikz.manualcolorbarticks = 1; % colobar axis requiered (axis name is h and called with tikz.h in m2t_export)
end
