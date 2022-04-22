function [] = ReasonsNotApplyPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    head_found = 0;
    num_options = 0;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'I did not apply for a job / internship / graduate programme because:')
            column_number = i;
            head_found = 1;
        end
        if head_found
            if ~(strncmp(headings{i}, 'Var', 3)) && num_options > 0
                break;
            else
                num_options = num_options + 1;
            end
        end
    end
    
    dimensions = size(table); %extract the dimensions of the spread sheet
    num_students = dimensions(1);
    
    %initialise the strings for the reasons for not applying
    reasons = {};
    for i = 1 : num_options - 1
        reasons{i} = '';
    end
    reasons{num_options} = 'Other';
    reason_counters = zeros(1, length(reasons)); %stores the counters for each reason not applying
    for col = column_number : column_number - 1 + length(reasons)
        for row = 1 : num_students
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            %only increment if the current element is both not empty string and not null
            if ~strcmp(table{row, col}, '') && ~null
                reason_counters(col - column_number + 1) = reason_counters(col - column_number + 1) + 1; %increment the counter for the appropriate reason
                if strcmp(reasons{col - column_number + 1}, '') && col ~= column_number - 1 + length(reasons)
                    reasons{col - column_number + 1} = table{row, col}; %copy the reason in the reason array (make sure 'Other' is still retained)
                end
            end
        end
    end
    
    %ensure only reasons with a non-zero count are plotted (ones with zero aren't plotted)
    options_index = 0;
    final_reasons = {};
    final_reason_counters = [];
    for i = 1 : length(reason_counters)
        if reason_counters(i) ~= 0
            options_index = options_index + 1;
            final_reasons{options_index} = reasons{i};
            final_reason_counters(options_index) = reason_counters(i);
        end
    end
    
    ordinal_final_reasons = categorical(final_reasons); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_reasons = reordercats(ordinal_final_reasons, final_reasons);
    
    %plot the data
    colours = rand(length(ordinal_final_reasons), 3); %generate the colours for the bars
    bar_plot = barh(ordinal_final_reasons, final_reason_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Reasons for not applying');
    xlabel('Reason')
    ylabel('Number of students')
end