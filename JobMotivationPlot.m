function [] = JobMotivationPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the salary motivation data
    column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('offered a job', headings{i}) && WithinWord('motivate', headings{i})
            column_number = i;
            break;
        end
    end
    
    %extract table dimensions (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %THIS ARRAY NEEDS TO BE SET UP MANUALLY AFTER REVIEWING THE SPREADSHEET BY A HUMAN
    motivations = {'Salary', 'Culture', 'Learning', 'Development', 'Benefits', 'Other'};
    %this array is for the storing of synonyms of the above motivations
    %e.g. motivations_synonyms{2} is a cell array of synonyms for
    %motivations{2}
    motivations_synonyms = {{'Salary', 'Pay', 'Money', 'Wages', 'Wage', 'Renumeration'}, {'Culture', 'Environment'}, {'Learning', 'Education'},...
        {'Development', 'Growth', 'Progression', 'Opportunities'}, {'Benefits', 'Perks', 'Privileges', 'Incentives'}};
    motivation_counters = zeros(1, length(motivations));
    
    %for each student find what motivates them to say yes against the list of motivations specified
    for i = 1 : num_students
        found = 0;
        for j = 1 : length(motivations) - 1 %-1 to account for 'other'
            %go through the list of synonyms to account for synonyms of the motivations being used 
            for k = 1 : length(motivations_synonyms{j})
                if WithinWord(motivations_synonyms{j}{k}, table{i, column_number})
                    motivation_counters(j) = motivation_counters(j) + 1;
                    found = 1;
                    break;
                end
            end
        end
        %if no match was found against any of the motivations, and the response isn't empty, increment the 'Other' count
        if ~found && length(table{i, column_number}) > 1
            motivation_counters(length(motivation_counters)) = motivation_counters(length(motivation_counters)) + 1;
        end
    end
    
    %only include motivations for which the count is non-zero
    options_index = 0;
    final_motivations = {};
    motivation_proportions = [];
    for i = 1 : length(motivation_counters)
        if round((motivation_counters(i) / num_students) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_motivations{options_index} = motivations{i};
            motivation_proportions(options_index) = round((motivation_counters(i) / num_students) * 100, 2);
        end
    end
    
    ordinal_final_motivations = categorical(final_motivations); %convert the strings to categorical type
    
    %reorder the categories because categorical() alphabetises them by default
    ordinal_final_motivations = reordercats(ordinal_final_motivations, final_motivations);
    
    %plot the data
    colours = rand(length(ordinal_final_motivations), 3);
    bar_plot = barh(ordinal_final_motivations, motivation_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the x-axis numbers
    limits = xlim;
    xlim([0, min([100, max([limits(2), max(motivation_proportions) + 5, max(motivation_proportions) * 1.1])])]);
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData) + '%';
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Motivations for students to say yes to a job opportunity');
    xlabel('Motivations');
    ylabel('Percentage of students');
end