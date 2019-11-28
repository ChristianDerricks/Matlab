function initialize()

  clc;
  clear all;
  close all;
  more off;

  % set a path for functions in a global package folder or
  % otherwise use a local pkg folder for every program
  pkg_path      = '/home/user/Octave';
  use_local_pkg = 1;  % 0 no and 1 yes

  if use_local_pkg == 1
    addpath(genpath([pwd, filesep, 'pkg']))
    disp('using local pkg folder');
  else
    addpath(genpath([pkg_path, filesep 'pkg']))
    disp('using global pkg folder');
  end

  % for a universal exchange of programs between different operationg systems utf8 encoding 
  % is used (this is can be a problem if certain characters are used (e.g. ° or ħ)
  if strcmp(which_os(), 'Windows')
        feature('DefaultCharacterSet', 'UTF8');
  end

  % if running Octave additional packages are loaded
  if is_octave()

    graphics_toolkit qt;

    % on Windows:
    % 1. Download package from website
    % 2. pkg install PACKAGENAME.gz
    % 3. pkg list (to see all installed packages)

    % on Linux:
    % e.g. sudo apt-get install octave-PACKAGENAME

    pkg load io;          % https://octave.sourceforge.io/io/index.html
    pkg load statistics;  % https://octave.sourceforge.io/statistics/index.html
    pkg load struct;      % https://octave.sourceforge.io/struct/index.html
    pkg load optim;       % https://octave.sourceforge.io/optim/index.html
    pkg load symbolic;    % https://octave.sourceforge.io/symbolic/index.html
   % pkg load image
  end
end
