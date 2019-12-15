This is a small collection of functions to make the work with Matlab and Octave a little easier when handling figures. There are also a few lines of code that help dealing with matlab2tikz. A standalone Tex file can be used immediately for bulding a PDF. In additon, for each figure an includeable version is also created that can be used within a LaTex document. There is also a Tex file that includes all includeable figure from an export and is ready for immediate build.

Workflow: Make your figure as usual in Matlab/Octave => export with `matlab2tikz` => compile the `.tex` document (by hand) => convert `.pdf` to `svg` and `.svg` to `.emf` with a small shell script. Figures will be available in three different vector formats useful for everyone. Everything, except making the figures of course, should be done in a few seconds and provide `.tex`, `.pdf`, `svg` and `.emf` files ready to use (in a thesis, as a standlone image, on a website, in PowerPoint or Word etc.).


Installation (must have)
========================

1. `Matlab` or `Octave`
2. `texlive-full`
3. `matlab2tikz` (see: https://github.com/matlab2tikz/matlab2tikz)

Installation (recommanded)
==========================

1. `texstudio`
2. `inkscape`
3. `pdf2svg`

Minimum Working Example (Octave)
================================

```
function mwe()
  initialize();           % a set of clear and load commands 

  number_of_figures = 1;  % number of figures
  number_of_axes    = 1;  % number of axed per figure

  config = create_figures_and_load_saved_position(number_of_figures, number_of_axes);

  tikz             = tikzoptions(); % a set of predefined options for matlab2tikz 
  tikz.texfilename = 'mwe';
  tikz.makelegend  = 1;
  tikz.legend      = 'Test Case';

  x = 1:1:200;
  y = 10*sin(x/(10*pi));
  plot(config{1}.ax(1), x, y, 'LineStyle', '--', 'LineWidth', 2);

  m2t_export(config{1}.ax(1), config{1}.fig(1), tikz.texfilename, num2str(1), tikz); 
end
```
As can be seen the `config{1}` stores information about the axis `config{1}.ax(1)` and figures `config{1}.fig(1)`. The index can be replaced with a variable (e.g. in a for loop). 
