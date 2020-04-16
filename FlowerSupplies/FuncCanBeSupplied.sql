USE [FlowerSupplies];
GO
--Создать функцию, 
--которая проверяет, можно ли создать поставку с определенным количеством цветов определенного типа из определённой плантации. 
--Т.е. хватает ли на плантации количества цветов с учетом того, что до того, как поставка закрыта, 
--количество цветов на плантации остается неизменным. 
--После закрытия поставки количество цветов на плантации уменьшается. 

--Входящие параметры: Id вида цветов, Id плантации, количество. 
--Возвращаемое значение в формате true/false.

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

					--Количество цветов на плантации без учёта текущих заказов
					SELECT @PlantationFlowers = SUM([dbo].[PlantationFlower].[Amount])
						FROM [dbo].[PlantationFlower] 
							WHERE 
								[dbo].[PlantationFlower].[idPlantation] = @IdPlantation 
								AND[dbo].[PlantationFlower].[idFlower] = @IdFlower
					--Количество цветов с этой плантации, которые уже заказали
					SELECT @OrderedFlowers +=  SUM([dbo].[SupplyFlower].[Amount])
						FROM [dbo].[SupplyFlower]
							JOIN
								[Supply] ON [Supply].[idPlantation] = @IdPlantation 
							AND [Supply].[Id] = [dbo].[SupplyFlower].[idSupply]							
							AND [dbo].[SupplyFlower].[idFlower] = @IdFlower
							AND [Supply].[Status] !='Delivered'										
					--Eсли нужные цветы заказаны, но ещё не доставлены, их всё равно нельзя заказать ещё раз
					IF (@OrderedFlowers IS NULL) -- проверка чтобы избежать @PlantationFlowers - NULL = NULL
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

--Сейчас на 1 плантации ровно 290 цветов 1 вида. 
--Была поставка 20 цветов 1 вида с 1 плантации, но она уже Delivered
SELECT  [dbo].[CanBeSupplied](1, 1, 290);
GO

--Сейчас на 3 плантации ровно 123 цветов 2 вида. 
--И Sheduled поставка 45 цветов 
SELECT  [dbo].[CanBeSupplied](2, 3, 78);
GO

--DROP FUNCTION IF EXISTS [dbo].[CanBeSupplied];					