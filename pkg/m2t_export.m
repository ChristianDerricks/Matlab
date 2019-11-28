function m2t_export(axis_name, fig_name, tex_name, iterator, tikz)

    set_xtick = regexprep(num2str(get(axis_name, 'xtick')), '\s+', ',');
    set_ytick = regexprep(num2str(get(axis_name, 'ytick')), '\s+', ',');
    
    % extraoptions
    set_extraAxisOptions = {};
    disp('')
    if isfield(tikz, 'xprecision') && tikz.xprecision >= 0
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['x tick label style={/pgf/number format/.cd, fixed, fixed zerofill, precision=', num2str(tikz.xprecision), ', /tikz/.cd}'];
                              ];
    end

    if isfield(tikz, 'yprecision') && tikz.yprecision >= 0
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['y tick label style={/pgf/number format/.cd, fixed, fixed zerofill, precision=', num2str(tikz.yprecision), ', /tikz/.cd}'];
                              ];
    end

    if isfield(tikz, 'sloped') && tikz.sloped == 1
      set_extraAxisOptions = [set_extraAxisOptions;    ...
                              'xlabel style={sloped}'; ...
                              'ylabel style={sloped}'; ...
                              ];
    end

    if isfield(tikz, 'subplot') && tikz.subplot == 0
      set_extraAxisOptions = [set_extraAxisOptions;         ...
                              ['xtick={', set_xtick , '}']; ...
                              ['ytick={', set_ytick , '}']; ...
                              ];

    end

    if isfield(tikz, 'subplot') && tikz.subplot == 1
      set_extraAxisOptions = [set_extraAxisOptions;         ...
                              'ylabel style={at={(-0.05, 0.25)}}',
                              ];
      disp('you must set the ylabel position manually (search for: ylabel style={at={(-0.05, 0.25)}}');
      disp('');
    end

    if isfield(tikz, 'yticksonlyleft') && tikz.yticksonlyleft == 1
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              'ytick pos=left';     ...
                              ];
    end

    if isfield(tikz, 'xticksonlybottom') && tikz.xticksonlybottom == 1
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              'xtick pos=bottom';   ...
                              ];
    end

    if isfield(tikz, 'decimalseperator')
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['/pgf/number format/.cd, set decimal separator={', tikz.decimalseperator, '}']; ...
                              ];
    end

    if isfield(tikz, 'thousandsep')
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['/pgf/number format/.cd, 1000 sep={', tikz.thousandsep, '}']; ...
                              ];
    end
    
    if isfield(tikz, 'legendpos') && isfield(tikz, 'legendanchor')
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['legend style={at={(', tikz.legendpos, ')}, anchor=', tikz.legendanchor, '}']; ...
                              ];
    end

    if isfield(tikz, 'legendalign')
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['legend cell align={', tikz.legendalign, '}']; ...
                              ];
    end

    if isfield(tikz, 'subplot') && tikz.subplot == 1
      set_noSize = false;
    else
      set_noSize = true;
    end
    
    if set_noSize == true
      if (isfield(tikz, 'axisheight') || isfield(tikz, 'axiswidth')) && isfield(tikz, 'subplot') && tikz.subplot == 0
        set_extraAxisOptions = [set_extraAxisOptions; ...
                                ['at={(0cm,0cm)}'];           ... %from pgf plot manual: The idea is to provide an <coordinate expression> where the axis will be placed. The axis anchor will be placed at <coordinate expression>.
                               ];
      disp('heigh and/or width are set manually, therefor ignore any related warning below');
      end

      if isfield(tikz, 'axisheight') && isfield(tikz, 'subplot') && tikz.subplot == 0
        set_extraAxisOptions = [set_extraAxisOptions; ...
                                ['height=', tikz.axisheight]; ...                              
                                ];
      end

      if isfield(tikz, 'axiswidth') && isfield(tikz, 'subplot') && tikz.subplot == 0
        set_extraAxisOptions = [set_extraAxisOptions; ...
                                ['width=', tikz.axiswidth]; ...
                                ];
      end
    end

    if isfield(tikz, 'boxplot') && tikz.boxplot == 1
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              'legend columns=2,';  ...
                              ];
    end

    if isfield(tikz, 'manualcolorbarticks') && isfield(tikz, 'h') && tikz.manualcolorbarticks == 1
      set_extraAxisOptions = [set_extraAxisOptions; ...
                              ['colorbar style={ytick={',regexprep(num2str(get(tikz.h, 'ytick')),'\s+',','),'}}']; ...
                              ];
    end 

    if isfield(tikz, 'boxplot') && tikz.boxplot == 1
      hidestandardlegend = '\pgfplotsset{/pgfplots/every axis plot post/.append style={forget plot}}%';
    else
      hidestandardlegend = '';
    end    

    % extra code (is only used for standalone tex files)
    set_extraCode = {'%!TEX TS-program = lualatex';     ... % might give a warning in yout Tex enviroment if used for the first time
                     '%!TeX encoding = utf8';           ...
                     '\RequirePackage{luatex85}';       ... % a compability fix for the standalone document class in case that luatex is used for pdf building (see: https://tex.stackexchange.com/questions/315025/lualatex-texlive-2016-standalone-undefined-control-sequence)
                     '\documentclass{standalone}';      ...
                     '\usepackage{pgfplots}';           ...
                     '\pgfplotsset{compat=newest}';     ...
                      hidestandardlegend;               ...
                     '\usepackage{amsmath}';            ...
                     '\usepackage{siunitx}';            ... % to parse formulas
                     '\usetikzlibrary{plotmarks}';      ...
                     '\usetikzlibrary{arrows.meta}';    ...
                     '\usepgfplotslibrary{patchplots}'; ...
                     '\usetikzlibrary{plotmarks}';      ...
                     '\usepackage{grffile}';            ...
                     '\begin{document}';                ...                   
                     };

    set_extraCodeAtEnd = {'\end{document}'};

    file = [tex_name, '_', num2str(iterator)];

    % remove the remnants of the past
    delete_old_files([fullfile(pwd, ['tikz', filesep, tex_name, filesep, 'standalone', filesep])], file);
    delete_old_files([fullfile(pwd, ['tikz', filesep, tex_name, filesep, 'includable', filesep])], file);

    disp(['saving files at: ', fullfile(pwd, ['tikz', filesep, tex_name, filesep])])
    disp('');

    % standalone
    subfolder = ['tikz', filesep, tex_name, filesep, 'standalone', filesep];
    tex_file_name_standalone = [subfolder, tex_name, '_', num2str(iterator), '.tex'];
    matlab2tikz('encoding',                 'UTF-8',                     ...
                'filename',                 tex_file_name_standalone,    ...
                'noSize',                   set_noSize,                  ...
                'showInfo',                 false,                       ...
                'parseStrings',             false,                       ...
                'figurehandle',             fig_name,                    ...
                'extraAxisOptions',         set_extraAxisOptions,        ...
                'extraCode',                set_extraCode,               ...
                'extraCodeAtEnd',           set_extraCodeAtEnd);
    disp(['saving file: ', tex_name, '_', num2str(iterator), ' (standalone)']);

    % includable
    subfolder = ['tikz', filesep, tex_name, filesep, 'includable', filesep];
    tex_file_name_includable = [subfolder, tex_name, '_', num2str(iterator), '.tex'];
    matlab2tikz('encoding',                 'UTF-8',                   ...
                'filename',                 tex_file_name_includable,  ...
                'noSize',                   set_noSize,                ...
                'showInfo',                 false,                     ...
                'parseStrings',             false,                     ...
                'figurehandle',             fig_name,                  ...
                'extraAxisOptions',         set_extraAxisOptions);
    disp(['saving file: ', tex_name, '_', num2str(iterator), ' (includable)']);

    disp('')    
    % special search and replace with regular expressions
    texfilenames = {tex_file_name_standalone, tex_file_name_includable};
    for str = texfilenames
      text_in_tex_file   = fileread(str{1});
      file_id_for_regex  = fopen(str{1}, 'w');

      % make certain that lualatex and utf8 encoding are used
      use_regexp_on_file = regexprep(text_in_tex_file, 'This file was created by matlab2tikz.', 'This file was created by matlab2tikz.%');

      % set fortget plot for all plots and ignore the settings
      %use_regexp_on_file = regexprep(use_regexp_on_file, 'usepackage{pgfplots}', 'usepackage{pgfplots}\n\\pgfplotsset{/pgfplots/every axis plot post/.append style={forget plot}}%');

      if isfield(tikz, 'makelegend') && tikz.makelegend == 1 
        use_regexp_on_file = regexprep(use_regexp_on_file, '\\end{axis}', ['\\legend{', tikz.legend, '}%\n' , '\\end{axis}']);
        if (!isfield(tikz, 'barplot') || tikz.barplot == 0) && (!isfield(tikz, 'boxplot') || tikz.boxplot == 0)
          use_regexp_on_file = regexprep(use_regexp_on_file, ', forget plot]', ']');
        end
      end

      % special legend for boxplots
      if not(isfield(tikz, 'barplot')) || tikz.barplot == 0
        if not(isfield(tikz, 'markersizedatapoints')) || not(isnumeric(tikz.markersizedatapoints))
          tikz.markersizedatapoints = 5;
          disp(['tikz.markersizedatapoints was set automatically to ', num2str(tikz.markersizedatapoints), 'pt due to a missing definition or wrong format']);
          disp('This can be ignored for scatter plots or plots without marks/points');
        end

        if not(isfield(tikz, 'markersizemeanvalues')) || not(isnumeric(tikz.markersizemeanvalues))
          tikz.markersizemeanvalues = 10;
          disp(['tikz.markersizedatapoints was set automatically to ', num2str(tikz.markersizemeanvalues), 'pt due to a missing definition or wrong format']);
          disp('This can be ignored for scatter plots or plots without marks/points');
        end
      end
      
      if isfield(tikz, 'boxplot') && tikz.boxplot == 1 && isfield(tikz, 'customboxplotlegend') && tikz.customboxplotlegend == 1
        set_boxplotlegend = [ '\\addlegendimage{only marks, black, mark=o, mark size=', num2str(tikz.markersizedatapoints/(4*sqrt(2))), 'pt}\n', ...
                              '\\addlegendentry{data within limit}\n',                                                                           ...
                              '\\addlegendimage{only marks, black, mark=*, mark size=', num2str(tikz.markersizemeanvalues/(4*sqrt(2))), '}\n',   ...
                              '\\addlegendentry{mean}\n',                                                                                        ...
                              '\\addlegendimage{only marks, black, mark=*, mark size=', num2str(tikz.markersizedatapoints/(4*sqrt(2))), 'pt}\n', ...
                              '\\addlegendentry{data outside limit}\n',                                                                          ...
                              '\\addlegendimage{line legend, red}\n',                                                                            ...
                              '\\addlegendentry{median}\n',                                                                                      ...
                              '\\addlegendimage{only marks, red,mark=+, mark size=2pt}\n',                                                       ...
                              '\\addlegendentry{light outliers}\n',                                                                              ...
                              '\\addlegendimage{only marks, red, mark=o, mark size=2pt}\n',                                                      ...
                              '\\addlegendentry{extrem outliers}\n',                                                                             ...
                              '\\addlegendimage{line legend, black, dashed}\n',                                                                  ...
                              '\\addlegendentry{upper limit}\n',                                                                                 ...
                              '\\addlegendimage{line legend, black, dotted}\n',                                                                  ...
                              '\\addlegendentry{lower limit}\n',                                                                                 ...
                              '\\end{axis}'                                                                                                      ...
                            ];
        use_regexp_on_file = regexprep(use_regexp_on_file, '\\end{axis}', set_boxplotlegend);
        use_regexp_on_file = regexprep(use_regexp_on_file, ', forget plot]', ']');
      end

      if isfield(tikz, 'barplot') && tikz.barplot == 1
        if isfield(tikz, 'legend') && isfield(tikz, 'makelegend') && tikz.makelegend == 1
          replace_with = ['\\legend{', tikz.legend, '}% \n\\end{axis}%'];
          use_regexp_on_file = regexprep(use_regexp_on_file, '\\end{axis}', replace_with);
          replace_with = '\\begin{tikzpicture} \n\\pgfplotsset{legend image code/.code={\\draw [#1] (0cm,-0.1cm) rectangle (0.6cm,0.1cm);},}'; % make a rectangular symbol for every property in the legend
          use_regexp_on_file = regexprep(use_regexp_on_file, '\\begin{tikzpicture}', replace_with);
        end
        use_regexp_on_file = regexprep(use_regexp_on_file, 'bar shift auto,', '%bar shift auto,');
        disp(['disabled >bar shift auto< in ', str{1}]);        
      end

      fprintf(file_id_for_regex, "%s", use_regexp_on_file);
      fclose(file_id_for_regex);
    end

    disp('done');
    disp('');
end

function delete_old_files(path, file)
  delete_file_if_exists(path, file, 'aux');
  delete_file_if_exists(path, file, 'log');
  delete_file_if_exists(path, file, 'synctex.gz');
  delete_file_if_exists(path, file, 'tex');
  delete_file_if_exists(path, file, 'pdf');
end
