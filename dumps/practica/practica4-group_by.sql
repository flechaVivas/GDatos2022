/*
	-------------------------------------------------
    PRACTICA 4 - GROUP BY + HAVING
    -------------------------------------------------
*/

/* 1) Mostrar las comisiones pagadas por la empresa Tráigame eso. */

select emp.cuit, emp.razon_social
, sum(importe_comision) total_pagado
, count(fecha_pago) cant_comisiones
from comisiones com
inner join contratos con
	on con.nro_contrato=com.nro_contrato
inner join empresas emp
	on emp.cuit=con.cuit
where emp.razon_social = 'Traigame Eso' and fecha_pago is not null
group by emp.cuit, emp.razon_social;

/* 2) Ídem 1) pero para todas las empresas. */

select emp.cuit, emp.razon_social
, sum(importe_comision) total_pagado
, count(fecha_pago) cant_comisiones
from comisiones com
inner join contratos con
	on con.nro_contrato=com.nro_contrato
inner join empresas emp
	on emp.cuit=con.cuit
where fecha_pago is not null
group by emp.cuit, emp.razon_social;

/* 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
en forma ascendente y luego por desviación estándar en forma descendente. */

select ent.nombre_entrevistador, ee.cod_evaluacion
	, avg(ee.resultado) promedio
    , stddev(ee.resultado) desvio
    , variance(ee.resultado) varianza
from entrevistas ent
inner join entrevistas_evaluaciones ee
	on ee.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, ee.cod_evaluacion
order by promedio asc, desvio desc;

/* 4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
de evaluación. */

select ent.nombre_entrevistador, ee.cod_evaluacion
	, avg(ee.resultado) promedio
    , stddev(ee.resultado) desvio
    , variance(ee.resultado) varianza
from entrevistas ent
inner join entrevistas_evaluaciones ee
	on ee.nro_entrevista=ent.nro_entrevista
where ent.nombre_entrevistador = 'Angelica Doria'
group by ent.nombre_entrevistador, ee.cod_evaluacion
having promedio > 71
order by ee.cod_evaluacion asc;

/* 5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014. */

select ent.nombre_entrevistador, count(ent.fecha_entrevista) 'Cantidad De Entevistas'
from entrevistas ent
where ent.fecha_entrevista between '20140101' and '20141231'
group by ent.nombre_entrevistador;

/* 6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
Ordenado por cantidad de entrevistas. */

select ent.nombre_entrevistador, ee.cod_evaluacion
	, count(*) cant_entrevistas
	, avg(ee.resultado) promedio
    , stddev(ee.resultado) desvio
    , variance(ee.resultado) varianza
from entrevistas ent
inner join entrevistas_evaluaciones ee
	on ee.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, ee.cod_evaluacion
having promedio > 71
order by cant_entrevistas asc;

/* 7) Ídem 6) para aquellos cuya cantidad de entrevistas por codigo de evalucaicpon
sea myor mayor que 1. Ordenado por nombre en forma descendente y por codigo de
evalucacion en forma ascendente */

select ent.nombre_entrevistador, ee.cod_evaluacion
	, count(*) cant_entrevistas
	, avg(ee.resultado) promedio
    , stddev(ee.resultado) desvio
    , variance(ee.resultado) varianza
from entrevistas ent
inner join entrevistas_evaluaciones ee
	on ee.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, ee.cod_evaluacion
having cant_entrevistas > 1
order by ent.nombre_entrevistador desc ,ee.cod_evaluacion asc;

/* 8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
cantidad a pagadas. */

select com.nro_contrato, count(*) Total
	, count(*) - count(com.fecha_pago) A_Pagar
    , count(com.fecha_pago) Pagadas
from comisiones com
group by com.nro_contrato;

/* 9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
el % de impagas. */

select nro_contrato, count(*) Total
	, (count(fecha_pago) / count(*)) * 100 Pagadas
    , ((count(*) - count(fecha_pago))  / count(*)) * 100 A_Pagar
from comisiones
group by nro_contrato;

/* 10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
diferencia respecto al total de solicitudes. */

select count(distinct cuit) Cantidad
	, count(*) - count(distinct cuit) Difernecia
from solicitudes_empresas;

/* 11) Cantidad de solicitudes por empresas. */

select emp.cuit, emp.razon_social, count(*) cant_solicitudes
from solicitudes_empresas se
inner join empresas emp
	on emp.cuit=se.cuit
group by emp.cuit, emp.razon_social
order by cant_solicitudes desc;

/* 12) Cantidad de solicitudes por empresas y cargos. */

select emp.cuit, emp.razon_social, se.cod_cargo, count(*)
from solicitudes_empresas se
inner join empresas emp
	on emp.cuit=se.cuit
group by emp.cuit, emp.razon_social, se.cod_cargo;


/*13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.*/

select emp.cuit, emp.razon_social, count(distinct ant.dni) cant_personas
from empresas emp
left join antecedentes ant
	on ant.cuit=emp.cuit
group by emp.cuit, emp.razon_social;

/* 14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
0. Agregar algún cargo que nunca haya sido solicitado */

select car.cod_cargo, car.desc_cargo, count(fecha_solicitud) cant_solicitudes
from cargos car
left join solicitudes_empresas se
	on se.cod_cargo=car.cod_cargo
group by car.cod_cargo, car.desc_cargo
order by cant_solicitudes desc;

/* 15) Indicar los cargos que hayan sido solicitados menos de 2 veces */

select car.cod_cargo, car.desc_cargo, count(fecha_solicitud) cant_solicitudes
from cargos car
left join solicitudes_empresas se
	on se.cod_cargo=car.cod_cargo
group by car.cod_cargo, car.desc_cargo
having cant_solicitudes < 2
order by cant_solicitudes desc;

