% Test if Octave is running
% See: https://wiki.octave.org/Compatibility

function r = is_octave()
    persistent IS_OCTAVE;
    if (isempty (IS_OCTAVE))
        IS_OCTAVE = exist('OCTAVE_VERSION', 'builtin');
    end
    r = IS_OCTAVE;
end
