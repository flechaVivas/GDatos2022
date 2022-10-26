
/*Crear una función prop_tematica que reciba una temática y un rango de fecha 
y hora (desde y hasta) y calcule la proporción de cantidad de entradas contratadas 
por tours con dicha temática en el rango propuesto sobre el total de entradas contratadas en el mismo rango.
Listar todas las temáticas y para cada una invocar a la función para calcular 
la proporción entre agosto y diciembre de 2022. Indicar tipo y proporción ordenar 
por proporción descendente. No se deben repetir temáticas*/

USE `role_play_events`;
DROP function IF EXISTS `prop_tematica`;

DELIMITER $$
USE `role_play_events`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `prop_tematica`(tematica_tour varchar(255), fecha_desde datetime, fecha_hasta datetime) RETURNS int
    READS SQL DATA
BEGIN
	
    declare total decimal(10,3);
    declare prop decimal(10,3);
    
	select sum(con.cant_entradas) into total
	from contrata con
    where con.fecha_hora between fecha_desde and fecha_hasta;

	select (sum(con.cant_entradas) / total)*100 into prop
	from tour t
	inner join contrata con
		on con.nro_tour=t.nro
	where con.fecha_hora between fecha_desde and fecha_hasta
	and t.tematica = tematica_tour;

RETURN prop; 
END$$

DELIMITER ;
;

select distinct t.tematica, prop_tematica(t.tematica, '20220801','20221231') prop
from tour t
order by prop desc;