-- Tabla Railway
SELECT*
FROM railway
LIMIT 5;

/* 1.Demanda */
-- 1.1 ¿Qué rutas concentran más viajes?
SELECT
	"Route",
	COUNT(*) AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

-- 1.2 ¿Qué días concentran más viajes?
SELECT
	"Day of Week",
	COUNT(*) AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

-- 1.3 ¿Qué horarios concentran más viajes?
SELECT
	"Departure Hour",
	COUNT(*) AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

-- 1.4 ¿Qué períodos del día concentran más viajes?
SELECT
	"Time Slot",
	COUNT(*) AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

/* 2.Ingresos */
-- 2.1 ¿Qué rutas generan mayores ingresos registrados?
SELECT
	"Route",
	SUM("Price") AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

-- 2.2 ¿Qué clases generan mayores ingresos registrados?
SELECT
	"Ticket Class",
	SUM("Price") AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

-- 2.3 ¿Qué tipos de ticket generan mayores ingresos registrados?
SELECT
	"Ticket Type",
	SUM("Price") AS "Total"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

/* 3.Desempeño */  
-- 3.1 ¿Qué proporción de viajes llega a tiempo, se retrasa o se cancela?
SELECT
	"Journey Status",
	COUNT(*) AS "Total",
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS "Porcentaje"
FROM railway
GROUP BY 1
ORDER BY 2 DESC;

/* 4.Retrasos */
-- 4.1 ¿Cuáles son las principales causas de retraso?
SELECT
	"Reason for Delay",
	COUNT(*) AS "Total",
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS "Porcentaje"
FROM railway
WHERE "Journey Status" = 'Delayed'
GROUP BY 1
ORDER BY 2 DESC;

-- 4.2 ¿Qué rutas presentan más retrasos?
SELECT
	"Route",
	COUNT(*) AS "Total",
	ROUND(AVG("Delay Minutes"), 2) AS "Promedio_minutos",
	ROUND(MAX("Delay Minutes"), 2) AS "Máximo_minutos"
FROM railway
WHERE "Journey Status" = 'Delayed'
GROUP BY 1
ORDER BY 2 DESC;

-- 4.3 ¿Qué rutas tienen mayor proporción de viajes retrasados?
SELECT
	"Route",
	COUNT(*) AS "Viajes_realizados",
	COUNT(*) FILTER (WHERE "Journey Status" = 'Delayed') AS "Viajes_con_retrasos",
	ROUND(COUNT(*) FILTER (WHERE "Journey Status" = 'Delayed') * 100.0 / COUNT(*), 2) AS "Porcentaje_retraso"
FROM railway
WHERE "Journey Status" IN ('On Time', 'Delayed')
GROUP BY "Route"
HAVING COUNT(*) >= 30
ORDER BY 4 DESC;

/* 5. Reembolsos */
-- 5.1 ¿Cómo se comportan las solicitudes de reembolso según el estado del viaje?
SELECT
	"Journey Status",
	"Refund Request",
	COUNT(*) AS "Total",
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Journey Status"), 2) AS "Porcentaje"
FROM railway
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 5.2 ¿Qué proporción de reembolsos tiene cada estado del viaje?
SELECT
	"Journey Status",
	COUNT(*) AS "Total",
	COUNT(*) FILTER (WHERE "Refund Request" = 'Yes') AS "Solicitud_Reembolso",
	ROUND(COUNT(*) FILTER (WHERE "Refund Request" = 'Yes') * 100.0 / COUNT(*), 2) AS "Porcentaje"
FROM railway
GROUP BY 1
ORDER BY 4 DESC;