function [sch_time, sch_temperature] = generate_schedule(startTime, startTemp, phases)
    % Generate a temperature schedule based on defined phases.
    %
    % Parameters:
    %   startTime: datetime - Start time of the schedule.
    %   startTemp: double - Initial temperature in Celsius.
    %   phases: struct array - Array of phase configurations with fields:
    %       - rate: Temperature change rate (C/hour).
    %       - duration: Duration of the phase (datetime duration object).
    %
    % Returns:
    %   sch_time: datetime array - Time points in the schedule.
    %   sch_temperature: double array - Corresponding temperature values.
    
    sch_time = startTime;
    sch_temperature = startTemp;
    
    phase_colors = lines(length(phases)); % Generate unique colors for each phase
    
    figure;
    hold on;
    
    for i = 1:length(phases)
        % Extract phase parameters
        rate = phases(i).rate;
        duration = phases(i).duration;
        duration_hrs = hours(duration); % Convert duration to hours

        
        % Generate time vector and temperature for this phase
        phase_time = sch_time(end):seconds(1):(sch_time(end) + duration);
        phase_temp = sch_temperature(end) + rate * hours(phase_time - phase_time(1));
        
        % Append to schedule
        sch_time = [sch_time, phase_time(2:end)];
        sch_temperature = [sch_temperature, phase_temp(2:end)];
        
        % Plot this phase with a unique color
        plot(phase_time, phase_temp, 'LineWidth', 3, 'Color', phase_colors(i, :), 'DisplayName', sprintf('Rate: %d (°C/hr), Duration: %d:%d', rate, floor(duration_hrs), mod(minutes(duration), 60)));
    end
    
    % Add labels, title, and legend
    xlabel('Time');
    ylabel('Temperature (°C)');
    title('Temperature Schedule');
    legend('show','Location', 'best');
    grid on;
    hold off;
end
