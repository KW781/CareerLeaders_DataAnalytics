function [] = CompaniesPlot(file_name, recent_param)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find column with the comapny date, corresponding to the recent parameter
    col_count = 0; %counter to keep track of number of columns with job title data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Where', headings{i})
            col_count = col_count + 1;
        end
        if col_count == recent_param
            column_number = i;
            break;
        end
    end
    
    %extract spreadsheet dimensions and number of students
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up comapanies and counters array, then count through the spreadsheet
    companies = {};
    company_counters = [];
    for student = 1 : num_students
        %check if current table element is null
        null = isnan(table{student, column_number});
        if length(null) > 1 %will return an array for character vectors, so following check must be done
            null = 0;
        end        
        if length(null) == 0
            null = 1; %set to null if the element is an empty string
        end
        
        if ~null %only check the element if it's not null
            %check whether the current company already exists in the array
            match = 0;
            for i = 1 : length(companies)
                if strcmp(table{student, column_number}, companies{i})
                    %if it does exist, increment counter and set match
                    company_counters(i) = company_counters(i) + 1;
                    match = 1;
                    break;
                end
            end
            %add company to companies array if it doesn't already exist
            if ~match
                companies{length(companies) + 1} = table{student, column_number};
                company_counters(length(company_counters) + 1) = 1;
            end
        end
    end
    
    %sort company counters in descending order using bubble sort
    no_more_swaps = 0;
    max_index = length(company_counters) - 1; 
    while ~no_more_swaps
        no_more_swaps = 1;
        for i = 1 : max_index
            if company_counters(i) < company_counters(i + 1)
                temp_count = company_counters(i);
                company_counters(i) = company_counters(i + 1);
                company_counters(i + 1) = temp_count;
                temp_comp = companies{i};
                companies{i} = companies{i + 1};
                companies{i + 1} = temp_comp;
                no_more_swaps = 0;
            end
        end
        max_index = max_index - 1;
    end
    
    %take only the top 10 companies
    if length(company_counters) > 15
        company_counters = company_counters(1 : 15);
        final_companies = {};
        for i = 1 : 15
            final_companies{i} = companies{i};
        end
    else
        final_companies = companies;
    end
    
    ordinal_companies = categorical(final_companies); %convert the strings to categorical type
    
    %reorder the categories, since categorical() alphabetises them
    ordinal_companies = reordercats(ordinal_companies, final_companies);
    
    %plot the data
    colours = rand(length(ordinal_companies), 3); %randomly generate colours for bars
    bar_plot = barh(ordinal_companies, company_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    xlim([0, max(company_counters) + 1]); %set the upper and lower limits of the x-axis numbers
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Number of graduates working at top 15 companies');
    xlabel('Company')
    ylabel('Number of graduates')     
end