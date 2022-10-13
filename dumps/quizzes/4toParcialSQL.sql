

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