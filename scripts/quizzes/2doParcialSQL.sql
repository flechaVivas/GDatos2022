
/* 302 - 3. Empleados encargados de pocas actividades. Listar los empleados encargados de menos de 3 actividades durante 2022.
(incluir aquellos que no tengan ninguna actividad). Indicar cuil, nombre y apellido del empleado, cantidad de veces que estuvo a cargo de una actividad,
última vez que estuvo a cargo de alguna y días que pasaron desde entonces hasta hoy.
Ordenar por cantidad de actividades descendente y por la última fecha que lo hizo ascendente. */

select em.cuil, em.nombre, em.apellido
	, count(es.fecha_hora_ini) cant_act_a_cargo
	, max(es.fecha_hora_ini) ult_act_a_cargo
    , datediff(now(), max(es.fecha_hora_ini)) dias_desde_ult
from empleado em
left join escala es
	on es.cuil_encargado=em.cuil
	and es.fecha_hora_ini between '20220101' and '20221231'
group by em.cuil, em.nombre, em.apellido
having cant_act_a_cargo < 3
order by cant_act_a_cargo desc, ult_act_a_cargo asc;