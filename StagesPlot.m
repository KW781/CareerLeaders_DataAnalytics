function [] = StagesPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'I am at stage:')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    % sets up stages array with stages that can be selected. Note that 
    %'Business Masters' MUST come before 'Masters' in the array because
    %'Masters' is within 'Business Masters' and we are running the
    %WithinWord() function
    stages = {'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5', 'Honours', 'Postgraduate Diploma',...
        'Business Masters', 'Masters', 'PhD', 'Other'};
    stage_counters = zeros(1, length(stages));
    
    %count the number of students selecting each option
    for row = 1 : num_students
        for i = 1 : length(stages)
            if WithinWord(stages{i}, table{row, column_number})
                stage_counters(i) = stage_counters(i) + 1;
                break;
            end
        end
    end
    
    %ensure only stages with non-zero count are plotted (stages with zero shouldn't be plotted)
    options_index = 0;
    final_stages = {};
    stage_proportions = [];
    for i = 1 : length(stage_counters)
        if round((stage_counters(i) / sum(stage_counters)) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_stages{options_index} = stages{i};
            stage_proportions(options_index) = round((stage_counters(i) / sum(stage_counters)) * 100, 2);
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