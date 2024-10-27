-- OBJECTIVE 1: Identify when vehicles are likely to be stolen

-- a. Find the number of vehicles stolen each year

SELECT year(date_stolen) as "Year", COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY year(date_stolen);


-- b. Find the number of vehicles stolen each month

SELECT year(date_stolen) as "Year", month(date_stolen) as "Month", 
COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY year(date_stolen), month(date_stolen)
ORDER BY year(date_stolen), month(date_stolen);

-- Anomaly found in April 2024 - records found for only 6 days

SELECT year(date_stolen) as "Year", month(date_stolen) as "Month", day(date_stolen) as "Day", 
COUNT(vehicle_id) as "No. of Vehicles" FROM stolen_vehicles
WHERE month(date_stolen) = 4
GROUP BY year(date_stolen), month(date_stolen), day(date_stolen)
ORDER BY year(date_stolen), month(date_stolen), day(date_stolen);


-- c. Find the number of vehicles stolen each day of the week
SELECT dayofweek(date_stolen) as "DoW No.", 
COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY dayofweek(date_stolen)
ORDER BY dayofweek(date_stolen);
	

-- d. Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
	
SELECT dayofweek(date_stolen) as "DoW No.", dayname(date_stolen) as "Day of the Week", 
substring(dayname(date_stolen),1,3) as "DoW Short",
COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY dayofweek(date_stolen), dayname(date_stolen),substring(dayname(date_stolen),1,3)
ORDER BY dayofweek(date_stolen);


-- e. Create a bar chart that shows the number of vehicles stolen on each day of the week
-- Made on Excel