raw_data = importdata('test_data.txt');
raw_data = raw_data.textdata
dates = raw_data(:,1);
temperature = raw_data(:,3);
precipitation = raw_data(:,20);
events = raw_data(:,22);

precipitation_transition = zeros(20,20)

% Precipitation transition matrix constants
PRCP_NUM_STATES = 22;

% Generate threshold values for precipitation, 2 indexed
% see 'transition_matrix.txt' for more details
function [upper_bound lower_bound] = computePrecipitationBounds(index)
  if index < 12
    lower_bound = (index - 2) / 10;
    upper_bound = lower_bound + 0.1;
  else 
    lower_bound = index - 11; 
    upper_bound = lower_bound + 1;
  end
end

% Compute row probabilities in the precipitaiton transition matrix
for c = 1:PRCP_NUM_STATES
  % Compute thresholds for current weather state
  current_lower_bound = 0;
  current_upper_bound = 0;

  % Note: an index of 1 means that there is no snow, as in the snow 
  % weather state marker is absent from the text file
  if c > 1 
    current_bounds = computePrecipitationBounds(c);
    current_upper_bound = current_bounds(1);
    current_lower_bound = current_bounds(2);
  end

  for r = 1:PRCP_NUM_STATES
    % Compute thresholds for 'next day' weather states 
    next_lower_bound = 0;
    next_upper_bound = 0;

    % Note: an index of 1 means the same thing as above...
    if r > 1 
      next_bounds = computePrecipitationBounds(c);
      next_upper_bound = next_bounds(1);
      next_lower_bound = next_bounds(2);
    end

    % taking a break from this approach...

    
  end
end
