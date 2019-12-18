function initialize()

  clc;
  clear all;
  close all;
  more off;

  pkg_path      = '/media/Daten/Dokumente/Programme/Octave';
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
    Octave_or_Matlab = 'Octave';

    graphics_toolkit qt;

    % 1. Download package from website
    % 2. pkg install PACKAGENAME.gz
    % 3. pkg list (to see all installed packages)

    pkg load io;          % https://octave.sourceforge.io/io/index.html         2.4.10
    pkg load statistics;  % https://octave.sourceforge.io/statistics/index.html 1.3.0
    pkg load struct;      % https://octave.sourceforge.io/struct/index.html     1.0.14
    pkg load optim;       % https://octave.sourceforge.io/optim/index.html      1.5.2
    pkg load symbolic;    % https://octave.sourceforge.io/symbolic/index.html   2.7.1
  else
    Octave_or_Matlab = 'Matlab';
  end
  %disp(['running ', Octave_or_Matlab, ' on ', which_os()])
end
