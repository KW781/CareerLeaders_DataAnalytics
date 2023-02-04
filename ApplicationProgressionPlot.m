function [] = ApplicationProgressionPlot(file_name, top_headings, bottom_headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find column numbers with employer data
    start_column_number = -1;
    end_column_number = -1;
    for i = 1 : length(top_headings)
        if WithinWord('Please indicate who you applied to and how far you got in the application process', top_headings{i})
            start_column_number = i;
        end
        %if start column has been found, end the search when we've found a
        %the last column of the company application question
        if start_column_number ~= -1 && WithinWord('If you applied to other organisations', bottom_headings{i})
            end_column_number = i - 1;
            break;
        end
    end
    
    %extract table dimensions (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up progression strings and counters for counting through spreadsheet
    app_stages = {'Submitted application', 'Completed psychometric test', 'Completed a video interview',...
                  'Attended assessment centre', 'Attended interview', 'Offered role', 'Accepted role'};
    app_stage_counters = zeros(1, length(app_stages));
    
    %count up the application stages for all the students
    for row = 1 : num_students
        prev_employer_name = '';
        submit_app = 0; %flag for whether student submitted application to current company
        offered_role = 0; %flag for whether student was offered role for current company
        for col = start_column_number : end_column_number
            %if length of current table element is greater than 1, then
            %that means the student selected that application stage
            if length(table{row, col}) > 1
                %extract employer name and current application stage from bottom heading
                head_strings = split(bottom_headings{col}, ' - ');
                employer_name = head_strings{1};
                curr_app_stage = head_strings{2};
                %if the current employer is different from the previous
                %employer, reset the flags to indicate that the student hasn't
                %submitted an application for current employer and hasn't been
                %offered a role
                if ~strcmp(employer_name, prev_employer_name)
                    submit_app = 0;
                    offered_role = 0;
                end
                for i = 1 : length(app_stages)
                    if strcmp(app_stages{i}, curr_app_stage)
                        app_stage_counters(i) = app_stage_counters(i) + 1;
                        %if stage is 'submitted application', then set flag as appropriate
                        if i == 1
                            submit_app = 1;
                        end
                        %if the student got to any particular stage in the
                        %application process, then they must've submitted an
                        %application hence automatically increment that counter
                        %if the student didn't select 'submitted application'
                        %as well
                        if i > 1 && ~submit_app
                            app_stage_counters(1) = app_stage_counters(1) + 1;
                        end
                        %if stage is 'offered role', then set flag as appropriate
                        if i == length(app_stages) - 1
                            offered_role = 1;
                        end
                        %if the student accepted a role, then they must've also
                        %been offered a role hence automatically increment that
                        %counter if the student didn't select 'offered role'
                        if i == length(app_stages) && ~offered_role
                           app_stage_counters(length(app_stages) - 1) = app_stage_counters(length(app_stages) - 1) + 1;
                        end
                        break;
                    end
                end
                prev_employer_name = employer_name;
            end
        end
    end
    
    %ensure that only application stages with count greater than zero are plotted
    options_index = 0;
    final_app_stages = {};
    final_app_stage_counters = [];
    for i = 1 : length(app_stage_counters)
        if app_stage_counters(i) > 0
            options_index = options_index + 1;
            final_app_stages{options_index} = app_stages{i};
            final_app_stage_counters(options_index) = app_stage_counters(i);
        end
    end
    
    ordinal_final_app_stages = categorical(final_app_stages); %convert strings to categorical type
    
    %reorder the ordinal application stages since categorical() alphabetises them by default
    ordinal_final_app_stages = reordercats(ordinal_final_app_stages, final_app_stages);
    
    %plot the data
    colours = rand(length(ordinal_final_app_stages), 3);
    bar_plot = bar(ordinal_final_app_stages, final_app_stage_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, max([limits(2), max(final_app_stage_counters) + 3, max(final_app_stage_counters)] * 1.1)]);
    text(1 : length(final_app_stage_counters),...
        final_app_stage_counters,...
        num2str(final_app_stage_counters'),...
        'vert', 'bottom', 'horiz', 'center'); 
    title('Number of applications progressing to each application stage throughout recruitment');
    xlabel('Application stage');
    ylabel('Number of applications')
end