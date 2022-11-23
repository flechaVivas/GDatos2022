
/* Ejercicios pre parcial AD by Bauti Guerra */

/* Basados en ejercicios de la practica recomendados por Meca */
/* 
1. Debido a un aumento inflacionario en el pais se requiere crear una nueva lista de 
precios para todas las actividades, a partir del 01/01/2023 con un 15 por ciento 
más que su último valor.
 */
 
start transaction;

insert into costo (codigo_locacion,nro_actividad,fecha_desde,valor)
with last_costo as(
	select c.codigo_locacion, c.nro_actividad, max(c.fecha_desde) fecha
    from costo c
    where c.fecha_desde <= '20230101'
    group by c.codigo_locacion, c.nro_actividad
)
select lc.codigo_locacion, lc.nro_actividad, '20230101', c.valor*1.15 
from last_costo lc
inner join costo c
	on c.codigo_locacion=lc.codigo_locacion
    and c.nro_actividad=lc.nro_actividad
    and c.fecha_desde=lc.fecha;
 
 rollback;
 commit;


/*
2. Eliminar los contratos de este año de los clientes que hayan hecho un tour con tematica SNK.
*/

start transaction;

delete ac
from asistente_contrato ac
inner join contrata con
	on con.nro_tour=ac.nro_tour
    and con.cuil_cliente=ac.cuil_cliente
    and con.fecha_hora=ac.fecha_hora
inner join tour t
	on t.nro=con.nro_tour
where t.tematica='BCS'
and con.fecha_hora between '20220101' and '20221231';

delete con
from contrata con
inner join cliente cli
	on cli.cuil=con.cuil_cliente
inner join tour t
	on t.nro=con.nro_tour
where t.tematica ='BCS'
and con.fecha_hora between '20220101' and '20221231';

rollback;
commit;

/* Basado en ejercicio tipico de final propuesto por Meca */
/*
3. Se requiere realizar una codificacion de las tematicas. 
Para ello se deberá crear una tabla de tematicas y
cargar el valor que actualmente figura para cada tour en dicha tabla. 
Luego eliminar la columna de la tabla tour.
*/

start transaction;

CREATE TABLE `role_play_events_a_arruinar`.`tematica` (
  `id_tematica` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tematica`));

ALTER TABLE `role_play_events_a_arruinar`.`tour` 
ADD COLUMN `id_tematica` INT NULL AFTER `cuil_guia`;

ALTER TABLE `role_play_events_a_arruinar`.`tour` 
ADD CONSTRAINT `fk_tour_tematica`
  FOREIGN KEY (`id_tematica`)
  REFERENCES `role_play_events_a_arruinar`.`tematica` (`id_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

insert into tematica(descripcion)
select distinct t.tematica
from tour t;

update tour t
inner join tematica tem
	on tem.descripcion=t.tematica
set t.id_tematica = tem.id_tematica;

ALTER TABLE `role_play_events_a_arruinar`.`tour` 
DROP FOREIGN KEY `fk_tour_tematica`;
ALTER TABLE `role_play_events_a_arruinar`.`tour` 
CHANGE COLUMN `id_tematica` `id_tematica` INT NOT NULL ;
ALTER TABLE `role_play_events_a_arruinar`.`tour` 
ADD CONSTRAINT `fk_tour_tematica`
  FOREIGN KEY (`id_tematica`)
  REFERENCES `role_play_events_a_arruinar`.`tematica` (`id_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `role_play_events_a_arruinar`.`tour` 
DROP COLUMN `tematica`;

commit;


/*Basados en final Cooperativa Sustentable*/
/*
1.Comenzar un histórico de precios unitarios sugeridos para los tour. Se ha decidido 
empezar a registrar un histórico de precios unitarios sugeridos para los tour. 
Para ello se deberá crear una tabla de históricos de precios y
cargar el valor que actualmente figura para cada tour en dicha tabla 
como el valor a partir de la fecha de hoy. Luego eliminar la columna de la tabla tour.
*/

START TRANSACTION;

CREATE TABLE `role_play_events_a_arruinar`.`precio_sugerido` (
  `nro_tour` INT UNSIGNED NOT NULL,
  `fecha_desde` DATE NOT NULL,
  `valor` DECIMAL(9,2) NOT NULL,
  PRIMARY KEY (`nro_tour`, `fecha_desde`));

ALTER TABLE `role_play_events_a_arruinar`.`precio_sugerido` 
ADD CONSTRAINT `fk_precio_sugerido_tour`
  FOREIGN KEY (`nro_tour`)
  REFERENCES `role_play_events_a_arruinar`.`tour` (`nro`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

insert into precio_sugerido(nro_tour,fecha_desde,valor)
select t.nro, current_date(), t.precio_unitario_sugerido
from tour t;

ALTER TABLE `role_play_events_a_arruinar`.`tour` 
DROP COLUMN `precio_unitario_sugerido`;

commit;

/*
2. Indicar tour realizados este año donde haya pasado al menos 31 dias entre la fecha del contrato
y la fecha de salida del tour. Indicar del tour numero y fecha de salida,
del cliente su denominacion, del contrato la fecha, nombre del idioma solicitado si es que tuvo y 
diferencia entre la fecha del contrato y la fecha de salida del tour. Ordenar por diferencia en forma 
descendente.
*/

select t.nro, t.fecha_hora_salida
	, c.denom
    , con.fecha_hora
    , coalesce(idi.nombre, 'Sin Idioma') idioma
    , datediff(t.fecha_hora_salida, con.fecha_hora) diferencia
from tour t
inner join contrata con
	on con.nro_tour=t.nro
inner join cliente c
	on c.cuil=con.cuil_cliente
left join idioma idi
	on idi.codigo=con.codigo_idioma
where year(t.fecha_hora_salida) = year(current_date())
and datediff(t.fecha_hora_salida, con.fecha_hora) <= 31
order by diferencia desc;

/*
3. Listar todos los tour y, si los hubo, los contratos realizados de los mismos donde el importe acordado
sea mayor que el unitario sugerido. Indicar nro y precio unitario sugerido del tour, de los contratos 
su fecha, cantidad de entradas e importe acordado y diferencia entre los precios. En caso que no tengaç
ningun contrato con precio mayor al sugerido mostrar "sin contratos por encima del sugerido".
*/

-- Asumiendo que tengo que usar la nueva tabla creada en el ej 1)

with last_precio as(
	select ps.nro_tour, max(ps.fecha_desde) fecha_desde
    from precio_sugerido ps
    group by ps.nro_tour
)
select t.nro, ps.valor imp_tour
	, coalesce(con.importe, 'sin contratos por encima del sugerido') imp_contrato
    , coalesce(con.fecha_hora, 'sin contratos por encima del sugerido') fecha
    , coalesce(con.cant_entradas, 'sin contratos por encima del sugerido') cant_entradas
    , coalesce((con.importe - ps.valor), 'sin contratos por encima del sugerido') diferencia
from tour t
inner join last_precio lp
	on lp.nro_tour=t.nro
inner join precio_sugerido ps
	on ps.nro_tour=lp.nro_tour
    and ps.fecha_desde=lp.fecha_desde
left join contrata con
	on con.nro_tour=ps.nro_tour
    and con.importe>ps.valor;

/*
4. Listar los tour con un total de ventas menor a $20.000 durante este año. Indicar nombre y apellido del guia
del tour, numero y tematica del tour, total de ventas de este año y la menor y mayor cantidad de entradas
para dicho tour en algun contrato del año. Ordenar por total de ventas ascendente.
*/

select emp.nombre, emp.apellido
	, t.nro, t.tematica
    , sum(con.importe) total_ventas
    , min(con.cant_entradas) menor
    , max(con.cant_entradas)
from tour t
inner join contrata con
	on con.nro_tour=t.nro
inner join empleado emp
	on emp.cuil=t.cuil_guia
where emp.tipo='guia' and year(con.fecha_hora)=year(current_date())
group by emp.nombre, emp.apellido, t.nro, t.tematica
having total_ventas < 20000
order by total_ventas asc;



/*
5. Listar todos los tour con tematica 'SNK' de los que no se haya realizado ninguna escala en octubre
de este año. Indicar numero, precio unitario sugerido, fecha de salida y tematica.
*/

select t.nro, t.precio_unitario_sugerido, t.fecha_hora_salida, t.tematica
from tour t
where t.tematica = 'SNK'
and t.nro not in(
	select e.nro_tour
	from escala e
	inner join tour t
		on e.nro_tour = t.nro
	where e.fecha_hora_ini between '20221001' and '20221031'
	and t.tematica = 'SNK'
);


/*
6. Crear una funcion llamada cantidad_escalas, que reciba de parametros el numero del tour, una fecha desde
y una fecha hasta y devuelva la cantidad de escalas de dicho tour que comiencen entre esas fechas.
Invocar a la funcion para obtener la cantidad de escalas de los tour del cliente 'SG-1' desde
01/10/2022 hasta el 31/10/2022. Indicando del tour su numero, tematica y cantidad de escalas. 
*/

USE `role_play_events_a_arruinar`;
DROP function IF EXISTS `cantidad_escalas`;

DELIMITER $$
USE `role_play_events_a_arruinar`$$
CREATE FUNCTION `cantidad_escalas` (nro int, f_desde date, f_hasta date)
RETURNS INTEGER READS SQL DATA
BEGIN

declare cant int;

select count(*) into cant
from escala es
where es.nro_tour=nro
and es.fecha_hora_ini between f_desde and f_hasta;

RETURN cant;
END$$

DELIMITER ;

select t.nro, t.tematica
	,cantidad_escalas(t.nro, '20221001', '20221031') cantidad
from tour t
inner join contrata con
	on t.nro=con.nro_tour
inner join cliente c
	on c.cuil=con.cuil_cliente
where c.denom='SG-1'
group by t.nro, t.tematica;
