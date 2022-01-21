function [] = FoundOutMethodPlot(table)
    dimensions = size(table);
    num_students = dimensions(1);
    methods = {'Business School Website', 'BizStudent Update (email)', 'Workshop or event', 'Plasma screen'};
    methods_count = zeros(1, length(methods)); %initialise method counters to zero
    other_count = 0; %count how many entries are 'other'
    
    %count how many selected each option then total them
    for i = 1 : num_students
        current_methods = split(table{i, 12}, ', ');
        for j = 1 : length(current_methods)
            match = 0; %initialise the match flag to false
            for k = 1 : length(methods)
                if strcmp(current_methods{j}, methods{k})
                    match = 1;
                    methods_count(k) = methods_count(k) + 1;
                    break; %exit the search for the current category if a match was found
                end
            end
            if ~match
                other_count = other_count + 1; %increment other count if no match was found
            end
        end
    end
    
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_methods = {}; %initialise the cell array for the final non-zero methods selected
    method_proportions = []; %initialise the array for the non-zero percentages of students selecting a method
    for i = 1 : length(methods_count)
        if methods_count(i) ~= 0
            options_index = options_index + 1;
            final_methods{options_index} = methods{i};
            method_proportions(options_index) = (methods_count(i) / num_students) * 100;
        end
    end
    %add on the category of 'other' if that was non-zero
    if other_count ~= 0
        options_index = options_index + 1;
        final_methods{options_index} = 'Other';
        method_proportions(options_index) = (other_count / num_students) * 100;
    end
    
    ordinal_final_methods = categorical(final_methods); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_methods = reordercats(ordinal_final_methods, final_methods);
    
    %plot the data
    bar(ordinal_final_methods, method_proportions);
    text(1 : length(method_proportions),...
        method_proportions,...
        num2str(method_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('How did you find out about us? (2021)');
    xlabel('How found out');
    ylabel('Percentage of students');
end