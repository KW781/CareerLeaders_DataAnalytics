function [] = FoundOutMethodPlot(file_name, time_period_num)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the found out method data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'How did you find out about the Business School Careers?')
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
    methods = {'Business School Website', 'BizStudent Update (email)', 'Workshop or event', 'Plasma screen'};
    methods_count = zeros(1, length(methods)); %initialise method counters to zero
    other_count = 0; %count how many entries are 'other'
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
            num_students_time_period = num_students_time_period + 1;
            current_methods = split(table{i, column_number}, ', ');
            for j = 1 : length(current_methods)
                match = 0; %initialise the match flag to false
                for k = 1 : length(methods)
                    if strcmp(current_methods{j}, methods{k})
                        match = 1;
                        methods_count(k) = methods_count(k) + 1;
                        break; %exit the search for the current category if a match was found
                    end
                end
                if ~match
                    other_count = other_count + 1; %increment other count if no match was found
                end
            end
        end
    end
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_methods = {}; %initialise the cell array for the final non-zero methods selected
    method_proportions = []; %initialise the array for the non-zero percentages of students selecting a method
    for i = 1 : length(methods_count)
        if round((methods_count(i) / num_students_time_period) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_methods{options_index} = methods{i};
            method_proportions(options_index) = round((methods_count(i) / num_students_time_period) * 100, 2);
        end
    end
    %add on the category of 'other' if that was non-zero
    if round((other_count / num_students_time_period) * 100, 2) ~= 0
        options_index = options_index + 1;
        final_methods{options_index} = 'Other';
        method_proportions(options_index) = round((other_count / num_students_time_period) * 100, 2);
    end
    
    ordinal_final_methods = categorical(final_methods); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_methods = reordercats(ordinal_final_methods, final_methods);
    
    %plot the data
    colours = rand(length(ordinal_final_methods), 3); %generate the colours for the bars
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(method_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_methods, method_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(method_proportions) + 5, max(method_proportions) * 1.1])])]);
    text(1 : length(method_proportions),...
        method_proportions,...
        [num2str(method_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('How did you find out about us?');
    xlabel('How found out');
    ylabel('Percentage of students');
end