function [] = YearLevelPlot()
    table = table2cell(readtable('Drop-in Data 2021 [CONFIDENTIAL] (1).xlsx'));

    dimensions = size(table);
    num_students = dimensions(1);
    year_levels = {'First year', 'Second year', 'Third year', 'Third year+', 'Masters', 'PhD', 'Other'};
    year_levels_count = zeros(1, length(year_levels)); %initialise the year level counters to zero
    
    %count how many selected each option then total them
    for i = 1 : num_students
        current_year_level = table{i, 6};
        for j = 1 : length(year_levels)
            if strcmp(current_year_level, year_levels{j})
                year_levels_count(j) = year_levels_count(j) + 1;
                break;
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
            year_level_proportions(options_index) = (year_levels_count(i) / num_students) * 100;
        end
    end
    
    ordinal_final_year_levels = categorical(final_year_levels); %convert the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_year_levels = reordercats(ordinal_final_year_levels, final_year_levels);
    
    %plot the data
    colours = rand(length(ordinal_final_year_levels), 3); %generate the colours for the bars
    bar_plot = bar(ordinal_final_year_levels, year_level_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(year_level_proportions),...
        year_level_proportions,...
        num2str(year_level_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('What year level are you? (2021)');
    xlabel('Year level');
    ylabel('Percentage of students');
end