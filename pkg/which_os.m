function os = which_os()
    if ismac
        os = 'MAC';
    elseif isunix    
        os = 'Linux';
    elseif ispc
        os = 'Windows';
    else
        os = 'unknown OS';
    end
end
