USE [FlowerSupplies];
GO
--������� �������, 
--������� ���������, ����� �� ������� �������� � ������������ ����������� ������ ������������� ���� �� ����������� ���������. 
--�.�. ������� �� �� ��������� ���������� ������ � ������ ����, ��� �� ����, ��� �������� �������, 
--���������� ������ �� ��������� �������� ����������. 
--����� �������� �������� ���������� ������ �� ��������� �����������. 

--�������� ���������: Id ���� ������, Id ���������, ����������. 
--������������ �������� � ������� true/false.

CREATE FUNCTION [dbo].[CanBeSupplied] (
	@IdFlower INT, 
	@IdPlantation INT, 
	@Amount INT)
		RETURNS BIT
			AS
			BEGIN
				 DECLARE @PlantationFlowers INT
				 DECLARE @OrderedFlowers INT = 0
				 DECLARE @AvailibleAmount INT = 0 
				 DECLARE @Result BIT = 0
				 DECLARE @ErrorMsg VARCHAR(30)

					--���������� ������ �� ��������� ��� ����� ������� �������
					SELECT @PlantationFlowers = SUM([dbo].[PlantationFlower].[Amount])
						FROM [dbo].[PlantationFlower] 
							WHERE 
								[dbo].[PlantationFlower].[idPlantation] = @IdPlantation 
								AND[dbo].[PlantationFlower].[idFlower] = @IdFlower
					--���������� ������ � ���� ���������, ������� ��� ��������
					SELECT @OrderedFlowers +=  SUM([dbo].[SupplyFlower].[Amount])
						FROM [dbo].[SupplyFlower]
							JOIN
								[Supply] ON [Supply].[idPlantation] = @IdPlantation 
							AND [Supply].[Id] = [dbo].[SupplyFlower].[idSupply]							
							AND [dbo].[SupplyFlower].[idFlower] = @IdFlower
							AND [Supply].[Status] !='Delivered'										
					--E��� ������ ����� ��������, �� ��� �� ����������, �� �� ����� ������ �������� ��� ���
					IF (@OrderedFlowers IS NULL) -- �������� ����� �������� @PlantationFlowers - NULL = NULL
						SELECT @AvailibleAmount = @PlantationFlowers
					ELSE						
						SELECT @AvailibleAmount = @PlantationFlowers - @OrderedFlowers
					
					IF (@Amount <= @AvailibleAmount )
	 						SELECT @Result = 1
					ELSE 
						SET @ErrorMsg=CONCAT(
						'Can`t add supply with ',
						(SELECT @Amount),
						' Flower - ', 
						(SELECT [Name] FROM [dbo].[Flower] WHERE [Flower].[Id] = @IdFlower),
						' from Plantation - ',
						(SELECT [Name] FROM [dbo].[Plantation] WHERE [Plantation].[Id] = @IdPlantation)
						);				
						
			RETURN @Result
END;
GO

--������ �� 1 ��������� ����� 290 ������ 1 ����. 
--���� �������� 20 ������ 1 ���� � 1 ���������, �� ��� ��� Delivered
SELECT  [dbo].[CanBeSupplied](1, 1, 290);
GO

--������ �� 3 ��������� ����� 123 ������ 2 ����. 
--� Sheduled �������� 45 ������ 
SELECT  [dbo].[CanBeSupplied](2, 3, 78);
GO

--DROP FUNCTION IF EXISTS [dbo].[CanBeSupplied];					