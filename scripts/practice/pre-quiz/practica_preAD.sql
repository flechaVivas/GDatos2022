
/*
	Crear un procedimiento que dado un rango de fechas indique la/s temática/s más frecuentemente contratadas.
	A partir de esto se deberá generar un tour que tenga los mismos datos del último tour generado con dicha temática
    con fecha de salida el 1/12/2022, la misma cantidad de días de duración y el mismo guia 
	Si hay más de una temática con la misma frecuencia registrar todos con el mismo criterio
*/

start transaction;

with cant_con_tem as(
	select t.tematica, count(t.nro) as cant
    from tour t
	inner join contrata con
		on con.nro_tour=t.nro
	where con.fecha_hora between '20220101' and '20230101'
    group by t.tematica
)
select max(cant) into @mayor
from cant_con_tem;

insert into tour(nro, fecha_hora_salida,fecha_hora_regreso,lugar_salida,precio_unitario, vehiculo, tematica, cuil_guia)
with tematicas_frecuentes as(
	select t.tematica
    from tour t
    group by t.tematica
    having count(t.nro) = @mayor
)

select @mayor

rollback;
commit;

/* 
	Se requiere conocer el salario total que corresponde a todos los guias asignados a tours en un rango de fechas
	el salario total de cada guia debe calcularse según la cantidad de días correspondientes a cada tour en el que haya
    participado multiplicado por el salario_hora vigente al momento del tour * 8 horas.
*/

USE `role_play_events`;
DROP function IF EXISTS `salario_total_a_fecha`;

DELIMITER $$
USE `role_play_events`$$
CREATE FUNCTION `salario_total_a_fecha` (f_desde date, f_hasta date)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN

DECLARE total DECIMAL(9,2);

with sal_a_fecha_tour as(
	select t.cuil_guia, max(sh.fecha_desde) fecha
    from salario_hora sh
    inner join tour t
		on t.cuil_guia=sh.cuil_empleado
	where t.fecha_hora_salida between f_desde and f_hasta
    and sh.fecha_desde <= t.fecha_hora_salida
    group by sh.cuil_empleado
), cant_tours_emp as(
	select emp.cuil, count(t.nro) cant
    from empleado emp
    inner join tour t
		on t.cuil_guia=emp.cuil
	where t.fecha_hora_salida between f_desde and f_hasta
	group by emp.cuil
)
select sum((valor*cant)*8) into total
from salario_hora sh
inner join sal_a_fecha_tour sf
	on sh.cuil_empleado=sf.cuil_guia
    and sh.fecha_desde=sf.fecha
inner join cant_tours_emp ct
	on ct.cuil=sh.cuil_empleado;

RETURN total;
END$$

DELIMITER ;

select salario_total_a_fecha('20220101','20230801');


/*
	Indicar para cada guia, el ultimo tour guiado durante el mes de octubre 2022
    Por cada guia indicar cuil, apellido y nombre.
    Si tiene tour guiado en ese periodo indicar nro tour, tematica y fecha y hora salida.
    En contrario mostrar 'Sin Tours Guiados'
*/

with ult_tour as (
	select emp.cuil, max(t.fecha_hora_salida) ult_fecha
    from empleado emp
    left join tour t
		on t.cuil_guia=emp.cuil
		and t.fecha_hora_salida between '20221001' and '20221031'
	group by emp.cuil
)
select emp.cuil, emp.nombre, emp.apellido
	, coalesce(t.nro, 'Sin Tour Guiado')
    , coalesce(t.tematica, 'Sin Tour Guiado')
    , coalesce(t.fecha_hora_salida, 'Sin Tour Guiado')
from empleado emp
left join ult_tour ut
	on emp.cuil=ut.cuil
left join tour t
	on t.cuil_guia=ut.cuil
    and t.fecha_hora_salida=ult_fecha
where emp.tipo in ('guia');


/*
	Indicar los datos de los clientes que contrataron al menos 2 tours
    El informe debera tener los siguientes datos: cuil, denom, tipo
*/

select c.cuil, c.denom, c.tipo
from cliente c
inner join contrata con
	on con.cuil_cliente=c.cuil
group by c.cuil
having  count(con.nro_tour) >= 2; 

/*
	Para cada cliente calcular el importe total a pagar del ultimo tour contratado,
    considerando un posible descuento. Si no tiene tour, indicar 'No contrato tours'.
*/

-- compeltarrrrrrr

with ult_tour as (
	select c.cuil, max(con.fecha_hora) ult_fecha
    from cliente c
    left join contrata con
		on con.cuil_cliente=c.cuil
	group by c.cuil
)
select datediff(t.fecha_hora_salida, con.fecha_hora)
from cliente c
left join ult_tour ut
	on ut.cuil=c.cuil
left join contrata con
	on con.cuil_cliente=ut.cuil
	and con.fecha_hora=ut.ult_fecha
left join tour t
	on t.nro=con.nro_tour;

/*
	El salario por hora de los empleados ha cambiado y se debe actualizar
    el historico con este nuevo valor. Para cada empleado, el nuevo sueldo será
    el del valor actual mas el 7%
*/
start transaction;

insert into salario_hora(cuil_empleado,fecha_desde,valor)
with ult_salario as(
	select sh.cuil_empleado, max(sh.fecha_desde) fecha
    from salario_hora sh
    group by sh.cuil_empleado
    having fecha <= current_date()
)
select us.cuil_empleado, current_date(), sh.valor * 1.07
from ult_salario us
inner join salario_hora sh
	on sh.cuil_empleado=us.cuil_empleado
    and sh.fecha_desde=us.fecha;

rollback;
-- commit;

/*
	Indicar los empleados con más horas trabajadas. Listar los empleados
    que en 2022 trabajaron más horas que el promedio de horas trabajadas.
    Indicar nombre, apellido, tipo, total horas trabajadas en 2022 y
    cuantas horas más que el promedio general. Ordenar por total de hs trbajadas
    descendente y por apellido y nombre alfabeticamente
*/

select avg(time_to_sec(timediff(t.fecha_hora_regreso, t.fecha_hora_salida))/3600) into @prom_horas
from empleado emp
inner join tour t
	on t.cuil_guia=emp.cuil
where emp.tipo in ('guia')
and t.fecha_hora_salida between '20220101' and '20221231';

select emp.cuil, emp.nombre, emp.apellido, emp.tipo
	, sum(time_to_sec(timediff(t.fecha_hora_regreso, t.fecha_hora_salida))/3600) horas
    , sum(time_to_sec(timediff(t.fecha_hora_regreso, t.fecha_hora_salida))/3600) - @prom_horas
from empleado emp
inner join tour t
	on t.cuil_guia=emp.cuil
where emp.tipo in ('guia')
and t.fecha_hora_salida between '20220101' and '20221231'
group by emp.cuil, emp.tipo
having horas > @prom_horas
order by horas desc, emp.apellido asc, emp.nombre asc;
