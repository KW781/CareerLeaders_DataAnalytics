function [] = MonthAttendancePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find column number with the timestamp data
    headings = table_raw.Properties.VariableDescriptions;
    column_number = -1;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Timestamp')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up month cell arays and counters for each month
    months = {'January', 'February', 'March', 'April', 'May', 'June', 'July',...
        'August', 'September', 'October', 'November', 'December'};
    month_counters = zeros(1, length(months));
    
    %go through the timestamp column and count up the month data
    for i = 1 : num_students
        month_counters(month(table{i, column_number})) = month_counters(month(table{i, column_number})) + 1;
    end
    
    %convert the cell array strings to ordinal type
    ordinal_months = categorical(months);
    
    %reorder the categories because categorical() alphabetises them
    ordinal_months = reordercats(ordinal_months, months);
    
    %plot the data
    colours = rand(length(ordinal_months), 3); %randomly generate colours for the bars
    bar_plot = bar(ordinal_months, month_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, max([limits(2), max(month_counters) + 3, max(month_counters) * 1.1])]);
    text(1 : length(month_counters),...
        month_counters,...
        num2str(month_counters'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar 
    title('Plot of drop in attendance over time');
    xlabel('Month');
    ylabel('Number of students');
end