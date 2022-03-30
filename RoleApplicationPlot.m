function [] = RoleApplicationPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableNames;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Internship_pleaseGoToQuestion2_')
            column_number = i;
            break
        end
    end
    dimensions = size(table);
    num_students = dimensions(1);
    %create cell array of the response values that correspond to the ones
    %in the spreadsheet
    application_values = {'Internship (please go to question 2)',...
                       'Graduate programme (please go to question 2)',...
                       'Individual graduate role (please go to question 2)',...
                       'I did not submit any application (please go to question 4)'};
    applications = {'Internship', 'Graduate programme', 'Individual graduate role', 'I did not submit any application', 'Unanswered'};
    %initialise counters for each response to zero
    application_counts = zeros(1, length(applications));
    
    %count how many students submitted each type of application then total
    %them
    for i = column_number : column_number - 1 + length(application_values)
        for j = 1 : num_students
           if strcmp(table{j, i}, application_values{i - 9})
               application_counts(i - 9) = application_counts(i - 9) + 1;
           end
        end
    end
    application_counts(length(application_counts)) = num_students - sum(application_counts); %count the number of 'unanswered' responses
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted   
    options_index = 0; %initialise the index counter for the options
    final_applications = {}; %initialise the cell array for the final non_zero applications submitted
    application_proportions = []; %initialise the array for the non_zero percentages submitting an application
    for i = 1 : length(application_counts)
        if application_counts(i) ~= 0
            options_index = options_index + 1;
            final_applications{options_index} = applications{i};
            application_proportions(options_index) = round((application_counts(i) / num_students) * 100);
        end
    end
     
    ordinal_application_responses = categorical(final_applications); %converts the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically    
    ordinal_application_responses = reordercats(ordinal_application_responses, final_applications);
     
    
    %plot the data 
    colours = rand(length(ordinal_application_responses), 3);
    bar_plot = bar(ordinal_application_responses, application_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(application_proportions),...
        application_proportions,...
        num2str(application_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students submitting applications for each role');
    xlabel('Role for which application was submitted');
    ylabel('Percentage of students')
end