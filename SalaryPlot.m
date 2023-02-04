function [] = SalaryPlot(file_name, headings)
%This particular function plots salary data for THREE different groups
%based on recruitment survey data:
%
%1. Overall
%2. Gender (Male vs Female)
%3. Type of programme (Internship vs Grad roles)

    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the salary data
    sal_column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('salary', headings{i}) && WithinWord('offered', headings{i})
            sal_column_number = i;
            break;
        end
    end
    
    %find the column number with the gender data
    gen_column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('gender', headings{i}) && WithinWord('identify', headings{i})
            gen_column_number = i;
            break;
        end
    end
    
    %find the column number with the internship/graduate data
    prog_column_number = -1;
    for i = 1 : length(headings)
        if WithinWord('applied', headings{i}) && WithinWord('January', headings{i}) && WithinWord('April', headings{i})
            prog_column_number = i;
            break
        end
    end
    
    %extract table dimensions (number of students)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up salary strings and salary counters to count up salary data responses
    salaries = {'$40,000 - $44,999', '$45,000 - $49,999', '$50,000 - $54,999',...
                '$55,000 - $59,999', '$60,000 - $64,999', '$65,000 - $69,999',...
                '$70,000 or above', 'I''d rather not say', 'Other'};
    salary_counters = zeros(1, length(salaries));
    male_salaries = zeros(1, length(salaries));
    female_salaries = zeros(1, length(salaries));
    intern_salaries = zeros(1, length(salaries));
    grad_salaries = zeros(1, length(salaries));
    
    %count number of students for each salary category
    for i = 1 : num_students
        if length(table{i, sal_column_number}) > 0
            found = 0; %initialise flag to check if a match was found within the array
            for j = 1 : length(salaries)
                %increment the counter for the salary if for that salary a match is found
                if strcmp(table{i, sal_column_number}, salaries{j})
                    salary_counters(j) = salary_counters(j) + 1;
                    %count towards gender based data
                    if strcmp(table{i, gen_column_number}, 'Male')
                        male_salaries(j) = male_salaries(j) + 1;
                    elseif strcmp(table{i, gen_column_number}, 'Female')
                        female_salaries(j) = female_salaries(j) + 1;
                    end
                    %count towards intern/grad based data
                    if WithinWord('intern', table{i, prog_column_number})
                        intern_salaries(j) = intern_salaries(j) + 1;
                    elseif WithinWord('graduate', table{i, prog_column_number})
                        grad_salaries(j) = grad_salaries(j) + 1;
                    end
                    found = 1;
                    break;
                end
            end
            %increment the 'other' category if there was no match found
            if ~found
                salary_counters(length(salary_counters)) = salary_counters(length(salary_counters)) + 1;
            end
        end
    end
    
    %ensure only salaries with a count greater than zero are plotted, for
    %both the overall salary statistics and gender based salary statistics
    final_salaries = {};
    overall_options_index = 0;
    gender_options_index = 0;
    prog_options_index = 0;
    final_gender_salaries = {};
    final_prog_salaries = {};
    salary_proportions = [];
    male_proportions = [];
    female_proportions = [];
    intern_proportions = [];
    grad_proportions = [];
    for i = 1 : length(salary_counters)
        if round((salary_counters(i) / sum(salary_counters)) * 100, 2) ~= 0
            overall_options_index = overall_options_index + 1;
            final_salaries{overall_options_index} = salaries{i};
            salary_proportions(overall_options_index) = round((salary_counters(i) / sum(salary_counters)) * 100, 2);
        end
        %if either the male or female count is non-zero, include that
        %salary for the gender plot
        if round((male_salaries(i) / sum(male_salaries)) * 100, 2) ~= 0 || round((female_salaries(i) / sum(female_salaries)) * 100, 2) ~= 0
            gender_options_index = gender_options_index + 1;
            final_gender_salaries{gender_options_index} = salaries{i};
            male_proportions(gender_options_index) = round((male_salaries(i) / sum(male_salaries)) * 100, 2);
            female_proportions(gender_options_index) = round((female_salaries(i) / sum(female_salaries)) * 100, 2);
        end
        %if either the intern or grad count is non-zero, include that in
        %the programme based plot
        if round((intern_salaries(i) / sum(intern_salaries)) * 100, 2) ~= 0
            prog_options_index = prog_options_index + 1;
            final_prog_salaries{prog_options_index} = salaries{i};
            intern_proportions(prog_options_index) = round((intern_salaries(i) / sum(intern_salaries)) * 100, 2);
            grad_proportions(prog_options_index) = round((grad_salaries(i) / sum(grad_salaries)) * 100, 2);
        end
    end
    
    ordinal_final_salaries = categorical(final_salaries); %convert strings to categorical type
    ordinal_gender_salaries = categorical(final_gender_salaries);
    ordinal_prog_salaries = categorical(final_prog_salaries);
    
    %reorder the salary categories because categorical() alphabetises them by default
    ordinal_final_salaries = reordercats(ordinal_final_salaries, final_salaries);
    ordinal_gender_salaries = reordercats(ordinal_gender_salaries, final_gender_salaries);
    ordinal_prog_salaries = reordercats(ordinal_prog_salaries, final_prog_salaries);
    
    %plot the data
    colours = rand(length(ordinal_final_salaries), 3);
    
    %create percentage symbols array, because they need to be appended to the numbers when plotting
    percent_arr = '';
    for i = 1 : length(salary_proportions)
        percent_arr = [percent_arr; '%'];
    end
    gen_percent_arr = '';
    for i = 1 : length(male_proportions)
        gen_percent_arr = [gen_percent_arr; '%'];
    end
    prog_percent_arr = '';
    for i = 1 : length(intern_proportions)
        prog_percent_arr = [prog_percent_arr; '%'];
    end
    
    %plot the actual data with colours and percent symbols generated, for the overall salary data
    figure(1);
    bar_plot = bar(ordinal_final_salaries, salary_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(salary_proportions),...
        salary_proportions,...
        [num2str(salary_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students receiving different salaries for their roles');
    xlabel('Salary');
    ylabel('Percentage of students');
    %generate random colour for male gender based salary plots
    colour = rand(1, 3);
    colours = [];
    for i = 1 : length(ordinal_gender_salaries)
        colours = [colours; colour];
    end
    %plot the data for gender based salary data
    figure(2);
    subplot(1, 2, 1);
    bar_plot = bar(ordinal_gender_salaries, male_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(male_proportions),...
        male_proportions,...
        [num2str(male_proportions'), gen_percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of male students receiving salaries for their roles');
    xlabel('Salary');
    ylabel('Percentage of male students'); 
    %generate random colour for female gender based salary data
    colour = rand(1, 3);
    colours = [];
    for i = 1 : length(ordinal_gender_salaries)
        colours = [colours; colour];
    end
    subplot(1, 2, 2);
    bar_plot = bar(ordinal_gender_salaries, female_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(female_proportions),...
        female_proportions,...
        [num2str(female_proportions'), gen_percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of female students receiving salaries for their roles');
    xlabel('Salary');
    ylabel('Percentage of female students');
    %plot the actual data with colours and percent symbols generated, for the intern/grad salary data
    figure(3);
    %generate random colour for intern based salary data
    colour = rand(1, 3);
    colours = [];
    for i = 1 : length(ordinal_prog_salaries)
        colours = [colours; colour];
    end  
    subplot(1, 2, 1); 
    bar_plot = bar(ordinal_prog_salaries, intern_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    text(1 : length(intern_proportions),...
        intern_proportions,...
        [num2str(intern_proportions'), prog_percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students receiving salaries for their roles: Internships');
    xlabel('Salary');
    ylabel('Percentage of students');
    %generate random colour for grad based salary data
    colour = rand(1, 3);
    colours = [];
    for i = 1 : length(ordinal_prog_salaries)
        colours = [colours; colour];
    end
    subplot(1, 2, 2);
    bar_plot = bar(ordinal_prog_salaries, grad_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars for the bar plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(grad_proportions) + 5, max(grad_proportions) * 1.1])])]);
    text(1 : length(grad_proportions),...
        grad_proportions,...
        [num2str(grad_proportions'), prog_percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Percentages of students receiving salaries for their roles: Graduate Roles');
    xlabel('Salary');
    ylabel('Percentage of students');
end