function [] = TopEmployersPlot(file_name, top_headings, bottom_headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find start and end column numbers with company application data
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
    
    %extract the dimensions of the table (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up employers and employer counter arrays
    employers = {};
    submit_app_counters = [];
    accepted_role_counters = [];
    for i = start_column_number : end_column_number
        head_strings = split(bottom_headings{i}, ' - ');
        employer_name = head_strings{1};
        %check if the current employer is already in the array
        new_employer = 1;
        for j = 1 : length(employers)
            if strcmp(employers{j}, employer_name)
                new_employer = 0;
                break;
            end
        end
        %if the employer is new, append to the arrays
        if new_employer
            employers{length(employers) + 1} = employer_name;
            submit_app_counters = [submit_app_counters; 0];
            accepted_role_counters = [accepted_role_counters; 0];
        end
    end
    
    %count up the application stats for all the companies
    for row = 1 : num_students
        prev_employer_name = '';
        employer_count = 0; %keep track of the number of employers
        for col = start_column_number : end_column_number
            %extract employer name and current application stage from bottom heading
            head_strings = split(bottom_headings{col}, ' - ');
            employer_name = head_strings{1};
            curr_app_stage = head_strings{2};
            %increment the employer count if the current employer is different from the previous employer
            if ~strcmp(employer_name, prev_employer_name)
                employer_count = employer_count + 1;
            end
            %if current table element isn't empty, then the student got to
            %that particular stage in the application process
            if length(table{row, col}) > 1
                %increment the submit application count if this is a new employer
                if ~strcmp(employer_name, prev_employer_name)
                    submit_app_counters(employer_count) = submit_app_counters(employer_count) + 1;
                end
                %increment the accepted role count if that is the current application stage
                if strcmp(curr_app_stage, 'Accepted role')
                    accepted_role_counters(employer_count) = accepted_role_counters(employer_count) + 1;
                end
            end
            prev_employer_name = employer_name;
        end
    end
    
    %order the employers in descending order of applications submitted using bubble sort
    max = length(submit_app_counters) - 1;
    no_more_passes = 0;
    while ~no_more_passes
        no_more_passes = 1;
        for i = 1 : max
            swap = 0; %logical indicating whether all values should be swapped or not
            if submit_app_counters(i) < submit_app_counters(i + 1)
                swap = 1;
            elseif submit_app_counters(i) == submit_app_counters(i + 1)
                if accepted_role_counters(i) < accepted_role_counters(i + 1)
                    swap = 1;
                end
            end
            if swap
                temp_count = submit_app_counters(i);
                submit_app_counters(i) = submit_app_counters(i + 1);
                submit_app_counters(i + 1) = temp_count;
                temp_count = accepted_role_counters(i);
                accepted_role_counters(i) = accepted_role_counters(i + 1);
                accepted_role_counters(i + 1) = temp_count;
                temp_employer = employers{i};
                employers{i} = employers{i + 1};
                employers{i + 1} = temp_employer;
                no_more_passes = 0;
            end
        end
        max = max - 1;
    end
    
    %take only the top 10 employers
    final_employers = {};
    final_submit_app_counters = [];
    final_accepted_role_counters = [];
    for i = 1 : 10
        final_employers{i} = employers{i};
        final_submit_app_counters = [final_submit_app_counters; submit_app_counters(i)];
        final_accepted_role_counters = [final_accepted_role_counters; accepted_role_counters(i)];
    end
    final_employer_stats = [final_submit_app_counters, final_accepted_role_counters]; %combine counter arrays together for grouped bar plot
    
    ordinal_final_employers = categorical(final_employers); %convert strings to categorical type
    
    %reorder employers since categorical() alphabetises them by default
    ordinal_final_employers = reordercats(ordinal_final_employers, final_employers);
    
    
    %plot the data
    
    %generate colours for colouring in bars
    submit_colour = rand(1, 3);
    accept_colour = rand(1, 3);
    submit_colours = [];
    accept_colours = [];
    for i = 1 : length(ordinal_final_employers)
        submit_colours = [submit_colours; submit_colour];
        accept_colours = [accept_colours; accept_colour];
    end
    bar_plot = bar(ordinal_final_employers, final_employer_stats, 'facecolor', 'flat');
    %colour in the bars for the bar plot
    bar_plot(1).CData = submit_colours;
    bar_plot(2).CData = accept_colours;
    %add text labels to the bars
    x_tips1 = bar_plot(1).XEndPoints;
    y_tips1 = bar_plot(1).YEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(x_tips1,y_tips1,labels1,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
    x_tips2 = bar_plot(2).XEndPoints;
    y_tips2 = bar_plot(2).YEndPoints;
    labels2 = string(bar_plot(2).YData);
    text(x_tips2,y_tips2,labels2,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
    %add labels to axes and title plus a legend
    title('Most popular companies students applied to');
    legend('Submitted application', 'Accepted offer')
    xlabel('Company');
    ylabel('Number of students applying');
end