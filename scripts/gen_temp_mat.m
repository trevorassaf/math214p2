% --------------- Intro ---------------- % 
% (importing, parsing, constants and shit)

% Read in data
FILE_NAME = 'AnnArbor_Weather';
raw_data = importdata(strcat('../data/', FILE_NAME, '.txt'))
raw_data = raw_data.textdata;
dates = raw_data(:,1);
temperature_data = raw_data(:,3)

num_days = length(dates) - 1;

% Temperature transition matrix constants
TEMP_LOW = -10;
TEMP_HIGH = 80;
TEMP_INTERVAL_SIZE = 5;
NUM_TEMP_INTERVALS = (TEMP_HIGH - TEMP_LOW) / TEMP_INTERVAL_SIZE;

% ------------ Main Shit -------------- %
% (actually assemble transition matrix)
temp_matrix = zeros(NUM_TEMP_INTERVALS);
temp_interval_counts = zeros(NUM_TEMP_INTERVALS, 1);

for current_day_idx = 2:num_days
  % Compute current temperature state index
  current_temperature = str2double(temperature_data{current_day_idx});
  current_temperature_state_idx = ceil(current_temperature / TEMP_INTERVAL_SIZE) - TEMP_LOW / TEMP_INTERVAL_SIZE;

  % Correct for out-of-bounds index for 'current-temperature-state-idx'
  if current_temperature_state_idx < 1
    current_temperature_state_idx = 1;
  elseif current_temperature_state_idx > NUM_TEMP_INTERVALS
    current_temperature_state_idx = NUM_TEMP_INTERVALS;
  end

  % Compute 'tomorrow's' temperature state index
  next_day_idx = current_day_idx + 1;
  next_temperature = str2double(temperature_data{next_day_idx});
  next_temperature_state_idx = ceil(next_temperature / TEMP_INTERVAL_SIZE) - TEMP_LOW / TEMP_INTERVAL_SIZE;
  
  % Correct for out-of-bounds index for 'next-temperature-state-idx'
  if next_temperature_state_idx < 1
    next_temperature_state_idx = 1;
  elseif next_temperature_state_idx > NUM_TEMP_INTERVALS
    next_temperature_state_idx = NUM_TEMP_INTERVALS;
  end

  % Increment count for current temperature interval
  temp_interval_counts(current_temperature_state_idx) = temp_interval_counts(current_temperature_state_idx) + 1;

  % Increment probability count in transition matrix, indexed by 'temperature 
  % state index' for today and tomorrow.
  temp_matrix(next_temperature_state_idx, current_temperature_state_idx) = temp_matrix(next_temperature_state_idx, current_temperature_state_idx) + 1;
end

% Compute probabilities by dividing each column in 'temp_matrix' (our temperature 
% transition matrix) by the corresponding entry in 'temp_interval_counts' (our counts 
% for the number of days with the corresponding temperature state)
temp_interval_counts
for temp_interval_idx = 1:NUM_TEMP_INTERVALS
  temp_interval_count = temp_interval_counts(temp_interval_idx); 
  if temp_interval_count > 0
    temp_matrix(:, temp_interval_idx) = temp_matrix(:, temp_interval_idx) / temp_interval_count;
  end
end

% Find equilibrium distribution vector
equilibrium_distribution_matrix = temp_matrix^30;

% Display results
temp_matrix
equilibrium_distribution_matrix

% Write matrices

xlswrite(strcat('../results/', FILE_NAME, '.xls'), temp_matrix);
xlswrite(strcat('../results/', FILE_NAME, '_equilibrium.xls'), equilibrium_distribution_matrix);
