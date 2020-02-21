function initialize()

  clc;              % Clear Command Window
  clear all;        % Clear all variables (including scope, persistent and global), scripts and functions 
  close all;        % Delete all figures
  close all hidden; % Delete all hidden figures
  close all force;  % Delete all figures, including those with altered CloseRequestFcn
  more off;         % Disable control paged output in Command Window

  % Set path for functions that are in a global
  % or in a local package folder.
  % Global means all programs use the same pkg folder while
  % local means that a copy is needed in the main folder of every program.
  % Note: Folder names that contain an @ character are ignored
  global_pkg_path = '/home/user/Octave';              % <-- Put your Octave location here
  use_local_pkg   = 0; % 0 no and 1 yes

  if use_local_pkg == 1
    addpath(genpath([pwd, filesep, 'pkg']))
    disp('using local pkg folder');
  else
    addpath(genpath([global_pkg_path, filesep 'pkg']))
    disp('using global pkg folder');
  end

  % For a universal exchange of programs between different operating systems utf8 encoding 
  % is forced to avoid problems if certain characters are used (e.g. ° or ħ).
  % Note: The function feature only works with Matlab
  if strcmp(which_os(), 'Windows') & !is_octave()
        feature('DefaultCharacterSet', 'UTF8');
  end

  % If running Octave additional packages are loaded
  if is_octave()

    graphics_toolkit qt; % used for making GUI with Octave

    % on Windows:
    % 1. Download package from website
    % 2. pkg install PACKAGENAME.gz
    % 3. pkg list (to see all installed packages)

    % on Linux:
    % e.g. sudo apt-get install octave-PACKAGENAME

%    pkg load io;          % https://octave.sourceforge.io/io/index.html
%    pkg load statistics;  % https://octave.sourceforge.io/statistics/index.html
%    pkg load struct;      % https://octave.sourceforge.io/struct/index.html
%    pkg load optim;       % https://octave.sourceforge.io/optim/index.html
%    pkg load symbolic;    % https://octave.sourceforge.io/symbolic/index.html
%    pkg load image
  end
end
