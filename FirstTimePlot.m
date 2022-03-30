function [] = FirstTimePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableNames;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'IsThisTheFirstTimeYouAreVisitingDrop_InThisSemester_')
            column_number = i;
            break
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    yes_no_count = [0, 0];
    
    %total 'yes' and 'no' answers
    for i = 1 : num_students
        current_answer = table{i, column_number};
        if strcmp(current_answer, 'Yes')
            yes_no_count(1) = yes_no_count(1) + 1; %increment 'yes' count if answer is 'yes'
        else
            yes_no_count(2) = yes_no_count(2) + 1; %increment 'no' count otherwise
        end
    end
    
    labels = {'Yes', 'No'}; %create the text labels for plot
    %plot data
    pie(yes_no_count);
    legend(labels);
    title('Is this your first time visiting drop-ins this semester?');
end