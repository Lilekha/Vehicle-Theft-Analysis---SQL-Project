-- OBJECTIVE 2: Identify which vehicles are likely to be stolen
SELECT * FROM stolen_vehicles;
SELECT * FROM make_details;

-- 1. Find the vehicle types that are most often and least often stolen
	
    -- Top 5 Most Stolen
    SELECT vehicle_type, count(vehicle_id) as Num_stolen FROM stolen_vehicles
    GROUP BY vehicle_type
    ORDER BY Num_stolen DESC
    LIMIT 5;
    
    -- Top 5 Least Stolen
	SELECT vehicle_type, count(vehicle_id) as Num_Stolen FROM stolen_vehicles
    GROUP BY vehicle_type
    ORDER BY Num_stolen
    LIMIT 5;

-- 2. For each vehicle type, find the average age of the cars that are stolen
	
	SELECT vehicle_type, ROUND(avg(year(date_stolen)-model_year),1) as avg_age,
    count(vehicle_id) as total_vehicles_stolen
    FROM stolen_vehicles
    GROUP BY vehicle_type
    ORDER BY avg_age;

-- 3. For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
	WITH lux_std AS (SELECT vehicle_type, CASE WHEN make_type = 'Luxury' THEN 1 ELSE 0 END AS is_lux FROM stolen_vehicles sv
    LEFT JOIN make_details md
    ON sv.make_id = md.make_id)
    
    SELECT vehicle_type, ROUND((sum(is_lux)/count(is_lux))*100,1) AS Lux_Pct, 
    ROUND(100 - ((sum(is_lux)/count(is_lux))*100),1) AS Std_Pct
    FROM lux_std 
    GROUP BY vehicle_type
    ORDER BY Lux_Pct DESC;

-- 4. Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen
	SELECT color, COUNT(vehicle_id) AS Num_Stolen
    FROM stolen_vehicles
    GROUP BY color
    ORDER BY Num_Stolen DESC;
    
    SELECT COUNT(vehicle_id) FROM stolen_vehicles
    WHERE color IN("Gold", "Brown", "Yellow", "Orange", "Purple", "Cream", "Pink") OR color IS NULL;
    
    SELECT vehicle_type, count(vehicle_id) AS Num_Stolen,
		SUM(CASE WHEN color = "Silver" THEN 1 ELSE 0 END) AS Silver,
        SUM(CASE WHEN color = "White" THEN 1 ELSE 0 END) AS White,
        SUM(CASE WHEN color = "Black" THEN 1 ELSE 0 END) AS Black,
        SUM(CASE WHEN color = "Blue" THEN 1 ELSE 0 END) AS Blue,
        SUM(CASE WHEN color = "Red" THEN 1 ELSE 0 END) AS Red,
        SUM(CASE WHEN color = "Grey" THEN 1 ELSE 0 END) AS Grey,
        SUM(CASE WHEN color = "Green" THEN 1 ELSE 0 END) AS Green,
        SUM(CASE WHEN (color IN("Gold", "Brown", "Yellow", "Orange", "Purple", "Cream", "Pink") OR color IS NULL) THEN 1 ELSE 0 END) AS "Others"
    FROM stolen_vehicles
    GROUP BY vehicle_type
    ORDER BY Num_Stolen DESC
    LIMIT 10;

-- 5. Create a heat map of the table comparing the vehicle types and colors


Silver	1272
White	934
Black	589
Blue	512
Red	    390
Grey	378
Green	224
Gold	77
Brown	49
Yellow	39
Orange	35
Purple	26
	    15
Cream	 9
Pink	 4