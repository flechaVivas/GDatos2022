
/*
	AGENCIA PERSONAL
*/
/*
	1 )¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?
*/
-- Subconsulta
select distinct p.dni, p.apellido, p.nombre
from personas p
inner join contratos c
	on c.dni=p.dni
where c.cuit in
(
	select con.cuit
	from personas per
	inner join contratos con
		on con.dni=per.dni
	where per.nombre = 'Stefania' and per.apellido = 'Lopez'
);
-- CTE
with cte_empresas as (
	select con.cuit
	from contratos con
	inner join personas p
		on p.dni=con.dni
	where p.apellido = 'Lopez' and p.nombre = 'Stefania'
)
select distinct p.apellido, p.nombre
from contratos c
inner join cte_empresas 
	on cte_empresas.cuit=c.cuit
inner join personas p
	on p.dni=c.dni
inner join empresas emp
	on emp.cuit=c.cuit;



/*
	2) Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados
	de Viejos Amigos.
*/
select max(sueldo) into @maxSueldo
from contratos con
inner join empresas emp
	on emp.cuit=con.cuit
where emp.razon_social = 'Viejos Amigos';

select per.dni, concat(per.apellido, per.nombre) as 'Apellido y Nombre', con.sueldo
from contratos con
inner join personas per
	on per.dni=con.dni
where con.sueldo < @maxSueldo;
/*
	3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
	de aquellas cuyo promedio supere al promedio de Tráigame eso.
*/
select avg(importe_comision) into @promTE
from comisiones com
inner join contratos con
	on con.nro_contrato=com.nro_contrato
inner join empresas emp
	on emp.cuit=con.cuit
where emp.razon_social = 'Traigame Eso';

select emp.cuit, emp.razon_social, avg(com.importe_comision) promedio
from empresas emp
left join contratos con
	on con.cuit=emp.cuit
left join comisiones com
	on com.nro_contrato=con.nro_contrato
group by emp.cuit, emp.razon_social
having promedio > @promTE;
/*
	4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las
	comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes
	contrato, año contrato , nro. contrato, nombre y apellido del empleado.
*/
select emp.razon_social, per.nombre, per.apellido, con.nro_contrato, com.mes_contrato, com.anio_contrato, com.importe_comision
from contratos con 
inner join comisiones com
	on con.nro_contrato = com.nro_contrato
inner join empresas emp
	on emp.cuit = con.cuit
inner join personas per
	on per.dni = con.dni
where com.fecha_pago is not null
and com.importe_comision < (select avg(importe_comision)
							from comisiones);
/*
	5) Determinar las empresas que pagaron más que el promedio
*/              
select avg(importe_comision) into @promeImporte
from comisiones;

select emp.razon_social, avg(com.importe_comision)
from empresas emp
inner join contratos con
	on con.cuit=emp.cuit
inner join comisiones com
	on com.nro_contrato=con.nro_contrato
where com.importe_comision > @promeImporte
group by emp.razon_social;
/*
	6) Seleccionar los empleados que no tengan educación no formal o terciario.
*/
select p.nombre, p.apellido 
from personas p
where p.dni not in (
	select p.dni
	from personas_titulos pt
	inner join titulos t
		on t.cod_titulo = pt.cod_titulo
	inner join personas p
		on p.dni = pt.dni
	where t.tipo_titulo = 'Terciario' or t.tipo_titulo = 'Educacion no formal');
/*
	7) Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los
	contrató.
*/
-- CTE
with cte_sueldos_emp as (
	select emp.cuit, avg(con.sueldo) prom
    from empresas emp
    inner join contratos con
		on con.cuit=emp.cuit
	group by emp.cuit
)
select c.cuit, p.dni, p.apellido, p.nombre, c.sueldo, prom
from personas p
inner join contratos c
	on c.dni=p.dni
inner join cte_sueldos_emp
	on cte_sueldos_emp.cuit=c.cuit
where c.sueldo > cte_sueldos_emp.prom


