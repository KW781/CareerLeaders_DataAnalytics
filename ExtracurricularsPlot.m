function [] = ExtracurricularsPlot(file_name)
    table = table2cell(readtable(file_name));
    dimensions = size(table);
    
    extracurriculars = {}; %initialise extracurriculars array
    for i = 1 : 28
        extracurriculars{i} = '';
    end
    extracurriculars{29} = 'Other'; %set the 'Other' extracurricular
    extracurricular_counters = zeros(1, length(extracurriculars));
    
    for col = 263 : 291
        for row = 1 : dimensions(1)
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            %only increment if the current element is both not empty string and not null
            if ~strcmp(table{row, col}, '') && ~null
                extracurricular_counters(col - 262) = extracurricular_counters(col - 262) + 1; %increment the counter for the appropriate extracurricular
                if strcmp(extracurriculars{col - 262}, '') && col ~= 291
                    extracurriculars{col - 262} = table{row, col}; %copy the extracurricular into the extracurriculars array (make sure 'Other' is still retained)
                end
            end
        end
    end
    
    %ensure only extracurriculars with a non-zero count are plotted (ones with zero shouldn't be plotted)
    options_index = 0;
    final_extracurriculars = {};
    final_extracurricular_counters = [];
    for i = 1 : length(extracurricular_counters)
        if extracurricular_counters(i) ~= 0
            options_index = options_index + 1;
            final_extracurriculars{options_index} = extracurriculars{i};
            final_extracurricular_counters(options_index) = extracurricular_counters(i);
        end
    end
    
    ordinal_final_extracurriculars = categorical(final_extracurriculars); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_extracurriculars = reordercats(ordinal_final_extracurriculars, final_extracurriculars);
    
    %plot the data
    colours = rand(length(ordinal_final_extracurriculars), 3); %generate the colours for the bars
    bar_plot = barh(ordinal_final_extracurriculars, final_extracurricular_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Extracurriculars students take part in');
    xlabel('Extracurriculars')
    ylabel('Number of students')
end