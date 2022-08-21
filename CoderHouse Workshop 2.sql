-- Indicate per working day, the number of teachers and sum the costs. This information is only needed for the "Desarrollo Web" subject.
-- The seults recorded must contain all the values in the first table. Rename the calculate column with the teachers as "CantDocentes" and the column with the sum of the costs as "SumaTotal".
/*Indicar por jornada la cantidad de docentes que dictan y sumar los costos. Esta información sólo se desea visualizar para las asignaturas de desarrollo web. 
El resultado debe contener todos los valores registrados en la primera tabla, Renombrar la columna del cálculo de la cantidad de 
docentes como cant_docentes y la columna de la suma de los costos como suma_total. 
Keywords: Asignaturas,Staff, DocentesID, Jornada, Nombre, costo.*/
Select *
From CoderHouse..Asignaturas
Select *
From CoderHouse..Staff

Select a.Jornada, Count(s.DocentesID) as CantDocentes, Sum(a.Costo) as SumaTotal
From Asignaturas a join Staff s 
	ON a.AsignaturasID = s.Asignatura
Where a.Nombre like '%Desarrollo Web%'
Group by a.Jornada

-- It is required to know the ID of the manager, name, last name and the number of teachers who are asigned to them. Then, filter those managers who doesn't have teachers asigned
/* Se requiere saber el id del encargado, el nombre, el apellido y cuántos son los docentes que tiene asignados cada encargado. Luego filtrar los encargados que tienen como resultado 0 ya que son 
los encargados que NO tienen asignado un docente. Renombrar el campo  de la operación como Cant_Docentes. 
Keywords: Docentes_id, Encargado, Staff, Nombre, Apellido,Encargado_ID.*/
SELECT *
FROM encargado;
SELECT *
FROM staff;

SELECT e.Encargado_ID, e.nombre, e.apellido, count(s.DocentesID) as Cant_Docentes
FROM encargado e
LEFT JOIN staff s
ON s.Encargado=e.Encargado_ID
GROUP BY e.Encargado_ID, e.nombre, e.apellido
HAVING count(s.DocentesID)> 0;

-- Those managers who doesn't have teachers asigned.
-- Encargados que no tienen docentes asignados

SELECT e.Encargado_ID, e.nombre, e.apellido, count(s.DocentesID) as Cant_Docentes
FROM encargado e
LEFT JOIN staff s
ON s.Encargado=e.Encargado_ID
GROUP BY e.Encargado_ID, e.nombre, e.apellido
HAVING count(s.DocentesID)= 0;

-- It is required to know all the subjects data that doesn't have a teacher asigned. The model of the query has to come from the staff table
/*Se requiere saber todos los datos de asignaturas que no tienen un docente asignado.El modelo de la consulta debe partir desde la tabla docentes. 
Keywords: Staff, Encargado, Asignaturas, costo, Area.*/
SELECT *
FROM asignaturas;
SELECT *
FROM staff

Select a.*
From staff s right join asignaturas a
	On s.Asignatura=a.AsignaturasID
Where s.Asignatura is null

/*It is required to know the next teacher's information: Full name, concatenate the first and last name. Rename the column as NombresCompletos;
the document; make a calculation to know the number of months since their entry date. Rename as MesesIngreso; the name of their managers. Rename as NombreEncargado;
the numberphone of the manager, rename as TelefonoEncargado; the name of the course or carreer; the working day; and the name of the area. It's only needed to show
those who have more than 3 months. Sort by entry month since the highest to lowest.*/
/*Se quiere conocer la siguiente información de los docentes. El nombre completo concatenar el nombre y el apellido. Renombrar NombresCompletos, 
el documento, hacer un cálculo para conocer los meses de ingreso. Renombrar meses_ingreso, el nombre del encargado. Renombrar NombreEncargado, 
el teléfono del encargado. Renombrar TelefonoEncargado, el nombre del curso o carrera, la jornada y el nombre del área. Solo se desean 
visualizar solo los que llevan más de 3 meses.Ordenar los meses de ingreso de mayor a menor. 
Keywords: Encargo,Area,Staff,jornada, fecha ingreso.*/
SELECT *
FROM Area
SELECT *
FROM Encargado
SELECT *
FROM asignaturas
SELECT *
FROM staff

Select concat(s.nombre,' ',s.apellido) As NombresCompletos, s.documento, datediff(month,s.[Fecha Ingreso],'2022/08/15') AS MesesIngreso,
		e.Nombre AS NombreEncargado, e.telefono As TelefonoEncargado, asi.Nombre as Asignatura, asi.Jornada, ar.Nombre As Área
From ((staff s join Encargado e ON s.Encargado = e.Encargado_ID) left join Asignaturas asi On s.Asignatura = asi.AsignaturasID) left join Area ar ON asi.Area = ar.AreaID
where datediff(month,s.[Fecha Ingreso],'2021/08/15') > 3
group by s.Nombre, s.Apellido, s.Documento, s.[Fecha Ingreso], e.Nombre, e.Telefono, asi.Nombre, asi.Jornada, ar.nombre
order by MesesIngreso desc
