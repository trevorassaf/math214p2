% -------- Main Shit ---------%
FILE_NAMES = {'AnnArbor' 'Syracuse' 'PaloAlto'};

for i = 1:length(FILE_NAMES)
  file_name = FILE_NAMES{i};
  gen_temp_mat(file_name)
  gen_prcp_mat(file_name)
end
