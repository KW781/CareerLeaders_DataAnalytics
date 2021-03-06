disp(newline);
disp('Drop-in Analysis Plots');
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp(newline);
disp('Recruitment Survey Plots');
disp('7. Plot of roles students applied to');
disp('8. Plot of reasons for not applying');
disp('9. Plot of extra-curriculars students take part in');
disp('10. Plot of stages students are in');
disp('11. Plot of business school events students attended')
disp('12. Plot of degrees students are studying');
disp('13. Plot of majors students are studying');
disp(newline);
disp('P2B Survey Plots');
disp('14. Plot of confidence of students in career areas before and after');
disp('15. Plot of understanding after programme completion');
disp('16. Plot of perceived value of group sessions');
disp('17. Plot of perceived value of workshops');
disp('18. Plot of perceived value of individual work');
disp('19. Plot of how satisfied students were in using Canvas');
disp('20. Plots of attendance at P2B events and workload');
disp(newline);
disp('LinkedIn Destinations Plots');
disp('21. Plot of most popular majors of graduates');
disp('22. Plots of jobs taken by graduates in current period');
disp('23. Plots of jobs taken by graduates in previous period');
disp('24. Plots of jobs taken by graduates in 2nd furthest period');
disp('25. Plots of jobs taken by graduates in furthest period');
disp('26. Plot of companies worked at by graduates in current period');
disp('27. Plot of companies worked at by graduates in previous period');
disp('28. Plot of companies worked at by graduates in 2nd furthest period');
disp('29. Plot of companies worked at by graduates in furthest period');
disp(newline);

%request the plot number from the user, until a valid one is entered
plot_number = -1;
while ~(plot_number >= 1 && plot_number <= 29)
    plot_number = input('Enter which number plot you want: ');
end
file_name = input('Enter the file name of the spreadsheet you want to analyse: ', 's');

%remove leading and trailing quotation marks
if strcmp(file_name(1), '"') 
    file_name = file_name(2 : length(file_name) - 1);
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
            RoleApplicationPlot(file_name);
        case 8
            ReasonsNotApplyPlot(file_name);
        case 9
            ExtracurricularsPlot(file_name);
        case 10
            StagesPlot(file_name);
        case 11
            EventAttendancePlot(file_name);
        case 12
            StudyDegreePlot(file_name);
        case 13
            MajorsPlot(file_name);
        case 14
            ConfidencePlot(file_name);
        case 15
            UnderstandingProgrammePlot(file_name);
        case 16
            GroupSessionPlot(file_name);
        case 17
            WorkshopPlot(file_name);
        case 18
            IndividualWorkPlot(file_name);
        case 19
            CanvasSatisfactionPlot(file_name);
        case 20
            WorkloadAttendancePlot(file_name);
        case 21
            DestinationsMajorsPlot(file_name);
        case 22
            JobTitlesPlot(file_name, 4);
        case 23
            JobTitlesPlot(file_name, 1);
        case 24
            JobTitlesPlot(file_name, 2);
        case 25
            JobTitlesPlot(file_name, 3);
        case 26
            CompaniesPlot(file_name, 4);
        case 27
            CompaniesPlot(file_name, 1);
        case 28
            CompaniesPlot(file_name, 2);
        case 29
            CompaniesPlot(file_name, 3);
    end
catch
    disp('Something went wrong. Try again. Make sure you have given the correct spreadsheet for the plot you want.')
    if plot_number >= 21 && plot_number <= 29
        disp('You are generating a plot for the LinkedIn Destinations project. Make sure you have entered the data into the spreadsheet correctly.');
    end
end


