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
    
    %calculate the percentages from the counters
    company_proportions = [];
    for i = 1 : length(company_counters)
        company_proportions(i) = round((company_counters(i) / sum(company_counters)) * 100, 2);
    end
    
    ordinal_companies = categorical(companies); %convert the strings to categorical type
    
    %reorder the categories, since categorical() alphabetises them
    ordinal_companies = reordercats(ordinal_companies, companies);
    
    %plot the data
    colours = rand(length(ordinal_companies), 3); %randomly generate colours for bars
    bar_plot = barh(ordinal_companies, company_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData) + '%';
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Percentages of graduates working at each company');
    xlabel('Company')
    ylabel('Percentage of graduates')     
end