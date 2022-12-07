
/*
	AD - 1. Sugerencias de tours. Para una promoción se desea sugerir a cada asistente
    otros tours que sean de su interés. Para cada asistente que haya realizado más de 
    un tour en alguna temática, identificar la temática más frecuente elegida por 
    el asistente y sugerirle todos los tours futuros con la misma temática.
    Indicar dni, nombre, apellido y teléfono del asistente y de los tours, 
    número, temática, fecha y hora de salida y precio unitario. 
    Ordenar por apellido y nombre alfabético y fecha y hora de salida descendente.
*/

with tematicas_asis as(
	select ac.dni_asistente, t.tematica, count(distinct t.tematica) cant
	from tour t
	inner join contrata con
		on con.nro_tour=t.nro
	inner join asistente_contrato ac
		on con.nro_tour=ac.nro_tour
		and con.cuil_cliente=ac.cuil_cliente
		and con.fecha_hora=ac.fecha_hora
	group by ac.dni_asistente, t.tematica
) , maxima as (
	select ta.dni_asistente, max(cant) as maxi
	from tt_tematicas_asis ta
	group by ta.dni_asistente
)
select asis.dni, asis.nombre, asis.apellido, asis.telefono
	, t.nro, t.tematica, t.fecha_hora_salida, t.precio_unitario_sugerido
from tematicas_asis ta
inner join maxima mp
	on ta.dni_asistente=mp.dni_asistente
inner join asistente asis
	on asis.dni=ta.dni_asistente
inner join tour t
	on t.tematica=ta.tematica
where ta.cant=mp.maxi and t.fecha_hora_salida <= current_date()
order by asis.apellido, asis.nombre, t.fecha_hora_salida desc;

-- Corrección Adrián Meca:
/*
	1. fecha_hora_salida debería
	ser mayor a current date -0
*/

/*
	AD - 2. Determinar el margen de ganancia por temática. 
    Crear una función que dado un tour devuelva la el costo total
    de todas sus actividades a la fecha de salida y otra función que
    dado un tour devuelva el ingreso utilizando los contratos. 
    Finalmente utilizando dichas funciones calcular el margen de ganancia 
    total de cada temática para los tours ya iniciados. Indicar, temática, 
    cantidad de tours y margen de ganancia. Ordenar por margen de ganancia 
    descendente.

	Margen de ganancia: (ingresos - costos)/costos

*/

USE `role_play_events`;
DROP function IF EXISTS `costo_actividades`;

DELIMITER $$
USE `role_play_events`$$
CREATE FUNCTION `costo_actividades` (nro int)
RETURNS INTEGER READS SQL DATA
BEGIN

declare costo_tour decimal(10,2);
	
with cte_last_costo as(
	select c.nro_actividad, c.codigo_locacion, max(c.fecha_desde) fecha
    from costo c
    where c.fecha_desde <= current_date()
    group by c.nro_actividad, c.codigo_locacion
)
select sum(c.valor) into costo_tour
from cte_last_costo lc
inner join costo c
	on c.codigo_locacion=lc.codigo_locacion
    and c.nro_actividad=lc.nro_actividad
    and c.fecha_desde=lc.fecha
inner join escala es
	on es.nro_actividad=c.nro_actividad
    and es.codigo_locacion=c.codigo_locacion
where es.nro_tour=nro;

RETURN costo_tour;
END$$

DELIMITER ;

USE `role_play_events`;
DROP function IF EXISTS `ingresos_tour`;

DELIMITER $$
USE `role_play_events`$$
CREATE FUNCTION `ingresos_tour` (nro int)
RETURNS INTEGER READS SQL DATA
BEGIN

declare ingresos decimal(10,2);

	select sum(con.importe) into ingresos
	from contrata con
	where con.nro_tour=nro;


RETURN ingresos;
END$$

DELIMITER ;

use role_play_events;
select t.tematica
	, count(*) cantidad
    , sum(((ingresos_tour(t.nro) - costo_actividades(t.nro)) / costo_actividades(t.nro))) as margen
from tour t
where t.fecha_hora_salida <= current_date()
group by t.tematica
order by margen desc;

-- Corrección Adrián Meca:
/*
	1. calcula costo con fecha actual
	en lugar de con la fecha de
	salida del tour correspondiente -2
	2. falta coalesce -0,5
*/


/*
	AD - 3. Consistencia de datos. La empresa notó que tanto la temática del tour
    como la ambientación de locación son en realidad lo mismo. Se decidió crear
    la tabla tematica (identificada por un código autoincremental y con una descripción),
    cargar las descripciones  con los datos de tour y ambientación y modificar las 
    tablas tour y locación para migrar las viejas columnas por la correspondiente 
    clave foránea a la tabla temática.
*/

CREATE TABLE `role_play_events_parcial`.`tematica` (
  `cod_tematica` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (`cod_tematica`));
  
ALTER TABLE `role_play_events_parcial`.`tour` 
ADD COLUMN `cod_tematica` INT NULL AFTER `cuil_guia`,
ADD INDEX `fk_tour_tematica_idx` (`cod_tematica` ASC) VISIBLE;
;
ALTER TABLE `role_play_events_parcial`.`tour` 
ADD CONSTRAINT `fk_tour_tematica`
  FOREIGN KEY (`cod_tematica`)
  REFERENCES `role_play_events_parcial`.`tematica` (`cod_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `role_play_events_parcial`.`locacion` 
ADD COLUMN `cod_tematica` INT NULL AFTER `direccion`,
ADD INDEX `fk_locacion_tematica_idx` (`cod_tematica` ASC) VISIBLE;
;
ALTER TABLE `role_play_events_parcial`.`locacion` 
ADD CONSTRAINT `fk_locacion_tematica`
  FOREIGN KEY (`cod_tematica`)
  REFERENCES `role_play_events_parcial`.`tematica` (`cod_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

begin;

insert ignore into tematica(descripcion)
select distinct t.tematica
from tour t;

update tour t
inner join tematica tem
	on t.tematica=tem.descripcion
set t.cod_tematica=tem.cod_tematica;

insert ignore into tematica(descripcion)
select distinct loc.ambientacion
from locacion loc;

update locacion loc
inner join tematica tem
	on tem.descripcion=loc.ambientacion
set loc.cod_tematica=tem.cod_tematica;

-- Utilizo el insert ignore para que no me falle la transaccion al insertar dos descripciones iguales
-- de tour y locacion

commit;

ALTER TABLE `role_play_events_parcial`.`tour` 
DROP FOREIGN KEY `fk_tour_tematica`;
ALTER TABLE `role_play_events_parcial`.`tour` 
DROP COLUMN `tematica`,
CHANGE COLUMN `cod_tematica` `cod_tematica` INT NOT NULL ;
ALTER TABLE `role_play_events_parcial`.`tour` 
ADD CONSTRAINT `fk_tour_tematica`
  FOREIGN KEY (`cod_tematica`)
  REFERENCES `role_play_events_parcial`.`tematica` (`cod_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `role_play_events_parcial`.`locacion` 
DROP FOREIGN KEY `fk_locacion_tematica`;
ALTER TABLE `role_play_events_parcial`.`locacion` 
DROP COLUMN `ambientacion`,
CHANGE COLUMN `cod_tematica` `cod_tematica` INT NOT NULL ;
ALTER TABLE `role_play_events_parcial`.`locacion` 
ADD CONSTRAINT `fk_locacion_tematica`
  FOREIGN KEY (`cod_tematica`)
  REFERENCES `role_play_events_parcial`.`tematica` (`cod_tematica`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;


-- Corrección Adrián Meca:
/*
	1. utiliza insert ignore en lugar de union
	para evitar duplicados -0 (en sistemas reales evitarlo,
	tiene comportamientos no deseables con las columnas
	autogeneradas, convine usar
	insert-on-duplicate-key
*/