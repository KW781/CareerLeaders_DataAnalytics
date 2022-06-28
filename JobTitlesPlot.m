function [] = JobTitlesPlot(file_name, recent_param)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find column number with the most recent job title data
    col_count = 0; %counter to keep track of number of columns with job title data
    column_number = -1;
    headings = table.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Generic Title', headings{i})
            col_count = col_count + 1;
        end
        if col_count == recent_param
            column_number = i;
            break;
        end
    end
    
    %extract data dimensions and create job title arrays
    dimensions = size(table);
    num_students = dimensions(1);
    %Note that 'None' should ALWAYS be the 2nd to last element in the
    %job_titles array
    job_titles = {'Manager', 'Auditor', 'Accountant', 'Banking', 'Advisor',...
                    'Administrator', 'Consultant', 'Analyst',...
                    'Engineer', 'Associate', 'None', 'Other'};
    job_title_counters = zeros(1, length(job_titles));
    
    %count students with the job titles
    for i = 1 : num_students
        %check if current table element is null
        null = isnan(table{i, column_number});
        if length(null) > 1 %will return an array for character vectors, so following check must be done
            null = 0;
        end
        if null
            %increment the 'None' count if current table element is null (null is stored in the 2nd to last element)
            job_title_counters(length(job_title_counters) - 1) = job_title_counters(length(job_title_counters) - 1) + 1;
        else
            for j = 1 : length(job_titles)
                if strcmpi(table{i, column_number}, job_titles{j})
                    job_title_counters(j) = job_title_counters(j) + 1;
                    break;
                end
            end
        end
    end
    
    %calculate the percentages from counters, for non-zero job titles
    options_index = 0;
    final_job_titles = {};
    job_title_proportions = [];
    for i = 1 : length(job_title_counters)
        if job_title_counters(i) > 0
            options_index = options_index + 1;
            final_job_titles{options_index} = job_titles{i};
            job_title_proportions(options_index) = round((job_title_counters(i) / num_students) * 100, 2);
        end
    end
    
    ordinal_final_job_titles = categorical(final_job_titles); %change strings to categorical type
    
    %reorder categories since categorical() alphabetises them by default
    ordinal_final_job_titles = reordercats(ordinal_final_job_titles, final_job_titles);
    
    %plot the data
    colours = rand(length(ordinal_final_job_titles), 3); %generate the colours for the bars
    bar_plot = bar(ordinal_final_job_titles, job_title_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(job_title_proportions),...
        job_title_proportions,...
        num2str(job_title_proportions'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Jobs currently taken by graduates');
    xlabel('Job title');
    ylabel('Percentage of graduates');   
end