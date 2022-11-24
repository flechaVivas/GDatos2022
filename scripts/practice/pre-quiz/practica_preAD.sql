
/*
	Crear un procedimiento que dado un rango de fechas indique la/s temática/s más frecuentemente contratadas.
	A partir de esto se deberá generar un tour que tenga los mismos datos del último tour generado con dicha temática
    con fecha de salida el 1/12/2022, la misma cantidad de días de duración y el mismo guia 
	Si hay más de una temática con la misma frecuencia registrar todos con el mismo criterio
*/

start transaction;

-- with cant_con_tem as(
-- 	select t.tematica, count(t.nro) as cant
--     from tour t
-- 	inner join contrata con
-- 		on con.nro_tour=t.nro
-- 	where con.fecha_hora between '20220101' and '20230101'
--     group by t.tematica
-- )
-- select max(cant) into @mayor
-- from cant_con_tem;

-- insert into tour(nro, fecha_hora_salida,fecha_hora_regreso,lugar_salida,precio_unitario, vehiculo, tematica, cuil_guia)
-- with tematicas_frecuentes as(
-- 	select t.tematica
--     from tour t
--     group by t.tematica
--     having count(t.nro) = @mayor
-- )

-- select @mayor

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

/*
	Ranking de idiomas contratados indicando: codigo y descripcion del idioma, suma de la cantidad
	de idiomas contratados para todos los tours y porcentaje de esta suma sobre la suma total de 
    las cantidades de idiomas contratados. Los idiomas que no hayan sido contratados deberán
    figurar en la lista con cantidad total 0.
	Ordenar el ranking en forma descendente por porcentaje.
*/

select count(con.codigo_idioma) into @total
from contrata con
inner join idioma idi
	on idi.codigo=con.codigo_idioma;

select idi.codigo, idi.nombre
	, count(idi.codigo)
    , (count(idi.codigo) / @total) * 100 porcen
from idioma idi
left join contrata con
	on idi.codigo=con.codigo_idioma
group by idi.codigo, idi.nombre
order by porcen desc;


/*
	Realice todos los cambios necesarios (agregado de tablas, para modificar el modelo relacional propuesto de modo que
	responda a los siguientes cambios de requerimientos:
	1. Se desea asignar a los empleados una categoría. Crear una entidad categoría con un código numérico secuencial
	que la identifique y un nombre. Las categorías a registrar son: Trainee, Jr, Ssr, Sr
	2. Modificar la tabla empleados para registrar la categoría correspondiente en referencia a la nueva tabla.
	3. Categorizar los empleados de la siguiente forma:
		a. Para los guias
			a1. Si ha guiado más tours que el promedio de tours guiados por guia debe ser “Sr”
			a2. Si ha guiado más tours que la mitad del promedio de tours guiados por guia debe ser "Ssr"
			a3. Si ha guiado menos tours que la mitad del promedio de tours guiados por guia debe ser "Jr"
            a4. Si no ha guiado tours debe ser 'Trrainee'
		b. Para los encaragados
			idem a1, a2, a3, a4
*/

-- Muy falopa, no se si funciona pq hay que limpiar todos atbs categoria

start transaction;

DROP TABLE IF EXISTS categoria;
CREATE TABLE `roleplay_a_arruinar`.`categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategoria`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE);

INSERT INTO `roleplay_a_arruinar`.`categoria` (`idCategoria`, `nombre`) VALUES ('Trainee');
select last_insert_id() into @tr;
INSERT INTO `roleplay_a_arruinar`.`categoria` (`idCategoria`, `nombre`) VALUES ('Jr');
select last_insert_id() into @jr;
INSERT INTO `roleplay_a_arruinar`.`categoria` (`idCategoria`, `nombre`) VALUES ('Ssr');
select last_insert_id() into @ssr;
INSERT INTO `roleplay_a_arruinar`.`categoria` (`idCategoria`, `nombre`) VALUES ('Sr');
select last_insert_id() into @sr;

select avg(total) into @prom_encargados
from(
	select count(t.cuil_guia) total
	from empleado emp
	inner join tour t
		on t.cuil_guia=emp.cuil
	where emp.tipo in ('guia')
) pe;
    
select avg(total) into @prom_guiados
from(
	select count(es.cuil_encargado) total
	from empleado emp
	inner join escala es
		on es.cuil_encargado=emp.cuil
	where emp.tipo in ('encargado')
) pg;

with cant_guiados as(
	
    select emp.cuil, count(*) cant
	from empleado emp
	inner join tour t
		on t.cuil_guia=emp.cuil
	where emp.tipo in ('guia')
    group by emp.cuil

), cant_encargados as(
	
	select emp.cuil, count(*) cant
	from empleado emp
	inner join escala es
		on es.cuil_encargado=emp.cuil
	where emp.tipo in ('encargado')
    group by emp.cuil

)
update empleado emp
inner join cant_guiados cg
	on cg.cuil=emp.cuil
inner join cant_encargados ce
	on ce.cuil=emp.cuil
set categoria = 
case 
	when emp.tipo = 'guia' then 
		case 
			when cg.cant = 0 then @tr
            when cg.cant <= @prom_guiados/2 then @jr
            when cg.cant >= @prom_guiados/2 then @ssr
            when cg.cant > @prom_guiados then @sr
		end
	when emp.tipo = 'encargado' then
		case
			when ce.cant = 0 then @tr
			when ce.cant <= @prom_encargado/2 then @jr
			when ce.cant >= @prom_encargado/2 then @ssr
			when ce.cant > @prom_encargado then @sr
		end
end;
rollback;
commit;


/*
	Actualización de sueldos: Debido a la gran inflacion, la empresa ha decidido un aumento
	de sueldos para los empleados. El aumento regirá a partir del miercoles próximo. El
	aumento será de un 35% a los que tengan un salario por hora menor a $2000 y de 25% a los que tengan un
	salario por hora mayor o igual a $2000.
*/

start transaction;

insert into salario_hora(cuil_empleado,fecha_desde,valor)
with ult_salario as(
	select sh.cuil_empleado, max(sh.fecha_desde) fecha
    from salario_hora sh
    where sh.fecha_desde <= current_date()
    group by sh.cuil_empleado
)
select us.cuil_empleado, '20221123',
	case 
		when valor < 2000 then valor * 1.35
        when valor >= 2000 then valor * 1.25
	end
from ult_salario us
inner join salario_hora sh
	on sh.cuil_empleado=us.cuil_empleado
    and sh.fecha_desde=us.fecha;

rollback;
commit;


/*
	Se desea categorizar a los tipos de cliente en una nueva tabla tipo_cliente
*/

CREATE TABLE `role_play_events_a_arruinar`.`tipo_cliente` (
`cod_tipo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
`descripcion` VARCHAR(45) NOT NULL,
PRIMARY KEY (`cod_tipo`),
UNIQUE INDEX `descripcion_UNIQUE` (`descripcion` ASC) VISIBLE);

ALTER TABLE `role_play_events_a_arruinar`.`cliente` 
ADD COLUMN `cod_tipo` INT UNSIGNED NULL AFTER `tipo`,
ADD INDEX `fk_cliente_tipo_idx` (`cod_tipo` ASC) VISIBLE;
;
ALTER TABLE `role_play_events_a_arruinar`.`cliente` 
ADD CONSTRAINT `fk_cliente_tipo`
  FOREIGN KEY (`cod_tipo`)
  REFERENCES `role_play_events_a_arruinar`.`tipo_cliente` (`cod_tipo`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

start transaction;

insert into tipo_cliente(descripcion)
select distinct tipo from cliente;

update cliente c
inner join tipo_cliente tc
	on tc.descripcion=c.tipo
set c.cod_tipo=tc.cod_tipo;

-- rollback;
commit;

/*
	Empleados excediendo el máximo de horas al mes: realizar un procedimiento almacenado que calcule las horas trabajadas
    reales totales por empleado en el mes (usando la fecha de inicio) y liste aquellos que exceden el máximo de horas que deberían
    haber trabajado en el mes. El procedimiento almacenado debe recibir como parámetros el mes, el año y el máximo de horas.
    Debe listar los empleados indicando cuil, nombre, apellido, tipo, cantidad total de horas trabajadas
    y horas excedidas. Al finalizar invocar el procedimiento.
*/


USE `role_play_events_a_arruinar`;
DROP procedure IF EXISTS `horas_trabajadas`;

DELIMITER $$
USE `role_play_events_a_arruinar`$$
CREATE PROCEDURE `horas_trabajadas` (in mes varchar(10), in anio varchar(10), hs int)
BEGIN

with hs_trabajadas_guia as(
	select emp.cuil
		, sum(time_to_sec(timediff(t.fecha_hora_regreso, t.fecha_hora_salida))/3600) hs_trabajadas
	from empleado emp
	inner join tour t
		on t.cuil_guia=emp.cuil
	where emp.tipo='guia'
	and month(t.fecha_hora_salida)=mes
	and year(t.fecha_hora_salida)=anio
	group by emp.cuil
	having hs_trabajadas > hs
), hs_trabajadas_encargado as(
	select emp.cuil
		, sum(time_to_sec(timediff(es.fecha_hora_fin, es.fecha_hora_ini))/3600) hs_trabajadas
	from empleado emp
    inner join escala es
		on es.cuil_encargado=emp.cuil
	where emp.tipo='encargado'
    and month(es.fecha_hora_ini)=mes
    and year(es.fecha_hora_ini)=anio
	group by emp.cuil
    having hs_trabajadas > hs
) 
select emp.cuil, emp.nombre, emp.apellido, emp.tipo
	, g.hs_trabajadas, e.hs_trabajadas
from empleado emp
left join hs_trabajadas_guia g
	on g.cuil=emp.cuil
left join hs_trabajadas_encargado e
	on e.cuil=emp.cuil;

END$$

DELIMITER ;

call horas_trabajadas('07','2022',0);




