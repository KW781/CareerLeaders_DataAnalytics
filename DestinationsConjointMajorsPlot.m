function [] = DestinationsConjointMajorsPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the majors data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Conjoint Major', headings{i})
            column_number = i;
            break
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    majors = {}; %unique majors that will be read from the spreadsheet
    major_counters = []; %counters for the majors taken by graduates
    
    %count the majors studied by the graduates
    for col = column_number : column_number + 2
        for row = 1 : num_students
            %check whether current major already exists in the array
            match = 0;
            for i = 1 : length(majors)
                if strcmpi(table{row, col}, majors)
                    major_counters(i) = major_counters(i) + 1;
                    match = 1;
                    break;
                end
            end
            %add new major to the array if there's no match
            if ~match
                majors{length(majors) + 1} = table{row, col};
                major_counters(length(major_counters) + 1) = 1;
            end
        end
    end
    
    %calculate the percentages from counters, for non-zero majors
    options_index = 0;
    final_majors = {};
    major_proportions = [];
    for i = 1 : length(major_counters)
        if round((major_counters(i) / num_students) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_majors{options_index} = majors{i};
            major_proportions(options_index) = round((major_counters(i) / num_students) * 100, 2);
        end
    end
    
    ordinal_final_majors = categorical(majors); %convert final major strings to categorical type
    
    %reorder categories, because categorical() sorts them alphabetically
    ordinal_final_majors = reordercats(ordinal_final_majors, majors);
    
    %plot the data
    colours = rand(length(ordinal_final_majors), 3); %randomly generate colours for bars
    bar_plot = barh(ordinal_final_majors, major_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    %set the upper and lower limits of the x-axis numbers
    limits = xlim;
    xlim([0, min([100, max([limits(2), max(major_proportions) + 5, max(major_proportions) * 1.1])])]);
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData) + '%';
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Percentages of graduates studying each major');
    xlabel('Percentage of graduates')
    ylabel('Majors') 
end