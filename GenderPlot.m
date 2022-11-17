function [] = GenderPlot(file_name, headings)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the gender data
    column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('gender', headings{i}) && WithinWord('identify', headings{i})
            column_number = i;
            break;
        end
    end
    
    %extract table dimensions (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up gender strings and counters to track number for each gender
    genders = {'Male', 'Female', 'Gender diverse', 'Prefer not to answer', 'Other'};
    gender_counters = zeros(1, length(genders));
    
    %count number of students for each gender
    for i = 1 : num_students
        if length(table{i, column_number}) > 0
            found = 0; %intialise flag to check if a match was found within the array
            for j = 1 : length(genders)
                %increment the gender counter if for that gender a match was found
                if strcmp(table{i, column_number}, genders{j})
                    gender_counters(j) = gender_counters(j) + 1;
                    found = 1;
                    break;
                end
            end
            %increment the 'other' category if there was no match found
            if ~found
                gender_counters(length(gender_counters)) = gender_counters(length(gender_counters)) + 1;
            end
        end
    end
    
    %ensure that only genders with a count greater than zero are plotted
    options_index = 0;
    final_genders = {};
    gender_proportions = [];
    for i = 1 : length(gender_counters)
        if round((gender_counters(i) / sum(gender_counters)) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_genders{options_index} = genders{i};
            gender_proportions(options_index) = round((gender_counters(i) / sum(gender_counters)) * 100, 2);
        end
    end
    
    ordinal_final_genders = categorical(final_genders); %convert strings to categorical type
    
    %reorder the gender categories because categorical() alphabetises them by default
    ordinal_final_genders = reordercats(ordinal_final_genders, final_genders);
    
    %plot the data
    colours = rand(length(ordinal_final_genders), 3);
    %create percentage symbols array, because they need to be appended to the numbers when plotting
    percent_arr = '';
    for i = 1 : length(gender_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_genders, gender_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(gender_proportions),...
        gender_proportions,...
        [num2str(gender_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students identifying with each gender');
    xlabel('Gender');
    ylabel('Percentage of students') 
end