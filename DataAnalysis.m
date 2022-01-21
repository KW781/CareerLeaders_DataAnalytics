table1 = table2cell(readtable('Drop-in Data 2021 [CONFIDENTIAL] (1).xlsx'));
table2 = table2cell(readtable('Recruit survey 2021 all responses data (1).xlsx'));

disp('Drop-in Analysis Plots')
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp('Recruitment Survey Plots');
disp('7. Plot of roles students applied to');

plot_number = input('Enter which number plot you want: ');

switch plot_number
    case 1
        clear table2;
        FirstTimePlot(table1);
    case 2
        clear table2;
        AttendancePurposePlot(table1);
    case 3
        clear table2;
        FoundOutMethodPlot(table1);
    case 4
        clear table2;
        RolePlot(table1);
    case 5
        clear table2;
        YearLevelPlot(table1);
    case 6
        clear table2;
        OrganisationPlot(table1);
    case 7
        clear table1;
        RoleApplicationPlot(table2);
end


