function [] = NZResidencyPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the NZ residency data
    column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('NZ residency', headings{i})
            column_number = i;
            break;
        end
    end
    
    %extract table dimensions (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up residency status strings and counters for each status
    residencies = {'NZ citizen', 'NZ permanent resident', 'Student visa', 'Work visa', 'Other'};
    residency_counters = zeros(1, length(residencies));
    
    %count up number of students for each residency status
    for i = 1 : num_students
        if length(table{i, column_number}) > 0
            found = 0; %initialise flag for whether a match is found in the array
            for j = 1 : length(residencies)
                %increment the residency status counter if a match for that status was found
                if strcmp(table{i, column_number}, residencies{j})
                    residency_counters(j) = residency_counters(j) + 1;
                    found = 1;
                    break;
                end
            end
            %increment the 'other' category if no match was found
            if ~found
                residency_counters(length(residency_counters)) = residency_counters(length(residency_counters)) + 1;
            end
        end
    end
    
    %ensure that only residency statuses with a count greater than zero are plotted
    options_index = 0;
    final_residencies = {};
    residency_proportions = [];
    for i = 1 : length(residency_counters)
        if round((residency_counters(i) / sum(residency_counters)) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_residencies{options_index} = residencies{i};
            residency_proportions(options_index) = round((residency_counters(i) / sum(residency_counters)) * 100, 2);
        end
    end
    
    ordinal_final_residencies = categorical(final_residencies); %conver the strings to categorical type
    
    %reorder the categories because categorical() alphabetises them by default
    ordinal_final_residencies = reordercats(ordinal_final_residencies, final_residencies);
    
    %plot the data
    colours = rand(length(ordinal_final_residencies), 3);
    %create percentage symbols array, because they need to be appended to the numbers when plotting
    percent_arr = '';
    for i = 1 : length(residency_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_residencies, residency_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(residency_proportions) + 5, max(residency_proportions) * 1.1])])]);
    text(1 : length(residency_proportions),...
        residency_proportions,...
        [num2str(residency_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students with each NZ residency status');
    xlabel('NZ Residency Status');
    ylabel('Percentage of students')
end