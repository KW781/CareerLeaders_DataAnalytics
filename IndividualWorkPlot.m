function [] = IndividualWorkPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the individual work data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Individual work: Please rate the value of each activity. If you did not submit, please select N/A.')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %create the individual activities cell array and the counters for them
    activities = {'Creating a CV and cover letter', 'Creating a LinkedIn profile',...
                  'Conducting an informational interview', 'Submitting reflective journals',...
                  'Completing the career plan'};
    total_value_levels = zeros(1, length(activities));
    num_responses = zeros(1, length(activities));
    
    %total the perceived values for each activity
    for col = column_number : column_number + length(activities) - 1
        for row = 1 : num_students
            value = 0;
            %check what the perceived value for the current student was
            if strcmp(table{row, col}, 'Not valuable')
                value = 1;
            elseif strcmp(table{row, col}, 'Slightly valuable')
                value = 2;
            elseif strcmp(table{row, col}, 'Valuable')
                value = 3;
            elseif strcmp(table{row, col}, 'Highly valuable')
                value = 4;
            end
            if value ~= 0 %check that the question received a response
                %increment the value to the total value
                total_value_levels(col - column_number + 1) = total_value_levels(col - column_number + 1) + value;
                %increment the number of responses received
                num_responses(col - column_number + 1) = num_responses(col - column_number + 1) + 1;
            end
        end
    end
    
    %calculate the average value levels
    avg_value_levels = [];
    for i = 1 : length(total_value_levels)
        avg_value_levels(i) = total_value_levels(i) / num_responses(i);
    end
    
    ordinal_activities = categorical(activities); %convert the strings to categorical type
    
    %reorder the ordinal values since categorical() alphabetises them
    ordinal_activities = reordercats(ordinal_activities, activities);
    
    %plot the data
    bar_plot = bar(ordinal_activities, avg_value_levels, 'facecolor', 'flat');
    colours = rand(length(ordinal_activities), 3); %generate the colours for the bars
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_value_levels),...
        avg_value_levels,...
        num2str(avg_value_levels'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Students perceived value of P2B individual activities (1 to 4)');
    xlabel('Activity');
    ylabel('Average rating of value');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)    
end