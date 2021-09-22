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

X = data(:, 1:4);
Y = arrayfun(@(s) lower(s) == "yes", data(:, 5)).';

W = MyRelief(X, Y, 14)