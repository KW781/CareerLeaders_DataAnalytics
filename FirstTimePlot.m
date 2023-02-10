function [] = FirstTimePlot(file_name, time_period_num)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the first time data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Is this the first time you are visiting Drop-In this semester?')
            column_number = i;
            break
        end
    end
    
    %find column number with the timestamp data
    headings = table_raw.Properties.VariableDescriptions;
    date_column_number = -1;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Timestamp')
            date_column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    yes_no_count = [0, 0];
    
    %total 'yes' and 'no' answers
    for i = 1 : num_students
        %only count data that falls within the time period requested
        month_num = month(table{i, date_column_number});
        data_included = 1;
        if time_period_num == 1
            data_included = month_num >= 1 && month_num <= 6;
        elseif time_period_num == 2
            data_included = month_num >= 7 && month_num <= 12;
        end
        
        if data_included
            current_answer = table{i, column_number};
            if strcmp(current_answer, 'Yes')
                yes_no_count(1) = yes_no_count(1) + 1; %increment 'yes' count if answer is 'yes'
            else
                yes_no_count(2) = yes_no_count(2) + 1; %increment 'no' count otherwise
            end
        end
    end
    
    labels = {'Yes', 'No'}; %create the text labels for plot
    %plot data
    pie(yes_no_count);
    legend(labels);
    title('Is this your first time visiting drop-ins this semester?');
end