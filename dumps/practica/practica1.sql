/*
		PRÁCTICA 1 : SELECT
*/
-- 1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la misma.
desc empresas;
select * from empresas;

-- 2) Mostrar la estructura de la tabla Personas. Mostrar el apellido y nombre y la fecha de registro en la agencia.
desc personas;
select apellido, nombre, fecha_registro_agencia from personas;

-- 4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de nacimiento, teléfono, y su dirección.
select concat(apellido,' ', nombre) as 'Apellido y Nombre', fecha_nacimiento as 'Fecha Nac.', Telefono, direccion
from personas
where dni in('28675888');

-- 5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y 31345778. Ordenadas por fecha de Nacimiento
select dni, concat(apellido,', ', nombre) as 'Apellido y Nombre', fecha_nacimiento as 'Fecha Nac.', Telefono, direccion
from personas
where dni in('27890765', '29345777','31345778')
order by fecha_nacimiento;

-- 6) Mostrar las personas cuyo apellido empiece con la letra ‘G’.
select * from personas where apellido like 'G%';

-- 7) Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y 2000
select nombre, apellido, fecha_nacimiento 
from personas where year(fecha_nacimiento) between 1980 and 2000; 

-- 8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente por fecha de solicitud.
select * from solicitudes_empresas
order by fecha_solicitud asc;

-- 9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral ordenados por fecha desde.
select * from antecedentes where fecha_hasta is null;

-- 10) Mostrar aquellos antecedentes laborales que finalizaron y cuya fecha hasta no esté entre
-- 	   junio del 2013 a diciembre de 2013, ordenados por número de DNI del empleado.
select * from antecedentes
where fecha_hasta is not null
and fecha_hasta not between '2013-06-01' and '2013-12-31';

-- 11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas
-- 	   30-10504876-5 o 30-21098732-4.
select nro_contrato as 'Nro Contrato', dni as DNI, sueldo as Salario, cuit as CUIT
from contratos
where sueldo > 2000 and cuit in('30-10504876-5','30-21098732-4');

-- 12) Mostrar los títulos técnicos
select *
from titulos
where desc_titulo like 'Tecnico%';

-- 13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y el código de cargo
--     sea 6 o hayan solicitado aspirantes de sexo femenino
select *
from solicitudes_empresas
where fecha_solicitud > '2013-09-21'
and (cod_cargo = 6 or sexo='Femenino');

-- 14) Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido terminado.
select * from contratos where sueldo > 2000 and fecha_caducidad is null;