function [] = RolePlot(file_name)
    table = table2cell(readtable(file_name));

    dimensions = size(table);
    num_students = dimensions(1);
    roles = {'Internship', 'Grad role', 'Part-time job', 'Full-time job', 'Scholarship', 'P2B'};
    roles_count = zeros(1, length(roles)); %initialise role counters to zero
    other_count = 0; %count how many entries are 'other'
    
    %count how many selected each option then total them
    for i = 1 : num_students
        current_roles = split(table{i, 9}, ', ');
        for j = 1 : length(current_roles)
            match = 0; %initialise match flag to false
            for k = 1 : length(roles)
                if strcmp(current_roles{j}, roles{k})
                    roles_count(k) = roles_count(k) + 1;
                    match = 1;
                    break; %exit the search for the current category if a match was found
                end
            end
            %{
            The following code checks whether there was a match found
            previously for the current role in the student record. If not,
            check if P2B is 'hidden' within it, and update the count for
            that if that's the case. Otherwise, update the 'other' counter.
            %}
            if ~match
                if (WithinWord('P2B', current_roles{j})) || (WithinWord('Passport to Business', current_roles{j}))
                    %{
                    use a loop to find the position of the P2B counter in
                    case the roles array is updated at any point
                    %}
                    for k = 1 : length(roles)
                        if strcmp(roles{k}, 'P2B')
                            roles_count(k) = roles_count(k) + 1;
                            break;
                        end
                    end
                else
                    other_count = other_count + 1;
                end
            end
        end
    end
        
    %this ensures that only categories that students selected are plotted
    %i.e. categories where the count was zero are not plotted
    options_index = 0; %initialise the index counter for the options
    final_roles = {}; %initialise the cell array for the final non-zero roles selected
    role_proportions = []; %initialise the array for the non_zero percentages selecting a role
    for i = 1 : length(roles_count)
        if roles_count(i) ~= 0
            options_index = options_index + 1;
            final_roles{options_index} = roles{i};
            role_proportions(options_index) = (roles_count(i) / num_students) * 100;
        end
    end
    %add on the category of 'other' if that was non_zero
    if other_count ~= 0 
        options_index = options_index + 1;
        final_roles{options_index} = 'Other';
        role_proportions(options_index) = (other_count / num_students) * 100;
    end
    
    ordinal_final_roles = categorical(final_roles); %convert the strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_roles = reordercats(ordinal_final_roles, final_roles);
    
    %plot the data
    colours = rand(length(ordinal_final_roles), 3); %generate the colours for the bars
    bar_plot = bar(ordinal_final_roles, role_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colours in the bars in the plot
    text(1 : length(role_proportions),...
        role_proportions,...
        num2str(role_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('What role is this application for? (2021)');
    xlabel('Role');
    ylabel('Percentage of students')
end