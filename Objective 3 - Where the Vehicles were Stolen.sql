-- OBJECTIVE 3: Identify where vehicles are likely to be stolen
SELECT * FROM stolen_vehicles;
SELECT * FROM locations;

SELECT * FROM stolen_vehicles sv
    LEFT JOIN locations l 
    ON sv.location_id = l.location_id;
    
-- 1. Find the number of vehicles that were stolen in each region
	SELECT region, count(vehicle_id) AS Num_Stolen FROM stolen_vehicles sv
    LEFT JOIN locations l 
    ON sv.location_id = l.location_id
    GROUP BY  region
    ORDER BY  Num_Stolen DESC;

-- 2. Combine the previous output with the population and density statistics for each region
    SELECT region, count(vehicle_id) AS Num_Stolen, population, density FROM stolen_vehicles sv
    LEFT JOIN locations l 
    ON sv.location_id = l.location_id
    GROUP BY  region, population, density
    ORDER BY  Num_Stolen DESC;

-- 3. Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?
	-- Top 3 Most Dense
		(SELECT "High Density" AS Density, sv.vehicle_type, count(vehicle_id) AS Num_Stolen FROM stolen_vehicles sv
		LEFT JOIN locations l 
		ON sv.location_id = l.location_id
		WHERE l.region IN ("Auckland", "Nelson", "Wellington")
		GROUP BY sv.vehicle_type
		ORDER BY  Num_Stolen DESC
        LIMIT 5)
        UNION
	-- Top 3 Least Dense
		(SELECT "Low Density" AS Density, sv.vehicle_type, count(vehicle_id) AS Num_Stolen FROM stolen_vehicles sv
		LEFT JOIN locations l 
		ON sv.location_id = l.location_id
		WHERE l.region IN ("Southland", "Gisborne", "Otago")
		GROUP BY sv.vehicle_type
		ORDER BY  Num_Stolen DESC
        LIMIT 5);      	 
	


-- 4. Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region
	

-- 5.Create a map of the regions and color the regions based on the number of stolen vehicles


-- Rough
-- Top 3 Most Dense
		SELECT region, count(vehicle_id) AS Num_Stolen, population, density FROM stolen_vehicles sv
		LEFT JOIN locations l 
		ON sv.location_id = l.location_id
		GROUP BY  region, population, density
		ORDER BY density DESC
        LIMIT 3;
  
        
Auckland	1638	1695200	343.09
Nelson	      92	  54500	129.15
Wellington	420	     543500	 67.52
        
	-- Top 3 Least Dense
		SELECT region, count(vehicle_id) AS Num_Stolen, population, density FROM stolen_vehicles sv
		LEFT JOIN locations l 
		ON sv.location_id = l.location_id
		GROUP BY  region, population, density
		ORDER BY density 
        LIMIT 3;
        
Southland	 26	 102400	 3.28
Gisborne	176	  52100	 6.21
Otago	    139	 246000	 7.89