--table creation
CREATE TABLE ai_models (
    model TEXT,
    context_window TEXT,
    creator TEXT,
    intelligence_index INT,
    price TEXT,
    speed INT,
    latency FLOAT
);


SELECT * FROM ai_models;

--top performing models

SELECT model, intelligence_index
FROM ai_models
ORDER BY intelligence_index DESC
LIMIT 5;


--fastest model
SELECT model, speed
FROM ai_models
ORDER BY speed DESC
LIMIT 5;

--best budget models
SELECT model, intelligence_index, price
FROM ai_models
ORDER BY intelligence_index DESC, price ASC
LIMIT 5;


--company wise performance
SELECT creator,
       AVG(intelligence_index) AS avg_intelligence,
       AVG(speed) AS avg_speed
FROM ai_models
GROUP BY creator;

--performance score

SELECT model,
       intelligence_index,
       price,
       (intelligence_index / price::numeric) AS performance_score
FROM ai_models
ORDER BY performance_score DESC;


--
--rank models
SELECT model, creator, intelligence_index,
       RANK() OVER (PARTITION BY creator ORDER BY intelligence_index DESC)
FROM ai_models;


--second best model
SELECT *
FROM (
  SELECT model, intelligence_index,
         RANK() OVER (ORDER BY intelligence_index DESC) rnk
  FROM ai_models
) t
WHERE rnk = 2;

--subqueries and filtering
SELECT model, intelligence_index
FROM ai_models
WHERE intelligence_index > (
    SELECT AVG(intelligence_index) FROM ai_models
);

--model with lowest price
SELECT REPLACE(TRIM(price), '$', '')::numeric
FROM ai_models;

--efficiency score
SELECT model,
       intelligence_index,
       price,
       intelligence_index / price AS score
FROM ai_models
WHERE price > 0;


--find top performing
SELECT creator,
       AVG(intelligence_index) AS avg_score
FROM ai_models
GROUP BY creator
ORDER BY avg_score DESC
LIMIT 1;

--company fast model
SELECT creator,
       AVG(speed) AS avg_speed
FROM ai_models
GROUP BY creator
ORDER BY avg_speed DESC;