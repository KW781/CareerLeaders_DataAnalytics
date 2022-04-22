function [] = OrganisationPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Which organisation is this application for?')
            column_number = i;
            break
        end
    end

    dimensions = size(table);
    num_students = dimensions(1);
    organisations = {'P2B'}; %initialise organisations cell array to be populated, with at first just P2B
    organisations_count = [0];
    
    organisation_index = 1; %initialise the index for the organisations array to zero
    for i = 1 : num_students
        current_organisation = table{i, column_number};
        if (length(current_organisation) ~= 0) && (~strcmpi(current_organisation, 'N/A'))
            if (WithinWord('P2B', current_organisation)) || (WithinWord('Passport to Business', current_organisation))
                organisations_count(1) = organisations_count(1) + 1;
            else
                match = 0; %initialise match flag to false
                for j = 2 : length(organisations)
                    if (WithinWord(organisations{j}, current_organisation)) || (WithinWord(current_organisation, organisations{j}))
                        match = 1;
                        organisations_count(j) = organisations_count(j) + 1;
                        break;
                    end
                end
                if ~match
                    organisation_index = organisation_index + 1;
                    organisations{organisation_index} = current_organisation;
                    organisations_count(organisation_index) = 1;
                end
            end
        end
    end
    
    %following algorithm sorts the organisations from most selected to
    %least selected
    num_iterations = length(organisations_count) - 1;
    no_more_swaps = 0;
    while ~no_more_swaps
        no_more_swaps = 1;
        for i = 1 : num_iterations
            if organisations_count(i) < organisations_count(i + 1)
                %swap counters
                temp_count = organisations_count(i);
                organisations_count(i) = organisations_count(i + 1);
                organisations_count(i + 1) = temp_count;
                %swap org names
                temp_org = organisations{i};
                organisations{i} = organisations{i + 1};
                organisations{i + 1} = temp_org;
                %set outer loop to iterate again
                no_more_swaps = 0;
            end
        end
        num_iterations = num_iterations - 1;
    end
    
    %take just the top 10 organisations
    if length(organisations) > 10
        final_organisations = {};
        organisation_proportions = [];
        for i = 1 : 10
            final_organisations{i} = organisations{i};
            organisation_proportions(i) = (organisations_count(i) / num_students) * 100;
        end
    end
    
    ordinal_final_organisations = categorical(final_organisations); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_organisations = reordercats(ordinal_final_organisations, final_organisations);
    
    %plot the data
    colours = rand(length(ordinal_final_organisations), 3); %generate the colours for the bars
    bar_plot = bar(ordinal_final_organisations, organisation_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(organisation_proportions),...
        organisation_proportions,...
        num2str(organisation_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('What organisation are you applying for? (2021)');
    xlabel('Organisation');
    ylabel('Percentage of students');
end
