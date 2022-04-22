function [] = ExtracurricularsPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number and number of columns with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    head_found = 0;
    num_options = 0;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Extra-curricular activities I take part in:')
            column_number = i;
            head_found = 1;
        end
        if head_found %analyse whether the heading is for another option or question if the header has already been found
            if ~(strncmp(headings{i}, 'Var', 3)) && num_options > 0
                break %exit if we've reached the next question in the survey
            else
                num_options = num_options + 1; %otherwise it's another option so increment
            end
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    extracurriculars = {}; %initialise extracurriculars array
    for i = 1 : num_options - 1
        extracurriculars{i} = '';
    end
    extracurriculars{num_options} = 'Other'; %set the 'Other' extracurricular
    extracurricular_counters = zeros(1, length(extracurriculars));
    
    for col = column_number : column_number - 1 + length(extracurriculars)
        for row = 1 : num_students
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            %only increment if the current element is both not empty string and not null
            if ~strcmp(table{row, col}, '') && ~null
                extracurricular_counters(col - column_number + 1) = extracurricular_counters(col - column_number + 1) + 1; %increment the counter for the appropriate extracurricular
                if strcmp(extracurriculars{col - column_number + 1}, '') && col ~= column_number - 1 + length(extracurriculars)
                    extracurriculars{col - column_number + 1} = table{row, col}; %copy the extracurricular into the extracurriculars array (make sure 'Other' is still retained)
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