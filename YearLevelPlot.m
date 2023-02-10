function [] = YearLevelPlot(file_name, time_period_num)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the year level data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'What university year level are you?')
            column_number = i;
            break
        end
    end
    
    %find column number with the timestamp data
    headings = table_raw.Properties.VariableDescriptions;
    date_column_number = -1;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Timestamp')
            date_column_number = i;
            break;
        end
    end

    dimensions = size(table);
    num_students = dimensions(1);
    year_levels = {'First year', 'Second year', 'Third year', 'Third year+', 'Masters', 'PhD', 'Other'};
    year_levels_count = zeros(1, length(year_levels)); %initialise the year level counters to zero
    num_students_time_period = 0; %counts the number of students that fall within the time period requested
    
    %count how many selected each option then total them
    for i = 1 : num_students
        %only count data that falls within the time period requested
        month_num = month(table{i, date_column_number});
        data_included = 1;
        if time_period_num == 1
            data_included = month_num >= 1 && month_num <= 6;
        elseif time_period_num == 2
            data_included = month_num >= 7 && month_num <= 12;
        end
        
        if data_included
            current_year_level = table{i, column_number};
            num_students_time_period = num_students_time_period + 1;
            for j = 1 : length(year_levels)
                if strcmp(current_year_level, year_levels{j})
                    year_levels_count(j) = year_levels_count(j) + 1;
                    break;
                end
            end
        end
    end
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_year_levels = {}; %initialise the cell array for the non-zero year levels
    year_level_proportions = [];
    for i = 1 : length(year_levels_count)
        if year_levels_count(i) ~= 0
            options_index = options_index + 1;
            final_year_levels{options_index} = year_levels{i};
            year_level_proportions(options_index) = (year_levels_count(i) / num_students_time_period) * 100;
        end
    end
    
    ordinal_final_year_levels = categorical(final_year_levels); %convert the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_year_levels = reordercats(ordinal_final_year_levels, final_year_levels);
    
    %plot the data
    colours = rand(length(ordinal_final_year_levels), 3); %generate the colours for the bars
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(year_level_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_year_levels, year_level_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(year_level_proportions) + 5, max(year_level_proportions) * 1.1])])]);
    text(1 : length(year_level_proportions),...
        year_level_proportions,...
        [num2str(year_level_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('What year level are you? (2021)');
    xlabel('Year level');
    ylabel('Percentage of students');
end