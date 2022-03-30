function [] = AttendancePurposePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableNames;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'WhatIsYourPurposeForAttendingDrop_in_')
            column_number = i;
            break
        end
    end

    dimensions = size(table);
    num_students = dimensions(1);
    purpose_options = {'CV check', 'Career advice', 'LinkedIn check', 'Cover letter check', 'Application form check'}; %store the different options for the purpose
    purpose_count = zeros(1, length(purpose_options)); %initialise purpose counters to zero
    other_count = 0; %count how many entries are 'other'
    
    %count how many selected each option then total them
    for i = 1 : num_students
        current_purposes = split(table{i, column_number}, ', ');
        for j = 1 : length(current_purposes)
            match = 0; %initialise the match flag to false
            for k = 1 : length(purpose_options)
                if strcmp(purpose_options{k}, current_purposes{j})
                    match = 1;
                    purpose_count(k) = purpose_count(k) + 1;
                    break; %exit the search for the current cateogory if a match was found
                end
            end
            if ~match
                other_count = other_count + 1; %increment other_count if no match was found
            end
        end
    end
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_purpose_options = {}; %initialise cell array for final purpose options (ones where the count isn't zero)
    purpose_proportions = []; %initialise array for percentage of students choosing an option
    for i = 1 : length(purpose_count)
        if purpose_count(i) ~= 0
            options_index = options_index + 1;
            final_purpose_options{options_index} = purpose_options{i};
            purpose_proportions(options_index) = (purpose_count(i) / num_students) * 100;
        end
    end
    %add on the data for the category 'Other' if that was non-zero
    if other_count ~= 0
        options_index = options_index + 1;
        final_purpose_options{options_index} = 'Other';
        purpose_proportions(options_index) = (other_count / num_students) * 100;
    end
    
    ordinal_final_purpose_options = categorical(final_purpose_options); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_purpose_options = reordercats(ordinal_final_purpose_options, final_purpose_options);
    
    %plot the data
    colours = rand(length(ordinal_final_purpose_options), 3); %generate the colours for the bars
    bar_plot = bar(ordinal_final_purpose_options, purpose_proportions, 'facecolor', 'flat');  
    bar_plot.CData = colours; %colour in the bars
    text(1 : length(purpose_proportions),...
        purpose_proportions,...
        num2str(purpose_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar    
    title('What is your purpose for attendance? (2021)');
    xlabel('Purpose');
    ylabel('Percentage of students');
end