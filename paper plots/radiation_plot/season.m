%{

    /*******************************\
    |                               |
    |       Casper van Wezel        |
    |       2018-12-11              |
    |       Season                  |
    |                               |
    \*******************************/
%}

% seasons_names = {'spring','summer','fall','winter'};

function s = season(time)
    mapping(1) = 4; % winter January
    mapping(2) = 4; % winter February
    mapping(3) = 1; % spring March
    mapping(4) = 1; % spring April
    mapping(5) = 1; % spring May
    mapping(6) = 2; % summer June
    mapping(7) = 2; % summer July
    mapping(8) = 2; % summer August
    mapping(9) = 3; % fall   September
    mapping(10) = 3; % fall  October
    mapping(11) = 3; % fall  November
    mapping(12) = 4; % winter December

    m = month(time);
    s = mapping(m);
end
