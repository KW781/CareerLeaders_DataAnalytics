function [] = MajorsPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the majors data, and the number of columns
    %with the data
    column_number = -1;
    head_found = 0;
    num_options = 0;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'My Commerce majors/subjects are:')
            column_number = i;
            head_found = 1;
        end
        if head_found
            %check if heading value is not null, indicating we've reached end of question section
            null = isnan(headings{i});
            if length(null) > 1
                null = 0;
            end
            if ~(null) && num_options > 0
                break;
            else
                num_options = num_options + 1;
            end
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up the majors cell array and the major counters
    majors = {};
    for i = 1 : num_options
        majors{i} = '';
    end
    major_counters = zeros(1, length(majors));
    
    %count majors studied across all students
    for col = column_number : column_number - 1 + length(majors)
        for row = 1 : num_students
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            if length(null) == 0
                null = 1; %set to null if the element is an empty string
            end
            
            %only increment if the current element is both not empty string and not null
            if ~strcmp(table{row, col}, '') && ~null
                major_counters(col - column_number + 1) = major_counters(col - column_number + 1) + 1; %increment the counter for the appropriate event
                if strcmp(majors{col - column_number + 1}, '')
                    majors{col - column_number + 1} = table{row, col}; %copy the event into the events array if not already there
                end
            end
        end
    end
    
    %calculate the percentages from the counters, and only count non-zero
    %ones
    options_index = 0;
    final_majors = {};
    final_major_proportions = [];
    for i = 1 : length(major_counters)
        if round((major_counters(i) / num_students) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_majors{options_index} = majors{i};
            final_major_proportions(options_index) = round((major_counters(i) / num_students) * 100, 2);
        end
    end
    
    ordinal_final_majors = categorical(final_majors); %convert the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_majors = reordercats(ordinal_final_majors, final_majors);
    
    %plot the data 
    colours = rand(length(ordinal_final_majors), 3);
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(final_major_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_majors, final_major_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(final_major_proportions),...
        final_major_proportions,...
        [num2str(final_major_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students studying BCom majors');
    xlabel('Major');
    ylabel('Percentage of students')     
end