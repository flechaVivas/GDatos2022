-- INSERT

/*
	1) Agregar el nuevo instructor Daniel Tapia con cuil: 44-44444444-4, teléfono: 444-444444,
	email: dotapia@gmail.com, dirección Ayacucho 4444 y sin supervisor.
*/

start transaction;

INSERT INTO instructores(cuil,nombre,apellido,tel,email,direccion)
VALUES ('4-44444444-4', 'Daniel', 'Tapia', '444-444444', 'dotapia@gmail.com', 'Ayacucho 4444');

rollback;
commit;

/*
	2) Ingresar un nuevo plan de capacitación con sus datos, costo, temas, exámenes y
	materiales:
	Plan:
	Nombre: Administrador de BD, descripción: Instalación y configuración MySQL. Lenguaje
	SQL. Usuarios y permisos, de 300 hs con modalidad presencial

	Temas: 4

	Titulo Detalle
	1- Instalación MySQL Distintas configuraciones de instalación
	2- Configuración DBMS Variables de entorno, su uso y configuración
	3- Lenguaje SQL DML, DDL y TCL
	4- Usuarios y Permisos Permisos de usuarios y DCL

	Exámenes: 4

	Examen Temas que incluye
	1 1- Instalación MySQL
	2 2- Configuración DBMS
	3 3- Lenguaje SQL
	4 4- Usuarios y Permisos

	Materiales Existentes que entrega: Código UT-001, UT-002, UT-003 y UT-004
	Nuevos Materiales:
	Código Desc. URL descarga Autor Tam Fecha
	Creación

	AP-010 DBA en
	MySQL
	www.afatse.com.ar/apuntes?AP=010 José
	Román
	2MB 01/03/09
	AP-011 SQL en www.afatse.com.ar/apuntes?AP=011 Juan 3MB 01/04/09

	MySQL López

	Valor: $ 150 desde el 01/02/2009
*/

start transaction;

insert into plan_capacitacion(nom_plan, desc_plan,hs,modalidad) 
values ('Administrador de BD', 'Instalación y configuración MySQL. Lenguaje SQL. Usuarios y permisos,', 300, 'Presencial');

insert into plan_temas(nom_plan,titulo,detalle) values 
('Administrador de BD','1- Instalación MySQL','Distintas configuraciones de instalación'),
('Administrador de BD','2- Configuración DBMS','2- Configuración DBMS'),
('Administrador de BD','3- Lenguaje SQL','3- Lenguaje SQL'),
('Administrador de BD','4- Usuarios y Permisos','4- Usuarios y Permisos');

insert into examenes(nom_plan,nro_examen) values
('Administrador de BD',1),
('Administrador de BD',2),
('Administrador de BD',3),
('Administrador de BD',4);

insert into examenes_temas(nom_plan,titulo,nro_examen) values
('Administrador de BD','1- Instalación MySQL',1),
('Administrador de BD','2- Configuración DBMS',2),
('Administrador de BD','3- Lenguaje SQL',3),
('Administrador de BD','4- Usuarios y Permisos',4);

insert into materiales(cod_material,desc_material,url_descarga,autores,tamanio,fecha_creacion) values
('AP-010','DBA en MySQL','www.afatse.com.ar/apuntes?AP=010','José Román','2','20090310'),
('AP-011','SQL en MySQL', 'www.afatse.com.ar/apuntes?AP=011','Juan Lopez', '3', '20090401');

insert into materiales_plan(nom_plan,cod_material,cant_entrega) values
('Administrador de BD','UT-001',0),
('Administrador de BD','UT-002',0),
('Administrador de BD','UT-003',0),
('Administrador de BD','UT-004',0);

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan) 
values ('Administrador de BD','20090201', 150);

rollback;
commit;

-- UPDATE

/*
	1) Como resultado de una mudanza a otro edificio más grande se ha incrementado la
	capacidad de los salones, además la experiencia que han adquirido los instructores permite
	ampliar el cupo de los cursos. Para todos los curso con modalidad presencial y
	semipresencial aumentar el cupo de la siguiente forma:
	● 50% para los cursos con cupo menor a 20
	● 25% para los cursos con cupo mayor o igual a 20
*/

start transaction;

update cursos c1, (select c.nro_curso, c.nom_plan
    from cursos c
    inner join plan_capacitacion pc
	on pc.nom_plan=c.nom_plan
	where c.cupo < 20 and pc.modalidad in ('Presencial', 'Semipresencial')) c2
set c1.cupo = c1.cupo * 1.5
where c1.nro_curso=c2.nro_curso 
and c1.nom_plan=c2.nom_plan;

update cursos c1, (select c.nro_curso, c.nom_plan
    from cursos c
    inner join plan_capacitacion pc
	on pc.nom_plan=c.nom_plan
	where c.cupo >= 20 and pc.modalidad in ('Presencial', 'Semipresencial')) c2
set c1.cupo = c1.cupo * 1.25
where c1.nro_curso=c2.nro_curso 
and c1.nom_plan=c2.nom_plan;


rollback;
commit;

/*
	2) Convertir a Daniel Tapia en el supervisor de Henri Amiel y Franz Kafka. Utilizar el cuil de
	cada uno.
*/

start transaction;

select i.cuil into @henri
from instructores i
where i.apellido = 'Amiel' and i.nombre='Henri';

select i.cuil into @franz
from instructores i
where i.apellido = 'Kafka' and i.nombre='Franz';

select i.cuil into @tapia
from instructores i
where i.apellido = 'Tapia' and i.nombre='Daniel';

update instructores set cuil_supervisor = @tapia
where cuil in (@henri, @franz);

rollback;
commit;

/*
	El alumno Victor Hugo se ha mudado. Actualizar su dirección a Italia 2323 y su teléfono
	nuevo es 3232323.
*/
start transaction;

select dni into @vhugo
from alumnos
where apellido='Hugo' and nombre='Victor';

update alumnos set direccion='Italia 2323', tel='3232323'
where dni = @vhugo;

rollback;
commit;


/*
	PRÁCTICA 9
*/
-- INSERT JOIN
/*
	1) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
	01/06/2009 con un 20 por ciento más que su último valor. Eliminar las filas agregadas.
*/

start transaction;

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan)
with ultimo as(
	select nom_plan, max(fecha_desde_plan) ult_fecha
    from valores_plan
    group by nom_plan
) 
select vp.nom_plan, '20090601', vp.valor_plan * 1.20
from ultimo u
inner join valores_plan vp
	on u.nom_plan=vp.nom_plan
    and u.ult_fecha=vp.fecha_desde_plan;

rollback;
-- commit;

/*
	2) Crear una nueva lista de precios para todos los planes de capacitación, a partir del
	01/08/2009, con la siguiente regla: Los cursos cuyo último valor sea menor a $90
	aumentarlos en un 20% al resto aumentarlos un 12%.
*/

start transaction;

drop temporary table if exists tt_ultimo;
create temporary table tt_ultimo
	select nom_plan, max(fecha_desde_plan) ult_fecha
    from valores_plan
    group by nom_plan;

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan)
select vp.nom_plan, '20090601', vp.valor_plan * 1.12
from valores_plan vp
inner join tt_ultimo u
	on u.nom_plan=vp.nom_plan
    and u.ult_fecha=vp.fecha_desde_plan
where vp.valor_plan >= 90;

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan)
select vp.nom_plan, '20090601', vp.valor_plan * 1.20
from valores_plan vp
inner join tt_ultimo u
	on u.nom_plan=vp.nom_plan
    and u.ult_fecha=vp.fecha_desde_plan
where vp.valor_plan < 90;

rollback;
-- commit;

-- Resolucion con CASE

start transaction;

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan)
with ultimo as(
	select nom_plan, max(fecha_desde_plan) ult_fecha
    from valores_plan
    group by nom_plan
) 
select vp.nom_plan, '20090601', case
									when vp.valor_plan < 90 then vp.valor_plan * 1.20
                                    else vp.valor_plan * 1.12
								end 
from valores_plan vp
inner join ultimo u
	on u.nom_plan=vp.nom_plan
    and u.ult_fecha=vp.fecha_desde_plan;

rollback;
-- commit;


/*
	3) Crear un nuevo plan: Marketing 1 Presen. Con los mismos datos que el plan
	Marketing 1 pero con modalidad presencial. Este plan tendrá los mismos temas, exámenes
	y materiales que Marketing 1 pero con un costo un 50% superior, para todos los períodos
	de este año que ya estén definidos costos del plan.
*/

start transaction;

insert into plan_capacitacion(nom_plan,desc_plan,hs,modalidad)
select 'Marketing 1 Presen', desc_plan, hs, 'Presencial'
from plan_capacitacion pc
where pc.nom_plan = 'Marketing 1';

insert into plan_temas(nom_plan,titulo,detalle)
select 'Marketing 1 Presen', pt.titulo, pt.detalle
from plan_temas pt
where pt.nom_plan = 'Marketing 1';

insert into examenes(nom_plan,nro_examen)
select 'Marketing 1 Presen', e.nro_examen
from examenes e
where e.nom_plan='Marketing 1';

insert into examenes_temas(nom_plan,titulo,nro_examen)
select 'Marketing 1 Presen',titulo,nro_examen
from examenes_temas
where nom_plan= 'Marketing 1';

insert into valores_plan(nom_plan,fecha_desde_plan,valor_plan)
select 'Marketing 1 Presen',fecha_desde_plan,valor_plan * 1.5
from `valores_plan`
where nom_plan= 'Marketing 1';

rollback;

-- commit;


 -- UPDATE JOIN
 /*
	4) Cambiar el supervisor de aquellos instructores que dictan Reparac PC Avanzada este año a
	66-66666666-6 (Franz Kafka).
 */
 
 start transaction;
 
 update instructores i
 inner join cursos_instructores ci
	on ci.cuil=i.cuil
inner join cursos c
	on c.nom_plan=ci.nom_plan
 set i.cuil_supervisor='66-66666666-6'
 where ci.nom_plan = 'Reparac PC Avanzada'
 and c.fecha_ini between '20140101' and '20141231';
 ;
 
 rollback;
 -- commit;
 