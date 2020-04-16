USE [FlowerSupplies];
GO

SELECT 
	[f].*
		FROM [dbo].[Flower] [f]
GO

/*-������ ���������;*/
SELECT 
	[p].[Name] 
		FROM 
		[dbo].[Plantation] [p];
GO

/*- ������ �� ���������: ������ ������ � �� ����������. 
   ������� � ����������: Id ���������, ���, �����, ��� ���� ������, ����������  */
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
/*������ �� ����� ������: ��� ������� ���� ���������� ���������, �� ������� ���� ����� ������� ����. 
  ������� � ����������: Id ���� ������, ���, ���������� ��������� 
  (������ ���������� ��� ������� "Plantations countity");*/

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
--v2 ����� ������ � ������ ���� ���� ��� ��� �� ���������
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

/*������ �� ����� ������: ��� ������� ���� ���������� ���������, 
 �� ������� ���� ����� ������� ���� � ���������� ������ 1000.
 �������, ��� � � ���������� ������: Id ���� ������, ���, ���������� ��������� 
  (������ ���������� ��� ������� "Plantations number");*/

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

/*������ �� ���������: ������ ������ � �� ���������� (����� �� ������� ����), 
  �������� ������� ��������� �� ������������ ���������. 
  ������� � ����������: Id ���� ������, ���, ����������. 
  ��� ����� ������ �� �����-�� ����� ���������;*/
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

/*������ �� ���������: ������� ����������� �������� �� ��������� �����.
 ������� � ����������: Id ��������, ��� ���������, ��� ������, ���� ���������� ��������.*/

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