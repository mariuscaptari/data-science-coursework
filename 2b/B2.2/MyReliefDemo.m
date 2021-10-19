
fprintf("\nThis demo demonstrates our implementation of the relief algorithm\n")
fprintf("We will be using the dataset from the homework set:\n\n")
% Data from table 1 in the homework set
%       Sky         Temp    Humid.  Windy       Cycle
data = ["Sunny",    "High", "High", "False",    "No"; 
        "Sunny",    "High", "High", "True",     "No"; 
        "Cloudy",   "High", "High", "False",    "Yes"; 
        "Rain",     "Mid",  "High", "False",    "Yes"; 
        "Rain",     "Low",  "Low",  "False",    "Yes"; 
        "Rain",     "Low",  "Low",  "True",     "No"; 
        "Cloudy",   "Low",  "Low",  "True",     "Yes"; 
        "Sunny",    "Mid",  "High", "False",    "No"; 
        "Sunny",    "Low",  "Low",  "False",    "Yes"; 
        "Rain",     "Mid",  "Low",  "False",    "Yes"; 
        "Sunny",    "Mid",  "Low",  "True",     "Yes"; 
        "Cloudy",   "Mid",  "High", "True",     "Yes"; 
        "Cloudy",   "High", "Low",  "False",    "Yes"; 
        "Rain",     "Mid",  "High", "True",     "No";
];

disp(["Sky", "Temp", "Humid", "Windy", "Cycle"]);
disp(data);



X = data(:, 1:4);
Y = arrayfun(@(s) lower(s) == "yes", data(:, 5)).';

W = MyRelief(X, Y, 14);
fprintf("\n\nThe feature weights after applying the algorithm to the cycling data set\n");
fprintf("Sky\tTemp\tHumid\tWindy\n")
fprintf("%.3f\t%.3f\t%.3f\t%.3f\n\n", W(1), W(2), W(3), W(4));

data(:,6) = data(:,4) + data(:,1);
data(:,7) = data(:,4) + data(:,2);
data(:,8) = data(:,4) + data(:,3);
X2 = data(:, 1:7);

W2 = MyRelief(X2, Y, 14);

fprintf("The feature weights of the interaction features (see the report):\n");
fprintf("Sky_x_Windy\tTemp_x_Windy\tHumid_x_Windy\n")
fprintf("%.3f\t\t%.3f\t\t%.3f\t\n", W2(5), W2(6), W2(7));


