CREATE DATABASE [FlowerSupplies]
USE [FlowerSupplies]
GO
CREATE TABLE [Flower]
(
Id int IDENTITY PRIMARY KEY,
[Name] nvarchar(80) NOT NULL
)
GO

CREATE TABLE [Plantation]
(
Id int IDENTITY PRIMARY KEY,
[Name] nvarchar(80) NOT NULL,
[Address] nvarchar(100) NOT NULL
)
GO


CREATE TABLE [PlantationFlower]
(
[idFlower] int FOREIGN KEY REFERENCES [Flower](Id),
[idPlantation] int FOREIGN KEY REFERENCES [Plantation](Id),
[Amount] int NOT NULL
)
GO

CREATE TABLE [Warehouse]
(
[Id] int IDENTITY PRIMARY KEY,
[Name] nvarchar(80) NOT NULL,
[Address] nvarchar(100) NOT NULL
)
GO

CREATE TABLE [WarehouseFlower]
(
[idFlower] int FOREIGN KEY REFERENCES [Flower](Id),
[idWarehousen] int FOREIGN KEY REFERENCES [Warehouse](Id),
[Amount] int NOT NULL
)
GO

CREATE TABLE [Supply]
(
[Id] int IDENTITY PRIMARY KEY,

[idPlantation] int FOREIGN KEY REFERENCES [Plantation](Id),
[idWarehousen] int FOREIGN KEY REFERENCES [Warehouse](Id),

[SheduledDate] DATE NOT NULL,
[ClosedDate] DATE NULL,
[Status] VARCHAR(20) NOT NULL CHECK ([Status] IN
	('Delivered',
	'In Transit', 
	'Sheduled',
	'Canceled'))
)
GO


CREATE TABLE [SupplyFlower]
(
[idFlower] int FOREIGN KEY REFERENCES [Flower](Id),
[idSupply] int FOREIGN KEY REFERENCES [Supply](Id),
[Amount] int NOT NULL
)
GO