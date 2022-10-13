/*
	302 - 1. Listado de encargados por actividad. Listar para cada actividad que se realizó entre enero y julio de 2022
    (inclusive) que empleado ofició de encargado.  
    Indicar código de locación, número y descripción de la actividad y cuil, nombre y apellido del encargado. 
    No se deberán mostrar registros repetidos y deberá ordenarse alfabéticamente por apellido y nombre del encargado.
*/
select distinct act.codigo_locacion, act.nro, act.descripcion, emp.cuil, emp.nombre, emp.apellido
from actividad act
inner join escala es
	on es.codigo_locacion=act.codigo_locacion
    and es.nro_actividad=act.nro
inner join empleado emp
	on emp.cuil=es.cuil_encargado
where es.fecha_hora_ini between '2022-01-01' and '2022-07-31'
order by emp.apellido, emp.nombre;
/*
	303 - 2. Idiomas y clientes que los solicitaron en julio de 2022.
    Listar todos los idiomas y , para aquellos que hayan sido solicitados durante una contratación de júlio de 2022,
    mostrar los datos de los clientes. Indicar código y nombre del idioma, cuil, denominación y tipo del cliente.
    Ordenar por fecha y hora de contratación ascendente
*/
select idi.codigo, idi.nombre, c.cuil, c.denom, c.tipo
from idioma idi
left join contrata con
	on con.codigo_idioma=idi.codigo
    and con.fecha_hora between '2022-07-01' and '2022-07-31'
left join cliente c
	on c.cuil=con.cuil_cliente
order by con.fecha_hora asc;




