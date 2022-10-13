/*
	302 - 6. Reemplazo de guía. Debido a la alta demanda el empleado “Inosuke Hashibira” fue asignado 
	como guía pero no habla bien idiomas extranjeros. Para resolver el problema se ha contratado 
	a un nuevo guía. Dar de alta el nuevo guía con los datos que figuran a continuación y 
	resignar todos los tours de “Inosuke Hashibira” que comienzan a partir del 1 de octubre y 
	en sus contratos han solicitado algún idioma.
	Nuevo guía
	CUIL: 80-80808080-8
	Nombre: Aoi
	Apellido: Toudou
	Teléfono:+808-080808080
	Categoría: Senpai
	Tipo: Guía
*/

start transaction;

insert into empleado(cuil,nombre,apellido,telefono,categoria,tipo)
values(80808080808,'Aoi','Toudou','+808-080808080','Senpai','Guia');

update tour t
inner join contrata con
	on con.nro_tour=t.nro
inner join empleado emp
	on emp.cuil=t.cuil_guia
set t.cuil_guia = 80808080808
where emp.nombre = 'Inosuke' and emp.apellido = 'Hashibira'
and con.fecha_hora >= '20221001'
and con.codigo_idioma is not null;

commit;
