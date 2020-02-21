function load_package_if_installed(loadpackage)

  % This program can load existing installed packages and give hints if there is no match.
  % There ia also a comparison with the packages available on Octave Forge and possible mispell.
  
  % Requierments: EditDistance(string1,string2) from Reza Ahmadzadeh at MATLAB Central File Exchange (https://www.mathworks.com/matlabcentral/fileexchange/39049-edit-distance-algorithm)

  % Use 1: load_package_if_installed('statistics')
  % Use 2: load_package_if_installed('stathistics')

  % The "persistent" variable and the first "if" function is used for compatibility
  % between Matlab and Octave. See: https://wiki.octave.org/Compatibility
  % The code below is only executed if Octave is used.
  persistent IS_OCTAVE;
  if (isempty (IS_OCTAVE)) & ischar(loadpackage)
    IS_OCTAVE = exist('OCTAVE_VERSION', 'builtin');

    % Abort if EditDistance is not present
    if exist('EditDistance') != 2
      disp('Function EditDistance is requiered!')
      disp('Download from File Exchange: https://www.mathworks.com/matlabcentral/fileexchange/39049-edit-distance-algorithm')
      disp('')
      break  
    end

    if IS_OCTAVE == 5

      [~, info] = pkg('list');  % get a list with installed packages
      pkglstpos = 0;            % variable for package list position, will use 0 for no package with that name found 

      % Search for the package position in the package list.
      % Note: A "for" loop instead of "while" loop is preferred here to make easy use of the index and
      % to avoid additional checking in case no match is found. Also, there is only a very short list 
      % expected here and this not time critical.
      for idx = 1:1:numel(info)
        if strcmp(info{idx}.name, loadpackage) == 1 % compare the name of every entry in the list with the wanted package name
          pkglstpos = idx;
        end
      end

      % If there is no match, display a warning and search for packages from Octave Forge with similar names.
      % Note that this would take some time (the command pkg ("list", "-forge") is slow), however, a list of 
      % possibilities has been saved in the variable oct_forge_pkgs. Consider that this list might be outdated.
      if pkglstpos == 0
        disp(['The package ', loadpackage, ' was not found.']);
        disp('')

        % use oct_forge_pkgs = pkg ("list", "-forge") to display the list (might take a minute or two)
        oct_forge_pkgs = {'arduino';'audio';'bim';'bsltl';'cgi';'communications';'control';'data-smoothing';'database';'dataframe';'dicom';
                          'divand';'doctest';'econometrics';'fem-fenics';'financial';'fits';'fpl';'fuzzy-logic-toolkit';'ga';'general';'generate_html';
                          'geometry';'gsl';'image';'image-acquisition';'instrument-control';'interval';'io';'level-set';'linear-algebra';'lssa';
                          'ltfat';'mapping';'matgeom';'miscellaneous';'msh';'mvn';'nan';'ncarray';'netcdf';'nurbs';'ocl';'ocs';'octclip';'octproj';
                          'optics';'optim';'optiminterp';'parallel';'quaternion';'queueing';'secs1d';'secs2d';'secs3d';'signal';'sockets';
                          'sparsersb';'splines';'statistics';'stk';'strings';'struct';'symbolic';'tisean';'tsa';'vibes';'video';'vrml';
                          'windows';'zeromq'};

        % This part uses the EditDistance function to return a vector of numbers with possible matches.
        % Low numbers mean a small distance and a good match.
        for idx = 1:1:max(size(oct_forge_pkgs))
          [V, v] = EditDistance(loadpackage,oct_forge_pkgs{idx,1});
          distances(idx) = V;
        end
        %singlebestmatchpos = find(distances == min(distances))
 
        % The code below is used to extracted the closest three matches.
        % More possibilities might be returned due to a same distance.
        bestmatches = '';
        for idx = 1:1:3
          bestmatchpos = find(distances == sort(distances)(idx));
          if min(size(bestmatchpos)) == max(size(bestmatchpos))
            bestmatches = [bestmatches, oct_forge_pkgs{bestmatchpos,1}, ', '];
          else
            % In case there is more than one match for a given distance another loop is requiered
            for inx = 1:1:max(size(bestmatchpos))
              % Avoid double output
              if (strfind(bestmatches, oct_forge_pkgs{bestmatchpos(1,inx),1}) >= 0)
                
              else
                bestmatches = [bestmatches, oct_forge_pkgs{bestmatchpos(1,inx),1}, ', '];
              end
            end
          end
        end
        disp(['Your input >>', loadpackage, '<< has similarities to the following known packages from Octave Forge:'])
        disp(bestmatches(1:(max(size(bestmatches))-2)))
        disp('')  
        disp(['Check spelling or use >>pkg install ', loadpackage,'<< to install the missing package.'])
      elseif info{pkglstpos}.loaded == 0
        disp(['Found a package with name >>', loadpackage, '<<, but it is not yet loaded.']);
        disp(['Loading package >>', loadpackage, '<< now.']);
        pkg('load', loadpackage);
      elseif info{pkglstpos}.loaded == 1
        disp(['package >>', loadpackage, '<< is installed and already loaded']);
      end
      disp('')
    end
  end
end
