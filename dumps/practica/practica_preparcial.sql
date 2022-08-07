
/*
	Práctica pre parcial
    enunciado: https://docs.google.com/document/d/1_i2ZBBffJFP8eMJLykyOB7ZH5T6_sxe3HJpUdExMoB4/edit
*/

-- 1) Listar los tours contratados por cada cliente en los últimos 6 meses. 
--    Indicando cuil y denominación del cliente, nro y lugar de salida del tour, nombre y apellido del guia del tour.
--    Ordenar por denominación del cliente, nombre del guia y fecha y hora de contrato ascendente. 

select c.cuil, c.denom, t.nro, t.lugar_salida, em.nombre, em.apellido, con.fecha_hora
from tour t
inner join contrata con
	on con.nro_tour=t.nro
inner join cliente c
	on c.cuil=con.cuil_cliente
inner join empleado em
	on em.cuil=t.cuil_guia
where con.fecha_hora > adddate(now(), interval -6 month)
order by c.denom, em.nombre, con.fecha_hora;


-- 2) Listar los tours con asistentes en los que participó el guía "Javier Gomez".
-- Indicando cuil, nombre y apellido del guía, nro del tour, fecha y hora del contrato,
-- y de cada asistente indicar dni, nombre y apellido. Ordenar por fecha y hora de contrato descendente.

select emp.cuil, emp.nombre, emp.apellido, con.nro_tour, con.fecha_hora, a.dni, a.nombre, a.apellido
from empleado emp
inner join tour t
	on t.cuil_guia=emp.cuil
inner join contrata con
	on con.nro_tour=t.nro
inner join asistente_contrato ac
	on ac.nro_tour=con.nro_tour
    and ac.cuil_cliente=con.cuil_cliente
    and ac.fecha_hora=con.fecha_hora
inner join asistente a
	on a.dni=ac.dni_asistente
where emp.nombre = 'Javier' and emp.apellido = 'Gomez'
order by con.fecha_hora desc;

-- 3) Listar para cada contrato de este año el tour, cliente, los idiomas solicitados y los asistentes.
-- Si un contrato no tiene idiomas solicitados o asistentes debe mostrarse igualmente.
-- Indicar cuil y denominación del cliente, nro y temática del tour, fecha y hora del contrato,
-- código y nombre del idioma, dni, nombre y apellido del asistente.
-- Ordenar por nro de tour ascendente y fecha y hora de contrato descendente.

select c.cuil, c.denom, t.nro, t.tematica, con.fecha_hora, i.*, a.dni, a.nombre, a.nombre
from contrata con
inner join tour t
	on t.nro=con.nro_tour
inner join cliente c
	on c.cuil=con.cuil_cliente
left join idioma i
	on i.codigo=con.codigo_idioma
left join asistente_contrato ac
	on ac.nro_tour=con.nro_tour
    and ac.cuil_cliente=con.cuil_cliente
    and ac.fecha_hora=con.fecha_hora
left join asistente a
	on a.dni=ac.dni_asistente
where year(con.fecha_hora) = year(now())
#where con.fecha_hora > '2022-01-01 00:00:00'
order by t.nro asc, con.fecha_hora desc;


-- 4) Listar los tours y para cada uno las escalas realizadas este año. 
-- Si no se realizó ninguna escala este año para ese tour deberá mostrarse igualmente.
-- Indicar nro y temática del tour, fecha y hora de inicio de la escala,
-- por cada actividad su descripción y el nombre de la locación.
-- Ordenar por nro de tour y fecha y hora de inicio de escala ascendentes.

select t.nro, t.tematica, es.fecha_hora_ini, a.descripcion, l.nombre 
from tour t
left join escala es
	on t.nro = es.nro_tour
    and year(es.fecha_hora_ini) = year(now())
left join actividad a
	on es.nro_actividad = a.nro
    and es.codigo_locacion = a.codigo_locacion
left join locacion l 
	on a.codigo_locacion = l.codigo
order by t.nro, es.fecha_hora_ini;

