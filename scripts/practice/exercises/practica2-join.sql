/*
	PRACTICA 2 - JOIN
*/
-- 1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
--    sueldo acordado en el contrato.
select per.nombre, per.apellido, con.sueldo, per.dni
from contratos con
inner join personas per
	on con.dni=per.dni
where con.nro_contrato = 5;

-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
--     Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
--     agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
--     ‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa.
select con.dni, con.nro_contrato, con.fecha_incorporacion, con.fecha_solicitud, coalesce(con.fecha_caducidad, 'Sin Fecha')
from empresas emp
inner join contratos con
	on con.cuit=emp.cuit
where emp.razon_social in('Viejos Amigos','Traigame eso')
order by 4, emp.razon_social;

-- 3) Listado de las solicitudes consignando razón social, dirección y e_mail de la
--    empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
--    fecha d solicitud y descripción de cargo.
select emp.razon_social, emp.direccion, emp.e_mail, car.desc_cargo, se.anios_experiencia
from empresas emp
inner join solicitudes_empresas se
	on se.cuit=emp.cuit
inner join cargos car
	on car.cod_cargo=se.cod_cargo
order by se.fecha_solicitud, car.desc_cargo;

-- 4) Listar todos los candidatos con título de bachiller o un título de educación no
--    formal. Mostrar nombre y apellido, descripción del título y DNI.
select per.dni, per.nombre, per.apellido, t.desc_titulo
from personas per
inner join personas_titulos pt
	on pt.dni=per.dni
inner join titulos t
	on t.cod_titulo=pt.cod_titulo
where t.desc_titulo = 'bachiller' or t.tipo_titulo = 'educacion no formal';

-- 5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.
select per.nombre, per.apellido, t.desc_titulo
from personas per
inner join personas_titulos pt
	on pt.dni=per.dni
inner join titulos t
	on t.cod_titulo=pt.cod_titulo
order by per.dni;

-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
--    Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
--    Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia S.A
select per.apellido,' ',per.nombre,' tiene como referencia a ', coalesce(ant.persona_contacto, 'No tiene contacto'), ' y cuando trabajo en ', emp.razon_social
from personas per
inner join antecedentes ant
	on per.dni=ant.dni
inner join empresas emp
	on emp.cuit=ant.cuit
where ant.persona_contacto in('armando esteban quito','felipe rojas') or ant.persona_contacto is null;

-- 7) Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del
--    cargo solicitado y edad máxima y mínima
select emp.razon_social, se.fecha_solicitud, car.desc_cargo, coalesce(se.edad_minima, 'Sin especificar'), coalesce(se.edad_maxima, 'Sin especificar')
from empresas emp
inner join solicitudes_empresas se
	on se.cuit=emp.cuit
inner join cargos car
	on car.cod_cargo=se.cod_cargo
where emp.razon_social = 'viejos amigos';

-- 8) Mostrar los antecedentes de cada postulante
select concat(per.nombre,' ',per.apellido) as Postulante, car.desc_cargo as Cargo
from personas per
inner join antecedentes ant
	on ant.dni=per.dni
inner join cargos car
	on car.cod_cargo=ant.cod_cargo;

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
--    ascendente por empresa y descendente por cargo:
select emp.razon_social, car.desc_cargo, ev.desc_evaluacion, eev.resultado
from empresas emp
inner join solicitudes_empresas se
	on se.cuit=emp.cuit
inner join cargos car
	on car.cod_cargo=se.cod_cargo
inner join entrevistas ent
	on ent.cuit=se.cuit
	and ent.cod_cargo=se.cod_cargo
    and ent.fecha_solicitud=se.fecha_solicitud
inner join entrevistas_evaluaciones eev
	on eev.nro_entrevista=ent.nro_entrevista
inner join evaluaciones ev
	on ev.cod_evaluacion=eev.cod_evaluacion
order by emp.razon_social asc, car.desc_cargo desc;

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
--     y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
--     leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.
select emp.cuit, emp.razon_social, coalesce(se.fecha_solicitud,'Sin Solicitud'), coalesce(car.desc_cargo,'Sin Solicitud')
from empresas emp
left join solicitudes_empresas se
	on se.cuit=emp.cuit
left join cargos car
	on car.cod_cargo=se.cod_cargo;
    
-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
--     y si se hubiese realizado un contrato los datos de la(s) persona(s).
select emp.cuit, emp.razon_social, car.desc_cargo,
 coalesce(per.dni, 'Sin contrato') as DNI, coalesce(per.apellido, 'Sin contrato') as Apellido, coalesce(per.nombre, 'Sin contrato') as Nombre
from empresas emp
inner join solicitudes_empresas se
	on se.cuit=emp.cuit
inner join cargos car
	on car.cod_cargo=se.cod_cargo
left join contratos con
	on con.cuit=se.cuit
    and con.cod_cargo=se.cod_cargo
    and con.fecha_solicitud=se.fecha_solicitud
left join personas per
	on per.dni=con.dni;
    
-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
--     las solicitudes para las cuales no se haya realizado un contrato.

-- ????????????????????????????????????????????????????????????????????????????????????????????
select emp.cuit, emp.razon_social, car.desc_cargo
from empresas emp
inner join solicitudes_empresas se
	on se.cuit=emp.cuit
right join contratos con
	on con.cod_cargo=se.cod_cargo
right join cargos car
	on car.cod_cargo=con.cod_cargo;
    
    
-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como
-- 	   antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
--     lo ocupó.
    
select car.desc_cargo, per.dni, per.apellido, emp.razon_social
from cargos car
left join antecedentes ant
	on ant.cod_cargo=car.cod_cargo
left join personas per
	on per.dni=ant.dni
left join empresas emp
	on emp.cuit=ant.cuit;
    
    




    