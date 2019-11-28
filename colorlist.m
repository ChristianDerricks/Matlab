function colorlist = colorlist(varargin);

## Copyright (C) 2019 Christian Derricks
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Author: Christian Derricks
## Created: 2019-11-28

## -*- texinfo -*-
## @deftypefn  {} {} colorlist (@dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{Name}, @var{Value}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{colorbase}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{grayscale}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{grayscalesorted}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{invsort}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{numberofcolors}, @dots{})
## @deftypefnx {} {} colorlist (@dots{}, @var{showexample}, @dots{})
##
## Returns a list with colors that are distinguishable for people with  
## different color deficiencies or a single total color blindness. The general
## idea for such lists is to have a color universal design (CUD).
## 
## If @var{colorbase} is not set CUDjp will be used as default an return 8 colors.
##
## @multitable @columnfractions 0.05 0.05 0.9
## Items with x can be combined with @var{numberofcolors}
## @item -----------------------------------------------------------------------
## @item comb @tab noc   @tab colorbase
## @item -----------------------------------------------------------------------
## @item          @tab   8  @tab CUDjp
## @item @samp{x} @tab 255  @tab grayscale
## @item          @tab   8  @tab qualitative_colors_bright
## @item          @tab   5  @tab qualitative_colors_high_contrast
## @item          @tab   8  @tab qualitative_colors_vibrant
## @item          @tab  11  @tab qualitative_colors_muted
## @item          @tab  10  @tab qualitative_colors_light
## @item          @tab  11  @tab diverging_sunset
## @item          @tab   9  @tab diverging_BuRd
## @item          @tab   9  @tab diverging_PRGn
## @item          @tab   9  @tab sequential_YlOrBr
## @item          @tab  14  @tab sequential_iridescent
## @item @samp{x} @tab  23  @tab sequential_discrete_rainbow
## @item          @tab  33  @tab sequential_smooth_rainbow
## @item          @tab  14  @tab ground_cover
## @end multitable
##
## If @var{grayscale} is set to true the colors will be returned as grayscale.
## 
## If @var{grayscalesorted} is set to true the colors will be returned only sorted
## by their respective grayscale value but not in grayscale unless @var{grayscale} is also set to true.
##
## If @var{invsort} is set to true the list will be returned inverted.
##
## The @var{numberofcolors} option can be used for certain sets (like grayscale or 
## sequential_discrete_rainbow).
## A Warning messages will inform about problems.
##
## The option @var{'showexample', 1..n} returns a colorlist but also shows an example
##
## @seealso{pkg image}
## @seealso{https://jfly.iam.u-tokyo.ac.jp/color/}
## @seealso{https://personal.sron.nl/~pault/}
## @seealso{https://personal.sron.nl/~pault/data/colourschemes.pdf}
## @end deftypefn

  % in Octave the package image is required for grayscale conversion
  persistent IS_OCTAVE;
  if (isempty (IS_OCTAVE))
    IS_OCTAVE = exist('OCTAVE_VERSION', 'builtin');

    if IS_OCTAVE == 5
      
      [~, info] = pkg('list');
      pkglstpos = 0;
      
      for idx = 1:1:numel(info)
        if strcmp(info{idx}.name, 'image') == 1
          pkglstpos = idx;
        end
      end

      if pkglstpos == 0
        disp('package image not found');
      end

      if info{pkglstpos}.loaded == 0
        disp('package image found, but it is not loaded');
        disp('loading package automatically with: pkg load image');
        pkg load image;
      end
    end
  end

  default_colorbase       = 'CUDjp';
  default_grayscale       = false;
  default_grayscalesorted = false;
  default_invsort         = false;
  default_return_cell     = true;  % return colors in a matrix or a cell

  validcolorbase = {'CUDjp',                            ...
                    'grayscale'                         ...
                    'qualitative_colors_bright',        ...
                    'qualitative_colors_high_contrast', ...
                    'qualitative_colors_vibrant',       ...
                    'qualitative_colors_muted',         ...
                    'qualitative_colors_light',         ... 
                    'diverging_sunset',                 ...
                    'diverging_BuRd',                   ...
                    'diverging_PRGn',                   ...
                    'sequential_YlOrBr',                ...
                    'sequential_iridescent',            ... 
                    'sequential_discrete_rainbow',      ... % not suited to be interpolated
                    'sequential_smooth_rainbow',        ...
                    'ground_cover'
                    };

  % mod, floor and ceil are used as an integer test
  validScalarIntPosNum = @(x) isnumeric(x) && isscalar(x) && mod(x,1) == 0 && floor(x) == ceil(x) && (x >= 0);
  checkcolorbase       = @(x) any(validatestring(x, validcolorbase));

  p = inputParser;
  addParameter(p, 'colorbase',       default_colorbase,       checkcolorbase); 
  addParameter(p, 'grayscale',       default_grayscale,       @(x) isbool(x));
  addParameter(p, 'grayscalesorted', default_grayscalesorted, @(x) isbool(x));
  addParameter(p, 'invsort',         default_invsort,         @(x) isbool(x));
  addParameter(p, 'numberofcolors',  0,                       validScalarIntPosNum);
  addParameter(p, 'showexample',     0,                       validScalarIntPosNum);
  addParameter(p, 'return_cell',     default_return_cell,     @(x) isbool(x));

  parse(p, varargin{:});
  gss = p.Results.grayscalesorted;
  gs  = p.Results.grayscale;
  cb  = p.Results.colorbase;
  noc = p.Results.numberofcolors;
  ins = p.Results.invsort;
  ex  = p.Results.showexample;
  rnc = p.Results.return_cell;

  % if no number of colors is given use the following defaults
  if ismember('numberofcolors', p.UsingDefaults)
    if strcmp(p.Results.colorbase, 'CUDjp');                            noc =  8; end;
    if strcmp(p.Results.colorbase, 'grayscale');                        noc = 63; end;
    if strcmp(p.Results.colorbase, 'qualitative_colors_bright');        noc =  8; end;
    if strcmp(p.Results.colorbase, 'qualitative_colors_high_contrast'); noc =  5; end;
    if strcmp(p.Results.colorbase, 'qualitative_colors_vibrant');       noc =  8; end;
    if strcmp(p.Results.colorbase, 'qualitative_colors_muted');         noc = 11; end;
    if strcmp(p.Results.colorbase, 'qualitative_colors_light');         noc = 10; end;
    if strcmp(p.Results.colorbase, 'diverging_sunset');                 noc = 11; end;
    if strcmp(p.Results.colorbase, 'diverging_BuRd');                   noc =  9; end;
    if strcmp(p.Results.colorbase, 'diverging_PRGn');                   noc =  9; end;
    if strcmp(p.Results.colorbase, 'sequential_YlOrBr');                noc =  9; end;
    if strcmp(p.Results.colorbase, 'sequential_iridescent');            noc = 14; end;
    if strcmp(p.Results.colorbase, 'sequential_discrete_rainbow');      noc = 23; end; % as per definition of the possible sequenz (see far below)
    if strcmp(p.Results.colorbase, 'sequential_smooth_rainbow');        noc = 33; end;
    if strcmp(p.Results.colorbase, 'ground_cover');                     noc = 14; end;
  end

  % warning that the number of colors options has no meaning for qualitative, diverging and most of the sequential color schemes
  if (strcmp(p.Results.colorbase, 'CUDjp')                             || ...
      strcmp(p.Results.colorbase, 'qualitative_colors_bright')         || ...
      strcmp(p.Results.colorbase, 'qualitative_colors_high_contrast')  || ...
      strcmp(p.Results.colorbase, 'qualitative_colors_vibrant')        || ...
      strcmp(p.Results.colorbase, 'qualitative_colors_muted')          || ...
      strcmp(p.Results.colorbase, 'qualitative_colors_light')          || ...
      strcmp(p.Results.colorbase, 'diverging_sunset')                  || ...
      strcmp(p.Results.colorbase, 'diverging_BuRd')                    || ...
      strcmp(p.Results.colorbase, 'diverging_PRGn')                    || ...
      strcmp(p.Results.colorbase, 'sequential_YlOrBr')                 || ...
      strcmp(p.Results.colorbase, 'sequential_iridescent')             || ...
      strcmp(p.Results.colorbase, 'sequential_smooth_rainbow')            ...
      ) && !ismember('numberofcolors', p.UsingDefaults)
    warning(['>>numberofcolors<< has no meaning for colorbase >>', p.Results.colorbase, '<<'])
    disp('')
  end

  if strcmp(p.Results.colorbase, 'grayscale') && (noc > 255 || noc <= 0)
    warning(['numberofcolors ', num2str(noc), ' out of range; ', 'using 63 now as default'])
    noc = 63;
  end

  % if number of color option is combined with a color scheme that is not suited
  % set the default value and print a warning
  if !ismember('numberofcolors', p.UsingDefaults)
    if strcmp(p.Results.colorbase, 'qualitative_colors_high_contrast') && noc != 5
      warning('this color scheme is forced to return 5 colors');
      noc = 5;
    end

    if (strcmp(p.Results.colorbase, 'CUDjp')                      || ...
        strcmp(p.Results.colorbase, 'qualitative_colors_bright')  || ...
        strcmp(p.Results.colorbase, 'qualitative_colors_vibrant')    ...
        ) && noc != 8
      warning('this color scheme is forced to return 8 colors');
      noc = 8;
    end

    if (strcmp(p.Results.colorbase, 'diverging_BuRd')    || ...
        strcmp(p.Results.colorbase, 'diverging_PRGn')    || ...
        strcmp(p.Results.colorbase, 'sequential_YlOrBr')    ...
        ) && noc != 9
      warning('this color scheme is forced to return 9 colors');
      noc = 9;
    end

    if strcmp(p.Results.colorbase, 'qualitative_colors_light') && noc != 10
      warning('this color scheme is forced to return 10 colors');
      noc = 10;
    end

    if (strcmp(p.Results.colorbase, 'qualitative_colors_muted') || ...
        strcmp(p.Results.colorbase, 'diverging_sunset')            ...
        ) && noc != 11
      warning('this color scheme is forced to return 11 colors');
      noc = 11;
    end
    
    if strcmp(p.Results.colorbase, 'ground_cover') && noc != 14
      warning('this color scheme is forced to return 14 colors');
      noc = 14;
    end
  end  
  
  % sequential color schemes  
  if strcmp(p.Results.colorbase, 'sequential_iridescent') && noc != 23
    warning('this color scheme is forced to return 23 colors');
    noc = 23;
  end

  if strcmp(p.Results.colorbase, 'sequential_discrete_rainbow') && (noc > 23 || noc <= 0)
    warning('this color scheme is forced to return 23 colors');
    noc = 23;
  end

  if strcmp(p.Results.colorbase, 'sequential_smooth_rainbow') && noc != 33
    warning('>>numberofcolors<< out of range, using 33 as default')
    noc = 33;
  end

  if isempty(cb) || ismember('colorbase', p.UsingDefaults)
    cb = 'CUDjp';
  end
  disp('');

  switch cb
    case 'CUDjp'
      % Color Universal Design
      % see: https://jfly.iam.u-tokyo.ac.jp/color/
      % This is a list of eight colors that are distinguishable for people with 
      % every type of color vision deficiency (often misleadingly called colorblindness).
      % As general rule for plotting use thick lines and different symbols

      % The order of this list was chosen on the basis of four aspects
      % 1. use "nice" colors first (like blue, orange, bluish green, vermillion)
      % 2. avoid consecutive colors (e.g. orange and red or blue and sky blue
      % 3. use an order that will be somewhat distinguishable if converted to grayscale
      % (true for the first three colors and first two blocks color 1 to)
      % 4. consider color deficiency of video projectors (e.g. put yellow to the end)

      colorlist = {[ 50  50  50], ... % very dark gray     note: if you make a plot with a pure black frame you can see the difference, thats the idea
                   [  0 114 178], ... % blue   
                   [230 159   0], ... % orange
                   [  0 158 115], ... % bluish green
                   [213  94   0], ... % vermillion
                   [ 86 180 233], ... % sky blue
                   [204 121 167], ... % reddish purple
                   [240 228  66]  ... % yellow
                  };

    % grayscale color scheme (noc = 63 is equivalent to colormap(gray))
    case 'grayscale'
      colorlist = {[0 0 0]};
      for inx = 1:1:noc
        colorlist(inx) = {[inx/noc inx/noc inx/noc]};
      end
      
    % The following lists of colorblind-friendly colors are provided by Paul Tol
    % https://personal.sron.nl/~pault/
    % https://personal.sron.nl/~pault/data/colourschemes.pdf
    % as a personal preferance black is replaced with a very dark gray

    % qualitative color schemes
    case 'qualitative_colors_bright'
      colorlist = {[ 68 119 170], ... % blue
                   [102 204 238], ... % cyan
                   [ 34 136  51], ... % green
                   [204 187  68], ... % yellow
                   [238 102 119], ... % red
                   [170 51  119], ... % purple
                   [187 187 187], ... % gray
                   [ 50  50  50]  ... % very dark gray
                  };

    case 'qualitative_colors_high_contrast'
      colorlist = {[255 255 255], ... % white
                   [221 170  51], ... % yellow
                   [187  85 102], ... % red
                   [  0  68 136], ... % blue
                   [ 50  50  50]  ... % very dark gray
                  };

    case 'qualitative_colors_vibrant'
      colorlist = {[  0 119 187], ... % blue
                   [ 51 187 238], ... % cyan
                   [  0 153 136], ... % teal
                   [238 119  51], ... % orange
                   [204  51  17], ... % red
                   [238  51 119], ... % magenta
                   [187 187 187], ... % gray
                   [ 50  50  50]  ... % very dark gray
                  };

    case 'qualitative_colors_muted'
      colorlist = {[ 51  34 136], ... % indigo
                   [136 204 238], ... % cyan
                   [ 68 170 153], ... % teal
                   [ 17 119  51], ... % green
                   [153 153  51], ... % olive
                   [221 204 119], ... % sand
                   [204 102 119], ... % rose
                   [136  34  85], ... % wine
                   [170  68 153], ... % purple
                   [221 221 221], ... % pale gray
                   [ 50  50  50]  ... % very dark gray
                  };

    case 'qualitative_colors_light'
      colorlist = {[119 170 221], ... % light blue
                   [153 221 255], ... % light cyan
                   [ 68 187 153], ... % mint
                   [187 204  51], ... % pear
                   [170 170   0], ... % olive
                   [238 221 136], ... % light yellow
                   [238 136 102], ... % orange
                   [255 170 187], ... % pink
                   [221 221 221], ... % pale grey
                   [ 50  50  50]  ... % very dark gray
                  };

    % diverging color schemes
    case 'diverging_sunset'
      colorlist = {[ 54  75 154], ... %  1
                   [ 74 123 183], ... %  2
                   [110 166 205], ... %  3
                   [152 202 225], ... %  4
                   [194 228 239], ... %  5
                   [234 236 204], ... %  6
                   [254 218 139], ... %  7
                   [253 179 102], ... %  8
                   [246 126  75], ... %  9
                   [221  61  45], ... % 10
                   [165   0  38]  ... % 11
                  };

    case 'diverging_BuRd'
      colorlist = {[ 33 102 172], ... %  1
                   [ 67 147 195], ... %  2
                   [146 197 222], ... %  3
                   [209 229 240], ... %  4
                   [247 247 247], ... %  5
                   [253 219 199], ... %  6
                   [244 165 130], ... %  7
                   [214  96  77], ... %  8
                   [178  24  43]  ... %  9
                  };

    case 'diverging_PRGn'
      colorlist = {[118  42 131], ... %  1
                   [153 112 171], ... %  2
                   [194 165 207], ... %  3
                   [231 212 232], ... %  4
                   [247 247 247], ... %  5
                   [217 240 211], ... %  6
                   [172 211 158], ... %  7
                   [90  174  97], ... %  8
                   [27  120  55]  ... %  9
                  };

    % sequential color schemes
    case 'sequential_YlOrBr'
      colorlist = {[255 255 229], ... %  1
                   [255 247 188], ... %  2
                   [254 227 145], ... %  3
                   [254 196  79], ... %  4
                   [251 154  41], ... %  5
                   [236 112  20], ... %  6
                   [204  76   2], ... %  7
                   [153  52   4], ... %  8
                   [102  37   6]  ... %  9
                  };

    case 'sequential_iridescent'
      colorlist = {[254 251 233], ... %  1
                   [252 247 213], ... %  2
                   [245 243 193], ... %  3
                   [234 240 181], ... %  4
                   [221 236 191], ... %  5
                   [208 231 202], ... %  6
                   [194 227 210], ... %  7
                   [181 221 216], ... %  8
                   [168 216 220], ... %  9
                   [155 210 225], ... % 10
                   [141 203 228], ... % 11
                   [129 196 231], ... % 12
                   [123 188 231], ... % 13
                   [126 178 228], ... % 14
                   [136 165 221], ... % 15
                   [147 152 210], ... % 16
                   [155 138 196], ... % 17
                   [157 125 178], ... % 18
                   [154 112 158], ... % 19
                   [144  99 136], ... % 20
                   [128  87 112], ... % 21
                   [104  73  87], ... % 22
                   [ 70  53  58]  ... % 23
                  };

    case 'sequential_discrete_rainbow'
      colorlist = {[232 236 251], ... %  1
                   [217 204 227], ... %  2
                   [209 187 215], ... %  3
                   [202 172 203], ... %  4
                   [186 141 180], ... %  5
                   [174 118 163], ... %  6
                   [170 111 158], ... %  7
                   [153  79 136], ... %  8
                   [136  46 114], ... %  9
                   [ 25 101 176], ... % 10
                   [ 67 125 191], ... % 11
                   [ 82 137 199], ... % 12
                   [ 97 149 207], ... % 13
                   [123 175 222], ... % 14
                   [ 78 178 101], ... % 15
                   [144 201 135], ... % 16
                   [202 224 171], ... % 17
                   [247 240  86], ... % 18
                   [247 203  69], ... % 19
                   [246 193  65], ... % 20
                   [244 167  54], ... % 21
                   [241 147  45], ... % 22
                   [238 128  38], ... % 23
                   [232  96  28], ... % 24
                   [230  85  24], ... % 25
                   [220   5  12], ... % 26
                   [165  23  14], ... % 27
                   [114  25  14], ... % 28
                   [ 66  21  10], ... % 29
                   [119 119 119]  ... % 30
                  };

      sequenz = {[10],...
                 [10; 26], ...
                 [10; 18; 26],...
                 [10; 15; 18; 26],...
                 [10; 14; 15; 18; 26],...
                 [10; 14; 15; 17; 18; 26],...
                 [ 9; 10; 14; 15; 17; 18; 26],...
                 [ 9; 10; 14; 15; 17; 18; 23; 26],...
                 [ 9; 10; 14; 15; 17; 18; 23; 26; 28],...
                 [ 9; 10; 14; 15; 17; 18; 21; 24; 26; 28],...
                 [ 9; 10; 12; 14; 15; 17; 18; 21; 24; 26; 28],...
                 [ 3;  6;  9; 10; 12; 14; 15; 17; 18; 21; 24; 26],...
                 [ 3;  6;  9; 10; 12; 14; 15; 16; 17; 18; 21; 24; 26],...
                 [ 3;  6;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26],...
                 [ 3;  6;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26; 28],...
                 [ 3;  5;  7;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26; 28],...
                 [ 3;  5;  7;  8;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26; 28],...
                 [ 3;  5;  7;  8;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26; 27; 28],...
                 [ 2;  4;  5;  7;  8;  9; 10; 12; 14; 15; 16; 17; 18; 20; 22; 24; 26; 27; 28],...
                 [ 2;  4;  5;  7;  8;  9; 10; 11; 13; 14; 15; 16; 17; 18; 20; 22; 24; 26; 27; 28],...
                 [ 2;  4;  5;  7;  8;  9; 10; 11; 13; 14; 15; 16; 17; 18; 19; 21; 23; 25; 26; 27; 28],...
                 [ 2;  4;  5;  7;  8;  9; 10; 11; 13; 14; 15; 16; 17; 18; 19; 21; 23; 25; 26; 27; 28; 29],...
                 [ 1;  2;  4;  5;  7;  8;  9; 10; 11; 13; 14; 15; 16; 17; 18; 19; 21; 23; 25; 26; 27; 28; 29],...
                };

      for sqi = 1:1:noc
        colorlisttemp{sqi} = colorlist(sequenz{noc}(sqi)){:};
      end
      colorlist = colorlisttemp;
      
    case 'sequential_smooth_rainbow'
      colorlist = {[232 236 251], ... %  1
                   [221 216 239], ... %  2
                   [209 193 225], ... %  3
                   [195 168 209], ... %  4
                   [181 143 194], ... %  5
                   [167 120 180], ... %  6
                   [155  98 167], ... %  7
                   [140  78 153], ... %  8
                   [111  76 155], ... %  9
                   [ 96  89 169], ... % 10
                   [ 85 104 184], ... % 11
                   [ 78 121 197], ... % 12
                   [ 77 138 198], ... % 13
                   [ 84 158 179], ... % 14
                   [ 89 165 169], ... % 15
                   [ 96 171 158], ... % 16
                   [105 177 144], ... % 17
                   [119 186 125], ... % 18
                   [140 188 104], ... % 19
                   [166 190  84], ... % 20
                   [190 188  72], ... % 21
                   [209 181  65], ... % 22
                   [221 170  60], ... % 23
                   [228 156  57], ... % 24
                   [231 140  53], ... % 25
                   [230 121  50], ... % 26
                   [228  99  45], ... % 27
                   [223  72  40], ... % 28
                   [218  34  34], ... % 29
                   [184  34  30], ... % 30
                   [149  33  27], ... % 31
                   [114  30  23], ... % 32
                   [ 82  26  19]  ... % 33                   
                  };

    % special cases
    case 'ground_cover'
      colorlist = {[ 85 102 170], ... %  1  water
                   [ 17 119  51], ... %  2  evergreen needleleaf forest
                   [ 68 170 102], ... %  3  deciduous needleleaf forest
                   [ 85 170  34], ... %  4  mixed forest
                   [102 136  34], ... %  5  evergreen broadleaf forest
                   [153 187  85], ... %  6  deciduous broadleaf forest
                   [ 85 136 119], ... %  7  woodland
                   [136 187 170], ... %  8  wooded grassland
                   [170 221 204], ... %  9  grassland
                   [ 68 170 136], ... % 10  cropland
                   [221 204 102], ... % 11  closed shrubland
                   [255 221  68], ... % 12  open shrubland
                   [225 238 136], ... % 13  bare ground
                   [187   0  17]  ... % 14  urban and built
                  };
  end

  if strcmp(cb, 'grayscale') == false
    % convert the selected color list
    colorlist               = cellfun(@(x) x/255, colorlist, 'UniformOutput', false);
    % convert the selected color list to gray scale
    colorlist_grayscale     = cellfun(@rgb2gray,  colorlist, 'UniformOutput', false);
    % a copy of the orginal color list for later comparision
    colorlist_org           = colorlist;
    % a copy of the orginal color list in gray scale for later comparision
    colorlist_org_grayscale = cellfun(@rgb2gray,  colorlist, 'UniformOutput', false);

    % sort color list by gray scale value 
    [colorlist_grayscale_sorted, idx] = sortrows(cell2mat(colorlist_org_grayscale(:)), [1 ,2]);
    colorlist_grayscale_sorted = mat2cell(colorlist_grayscale_sorted, ones(noc, 1), 3);
    colorlist_grayscale_sorted = colorlist(:)(idx,:);
    colorlist_grayscale_sorted_gray = cellfun(@rgb2gray, colorlist_grayscale_sorted, 'UniformOutput', false);

    % output
    if gss == true
      colorlist = colorlist_grayscale_sorted;
    end

    if gs == true
      colorlist = colorlist_org_grayscale;
    end
    
    if gss == true && gs == true
      colorlist = colorlist_grayscale_sorted_gray;
    end

    if ins == true
      colorlist = flip(colorlist);
    end
  end

  % if needed, convert the colorlist from cell to matrix type
  if rnc == false
    colorlist = cell2mat(colorlist(:));
  end

  switch ex
  case 0
    break
  case 1
    colorlist = mat2cell(colorlist, ones(noc, 1), 3);    
    for i = 1:1:max(size(colorlist))
      rectangle('Position', [i 1     1 0.3], 'FaceColor', colorlist_org{i})
      rectangle('Position', [i 1-0.3 1 0.3], 'FaceColor', colorlist_org_grayscale{i})

      rectangle('Position', [i 2     1 0.3], 'FaceColor', colorlist_grayscale_sorted{i});
      rectangle('Position', [i 2-0.3 1 0.3], 'FaceColor', colorlist_grayscale_sorted_gray{i})
      
      % the resulting color list for the user
      rectangle('Position', [i 3     1 0.3], 'FaceColor', colorlist{i});
    end

    text(noc + 1.1, 2.15,'colorlist sorted by grayscale');
    text(noc + 1.1, 1.85,'colorlist sorted by grayscale in grayscale');
    text(noc + 1.1, 1.15,'colorlist');
    text(noc + 1.1, 0.85,'colorlist in grayscale');
    text(noc + 1.1, 3.15,'colorlist that is returned');
    xlim([0 5+round(3*noc/2)]);
    ylim([0 4]);
    set(gca, 'xTickLabel', [], 'yTickLabel', []);
    set(gca, 'visible','off')

  case 2
    x = 1:0.5:100;
    y = 1:0.5:100;
    [xx, yy] = meshgrid(x, y);
    colormap(colorlist);
    %z = 0.1*((xx-25).^2+(yy-25).^2);  
    %z = randi([0,30], 30, 30);
    z = sin(xx./5)+sin(yy./5); 

    surf(x,y,z, 'FaceColor', 'interp', 'LineStyle', 'none')
    %contourf(x,y,z,15)
    view([0,90])
    pbaspect([1 1 1]);

    set(gca, 'xTickLabel', [], 'yTickLabel', []);
    set(gca, 'visible','off')
  end
end
