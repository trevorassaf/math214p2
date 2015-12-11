% --------------- Intro ---------------- % 
% (importing, parsing, constants and shit)

% Read in data
raw_data = importdata('full_data.txt');
raw_data = raw_data.textdata;
dates = raw_data(:,1);
precipitation_amounts = raw_data(:,20);
weather_states = raw_data(:,22);

num_days = length(dates) - 1;

% Precipitation transition matrix contants
PRCP_NUM_STATES = 22;

% ------------ Main Shit -------------- %
% (actually assemble transition matrix)
prcp_matrix = zeros(PRCP_NUM_STATES);
weather_state_counts = zeros(PRCP_NUM_STATES, 1);

for current_day_idx = 2:num_days
  % Compute current weather state index
  current_weather_state_idx = get_snowfall_state_index(precipitation_amounts, weather_states, current_day_idx);

  % Compute 'tomorrow's' weather state index
  next_day_idx = current_day_idx + 1;
  next_weather_state_idx = get_snowfall_state_index(precipitation_amounts, weather_states, next_day_idx);

  % Increment count for current weather state
  weather_state_counts(current_weather_state_idx) = weather_state_counts(current_weather_state_idx) + 1;

  % Increment probability count in transition matrix, indexed by 'weather state index' 
  % for today and tomorrow
  prcp_matrix(next_weather_state_idx, current_weather_state_idx) = prcp_matrix(next_weather_state_idx, current_weather_state_idx) + 1;
end

% Compute probabilities by dividing each column in 'prcp_matrix' (our precipitation 
% transition matrix) by the corresponding entry in 'weather_states' (our counts 
% for the number of days with the corresponding weather state)
weather_state_counts
for weather_state_idx = 1:PRCP_NUM_STATES
  weather_state_count = weather_state_counts(weather_state_idx);
  if weather_state_count > 0
    prcp_matrix(:, weather_state_idx) = prcp_matrix(:, weather_state_idx) / weather_state_count;
  end
end
prcp_matrix
