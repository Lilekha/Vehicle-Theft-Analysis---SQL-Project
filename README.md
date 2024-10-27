
# Motor Vehicles Theft Analysis

#### Analyzing when, which and where the vehicles are likely to be stolen 

**THE SITUATION**

- We’ve just been hired as a Data Analyst for the New Zealand police department to help raise awareness about motor vehicle thefts.

**THE ASSIGNMENT**

- The police department plans to release a public service announcement to encourage citizens to be aware of thefts and stay safe. You've been asked to dig into the stolen vehicles database to find details on when, which and where vehicles are most likely to be stolen.

**THE OBJECTIVES**

1. Identify **when** vehicles are likely to be stolen.
2. Identify **which** vehicles are likely to be stolen.
3. Identify **where** vehicles are likely to be stolen.

### Motor Vehicle Thefts Dataset

Stolen vehicle data from the New  Zealand police department's vehicle of interest database containing 6  months of data. Each record represents a single stolen vehicle, with  data on vehicle type, make, year, color, date stolen and region stolen.

[stolen_vehicles_db_data_dictionary ](https://www.notion.so/127c8a78b37c80698ddbd690c5d7aa67?pvs=21)

## **Objective 1: Identify When Vehicles Are Likely to Be Stolen**

1. **Annual Theft Count:** Determine the number of vehicles stolen each year.
2. **Monthly Theft Count:** Calculate the number of vehicles stolen each month.
3. **Daily Theft Count:** Find the number of vehicles stolen each day of the week.
4. **Day of Week Names:** Replace numeric day-of-week values with their corresponding names (e.g., Sunday, Monday, Tuesday).
5. **Weekly Theft Visualization:** Create a bar chart to illustrate the number of vehicles stolen on each day of the week.

```sql
-- OBJECTIVE 1: Identify when vehicles are likely to be stolen

-- a. Find the number of vehicles stolen each year

SELECT year(date_stolen) as "Year", COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY year(date_stolen);
```

```sql
-- OBJECTIVE 1: Identify when vehicles are likely to be stolen

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
```

```sql
-- OBJECTIVE 1: Identify when vehicles are likely to be stolen

-- c. Find the number of vehicles stolen each day of the week
SELECT dayofweek(date_stolen) as "DoW No.", 
COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY dayofweek(date_stolen)
ORDER BY dayofweek(date_stolen);
```

```sql
-- OBJECTIVE 1: Identify when vehicles are likely to be stolen

-- d. Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
	
SELECT dayofweek(date_stolen) as "DoW No.", dayname(date_stolen) as "Day of the Week", 
substring(dayname(date_stolen),1,3) as "DoW Short",
COUNT(vehicle_id) as "No. of Vehicles" 
FROM stolen_vehicles
GROUP BY dayofweek(date_stolen), dayname(date_stolen),substring(dayname(date_stolen),1,3)
ORDER BY dayofweek(date_stolen);

-- e. Create a bar chart that shows the number of vehicles stolen on each day of the week
-- Made on Excel
```

![vehicle theft analysis ](https://github.com/user-attachments/assets/03ce09de-de28-4504-b05a-49cd207f3082)




## **Objective 2: Identify Which Vehicles Are Likely to Be Stolen**

1. **Vehicle Type Theft Frequency:** Identify the vehicle types that are most and least frequently stolen.
2. **Average Stolen Vehicle Age:** Calculate the average age of stolen cars for each vehicle type.
3. **Luxury vs. Standard Theft:** Determine the percentage of stolen vehicles that are luxury versus standard for each vehicle type.
4. **Theft by Vehicle Type and Color:** Create a table showing the number of stolen vehicles for the top 10 vehicle types and top 7 colors (including an "Other" category).
5. **Theft Heatmap:** Visualize the table data as a heatmap to compare vehicle types and colors.

```sql
-- OBJECTIVE 2: Identify which vehicles are likely to be stolen
SELECT * FROM stolen_vehicles;
SELECT * FROM make_details;

-- a. Find the vehicle types that are most often and least often stolen
	
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
```

```sql
-- OBJECTIVE 2: Identify which vehicles are likely to be stolen

-- b. For each vehicle type, find the average age of the cars that are stolen
	
	SELECT vehicle_type, ROUND(avg(year(date_stolen)-model_year),1) as avg_age,
    count(vehicle_id) as total_vehicles_stolen
    FROM stolen_vehicles
    GROUP BY vehicle_type
    ORDER BY avg_age;
```

```sql
-- OBJECTIVE 2: Identify which vehicles are likely to be stolen

-- c. For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
	
		WITH lux_std AS (SELECT vehicle_type, CASE WHEN make_type = 'Luxury' THEN 1 ELSE 0 END AS is_lux FROM stolen_vehicles sv
    LEFT JOIN make_details md
    ON sv.make_id = md.make_id)
    
    SELECT vehicle_type, ROUND((sum(is_lux)/count(is_lux))*100,1) AS Lux_Pct, 
    ROUND(100 - ((sum(is_lux)/count(is_lux))*100),1) AS Std_Pct
    FROM lux_std 
    GROUP BY vehicle_type
    ORDER BY Lux_Pct DESC;
```

```sql
-- OBJECTIVE 2: Identify which vehicles are likely to be stolen

-- d. Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen
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
```
![Screenshot 2024-10-23 021922](https://github.com/user-attachments/assets/32eb96d5-d392-4cef-a382-2d6b29c117f9)


## **Objective 3: Identify Where Vehicles Are Likely to Be Stolen**

1. **Regional Theft Count:** Find the number of vehicles stolen in each region.
2. **Regional Demographics and Theft:** Combine the previous output with population and density statistics for each region.
3. **Regional Theft Patterns:** Compare the types of vehicles stolen in the densest and least dense regions.
4. **Population vs. Density Scatter Plot:** Create a scatter plot of population versus density, with point size representing the number of stolen vehicles.
5. **Regional Theft Map:** Create a map of the regions, coloring them based on the number of stolen vehicles.

5. **Regional Theft Map:** Create a map of the regions, coloring them based on the number of stolen vehicles.

```sql
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
   
```

![vehicle theft analysis 1](https://github.com/user-attachments/assets/796aaa99-acf9-411e-a217-a92e46501eb7)