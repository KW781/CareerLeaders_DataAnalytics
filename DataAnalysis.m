disp(newline);
disp('Drop-in Analysis Plots');
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp('7. Plot of drop in attendance over time');
disp(newline);
disp('Recruitment Survey Plots');
disp('8. Plot of roles students applied to');
disp('9. Plot of reasons for not applying');
disp('10. Plot of extra-curriculars students take part in');
disp('11. Plot of stages students are in');
disp('12. Plot of business school events students attended')
disp('13. Plot of degrees students are studying');
disp('14. Plot of majors students are studying');
disp('15. Plot of salaries offered to students for their roles')
disp('16. Plot of genders of survey respondents')
disp('17. Plot of NZ residency status of students')
disp('18. Plot of application progression of students')
disp('19. Plot of top/most popular employers')
disp(newline);
disp('P2B Survey Plots');
disp('20. Plot of confidence of students in career areas before and after');
disp('21. Plot of understanding after programme completion');
disp('22. Plot of perceived value of group sessions');
disp('23. Plot of perceived value of workshops');
disp('24. Plot of perceived value of individual work');
disp('25. Plot of how satisfied students were in using Canvas');
disp('26. Plots of attendance at P2B events and workload');
disp(newline);
disp('LinkedIn Destinations Plots');
disp('27. Plot of most popular majors of graduates');
disp('28. Plots of jobs taken by graduates in current period');
disp('29. Plots of jobs taken by graduates in previous period');
disp('30. Plots of jobs taken by graduates in 2nd furthest period');
disp('31. Plots of jobs taken by graduates in furthest period');
disp('32. Plot of companies worked at by graduates in current period');
disp('33. Plot of companies worked at by graduates in previous period');
disp('34. Plot of companies worked at by graduates in 2nd furthest period');
disp('35. Plot of companies worked at by graduates in furthest period');
disp(newline);

%request the plot number from the user, until a valid one is entered
plot_number = -1;
while ~(plot_number >= 1 && plot_number <= 34)
    plot_number = input('Enter which number plot you want: ');
end
file_name = input('Enter the file name of the spreadsheet you want to analyse: ', 's');

%remove leading and trailing quotation marks
if strcmp(file_name(1), '"') 
    file_name = file_name(2 : length(file_name) - 1);
end

%if recruitment plot is wanted, parse top and bottom spreadsheet headers
if plot_number >= 7 && plot_number <= 16 && plot_number ~= 14
    [~, ~, raw_data] = xlsread(file_name);
    dimensions = size(raw_data);
    num_cols = dimensions(2);
    headings = {};
    for i = 1 : num_cols
        headings{i} = raw_data{1, i};
    end
elseif plot_number >= 17 && plot_number <= 18 || plot_number == 14
    %if recruitment plot where employer data is needed, extract the bottom
    %headings as well because they contain the employer headings
    [~, ~, raw_data] = xlsread(file_name);
    dimensions = size(raw_data);
    num_cols = dimensions(2);
    top_headings = {};
    bottom_headings = {};
    for i = 1 : num_cols
        top_headings{i} = raw_data{1, i};
        bottom_headings{i} = raw_data{2, i};
    end
end
    

try
    switch plot_number
        case 1
            FirstTimePlot(file_name);
        case 2
            AttendancePurposePlot(file_name);
        case 3
            FoundOutMethodPlot(file_name);
        case 4
            RolePlot(file_name);
        case 5
            YearLevelPlot(file_name);
        case 6
            OrganisationPlot(file_name);
        case 7
            MonthAttendancePlot(file_name);
        case 8
            RoleApplicationPlot(file_name, headings);
        case 9
            ReasonsNotApplyPlot(file_name, headings);
        case 10
            ExtracurricularsPlot(file_name, headings);
        case 11
            StagesPlot(file_name, headings);
        case 12
            EventAttendancePlot(file_name, headings);
        case 13
            StudyDegreePlot(file_name);
        case 14
            MajorsPlot(file_name, top_headings, bottom_headings);
        case 15
            SalaryPlot(file_name, headings);
        case 16
            GenderPlot(file_name, headings);
        case 17
            NZResidencyPlot(file_name, headings);
        case 18
            ApplicationProgressionPlot(file_name, top_headings, bottom_headings);
        case 19
            TopEmployersPlot(file_name, top_headings, bottom_headings);
        case 20
            ConfidencePlot(file_name);
        case 21
            UnderstandingProgrammePlot(file_name);
        case 22
            GroupSessionPlot(file_name);
        case 23
            WorkshopPlot(file_name);
        case 24
            IndividualWorkPlot(file_name);
        case 25
            CanvasSatisfactionPlot(file_name);
        case 26
            WorkloadAttendancePlot(file_name);
        case 27
            DestinationsMajorsPlot(file_name);
        case 28
            JobTitlesPlot(file_name, 4);
        case 29
            JobTitlesPlot(file_name, 1);
        case 30
            JobTitlesPlot(file_name, 2);
        case 31
            JobTitlesPlot(file_name, 3);
        case 32
            CompaniesPlot(file_name, 4);
        case 33
            CompaniesPlot(file_name, 1);
        case 34
            CompaniesPlot(file_name, 2);
        case 35
            CompaniesPlot(file_name, 3);
    end
catch
    disp('Something went wrong. Try again. Make sure you have given the correct spreadsheet for the plot you want.')
    if plot_number >= 26 && plot_number <= 34
        disp('You are generating a plot for the LinkedIn Destinations project. Make sure you have entered the data into the spreadsheet correctly.');
    end
end


