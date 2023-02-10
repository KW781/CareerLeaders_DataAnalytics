function [] = AttendancePurposePlot(file_name, time_period_num)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the attendance purpose data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'What is your purpose for attending Drop-in?')
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
    purpose_options = {'CV check', 'Career advice', 'LinkedIn check', 'Cover letter check', 'Application form check'}; %store the different options for the purpose
    purpose_count = zeros(1, length(purpose_options)); %initialise purpose counters to zero
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
            current_purposes = split(table{i, column_number}, ', ');
            for j = 1 : length(current_purposes)
                match = 0; %initialise the match flag to false
                for k = 1 : length(purpose_options)
                    if strcmp(purpose_options{k}, current_purposes{j})
                        match = 1;
                        purpose_count(k) = purpose_count(k) + 1;
                        break; %exit the search for the current cateogory if a match was found
                    end
                end
                if ~match
                    other_count = other_count + 1; %increment other_count if no match was found
                end
            end
        end
    end
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_purpose_options = {}; %initialise cell array for final purpose options (ones where the count isn't zero)
    purpose_proportions = []; %initialise array for percentage of students choosing an option
    for i = 1 : length(purpose_count)
        if purpose_count(i) ~= 0
            options_index = options_index + 1;
            final_purpose_options{options_index} = purpose_options{i};
            purpose_proportions(options_index) = (purpose_count(i) / num_students) * 100;
        end
    end
    %add on the data for the category 'Other' if that was non-zero
    if other_count ~= 0
        options_index = options_index + 1;
        final_purpose_options{options_index} = 'Other';
        purpose_proportions(options_index) = (other_count / num_students_time_period) * 100;
    end
    
    ordinal_final_purpose_options = categorical(final_purpose_options); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_purpose_options = reordercats(ordinal_final_purpose_options, final_purpose_options);
    
    %plot the data
    colours = rand(length(ordinal_final_purpose_options), 3); %generate the colours for the bars
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(purpose_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_purpose_options, purpose_proportions, 'facecolor', 'flat');  
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(purpose_proportions) + 5, max(purpose_proportions) * 1.1])])]);
    text(1 : length(purpose_proportions),...
        purpose_proportions,...
        [num2str(purpose_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar    
    title('What is your purpose for attendance? (2021)');
    xlabel('Purpose');
    ylabel('Percentage of students');
end