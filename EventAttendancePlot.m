function [] = EventAttendancePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number and the number of columns with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    head_found = 0;
    num_options = 0;
    for i = 1 : length(headings)
        if WithinWord('During', headings{i}) && WithinWord('attended', headings{i})
            column_number = i;
            head_found = 1;
        end
        if head_found %analyse whether the heading is for another option or question if the header has already been found
            if ~(strncmp(headings{i}, 'Var', 3)) && num_options > 0
                break %exit if we've reached the next question in the survey
            else
                num_options = num_options + 1; %otherwise it's another option so increment
            end
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %initialise the events and event counters arrays
    events = {};
    for i = 1 : num_options - 1
        events{i} = '';
    end
    events{num_options} = 'Other';
    event_counters = zeros(1, length(events));
    
    %count attendance at events across all students
    for col = column_number : column_number - 1 + length(events)
        for row = 1 : num_students
            %check whether the current element in table is null or not
            null = isnan(table{row, col}); %will return an array for character vectors, so following check must be done
            if length(null) > 1
                null = 0;
            end
            %only increment if the current element is both not empty string and not null
            if ~strcmp(table{row, col}, '') && ~null
                event_counters(col - column_number + 1) = event_counters(col - column_number + 1) + 1; %increment the counter for the appropriate event
                if strcmp(events{col - column_number + 1}, '') && col ~= column_number - 1 + length(events)
                    events{col - column_number + 1} = table{row, col}; %copy the event into the events array (make sure 'Other' is still retained)
                end
            end
        end
    end
    
    %ensure only events with a non-zero count are plotted
    options_index = 0;
    final_event_counters = [];
    final_events = {};
    for i = 1 : length(event_counters)
        if event_counters(i) > 0
            options_index = options_index + 1;
            final_event_counters(options_index) = event_counters(i);
            final_events{options_index} = events{i};
        end
    end
    
    ordinal_final_events = categorical(final_events); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_events = reordercats(ordinal_final_events, final_events);

    %plot the data
    colours = rand(length(ordinal_final_events), 3); %generate the colours for the bars
    bar_plot = barh(ordinal_final_events, final_event_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Number of students attending Business School events');
    xlabel('Events')
    ylabel('Number of students')
end