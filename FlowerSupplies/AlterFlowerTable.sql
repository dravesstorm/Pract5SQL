USE [FlowerSupplies]
GO

ALTER TABLE [dbo].[Flower]
	ADD 
	[LatinName]   nvarchar(80) NOT NULL DEFAULT 'nomen Latine';