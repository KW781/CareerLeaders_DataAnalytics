function [] = WorkshopPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the workshops data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    head_found = 0;
    num_workshops = 0;
    for i = 1 : length(headings)
        if WithinWord('Workshops: Please rate the value of each workshop', headings{i})
            column_number = i;
            head_found = 1;
        end
        if head_found
            if ~strncmp(headings{i}, 'Var', 3) && num_workshops > 0 %check if we've gone past all the workshops, then break
                break;
            else
                num_workshops = num_workshops + 1;
            end
        end
    end
    num_workshops = num_workshops - 1; %accounts for the 'please comment' column
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %create the names of the workshops and the total values for each,
    %all_workshops is all of the current workshops (older ones may not have all workshops)
    all_workshops = {'My personal brand', 'Resilience strategies',...
                     'CV and cover letters explained', 'My LinkedIn',...
                     'What can I do with my major?', 'Employability skills',...
                     'Networking strategies', 'Interviews explained',...
                     'Psychometric tests decoded', 'Assessment centres explained',...
                     'Time management strategies', 'Job search strategies (optional)',...
                     'Jump-start your new job (optional)'};
    workshops = {};
    for i = 1 : num_workshops
        workshops{i} = all_workshops{i};
    end
    %create the total values array and the number of responses
    total_value_levels = zeros(1, length(workshops));
    num_responses = zeros(1, length(workshops));
    
    %total the value levels for each workshop, scale 1 to 4
    for col = column_number : column_number + length(workshops) - 1
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
                %increment the value total for the current student
                total_value_levels(col - column_number + 1) = total_value_levels(col - column_number + 1) + value;
                %increment the number of responses
                num_responses(col - column_number + 1) = num_responses(col - column_number + 1) + 1;
            end
        end
    end
    
    %calculate average value levels
    avg_value_levels = [];
    for i = 1 : length(total_value_levels)
        avg_value_levels(i) = total_value_levels(i) / num_responses(i);
    end
    
    ordinal_workshops = categorical(workshops); %convert the strings to categorical type
    
    %reorder the ordinal values since categorical() alphabetises them
    ordinal_workshops = reordercats(ordinal_workshops, workshops);
    
    %plot the data
    colours = rand(length(ordinal_workshops), 3); %generate the colours for the bars
    bar_plot = barh(ordinal_workshops, avg_value_levels, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    xtips1 = bar_plot(1).YEndPoints + 0.03;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Students perceived value of P2B workshops (1 to 4)');
    xlabel('Workshop')
    ylabel('Average rating of value')
    xlim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)
end