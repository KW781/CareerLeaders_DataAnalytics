function [] = RoleApplicationPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('applied', headings{i}) && WithinWord('January', headings{i}) && WithinWord('April', headings{i})
            column_number = i;
            break
        end
    end
    dimensions = size(table);
    num_students = dimensions(1);
    %create cell array of the response values that correspond to the ones
    %in the spreadsheet
    applications = {'Internship', 'Graduate programme', 'Individual graduate role', 'I did not submit any application', 'Unanswered'};
    %initialise counters for each response to zero
    application_counts = zeros(1, length(applications));
    
    %count how many students submitted each type of application then total
    %them
    for row = 1 : num_students
        for i = 1 : length(applications)
            if WithinWord(applications{i}, table{row, column_number})
                application_counts(i) = application_counts(i) + 1;
                break;
            end
        end
    end
    
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted   
    options_index = 0; %initialise the index counter for the options
    final_applications = {}; %initialise the cell array for the final non_zero applications submitted
    application_proportions = []; %initialise the array for the non_zero percentages submitting an application
    for i = 1 : length(application_counts)
        if round((application_counts(i) / sum(application_counts)) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_applications{options_index} = applications{i};
            application_proportions(options_index) = round((application_counts(i) / sum(application_counts)) * 100, 2);
        end
    end
     
    ordinal_application_responses = categorical(final_applications); %converts the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically    
    ordinal_application_responses = reordercats(ordinal_application_responses, final_applications);
     
    
    %plot the data 
    colours = rand(length(ordinal_application_responses), 3);
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(application_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_application_responses, application_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(application_proportions) + 5, max(application_proportions) * 1.1])])]);
    text(1 : length(application_proportions),...
        application_proportions,...
        [num2str(application_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students submitting applications for each role');
    xlabel('Role for which application was submitted');
    ylabel('Percentage of students')
end