function [] = CanvasSatisfactionPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the canvas satisfaction data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'We would like your feedback on how satisfied you were with the following features of Canvas')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %create the canvas features cell array and the satisfaction counters
    canvas_features = {'Ease of finding what you wanted',...
                       'Use of Piazza to communicate with you',...
                       'Submission of assignments'};
    total_satisfaction_levels = zeros(1, length(canvas_features));
    num_responses = zeros(1, length(canvas_features));
    
    %total the satisfaction levels for each feature
    for col = column_number : column_number + length(canvas_features) - 1
        for row = 1 : num_students
            satisfaction = 0;
            if strcmp(table{row, col}, 'Not satisfied')
                satisfaction = 1;
            elseif strcmp(table{row, col}, 'Slightly satisfied')
                satisfaction = 2;
            elseif strcmp(table{row, col}, 'Satisfied')
                satisfaction = 3;
            elseif strcmp(table{row, col}, 'Very satisfied')
                satisfaction = 4;
            end
            if satisfaction ~= 0
                total_satisfaction_levels(col - column_number + 1) = total_satisfaction_levels(col - column_number + 1) + satisfaction;
                num_responses(col - column_number + 1) = num_responses(col - column_number + 1) + 1;
            end
        end
    end
    
    %calculate the average satisfaction levels
    avg_satisfaction_levels = [];
    for i = 1 : length(total_satisfaction_levels)
        avg_satisfaction_levels(i) = total_satisfaction_levels(i) / num_responses(i);
    end
    
    ordinal_canvas_features = categorical(canvas_features); %convert the strings to categorical type
    
    %reorder the categories since categorical() alphabetises them
    ordinal_canvas_features = reordercats(ordinal_canvas_features, canvas_features);
    
    %plot the data
    bar_plot = bar(ordinal_canvas_features, avg_satisfaction_levels, 'facecolor', 'flat');
    colours = rand(length(ordinal_canvas_features), 3); %generate the colours for the bars
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_satisfaction_levels),...
        avg_satisfaction_levels,...
        num2str(avg_satisfaction_levels'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Satisfaction of students in using Canvas features (1 to 4)');
    xlabel('Canvas feature');
    ylabel('Average rating of satisfaction');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)    
end