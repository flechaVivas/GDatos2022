
/*
	Práctica pre parcial
    enunciados: https://docs.google.com/document/d/1_i2ZBBffJFP8eMJLykyOB7ZH5T6_sxe3HJpUdExMoB4/edit
*/
/*
	1) Listar los tours contratados por cada cliente en los últimos 6 meses. 
	Indicando cuil y denominación del cliente, nro y lugar de salida del tour, nombre y apellido del guia del tour.
	Ordenar por denominación del cliente, nombre del guia y fecha y hora de contrato ascendente. 
*/

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

/*
	2) Listar los tours con asistentes en los que participó el guía "Javier Gomez".
	Indicando cuil, nombre y apellido del guía, nro del tour, fecha y hora del contrato,
	y de cada asistente indicar dni, nombre y apellido. Ordenar por fecha y hora de contrato descendente.
*/

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

/*
	3) Listar para cada contrato de este año el tour, cliente, los idiomas solicitados y los asistentes.
	Si un contrato no tiene idiomas solicitados o asistentes debe mostrarse igualmente.
	Indicar cuil y denominación del cliente, nro y temática del tour, fecha y hora del contrato,
	código y nombre del idioma, dni, nombre y apellido del asistente.
	Ordenar por nro de tour ascendente y fecha y hora de contrato descendente.
*/

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

/*
	4) Listar los tours y para cada uno las escalas realizadas este año. 
	Si no se realizó ninguna escala este año para ese tour deberá mostrarse igualmente.
	Indicar nro y temática del tour, fecha y hora de inicio de la escala,
	por cada actividad su descripción y el nombre de la locación.
	Ordenar por nro de tour y fecha y hora de inicio de escala ascendentes.
*/

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

/*
	5) Listado de tour contratados. Listar para cada tour contratado entre enero y julio 2022
	inclusive los clientes que lo contrataron. Indicar nro y tematica del tour,
	fecha y hora de contratacion y cuil, tipo y denominacion del cliente. No se deberan
	mostrar registros repetidos y deberá prdenarse alfabeticamente por denominacion de cliente.
*/

select t.nro, t.tematica, con.fecha_hora, cli.cuil, cli.tipo, cli.denom
from tour t inner join contrata con
on t.nro=con.nro_tour
inner join cliente cli
on con.cuil_cliente=cli.cuil
where con.fecha_hora between '20220101' and '20220731'
order by cli.denom asc;

/*
	6) Idiomas y solicitudes de julio 2022. Listar los idiomas y, para aquellos que hayan sido
    solicitados en contrataciones de julio 2022, mostrar en qué eventos fueron solicitados
    Indicar codigo y nombre del idioma, numero y tematica de tour. Ordenar por nombre idioma.
*/

select i.*, t.nro, t.tematica
from idioma i
left join contrata con
	on con.codigo_idioma=i.codigo
    and con.fecha_hora between '2022-07-01' and '2022-07-31'
left join tour t
	on t.nro=con.nro_tour
order by i.nombre;

/*
	7) Listado de guias por tour. Listar para cada tour que se contrató entre enero y julio de 2022 (inclusive) que empleado se asignó como guía.
	Indicar número de tour, fecha  y hora de salida, fecha y hora de regreso, lugar de salida y cuil, nombre y apellido del guía.
	El listado deberá ordenarse alfabéticamente por apellido y nombre del guía.
*/

select t.nro, t.fecha_hora_salida, t.fecha_hora_regreso, t.lugar_salida, em.cuil, em.apellido, em.nombre
from empleado em
inner join tour t
	on t.cuil_guia=em.cuil
inner join contrata con
	on con.nro_tour=t.nro
where con.fecha_hora between '2022-01-01' and '2022-07-31'
order by em.apellido, em.nombre;


/*
	8) Actividad y tours que se realizaron en julio de 2022. Listar todas las actividades y , para aquellas realizadas 
	en una escala durante julio de 2022, los datos del tour donde se realizó. Indicar código de locación, número y 
	descripción de la actividad, número y temática del tour. Ordenar por fecha y hora de inicio de la escala en forma ascendente.
*/

-- Mi resolucion: 
select act.codigo_locacion, act.nro, act.descripcion, t.nro, t.tematica
from actividad act
left join escala es
	on es.nro_actividad=act.nro
    and es.codigo_locacion=act.codigo_locacion
left join tour t
	on t.nro=es.nro_tour
    and es.fecha_hora_ini between '2022-07-01' and '2022-07-31'
order by es.fecha_hora_ini asc;
    
-- Solucion correcta:
select a.codigo_locacion, a.nro, a.descripcion
	, t.nro, t.tematica
from actividad a
left join escala e
	on a.nro = e.nro_actividad and a.codigo_locacion = e.codigo_locacion
    and e.fecha_hora_ini between "2022-07-01" and "2022-07-31"
left join tour t
	on e.nro_tour = t.nro
order by e.fecha_hora_ini;

/*
	9) Listado de actividades de tour. Listar para cada tour que se realizó entre enero y julio de 2022 (inclusive) las actividades realizadas. 
	Indicar número y temática del tour, código de locación, número y descripción de la actividad. No se deberán mostrar registros repetidos 
	y deberá ordenarse alfabéticamente por temática y descripción de la actividad.
*/

select distinct t.nro, t.tematica, act.codigo_locacion, act.nro, act.descripcion
from tour t
inner join escala es
	on es.nro_tour=t.nro
inner join actividad act
	on es.nro_actividad=act.nro
    and es.codigo_locacion=act.codigo_locacion
where t.fecha_hora_salida between '2022-01-01' and '2022-07-31'
order by t.tematica, act.descripcion;


/*
	10) Listar todos los clientes que tienen registrados, y en caso de haber contratado tours en el 2022,
    los datos del tour. Indicar cuil, y denominación del cliente, 
	número y temática del tour. Ordenar por fecha y hora de contratación ascendente
*/

select c.cuil, c.denom, t.nro, t.tematica
from cliente c
left join contrata con
	on con.cuil_cliente=c.cuil
    and year(con.fecha_hora) = '2022'
left join tour t
	on t.nro=con.nro_tour
order by con.fecha_hora asc;
