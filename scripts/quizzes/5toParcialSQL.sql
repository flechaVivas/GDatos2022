
/*
	7. Crear una función prop_categoria que reciba una categoría de empleado 
    y un rango de fecha y hora (desde y hasta) y calcule la proporción de tours 
    guiados por empleados de dicha categoría iniciados en ese rango de fechas sobre 
    el total de tours realizados en el mismo rango.
	Listar todas las categorías y para cada una invocar a la función para calcular
    la proporción entre noviembre de 2022 y febrero de 2022.
    Indicar categoría y proporción, ordenar por proporción ascendente.
    No se deben repetir categorías

*/

USE `role_play_events`;
DROP function IF EXISTS `prop_categoria`;

DELIMITER $$
USE `role_play_events`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `prop_categoria`(cat_empleado varchar(255), fecha_desde datetime, fecha_hasta datetime) RETURNS decimal(9,3)
    READS SQL DATA
BEGIN
	
    declare total decimal(9,3);
	declare prop decimal(9,3);
    
	select count(*) into total
	from empleado e
	inner join tour t
		on t.cuil_guia=e.cuil
	where t.fecha_hora_salida between fecha_desde and fecha_hasta;
	
	select (count(*) / total) into prop
    from empleado e
    inner join tour t
		on t.cuil_guia=e.cuil
	where e.categoria = cat_empleado
    and t.fecha_hora_salida between fecha_desde and fecha_hasta;


RETURN prop;
END$$

DELIMITER ;
;

select distinct e.categoria, prop_categoria(e.categoria, "20221101", "20230228") prop
from empleado e
order by prop;
