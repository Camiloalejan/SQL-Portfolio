use CoderHouse;

-- Area table.
SELECT *
FROM [dbo].[Area]

-- This table contains the Subjects broken down by schedule, type of course and cost
SELECT *
FROM [dbo].[Asignaturas]

-- Managers table. Contains the managers data.
SELECT *
FROM [dbo].[Encargado]

-- Students table
SELECT *
FROM [dbo].[Estudiantes]

-- Professions Table
SELECT *
FROM [dbo].[Profesiones]

-- Staff table
SELECT *
FROM [dbo].[Staff]

-- Indicate how many courses and careers the Data area has. Rename the new column as cant_asignaturas.
-- Indicar cuántos cursos y carreras tiene el área de Data. Renombrar la nueva columna como cant_asignaturas. Keywords: Tipo, Área, Asignaturas. 

-- We select both tables to show what they have in common
Select *
from [dbo].[Asignaturas]
Select *
from [dbo].[Area]

Select Tipo, count(Area) as 'cant_asignaturas'
from [dbo].[Asignaturas]
where Area = (Select AreaID
			from [dbo].[Area]
			where Nombre = 'Data')
group by Tipo

--It is required to know the name, document and telephone number of students who are professionals in agronomy and who were born between 1970 and 2000.
/* Se requiere saber cual es el nombre, el documento y el teléfono de los estudiantes que son profesionales en agronomía y que nacieron entre el año 1970 y el año 2000. 
Keywords: Estudiantes, Profesión, fecha de Nacimiento.*/
Select *
From [dbo].[Profesiones]
Select *
From [dbo].[Estudiantes]

Select Nombre, Documento, Telefono
From Estudiantes
Where Profesion = (Select ProfesionesID 
	from [dbo].[Profesiones]
	where Profesiones = 'Agronomo Agronoma') AND year([Fecha de Nacimiento]) between 1970 and 2000

/* A list of teachers who entered in 2021 is required and concatenate the fields of name and last name. The result must have a separator: hyphen (-). The new column with the results must be in uppercase*/
/* Se requiere un listado de los docentes que ingresaron en el año 2021 y concatenar los campos nombre y apellido. El resultado debe utilizar un separador: guión (-). 
Ejemplo: Elba-Jimenez. Renombrar la nueva columna como Nombres_Apellidos. Los resultados de la nueva columna deben estar en mayúsculas. 
Keywords: Staff, Fecha Ingreso, Nombre, Apellido. */
Select Nombre, Apellido, [Fecha Ingreso]
From [dbo].[Staff]

Select Nombres_Apellidos = Concat(upper(Nombre), ' - ', upper(Apellido))
from [dbo].[Staff]
where year([Fecha Ingreso]) = 2021

-- Indicate the number of managers in charge of teachers and tutors. Rename the column as CantEncargados. Remove the word "Encargado" in every record. Rename the column as NuevoTipo
/* Indicar la cantidad de encargados de docentes y de tutores. Renombrar la columna como CantEncargados. Quitar la palabra ”Encargado ”en cada uno de los registros. 
Renombrar la columna como NuevoTipo. Keywords: Encargado, tipo, Encargado_ID. */
Select *
From [dbo].[Encargado]

Select trim(replace(Tipo,'Encargado','')) as NuevoTipo, count(Encargado_ID) as CantEncargados
From [dbo].[Encargado]
group by Tipo

-- just for tutors
Select trim(replace(Tipo,'Encargado','')) as NuevoTipo, count(Encargado_ID) as CantEncargados
From [dbo].[Encargado]
where Tipo like '%Tutores%'
group by Tipo

/* Indicate wath is the average price of the carreers and courses per day. Rename the new column as Promedio. Sort the averages from highest to lowest */
/* Indicar cuál es el precio promedio de las carreras y los cursos por jornada. Renombrar la nueva columna como Promedio. Ordenar los promedios de Mayor a menor 
Keywords: Tipo, Jornada, Asignaturas. */
Select *
from [dbo].[Asignaturas]

Select Nombre, Tipo, Jornada, AVG(Costo) as Promedio
from Asignaturas
group by Nombre, Tipo, Jornada
Order by 3, 4 desc


-- It is required to calculate the age of the students in a new column. Rename the new column as Edad. Filter only those over the 18 years old. Sort by lowest to highest.
/* Se requiere calcular la edad de los estudiantes en una nueva columna. Renombrar a la nueva columna Edad. Filtrar solo los que son mayores de 18 años. 
Ordenar de Menor a Mayor Keywords: Fecha de Nacimiento, Estudiantes. */
Select *
From Estudiantes

Select EstudiantesID, Nombre, Apellido, (cast(DateDiff(year,'2022/08/15',[Fecha de Nacimiento]) as int) * -1) as Edad
From Estudiantes
Where DateDiff(year,'2022/08/15',[Fecha de Nacimiento]) < '-18'
Order by Edad asc

-- It is required to know the name, e-mail, litter and date of entry of staff people who contain .edu in their emails and TeacherID is greater or equal to 100
/* Se requiere saber el Nombre,el correo, la camada y la fecha de ingreso de personas del staff que contienen correo .edu y su DocenteID sea mayor o igual que 100.
Keywords: Staff, correo, DocentesID */
Select *
From Staff

Select DocentesID, Nombre, Correo, Camada, [Fecha Ingreso]
From Staff
Where Correo like '%.edu%' and DocentesID >= 100

-- It is reaquired to know the document, address, zip code and the name of the first students who registered on the platform.
/* Se requiere conocer el documento, el domicilio, el código postal y el nombre de los primeros estudiantes que se registraron en la plataforma.
Keywords: Documento, Estudiantes, Fecha Ingreso.*/
Select *
From Estudiantes

Select Documento, Domicilio, [Codigo Postal], Nombre
From Estudiantes
Where [Fecha Ingreso] like '2020-01-01'

-- Indicate the name, last name and document of the teachers and tutor who have subjects "UX"
/* Indicar el nombre apellido y documento de los docentes y tutores que tienen asignaturas “UX”. 
Keywords: Staff, Asignaturas, Nombre, Apellido.*/
Select *
From Staff
Select *
From Asignaturas
-- We also consult the 'Area' table to know which subject belongs to the UX area (Area = 1)
Select *
from Area

Select s.Nombre, s.Apellido, s.Documento
From Staff s Join Asignaturas a
	On s.Asignatura = a.AsignaturasID
Where a.Area = 1
Order by Nombre

/* Se desea calcular el 25% de aumento para las asignaturas del área de marketing de la jornada mañana se deben traer todos los campos, 
más el de los cálculos correspondientes el porcentaje y el Nuevo costo debe estar en decimal con 3 dígitos. 
Renombrar el cálculo del porcentaje con el nombre porcentaje y la suma del costo más el porcentaje por NuevoCosto. 
Keywords: Asignaturas, Costo, Área, Jornada, Nombre */
Select *
From CoderHouse..Asignaturas
Select *
From CoderHouse..Area

Select *, ROUND(Costo*0.25,3) As Porcentaje, ROUND(Costo*0.25,3)+Costo As [Nuevo Costo]
From CoderHouse..Asignaturas
Where Area = 2
