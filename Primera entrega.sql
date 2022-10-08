/*Creación de tabla Envigado */ 
DROP TABLE IF EXISTS Envigado;
CREATE TABLE Envigado(
    RADICADO int not null check(RADICADO > 2000000),
    FECHA varchar(150),
    HORA varchar(150),
    D__A_DE_LA_SEMANA varchar(150),
    CLASE_DE_VEHICULO varchar(150),
    TIPO_DE_SERVICIO varchar(150),
    TIPO_DE_VICTIMA varchar(150),
    SEXO varchar(100),
    ESTAD0_DE_BEODEZ varchar (150) DEFAULT No ,
    RESULTADO_DE_BEODEZ varchar(150) DEFAULT Sin Registro,
    GRAVEDAD varchar(150),
    CLASE_DE_ACCIDENTE varchar(150),
    CAUSA varchar(150) DEFAULT Otra,
    DIRECCI_N varchar(200),
    BARRIO varchar(150) DEFAULT Sin Registro,
    AREA varchar(150),
    Coordenadas varchar(150) DEFAULT (en blanco) );


/*Creación de tabla Medellin */ 
DROP TABLE IF EXISTS Medellin;
CREATE TABLE Medellin(
    A__O int not null check(A__O = 2020),
    CBML int DEFAULT null,
    CLASE_ACCIDENTE varchar(150) DEFAULT otro,
    DIRECCION varchar(150),
    DIRECCION_ENCASILLADA varchar(150) DEFAULT null,
    DISE__O varchar(150),
    EXPEDIENTE varchar(150) not null unique,
    FECHA_ACCIDENTE varchar(150),
    GRAVEDAD_ACCIDENTE varchar (150),
    MES int not null check( MES<12),
    NRO_RADICADO int not null unique, 
    NUMCOMUNA int ,
    BARRIO varchar(150) DEFAULT null,
    COMUNA varchar(150) DEFAULT null,
    LOCATION varchar(150),
    X varchar(150),
    Y varchar(150));



/*Creación de tabla Palmira */ 
DROP TABLE IF EXISTS Palmira;
CREATE TABLE Palmira(
    GRAVEDAD varchar(150),
    FECHA varchar(150),
    A__O int not null check(A__O = 2020) ,
    HORA varchar(150),
    JORNADA varchar(150),
    DIA_SEMANA varchar(150),
    BARRIOS_COREGIMIENTO_VIA varchar(150),
    DIRECCION varchar(100),
    ZONA varchar (150) ,
    AUTORIDAD varchar(150),
    LAT float not null,
    LONG varchar(150),
    HIPOTESIS varchar(200),
    CONDICION_DE_LA_VICTIMA varchar(150) DEFAULT No Aplica,
    CLASE_DE_SINIESTRO varchar(150),
    LESIONADO varchar(150) DEFAULT No Aplica,
    HOMICIDIOS varchar(150) DEFAULT No aplica,
    CLINICA varchar(150) DEFAULT No Aplica,
    SITIO varchar(150) DEFAULT No Aplica ,
    CLASE_VEHICULO varchar(150),
    MARCA varchar(150),
    MATRICULA varchar(150),
    TIPO_DE_SERVICIO varchar(150),
    EMPRESA varchar(150) DEFAULT No Aplica );

/*1.¿Cantidad de accidentes según el diseño de la via o lugar del siniestro? */

SELECT DISE__O, COUNT(DISE__O) AS CANTIDAD_VIA FROM `primera-entrega-proyecto.Accidentalidad.Medellin`
GROUP BY DISE__O
ORDER BY CANTIDAD_VIA DESC;

/*2.¿Cuantos accidentes se realizaron el dia lunes en la ciudad de Envigado?*/
SELECT COUNT(D__A_DE_LA_SEMANA) AS accidente_pordia, D__A_DE_LA_SEMANA FROM `primera-entrega-proyecto.Accidentalidad.Envigado`
GROUP BY D__A_DE_LA_SEMANA 
HAVING (D__A_DE_LA_SEMANA="Lunes");

/*3.¿Cantidad de accidentes en la ciudad de Palmira segun el tipo de Servicio*/
SELECT COUNT(TIPO_DE_SERVICIO) AS accidentes_tiposervicio , TIPO_DE_SERVICIO FROM `primera-entrega-proyecto.Accidentalidad.Palmira` 
GROUP BY TIPO_DE_SERVICIO;


/*4.¿Cuantos accidentes resultaron con heridos en la ciudad de Medellin?*/

SELECT COUNT (GRAVEDAD_ACCIDENTE) AS cantidad_heridos, GRAVEDAD_ACCIDENTE FROM `primera-entrega-proyecto.Accidentalidad.Medellin`
GROUP BY GRAVEDAD_ACCIDENTE 
HAVING (GRAVEDAD_ACCIDENTE="Con heridos");


/*5.¿Cuantas hombres y mujeres tuvieron un accidente por cada tipo de vehiculo en la ciudad de envigado? */
SELECT COUNT(SEXO) AS sexo_vehiculo, CLASE_DE_VEHICULO,SEXO FROM `primera-entrega-proyecto.Accidentalidad.Envigado` 
GROUP BY CLASE_DE_VEHICULO,SEXO;


/*6.¿Cantidad de accidentes segun el tipo despues de la mitad del año en la ciudad de Medellin*/
SELECT COUNT(MES) as cantidad_accidentes, CLASE_ACCIDENTE, MES FROM `primera-entrega-proyecto.Accidentalidad.Medellin`
GROUP BY MES,CLASE_ACCIDENTE
HAVING MES>6;

/*7.¿Cantidad de accidentes donde la Clase de accidente sea choque y que la gravedad sea con heridos en la ciudad de Medellin  */
SELECT CLASE_ACCIDENTE, COUNT (GRAVEDAD_ACCIDENTE) AS cantidad_conheridos FROM `primera-entrega-proyecto.Accidentalidad.Medellin`
GROUP BY CLASE_ACCIDENTE,GRAVEDAD_ACCIDENTE
HAVING (CLASE_ACCIDENTE="Choque" AND GRAVEDAD_ACCIDENTE= "Con heridos");

/*8.¿Cuando ocurrio el primer accidente en la ciudad de Medellin?*/
SELECT min(NRO_RADICADO) AS total FROM `primera-entrega-proyecto.Accidentalidad.Medellin`;
SELECT * FROM `primera-entrega-proyecto.Accidentalidad.Medellin` WHERE NRO_RADICADO=1702127;

/*9.¿Cuantos siniestros hubo en envigado y palmira en cada dia de la semana?*/
WITH ENVIGADO AS (
SELECT UPPER(REPLACE(REPLACE(D__A_DE_LA_SEMANA,"Miércoles","Miercoles"),"Sábado","Sabado")) AS D__A_DE_LA_SEMANA, COUNT(*) AS SINIESTROS_ENV
FROM `primera-entrega-proyecto.Accidentalidad.Envigado` 
GROUP BY D__A_DE_LA_SEMANA),

PALMIRA AS (
SELECT DIA_SEMANA, COUNT(*) AS SINIESTROS_PAL
FROM `primera-entrega-proyecto.Accidentalidad.Palmira` 
GROUP BY DIA_SEMANA)

SELECT DIA_SEMANA, ENVIGADO.SINIESTROS_ENV, PALMIRA.SINIESTROS_PAL FROM PALMIRA
LEFT JOIN ENVIGADO ON DIA_SEMANA = D__A_DE_LA_SEMANA
ORDER BY PALMIRA.SINIESTROS_PAL DESC;

/*10.Cantidad de vehiculos segun su clase que se encuentran involucrados en accidentes de transito en palmira y envigado*/
WITH VEHICULO_ENVIGADO AS (
SELECT LOWER(REPLACE(CLASE_DE_VEHICULO,"Motocicleta", "moto")) AS CLASE_DE_VEHICULO, COUNT(*) AS CLASE_VEHICULO_ENV
FROM `primera-entrega-proyecto.Accidentalidad.Envigado` 
GROUP BY CLASE_DE_VEHICULO),

VEHICULO_PALMIRA AS (
SELECT LOWER(CLASE_VEHICULO) AS CLASE_VEHICULO, COUNT(*) AS CLASE_VEHICULO_PAL
FROM `primera-entrega-proyecto.Accidentalidad.Palmira` 
GROUP BY CLASE_VEHICULO)

SELECT CLASE_VEHICULO,VEHICULO_PALMIRA.CLASE_VEHICULO_PAL, VEHICULO_ENVIGADO.CLASE_VEHICULO_ENV FROM VEHICULO_PALMIRA
LEFT JOIN VEHICULO_ENVIGADO ON CLASE_VEHICULO = CLASE_DE_VEHICULO;

/*11.¿Cantidad de accidentes en envigado y medellin segun la clase? */
WITH CLASEE AS (
SELECT LOWER(CLASE_DE_ACCIDENTE) AS CLASE_DE_ACCIDENTE, COUNT(*) AS CLASE_ACCIDENTE_ENV
FROM `primera-entrega-proyecto.Accidentalidad.Envigado` 
GROUP BY CLASE_DE_ACCIDENTE),

CLASEM AS (
SELECT LOWER(CLASE_ACCIDENTE) AS CLASE_ACCIDENTE, COUNT(*) AS CLASE_ACCIDENTE_MED
FROM `primera-entrega-proyecto.Accidentalidad.Medellin` 
GROUP BY CLASE_ACCIDENTE)

SELECT CLASE_DE_ACCIDENTE, CLASEE.CLASE_ACCIDENTE_ENV, CLASEM.CLASE_ACCIDENTE_MED FROM CLASEE
LEFT JOIN CLASEM ON CLASE_DE_ACCIDENTE = CLASE_ACCIDENTE;

/*12.Cantidad de mujeres que sufrieron un accidente en el municipio de envigado segun su clase de vehiculo (carro o moto) */
SELECT TIPO_DE_VICTIMA, SEXO, COUNT(SEXO) AS CANTIDAD_SEXO FROM `primera-entrega-proyecto.Accidentalidad.Envigado`  
GROUP BY TIPO_DE_VICTIMA, SEXO
HAVING (SEXO= "Femenino")
ORDER BY CANTIDAD_SEXO DESC;

/*13.¿Cantidad de accidentes que hay en la ciudad de Medellin y Palmira dependiendo de su gravedad*/
WITH MEDELLIN AS(
SELECT  UPPER(REPLACE(REPLACE(TRIM(TRIM(GRAVEDAD_ACCIDENTE, "Con"),"Solo"), "Datos","Daños"),"muertos", "muerto"))AS GRAVEDAD_ACCIDENTE, COUNT(*) ACCIDENTE_MEDELLIN
FROM `primera-entrega-proyecto.Accidentalidad.Medellin` 
GROUP BY GRAVEDAD_ACCIDENTE),
 
PALMIRA AS(
SELECT GRAVEDAD, COUNT(*) AS ACCIDENTE_PALMIRA
FROM `primera-entrega-proyecto.Accidentalidad.Palmira` 
GROUP BY GRAVEDAD)
 
SELECT TRIM(GRAVEDAD_ACCIDENTE) AS GRAVEDAD, MEDELLIN.ACCIDENTE_MEDELLIN, PALMIRA.ACCIDENTE_PALMIRA FROM MEDELLIN 
INNER JOIN PALMIRA ON TRIM(GRAVEDAD_ACCIDENTE) = TRIM(GRAVEDAD);

/* 14.¿Cantidad de accidentes por mes en la ciudad de Envigado y Medellin?*/
WITH ENVIGADO AS (
SELECT CAST(EXTRACT(MONTH FROM DATE(FECHA)) AS INT64) AS MES_ACCIDENTE, COUNT(*) AS MES_ENVIGADO
FROM `primera-entrega-proyecto.Accidentalidad.Envigado` T1
GROUP BY MES_ACCIDENTE),
 
MEDELLIN AS(
SELECT MES AS MES, COUNT(*) AS MES_MEDELLIN
FROM `primera-entrega-proyecto.Accidentalidad.Medellin` 
GROUP BY MES)
 
SELECT MES,MEDELLIN.MES_MEDELLIN, ENVIGADO.MES_ENVIGADO FROM MEDELLIN 
INNER JOIN ENVIGADO ON MES = MES_ACCIDENTE
ORDER BY MES;

/*15.¿CANTIDAD DE ACCIDENTES POR AREA EN ENVIGADO Y PALMIRA?*/
WITH ENVIGADO AS (
SELECT UPPER(AREA) AS AREA, COUNT(*) AS CANTIDAD_ENVIGADO
FROM `primera-entrega-proyecto.Accidentalidad.Envigado` 
GROUP BY AREA),
 
PALMIRA AS(
SELECT ZONA AS ZONA, COUNT(*) AS CANTIDAD_PALMIRA
FROM `primera-entrega-proyecto.Accidentalidad.Palmira` T2
GROUP BY ZONA)
 
SELECT ZONA, ENVIGADO.CANTIDAD_ENVIGADO, PALMIRA.CANTIDAD_PALMIRA FROM PALMIRA
LEFT JOIN ENVIGADO ON AREA=ZONA;
 