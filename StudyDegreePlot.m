function [] = StudyDegreePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the studying degree data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'I am studying a:')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up degree cell array with the options that students can select,
    %and the counter for them
    degree_options = {'Bachelor of Commerce only',...
                      'Bachelor of Property only',...
                      'Bachelor of Commerce conjoint with other degree',...
                      'Bachelor of Property only',...
                      'Bachelor of Property conjoint with other degree',...
                      'Bachelor of Commerce conjoint with Property'};
    degree_option_counters = zeros(1, length(degree_options));
    total_responses = 0; %counter for the number of responses to the question because it's an optional question which not everyone answers
    %count the students studying each degree
    for row = 1 : num_students
        for i = 1 : length(degree_options)
            if WithinWord(degree_options{i}, table{row, column_number})
                degree_option_counters(i) = degree_option_counters(i) + 1;
                total_responses = total_responses + 1;
                break;
            end
        end
    end
    
    %ensure only degrees with a zero count are plotted, and calculate
    %percentages
    final_degree_options = {};
    final_degree_proportions = [];
    options_index = 0;
    for i = 1 : length(degree_option_counters)
        if degree_option_counters(i) > 0
            options_index = options_index + 1;
            final_degree_options{options_index} = degree_options{i};
            final_degree_proportions(options_index) = round((degree_option_counters(i) / total_responses) * 100, 2);
        end
    end
    
    ordinal_final_degree_options = categorical(final_degree_options); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_degree_options = reordercats(ordinal_final_degree_options, final_degree_options);
    
    %plot the data 
    colours = rand(length(ordinal_final_degree_options), 3);
    bar_plot = bar(ordinal_final_degree_options, final_degree_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(final_degree_proportions),...
        final_degree_proportions,...
        num2str(final_degree_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students studying Business School degrees');
    xlabel('Degree');
    ylabel('Percentage of students')    
end