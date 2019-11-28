This is a collection of functions to make the work with Matlab and Octave a little easier when it comes to figures and exporting them. There are also a few lines of code that help when dealing with matlab2tikz and some special needs.

Workflow: Make your figure as usual => export it with `matlab2tikz` => compile the `.tex` document => convert `.pdf` to `svg` and `.svg` to `.emf`. Figures will be available in different vector formats usefull for everyone. Everything, except making the figures, should be done in a few seconds and result in `.tex`, `.pdf`, `svg`, `.emf` files ready to use.


1. remember the last figure position of all figures if running the program again
2. automaticall build for all figures a working tex document as "standalone" and one as "includeable" while using a lot of custom changes (that a included as regex, horrible ... I know)


Installation (must have)
========================

1. `texlive-full`
2. `matlab2tikz` (see: https://github.com/matlab2tikz/matlab2tikz)

Installation (recommanded)
==========================

1. `texstudio`
2. `inkscape`
3. `pdf2svg`
