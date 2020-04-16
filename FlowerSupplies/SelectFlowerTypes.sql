USE [FlowerSupplies];
GO

SELECT 
	[f].*
		FROM [dbo].[Flower] [f]
GO

/*-список плантаций;*/
SELECT 
	[p].[Name] 
		FROM 
		[dbo].[Plantation] [p];
GO

/*- данные по плантации: список цветов и их количество. 
   Столбцы в результате: Id плантации, имя, адрес, ИМЯ ВИДА ЦВЕТОВ, количество  */
SELECT 
	[p].*,	
	[f].[Name] AS [Flower Name],
	[pf].[Amount]
		FROM 
		[dbo].[PlantationFlower] [pf],
		[dbo].[Flower] [f],
		[dbo].[Plantation] [p]
			WHERE
			[pf].[idFlower] = [f].[Id]
			and [pf].[idPlantation] = [p].[Id]
				GROUP BY 
					[p].[Id], 
					[p].[Address], 
					[p].[Name],
					[f].[Name],
					[pf].[Amount];
GO
/*данные по видам цветов: для каждого вида количество плантаций, на которых есть цветы данного вида. 
  Столбцы в результате: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations countity");*/

--v1
 SELECT 
	[f].[Id], 
	[f].[Name], 
	COUNT([p].[Id]) as "Plantations countity"
		FROM 
		[dbo].[Flower] [f],
		[dbo].[Plantation] [p],
		[dbo].[PlantationFlower] [pf]
			WHERE
			[pf].[idPlantation] = [p].[Id]
			and [pf].[idFlower] = [f].[Id]
				GROUP BY
				[f].[Id], [f].[Name];
GO
--v2 Вывод данных о цветке даже если его нет на плантации
SELECT
	[dbo].[Flower].[Id], 
	[dbo].[Flower].[Name], 
	COUNT([dbo].[PlantationFlower].[idFlower]) AS [PlantationNumber]
		FROM 
		[dbo].[Flower] 
		LEFT OUTER JOIN [dbo].[PlantationFlower] ON Flower.[Id] = [dbo].[PlantationFlower].idFlower
			GROUP BY 
			Flower.[Id], Flower.[Name];
GO				

/*данные по видам цветов: для каждого вида количество плантаций, 
 на которых есть цветы данного вида в количестве больше 1000.
 Столбцы, как и в предыдущем пункте: Id вида цветов, имя, количество плантаций 
  (должно выводиться имя столбца "Plantations number");*/

  SELECT 
	[f].[Id], 
	[f].[Name], 
	COUNT([pf].[idPlantation]) as "Plantations number"
		FROM 
		[dbo].[Flower] [f],
		[dbo].[Plantation] [p],
		[dbo].[PlantationFlower] [pf]
			WHERE
			[pf].[idPlantation] = [p].[Id]
			and [pf].[idFlower] = [f].[Id]
			and [pf].[Amount] > 1000
				GROUP BY
				[f].[Id], [f].[Name];
GO

/*данные по поставкам: список цветов и их количество (общее по каждому виду), 
  поставки которых назначены из определенной плантации. 
  Столбцы в результате: Id вида цветов, имя, количество. 
  Это будут данные по какой-то одной плантации;*/
   SELECT 
	[f].[Id], 
	[f].[Name],
	SUM([sf].[Amount]) as "Flowers per plantation"
		FROM 
		[dbo].[Flower] [f],
		[dbo].[Plantation] [p],
		[dbo].[Supply] [s],
		[dbo].[SupplyFlower] [sf]
			WHERE
			[f].Id = [sf].[idFlower]
			and [s].[Id] = [sf].[idSupply]	
			and [p].[Id] = [s].[idPlantation]
			and [p].[Id] = 3
				GROUP BY
				[f].[Id], 
				[f].[Name];
GO

/*данные по поставкам: успешно выполненные поставки за последний месяц.
 Столбцы в результате: Id поставки, имя плантации, имя склада, дата выполнения поставки.*/

   SELECT 
	[s].[Id],
	[p].[Name], 
	[w].[Name],	
	[s].[ClosedDate]
		FROM 
		[dbo].[Warehouse] [w],
		[dbo].[Plantation] [p],
		[dbo].[Supply] [s]
			WHERE
			[w].Id = [s].[idWarehousen]
			and [p].[Id] = [s].[idPlantation]
			and MONTH([s].[ClosedDate]) = MONTH(getdate());
GO