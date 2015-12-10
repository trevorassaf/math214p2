function weather_state_idx = get_snowfall_state_index(precipitation_amounts, weather_states, day_idx)
  weather_state_idx = 1;

  % Precipitation transition matrix constants
  SNOW_STATE_TOKEN = 'snow';
  RAIN_TO_SNOWFALL_CONVERSION = 10;
  UPPER_SNOWFALL_TO_INDEX_DISPLACEMENT = 10;
  LOWER_SNOWFALL_TO_INDEX_DISPLACEMENT = 1;
  SNOWFALL_THRESHOLD = 1;
  MAX_SNOWFALL = 10;

  % Deterimine current weather state
  current_weather_state = lower(weather_states{day_idx});
  is_snowing = ~isempty(strfind(current_weather_state, SNOW_STATE_TOKEN));
 
  % Back-calculate index for the current weather state
  if is_snowing
    % Get amount of snowfall
    precipitation_amounts(day_idx);
    snowfall = str2double(precipitation_amounts(day_idx)) * RAIN_TO_SNOWFALL_CONVERSION;

    if snowfall > MAX_SNOWFALL
      snowfall = MAX_SNOWFALL;
    end

    if snowfall > SNOWFALL_THRESHOLD
      weather_state_idx = ceil(snowfall) + UPPER_SNOWFALL_TO_INDEX_DISPLACEMENT;
    else
      weather_state_idx = ceil(snowfall * 10) + LOWER_SNOWFALL_TO_INDEX_DISPLACEMENT;
      if weather_state_idx == 1
        weather_state_idx = 2;
      end
    end
  end
end
