function [] = StagesPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'I am at stage:')
            column_number = i;
            break
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    stages = {}; %initialise the stages array
    for i = 1 : 10
        stages{i} = '';
    end
    stages{11} = 'Other'; %set the 'Other' stage
    stage_counters = zeros(1, length(stages));
    
    for col = column_number : column_number - 1 + length(stages)
        for row = 1 : num_students
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            if ~strcmp(table{row, col}, '') && ~null
                stage_counters(col - column_number + 1) = stage_counters(col - column_number + 1) + 1; %increment the counter for the appropriate stage
                if strcmp(stages{col - column_number + 1}, '') && col ~= column_number - 1 + length(stages)
                    stages{col - 291} = table{row, col}; %copy the stage into the stages array (making sure 'Other' is still retained)
                end
            end
        end
    end
    
    %ensure only stages with non-zero count are plotted (stages with zero shouldn't be plotted)
    options_index = 0;
    final_stages = {};
    stage_proportions = [];
    for i = 1 : length(stage_counters)
        if round((stage_counters(i) / num_students) * 100) ~= 0
            options_index = options_index + 1;
            final_stages{options_index} = stages{i};
            stage_proportions(options_index) = round((stage_counters(i) / dimensions(1)) * 100);
        end
    end
    
    ordinal_final_stages = categorical(final_stages); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_stages = reordercats(ordinal_final_stages, final_stages);
    
    %plot the data
    colours = rand(length(ordinal_final_stages), 3); %generate the colours for the bars
    bar_plot = barh(ordinal_final_stages, stage_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData) + '%';
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Stages of students in university');
    xlabel('Stage')
    ylabel('Percentage of students')
end