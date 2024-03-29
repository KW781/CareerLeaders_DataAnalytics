function [] = OrganisationPlot(file_name, time_period_num)
    table_raw = readtable(file_name);
    table = table2cell(table_raw); %read table data
    
    %find the column number with the organisation data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Which organisation is this application for?')
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
    organisations = {'P2B'}; %initialise organisations cell array to be populated, with at first just P2B
    organisations_count = [0];
    
    organisation_index = 1; %initialise the index for the organisations array to one
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
            organisation_proportions(i) = round((organisations_count(i) / sum(organisations_count)) * 100);
        end
    end
    
    ordinal_final_organisations = categorical(final_organisations); %convert strings to categorical type
    
    %this statement re-orders the cateogorical data into its original state
    %since by default, categorical() orders the data alphabetically
    ordinal_final_organisations = reordercats(ordinal_final_organisations, final_organisations);
    
    %plot the data
    colours = rand(length(ordinal_final_organisations), 3); %generate the colours for the bars
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(organisation_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_organisations, organisation_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(organisation_proportions) + 5, max(organisation_proportions) * 1.1])])]);
    text(1 : length(organisation_proportions),...
        organisation_proportions,...
        [num2str(organisation_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('What organisation are you applying for? (Top 10 shown)');
    xlabel('Organisation');
    ylabel('Percentage of students');
end
