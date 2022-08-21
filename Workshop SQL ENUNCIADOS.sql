use CoderHouse

/*1.Análisis de docentes por camada: 
Número de documento, nombre del docente y camada para identificar la camada mayor y 
la menor según el número de la  camada. 
Número de documento, nombre del docente y camada para identificar la camada con 
fecha de ingreso Mayo 2021. 
Agregar un campo indicador que informe cuales son los registros ”mayor o menor” 
y los que son “Mayo 2021” y ordenar el listado de menor a mayor por camada.

Nota: para el ejercicio 1, los dos análisis deben encontrarse en el mismo reporte. 
Identificar si es necesario unificar o reunir la consulta SQL.*/

Select i.Documento, i.Nombre, i.Camada, 'Mayor' as 'Tipo'
From Staff i left join Encargado e on i.Encargado = e.Encargado_ID
where i.Camada = (select MAX (camada) from Staff) and e.Tipo like '%docente%'

union

Select i.Documento, i.Nombre, i.Camada, 'Menor' as 'Tipo'
From Staff i left join Encargado e on i.Encargado = e.Encargado_ID
where i.Camada = (select min (camada) from Staff) and e.Tipo like '%docente%'

UNION 

Select i.Documento, i.Nombre, i.Camada, 'Mayo 21' as 'Tipo'
From Staff i left join Encargado e on i.Encargado = e.Encargado_ID
where (month([Fecha Ingreso])=05 AND year([Fecha Ingreso])=2021) and e.Tipo like '%docente%'

order by Camada asc

/*2.Análisis diario de estudiantes: 
Por medio de la fecha de ingreso de los estudiantes identificar: cantidad total de estudiantes.
Mostrar los periodos de tiempo separados por año, mes y día, y presentar la información ordenada 
por la fecha que más ingresaron estudiantes.*/
--hay que usar una tabla
Select year([fecha ingreso]) as Anio, month([fecha ingreso]) as Mes, day([fecha ingreso]) as Día, count(EstudiantesID) as TotalDeEstudiantes
From Estudiantes
Group by [Fecha Ingreso]
Order by TotalDeEstudiantes desc

/*3.Análisis de encargados con más docentes a cargo: 
Identificar el top 10 de los encargados que tiene más docentes a cargo, 
filtrar solo los que tienen a cargo docentes. 
Ordenar de mayor a menor para poder tener el listado correctamente.*/
Select TOP (10) e.Encargado_ID, e.Nombre, e.Apellido, count(s.DocentesID) as TotalDocentes
From Encargado e Join Staff s
	On e.Encargado_ID = s.Encargado
Where e.Tipo like '%Docentes%'
Group by e.Encargado_ID, e.Nombre, e.Apellido
Order by TotalDocentes desc

/*4.Análisis de profesiones con más estudiantes: 
Identificar la profesión y la cantidad de estudiantes que ejercen, 
mostrar el listado solo de las profesiones que tienen más de 5 estudiantes.
Ordenar de mayor a menor por la profesión que tenga más estudiantes.*/
Select Count(e.EstudiantesID) As TotalEstudiantes, p.Profesiones
From Estudiantes e Right Join Profesiones p
	On e.Profesion = P.ProfesionesID
Group by p.Profesiones
Having Count(e.EstudiantesID) > 5
Order by TotalEstudiantes desc

/*5.Análisis de estudiantes por área de educación: 
Identificar: nombre del área, si la asignatura es carrera o curso, 
a qué jornada pertenece, 
cantidad de estudiantes y monto total del costo de la asignatura. 
Ordenar el informe de mayor a menor por monto de costos total 
tener en cuenta los docentes 
que no tienen asignaturas ni estudiantes asignados, 
también sumarlos.*/
Select a.Nombre as Área, asi.Tipo, asi.Jornada, s.DocentesID, count(es.EstudiantesID) as CantidadEstudiantes, Sum(asi.Costo) as CostoTotalAsignatura
From Area a Join Asignaturas asi On a.AreaID = asi.Area
	 left join Staff s On asi.AsignaturasID = s.Asignatura
	 left Join Estudiantes es On s.DocentesID = es.Docente
Group by a.Nombre, asi.Tipo, asi.Jornada, s.DocentesID
Order by CostoTotalAsignatura Desc
