
/*
	------------------------------------------
    PRACTICA PREPARCIAL 4 - DB: role_play_events
    ------------------------------------------
*/

/*	Cambio de empresa de turismo. La empresa de turismo SG-1 ha cerrado y vendido todos sus futuros contratos a la empresa Bosom Jump. 
	Se deberá registrar la nueva empresa con los datos a continuación y transferir todos los contratos 
	de SG-1 a Bosom Jump de tours que empiecen desde noviembre en adelante.

	Nuevo cliente:
	CUIT/CUIL: 98-98989898-9
	Denominación: Bosom Jump Ltd.
	Email: nergal@mars.jp
	Teléfono:+989-989899898
	Dirección: Xebec 1996
	Tipo: Empresa de turismo 
*/

start transaction;

insert into cliente(cuil,denom,email,telefono,direccion,tipo)
values(98989898989,'Bosom Jump Ltd.','nergal@mars.jp','+989-989899898','Xebec 1996','Empresa de turismo');

update contrata con
inner join cliente cli
	on cli.cuil=con.cuil_cliente
inner join tour t
	on t.nro=con.nro_tour
set cuil_cliente = 98989898989
where t.fecha_hora_salida >= '20221001'
and cli.denom = 'SG-1';

rollback;
commit;

/*Reemplazo de encargado. El encargado Erwin Smith no tiene suficiente conocimiento en tours de temática “SNK”, 
para suplir sus tareas, se ha contratado a la nueva encargada Hange Zoë. 
Dar de alta a la nueva encargada con los datos que figuran a continuación y reemplazar a Erwin Smith 
por ella en las escalas ya existentes a realizarse a partir del 29 de octubre correspondientes a tours con temática “SNK”.

Nuevo empleado:
CUIL:90-90909090-9
Nombre: Hange
Apellido: Zoë
Teléfono:+909-090909090
Categoría: comander
Tipo: encargado*/


start transaction;

insert into empleado(cuil,nombre,apellido,telefono,categoria,tipo)
values(90909090909, 'Hange','Zoë','+909-090909090','comander','Encargado');

update escala es
inner join empleado em
	on em.cuil=es.cuil_encargado
inner join tour t
	on t.nro=es.nro_tour
set es.cuil_encargado = 90909090909
where em.nombre = 'Erwin' and em.apellido = 'Smith'
and es.fecha_hora_ini >= '20221029'
and t.tematica in ('SNK');


rollback;
-- commit;






