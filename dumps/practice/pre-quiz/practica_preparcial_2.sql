
/*
	------------------------------------------
    PRACTICA PREPARCIAL - DB: role_play_events
    ------------------------------------------
*/

/* Actividades poco frecuentes. Listar las actividades que se hayan realizado menos de 3 veces en 2022.
   Indicar código de la locación, número y descripción de la actividad, cuántas veces se realizó en 2022, 
   última vez que se realizó y la cantidad de días que pasaron desde que se realizó por última vez hasta hoy.
   Ordenar por cantidad de veces descendente y cantidad de días desde que se realizó por última vez ascendente.*/
   
select act.codigo_locacion, act.nro, act.descripcion
	, count(es.fecha_hora_ini) cant_act
    , max(es.fecha_hora_ini) ultima_act
    , datediff(now(), max(es.fecha_hora_ini)) cant_dias_desde_ultima
from escala es
left join actividad act
	on act.codigo_locacion=es.codigo_locacion
    and act.nro=es.nro_actividad
	and es.fecha_hora_ini between '20220101' and '20221231'
group by act.codigo_locacion, act.nro, act.descripcion
having cant_act < 3
order by cant_act desc, cant_dias_desde_ultima asc;

/* 3. Idiomas poco solicitados. Listar cuáles fueron los idiomas solicitados menos de 5 veces en 2021. 
Indicando código y nombre del idioma, cantidad de veces que fue solicitado en 2021, 
fecha en que se lo solicitó por última vez y cuántos días han pasado desde entonces. 
Ordenar por la última fecha de solicitud descendente y por cantidad de solicitudes descendente. */

select idi.codigo, idi.nombre
	, count(con.fecha_hora) cant_solicitado
    , max(con.fecha_hora) ult_solicitado
    , datediff(now(), max(con.fecha_hora)) dias_desde_ult_soli
from idioma idi
left join contrata con
	on con.codigo_idioma=idi.codigo
	and con.fecha_hora between '20210101' and '20211231'
group by idi.codigo, idi.nombre
having cant_solicitado < 5
order by ult_solicitado desc, cant_solicitado desc;

/*Clientes ocasionales. Listar los clientes que hayan hecho menos de 4 contrataciones de tours de 2021. 
Indicar CUIL y denominación del cliente, cantidad de contrataciones (no de entradas), 
fecha de la última contratación y días que pasaron desde entonces.
Ordenar por cantidad de contrataciones ascendente y fecha de última contratación descendente.*/

select cli.cuil, cli.denom
	, count(con.fecha_hora) cant_contrataciones
    , max(con.fecha_hora) ult_contratacion
    , datediff(now(), max(con.fecha_hora)) dias_desde_ult_contratacion
from cliente cli
left join contrata con
	on con.cuil_cliente=cli.cuil
	and con.fecha_hora between '20210101' and '20211231' 
group by cli.cuil, cli.denom
having cant_contrataciones < 4
order by cant_contrataciones asc, ult_contratacion desc;

/* Indicar para cada tour la cantidad total de importe de sus contratos y la cantidad de idiomas diferentes que fueron solicitados,
si no se contrató dicho tour y/o no se solicitó idioma en ninguno de los contratos se debe indicar 0.
Indicar nro y temática del tour, cantidad total del importe de los contratos y cantidad de idiomas diferentes.
Ordenar por cantidad total de importe descendente y cantidad de idiomas diferentes ascendente. */

select t.nro, t.tematica
	, coalesce(sum(con.importe), 0) importe_total
    , count(distinct con.codigo_idioma) cant_idiomas_distintos
from tour t
left join contrata con
	on t.nro=con.nro_tour
group by t.nro, t.tematica
order by importe_total desc, cant_idiomas_distintos asc;

/* Indicar los clientes con menos de 2 contratos, en los últimos 6 años, sin idioma solicitado.
Listar cuil, denominación, cantidad de contratos, cantidad de contratos sin idioma.
Ordenar por cantidad de cantidad de contratos sin idioma solicitado descendente.
Si no tienen contratos sin idioma listarlos con cantidad 0 */

select cli.cuil, cli.denom
	, count(con.cuil_cliente) cant_contratos
    , count(con.cuil_cliente) - count(con.codigo_idioma) cant_contratos_sin_idioma
from cliente cli
left join contrata con
	on con.cuil_cliente=cli.cuil
where adddate(now(), interval -6 year)
and con.codigo_idioma is null
group by cli.cuil, cli.denom
having cant_contratos < 2
order by cant_contratos_sin_idioma;



