function [] = UnderstandingProgrammePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the understanding programme data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Now you have completed the programme, please rate your understanding of the following:')...
           || strcmp(headings{i}, 'Now that you have completed the programme, please rate your understanding of the following:')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up the responses cell array and the counter for them
    topics = {'Yourself',...
              'Whether you are ready for the "world of work"',...
              'Where your degree will lead'};
    total_understanding_levels = zeros(1, length(topics));
    num_responses = zeros(1, length(topics));
    
    %total the response values for each response (1 to 4 scale)
    for col = column_number : column_number + length(topics) - 1
        for row = 1 : num_students
            level = 0;
            %check what the level is and set level accordingly
            if strcmp(table{row, col}, 'Understanding is the same')
                level = 1;
            elseif strcmp(table{row, col}, 'Slightly higher')
                level = 2;
            elseif strcmp(table{row, col}, 'Moderately higher')
                level = 3;
            elseif strcmp(table{row, col}, 'Much higher')
                level = 4;
            end
            if level ~= 0 %check if there was a response to the question
                %increment understanding level
                total_understanding_levels(col - column_number + 1) = total_understanding_levels(col - column_number + 1) + level;
                %increment number of responses
                num_responses(col - column_number + 1) = num_responses(col - column_number + 1) + 1;
            end
        end
    end
    
    %calculate average understanding levels
    avg_understanding_levels = [];
    for i = 1 : length(total_understanding_levels)
        avg_understanding_levels(i) = total_understanding_levels(i) / num_responses(i);
    end
    
    ordinal_topics = categorical(topics); %convert strings to categorical type
    
    %reorder since categorical() makes it alphabetical by default
    ordinal_topics = reordercats(ordinal_topics, topics);
    
    %plot the data
    bar_plot = bar(ordinal_topics, avg_understanding_levels, 'facecolor', 'flat');
    colours = rand(length(ordinal_topics), 3); %generate the colours for the bars
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_understanding_levels),...
        avg_understanding_levels,...
        num2str(avg_understanding_levels'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Understanding in career development topics after P2B (1 to 4)');
    xlabel('Topic');
    ylabel('Average rating of understanding');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)
end