
/* 
	PRÁCTICA 12 - STORED PROCEDURES y FUNCIONES
    DB: AFATSE
 */
 /*
    1) Crear un procedimiento almacenado llamado plan_lista_precios_actual que devuelva los
	planes de capacitación indicando: nom_plan modalidad valor_actual
 */
 
USE `afatse`;
DROP procedure IF EXISTS `plan_lista_precios_actual`;

DELIMITER $$
USE `afatse`$$
CREATE PROCEDURE `plan_lista_precios_actual` ()
BEGIN

	with actual as (
		select nom_plan, max(fecha_desde_plan) maxi
        from valores_plan
        group by nom_plan
)
select pc.nom_plan, pc.modalidad, vp.valor_plan
from actual a
inner join valores_plan vp
	on vp.nom_plan=a.nom_plan
	and vp.fecha_desde_plan=a.maxi
inner join plan_capacitacion pc
	on pc.nom_plan=a.nom_plan;

END$$

DELIMITER ;

call plan_lista_precios_actual;


/*
	Crear un procedimiento almacenado llamado plan_lista_precios_a_fecha que dada una
	fecha devuelva los planes de capacitación indicando: nombre_plan modalidad valor_a_fecha
*/

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_a_fecha`(in fecha date)
BEGIN

with ultimo_hasta_fecha as(
	select nom_plan, max(fecha_desde_plan) ultimo
    from valores_plan
    where fecha_desde_plan <= fecha
    group by nom_plan
)
select pc.nom_plan, pc.modalidad, vp.valor_plan
from ultimo_hasta_fecha a
inner join valores_plan vp
	on vp.nom_plan=a.nom_plan
	and vp.fecha_desde_plan=a.ultimo
inner join plan_capacitacion pc
	on pc.nom_plan=a.nom_plan;
	
END$$
DELIMITER ;

call `plan_lista_precios_a_fecha`('20130808');

/*
	Modificar el procedimiento almacenado creado en 1) para que internamente invoque al
	procedimiento creado en 2).
*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_actual`()
BEGIN

call `plan_lista_precios_a_fecha`(current_date());

END$$
DELIMITER ;

call `plan_lista_precios_a_fecha`;


/*
	Crear una función llamada alumnos_deudas_a_fecha que dado un alumno y una fecha
	indique cuantas cuotas adeuda a la fecha.
*/

USE `afatse`;
DROP function IF EXISTS `alumnos_deudas_a_fecha`;

DELIMITER $$
USE `afatse`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `alumnos_deudas_a_fecha`(alumno int, fecha date) RETURNS int
    READS SQL DATA
BEGIN

select (count(*) - count(c.fecha_pago)) into @cantCoutas
from alumnos a
inner join inscripciones ins
	on ins.dni=a.dni
inner join cuotas c
	on c.nom_plan=ins.nom_plan
    and c.nro_curso=ins.nro_curso
    and c.dni=ins.dni
where c.fecha_emision <= fecha
and c.dni in(alumno);

RETURN @cantCuotas;
END$$

DELIMITER ;
;








