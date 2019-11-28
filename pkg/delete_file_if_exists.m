function delete_file_if_exists(path, file_name, extension)
  path_file_extension = [path, file_name, '.', extension];
  
  if exist(path_file_extension, 'file') == 2
        delete(path_file_extension);
  end
  
end
