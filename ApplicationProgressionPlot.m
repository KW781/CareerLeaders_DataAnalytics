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
    num_ranges = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11',...
        '12', '13', '14', '15', '15+'};
    num_apps_submitted_ranges_counters = zeros(1, length(num_ranges));
    num_offers_ranges_counters = zeros(1, length(num_ranges));
    
    %count up the application stages for all the students
    for row = 1 : num_students
        prev_employer_name = '';
        submit_app = 0; %flag for whether student submitted application to current company
        offered_role = 0; %flag for whether student was offered role for current company
        curr_num_apps_submitted = 0;
        curr_num_offers = 0;
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
                    %before resetting, record in the counters whether they
                    %submitted application or received offer
                    curr_num_apps_submitted = curr_num_apps_submitted + submit_app;
                    curr_num_offers = curr_num_offers + offered_role;
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
                            submit_app = 1;
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
                           offered_role = 1;
                        end
                        break;
                    end
                end
                prev_employer_name = employer_name;
            end
        end
        %before doing calculation for student, record whether they submitted application or received offer for last company
        curr_num_apps_submitted = curr_num_apps_submitted + submit_app;
        curr_num_offers = curr_num_offers + offered_role;
        %record the number of applications and offers for the current student
        arr_index = min([length(num_ranges), curr_num_apps_submitted + 1]);
        num_apps_submitted_ranges_counters(arr_index) = num_apps_submitted_ranges_counters(arr_index) + 1;
        arr_index = min([length(num_ranges), curr_num_offers + 1]);
        num_offers_ranges_counters(arr_index) = num_offers_ranges_counters(arr_index) + 1;
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
    
    
    %ensure that all zero columns beyond the last non-zero column are removed
    num_apps_submitted_ranges = num_ranges;
    for i = length(num_apps_submitted_ranges_counters) : -1 : 1
        if num_apps_submitted_ranges_counters(i) ~= 0
            num_apps_submitted_ranges_counters = num_apps_submitted_ranges_counters(1 : i);
            num_apps_submitted_ranges = num_apps_submitted_ranges(1 : i);
            break;
        end
    end
    
    ordinal_num_apps_submitted_ranges = categorical(num_apps_submitted_ranges); %convert strings to categorical type
    
    %reorder the ordinal numeric ranges since categorical() alphabetises them by default
    ordinal_num_apps_submitted_ranges = reordercats(ordinal_num_apps_submitted_ranges, num_apps_submitted_ranges);
    
    
    %ensure that all zero columns beyond the last non-zero column are removed
    num_offers_ranges = num_ranges;
    for i = length(num_offers_ranges_counters) : -1 : 1
        if num_offers_ranges_counters(i) ~= 0
            num_offers_ranges_counters = num_offers_ranges_counters(1 : i);
            num_offers_ranges = num_offers_ranges(1 : i);
            break;
        end
    end
    
    ordinal_num_offers_ranges = categorical(num_offers_ranges); %convert strings to categorical type
    
    %reorder the ordinal numeric ranges since categorical() alphabetises them by default
    ordinal_num_offers_ranges = categorical(ordinal_num_offers_ranges, num_offers_ranges);
    
    
    %plot the data for the overall appliation stage progression
    figure(1);
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
    
    %plot the percentage of students submitting applications in each range
    figure(2);
    colours = rand(length(ordinal_num_apps_submitted_ranges), 3);
    bar_plot = bar(ordinal_num_apps_submitted_ranges, num_apps_submitted_ranges_counters, 'facecolor', 'flat');  
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, max([limits(2), max(num_apps_submitted_ranges_counters) + 3, max(num_apps_submitted_ranges_counters)] * 1.1)]);
    text(1 : length(num_apps_submitted_ranges_counters),...
        num_apps_submitted_ranges_counters,...
        num2str(num_apps_submitted_ranges_counters'),...
        'vert', 'bottom', 'horiz', 'center'); 
    title('Number of students submitting different numbers of applications');
    xlabel('Number of applications submitted');
    ylabel('Number of students');
    
    %plot the percentage of students receiving offers in each range
    figure(3);
    colours = rand(length(ordinal_num_offers_ranges), 3);
    bar_plot = bar(ordinal_num_offers_ranges, num_offers_ranges_counters, 'facecolor', 'flat');  
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, max([limits(2), max(num_offers_ranges_counters) + 3, max(num_offers_ranges_counters)] * 1.1)]);
    text(1 : length(num_offers_ranges_counters),...
        num_offers_ranges_counters,...
        num2str(num_offers_ranges_counters'),...
        'vert', 'bottom', 'horiz', 'center'); 
    title('Number of students receiving different numbers of offers');
    xlabel('Number of offers received');
    ylabel('Number of students');    
end