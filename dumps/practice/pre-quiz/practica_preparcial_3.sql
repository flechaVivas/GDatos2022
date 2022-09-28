/*
	------------------------------------------
    PRACTICA PREPARCIAL 3 - DB: role_play_events
    ------------------------------------------
*/

/*	
	Tours particulares del Warcraft. Listar todos los tours realizados en 2022 que no hayan sido contratados 
	por algún cliente revendedor o empresa de turismo.
	Indicar nro de tour, fechas de salida y regreso y precio unitario sugerido.
*/ 

select t.nro, t.fecha_hora_salida, t.fecha_hora_regreso, t.precio_unitario_sugerido
from tour t
where t.fecha_hora_salida between '20220101' and '20221231'
-- and t.tematica = 'Warcraft'
and t.nro not in (
	select nro_tour
    from contrata con
    inner join cliente c
		on c.cuil=con.cuil_cliente
    where c.tipo in('Revendedor', 'Empresa de turismo')
);

/*
	Guías en declive. Listar guías que hayan guiado menos tours en 2022 que en 2021. 
	Se deberán mostrar incluso aquellos guías que no hayan guiado tours en 2021 o 2022. 
	Indicar cuil, nombre, apellido y categoría del guía, cantidad de tours guiados en 2022, 
	cantidad de tours guiados en 2021 y declive en la cantidad
*/

with cte_guias_21 as (
	select e.cuil, count(t.cuil_guia) as 'guiados_2021'
    from empleado e
    left join tour t
		on e.cuil=t.cuil_guia
        and t.fecha_hora_salida between '20210101' and '20211231'
	where e.tipo = 'Guia'
	group by e.cuil
)
select e.cuil, e.nombre, e.apellido, e.categoria
	, ifnull(count(t.cuil_guia), 0) as guiados_2022
    , ifnull(cte_guias_21.guiados_2021, 0) as guiados_2021
    , guiados_2021 - count(t.cuil_guia) as declive
from empleado e
left join tour t
	on e.cuil=t.cuil_guia
	and t.fecha_hora_salida between '20220101' and '20221231'
left join cte_guias_21
	on cte_guias_21.cuil = t.cuil_guia
where e.tipo = 'Guia'
group by e.cuil, e.nombre, e.apellido, e.categoria
having guiados_2022 < guiados_2021;

/*
	Tours sin disfraz. Listar los tours realizados en 2021 pero que en ninguna de sus actividades se utilice 
	equipamiento “disfraz” ni “accesorio cosplay”. Indicar nro, precio unitario y temática.
*/

select distinct t.nro, t.precio_unitario_sugerido, t.tematica
from tour t
where t.fecha_hora_salida between '20210101' and '20211231'
and t.nro not in(
	select distinct sub_t.nro
    from tour sub_t
    inner join escala es
		on es.nro_tour=sub_t.nro
	inner join actividad act
		on act.codigo_locacion=es.codigo_locacion
        and act.nro=es.nro_actividad
	where act.equipamiento in ('disfraz', 'accesorio cosplay')
);

/*
	Listar los encargados que hayan coordinado más escalas en 2021 que en 2022. Se deberán listar aún aquellos
	encargados que no hayan coordinado escalas en 2021 o 2022. Indicar cuil, nombre, apellido y categoría del encargado,
	cantidad de escalas coordinadas en 2021, cantidad de escalas coordinadas en 2022 y declive en la cantidad.
*/

with cte_emp_21 as(
	select emp.cuil, count(es.fecha_hora_ini) as cant_escalas_21
    from empleado emp
    left join escala es
		on es.cuil_encargado=emp.cuil
        and es.fecha_hora_ini between '20210101' and '20211231'
	group by emp.cuil
)
select emp.cuil, emp.nombre, emp.apellido, emp.categoria
	, ifnull(cant_escalas_21 , 0) as cant_escalas_21
	, ifnull(count(es.fecha_hora_ini), 0) as cant_escalas_22
    , (ifnull(cant_escalas_21 , 0) - count(es.fecha_hora_ini)) as declive
from empleado emp
left join escala es
	on es.cuil_encargado=emp.cuil
	and es.fecha_hora_ini between '20220101' and '20221231'
left join cte_emp_21
	on cte_emp_21.cuil=es.cuil_encargado
group by emp.cuil, emp.nombre, emp.apellido, emp.categoria
having cant_escalas_21 > cant_escalas_22;

/*
	Encargados con temáticas no realizadas. Listar todos los empleados encargados  
	que no hayan coordinado ninguna escala de algún tour con las temáticas “Overlord” o “Lord of the Rings”.
	Indicar cuil, nombre y apellido del encargado.
*/

select emp.cuil, emp.nombre, emp.apellido
from empleado emp
where emp.tipo = 'Encargado' 
and emp.cuil not in(
	select cuil_encargado
    from escala es
    inner join tour t
		on t.nro=es.nro_tour
	where t.tematica in ('Overlord', 'Lord of the Rings')
);

select emp.cuil as 'Cuil Empleado', concat(emp.nombre,' ', emp.apellido) as 'Nombre y Apellido'
from empleado emp
where emp.tipo = 'Encargado' and emp.cuil not in (
select e.cuil_encargado
from escala e
inner join tour t on e.nro_tour = t.nro
where t.tematica = "Overlord" or "Lord of the Rings");

/*
	Idiomas en auge. Listar los idiomas que hayan sido más solicitados en 2022 que en 2021. 
	Se deberán listar aún aquellos idiomas que no hayan sido solicitados en 2022 o 2021. 
	Indicar código y nombre del idioma, cantidad de veces que fue solicitado en 2022, 
	cantidad de veces que fue solicitado en 2021 e incremento en la cantidad.
*/

with idiomas2022 as (
	select idi.codigo, count(con.codigo_idioma) cant_sol_2022
    from idioma idi
    left join contrata con
		on con.codigo_idioma=idi.codigo
        and con.fecha_hora between '20220101' and '20221231'
	group by idi.codigo
)
select idi.*
	, coalesce(count(con.codigo_idioma), 0) cant_sol_2021
    , coalesce(cant_sol_2022, 0) cant_sol_2022
    , (cant_sol_2022 - count(con.codigo_idioma)) incremento
from idioma idi
left join contrata con
	on con.codigo_idioma=idi.codigo
	and con.fecha_hora between '20210101' and '20211231'
left join idiomas2022
	on idiomas2022.codigo=idi.codigo
group by idi.codigo, idi.nombre
having cant_sol_2022 > cant_sol_2021;






