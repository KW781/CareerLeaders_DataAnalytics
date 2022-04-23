function [] = GroupSessionPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column with the group session data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Group sessions: Please rate the value of each session', headings{i})
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %create the names of the group sessions and level total for each
    group_sessions = {'Knowing yourself - Introductory session and MBTI',...
                      'Knowing yourself - Card sorts',...
                      'Connect yourself - Creating work futures',...
                      'Connect yourself - Enhancing employability',...
                      'Market yourself - Speed networking'};
    total_value_levels = zeros(1, length(group_sessions));
    num_responses = zeros(1, length(group_sessions));
    
    %total the value levels for each group session, scale 1 to 4
    for col = column_number : column_number + length(group_sessions) - 1
        for row = 1 : num_students
            value = 0;
            %check what the reponse is and set value accordingly
            if strcmp(table{row, col}, 'Limited value')
                value = 1;
            elseif strcmp(table{row, col}, 'Slightly valuable')
                value = 2;
            elseif strcmp(table{row, col}, 'Valuable')
                value = 3;
            elseif strcmp(table{row, col}, 'Highly valuable')
                value = 4;
            end
            if value ~= 0 %check that the question received a response 
                %increment the perceived value
                total_value_levels(col - column_number + 1) = total_value_levels(col - column_number + 1) + value;
                %increment the number of responses for the current group
                %session
                num_responses(col - column_number + 1) = num_responses(col - column_number + 1) + 1;
            end
        end
    end
    
    %calculate average value levels
    avg_value_levels = [];
    for i = 1 : length(total_value_levels)
        avg_value_levels(i) = total_value_levels(i) / num_responses(i);
    end
    
    ordinal_group_sessions = categorical(group_sessions); %convert strings to categorical type
    
    %reorder the ordinal values, since reordercats() alphabetises them
    ordinal_group_sessions = reordercats(ordinal_group_sessions, group_sessions);
    
    %plot the data
    bar_plot = bar(ordinal_group_sessions, avg_value_levels, 'facecolor', 'flat');
    colours = rand(length(ordinal_group_sessions), 3); %generate the colours for the bars
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_value_levels),...
        avg_value_levels,...
        num2str(avg_value_levels'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Students perceived value of P2B group sessions (1 to 4)');
    xlabel('Group session');
    ylabel('Average rating of value');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)    
end