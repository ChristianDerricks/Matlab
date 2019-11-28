This is a collection of functions to make the work with Matlab and Octave a little easier when it comes to figures and exporting them. There are also a few lines of code that help when dealing with matlab2tikz and some special needs.

The main goal is: Make your figure as usual => export it with `matlab2tikz` => compile the `.tex` document => convert `.pdf` to `svg` and `.svg` to `.emf`. In the end figures will be available in different vector formats usefull for everyone.


1. remember the last figure position of all figures if running the program again
2. automaticall build for all figures a working tex document as "standalone" and one as "includeable" while using a lot of custom changes (that a included as regex, horrible ... I know)


Installation (must have)
============

`texlive-full`

`matlab2tikz` (https://github.com/matlab2tikz/matlab2tikz)

Installation (recommanded)
============

`texstudio`
