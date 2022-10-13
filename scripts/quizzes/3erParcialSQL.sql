/*
	 Guías que no hablan idiomas frecuentes. 
     Listar los empleados guías que no hablan “inglés” ni “portugués”.
     Indicar cuil, nombre y apellido.
*/

select emp.cuil, emp.nombre, emp.apellido
from empleado emp
where emp.tipo = 'Guia'
and emp.cuil not in(
	select e.cuil
    from empleado e
    inner join idioma_guia ig
		on ig.cuil_guia=e.cuil
	inner join idioma idi
		on idi.codigo=ig.codigo_idioma
	where idi.nombre in ('%Ingl_s%' , '%Portugu_s%')
);

/*
	Clientes en auge. Listar los clientes que hayan contratado menos tours en 2021 que en 2022.
    Se deberán mostrar aún aquellos clientes que no hayan contratado en 2021 o 2022.
    Indicar cuil, denominación y tipo del cliente, cantidad de contratos en 2021, cantidad de contratos en 2022 e incremento en la cantidad.
*/

with clientes21 as (
	select c.cuil, count(con.cuil_cliente) as cant2021
    from cliente c
    left join contrata con
		on con.cuil_cliente=c.cuil
        and con.fecha_hora between '20210101' and '20211231'
	group by c.cuil
)
select c.cuil, c.denom, c.tipo
	, coalesce(count(con.fecha_hora), 0) cant2022
    , coalesce(cant2021, 0) cant2021
    , (count(con.fecha_hora) - cant2021) as incremento
from cliente c
left join contrata con
	on con.cuil_cliente=c.cuil
    and con.fecha_hora between '20220101' and '20221231'
left join clientes21
	on clientes21.cuil=con.cuil_cliente
group by c.cuil
having cant2021 < cant2022;
