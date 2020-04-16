USE [FlowerSupplies];

DROP PROCEDURE IF EXISTS [dbo].[DeliveredSupply_TRAN];

GO
CREATE PROCEDURE [dbo].[DeliveredSupply_TRAN](
	@IdSupply INT,
	@IdFlower INT,
	@IdPlantation INT,
	@IdWarehouse INT,
	@Amount INT
	)
		AS
		BEGIN	
			DECLARE @ErrorMsg VARCHAR(80)

			IF NOT EXISTS 
				(SELECT 
				[f].[Id]
					FROM
					[dbo].[Flower] [f]
						WHERE
						[f].[Id]=@IdFlower)
				BEGIN
					SET @ErrorMsg=CONCAT(
						'Can`t find flower with #',
						(SELECT @IdFlower)); 
				END	
			
			ELSE

			BEGIN
			IF NOT EXISTS 
			(SELECT 
			[p].[Id]
				FROM
				[dbo].[Plantation] [p]
					WHERE
					[p].[Id]=@IdPlantation)
				BEGIN
					SET @ErrorMsg = CONCAT(
						'Can`t find Plantation with #',
						(SELECT @IdPlantation)); 
				END

			ELSE

			BEGIN
			IF NOT EXISTS 
				(SELECT 
				[s].[Id]
					FROM
					[dbo].[Supply] [s]
						WHERE
						[s].[Id] = @IdSupply)
				BEGIN
					SET @ErrorMsg = CONCAT(
						'Can`t find supply with #',
						(SELECT @IdSupply));
				END

		ELSE

			BEGIN
			IF NOT EXISTS 
				(SELECT 
				[s].[ClosedDate]
					FROM
					[dbo].[Supply] [s]
						WHERE
						[s].[Id] = @IdSupply
						AND [s].ClosedDate IS NULL)
		BEGIN
		SET @ErrorMsg='Supply has had already closed';
		END
		
		ELSE

			BEGIN
			IF  
			 (@Amount <= 0)
		BEGIN
		SET @ErrorMsg='Amount should be >0';
		END

		ELSE	

				BEGIN
					BEGIN TRANSACTION [FlowerAmountUpd]
				BEGIN TRY 
				UPDATE [dbo].[Supply]
				SET
				[ClosedDate]=(SELECT GETDATE()),
				[Status] = 'Delivered'
					WHERE 
						[Id] = @IdSupply
					and [idWarehousen] = @IdWarehouse 
					and [idPlantation] = @IdPlantation;

			IF EXISTS(
				SELECT *
					FROM [dbo].[SupplyFlower] [sf]
						WHERE 
							[sf].[idFlower] = @IdFlower
						and [sf].[idSupply] = @IdSupply)
			BEGIN
				UPDATE [dbo].[SupplyFlower]
					SET
					[Amount] = @Amount
						WHERE 
							[idSupply] = @IdSupply
						and [idFlower] = @IdFlower;
			END
			ELSE 
				BEGIN
				INSERT INTO [dbo].[SupplyFlower]( 
					[idSupply], 
					[idFlower], 
					[Amount]
					)
						VALUES (
						@IdSupply, @IdFlower, @Amount
					);
				END

			IF EXISTS(
				SELECT *
					FROM [dbo].[PlantationFlower] [pf]
						WHERE 
							[pf].[idFlower] = @IdFlower
						and [pf].[idPlantation] = @IdPlantation)
			BEGIN
			UPDATE [dbo].[PlantationFlower]
				SET
				[Amount] = [Amount]-@Amount
					WHERE 
						[idPlantation] = @IdPlantation
					and [idFlower] = @IdFlower;
			END
			ELSE 
				BEGIN
					INSERT INTO [dbo].[PlantationFlower](
						[idPlantation],
						[idFlower],
						[Amount])
					VALUES(
					@IdPlantation, @IdFlower, @Amount
					);
			END

			IF EXISTS(
				SELECT *
					FROM [dbo].[WarehouseFlower] [wf]
						WHERE 
							[wf].[idFlower]=@IdFlower
						and [wf].[idWarehousen] = @IdWarehouse)
			BEGIN
			UPDATE [dbo].[WarehouseFlower]
				SET
				[Amount]=[Amount]+@Amount
					WHERE 
						[idWarehousen] = @IdWarehouse 
					and [idFlower] = @IdFlower;
			END
			ELSE 
				BEGIN
					INSERT INTO [dbo].[WarehouseFlower](
						[idWarehousen],
						[idFlower],
						[Amount])
					VALUES(
					@IdWarehouse, @IdFlower, @Amount
					);
				END
				
				COMMIT TRANSACTION [FlowerAmountUpd]
				SET @ErrorMsg='The flower amount has changed';
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [FlowerAmountUpd]
					END CATCH
					END
				END	
			
		END
	END
END
		SELECT @ErrorMsg;		
	END;
GO

/*Test*/

/*Can`t find supply with #95*/

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 95,
		@IdFlower = 4,
		@IdPlantation = 3,
		@IdWarehouse = 2,
		@Amount = 80
GO

/*case 1: add supply date and status also change flower amount*/

/*case 2: Supply has had already closed*/

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 7,
		@IdFlower = 4,
		@IdPlantation = 3,
		@IdWarehouse = 2,
		@Amount = 80
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 1,
		@IdFlower = 1,
		@IdPlantation = 1,
		@IdWarehouse = 3,
		@Amount = 20
GO

DECLARE	@return_value int
EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 3,
		@IdFlower = 4,
		@IdPlantation = 4,
		@IdWarehouse = 5,
		@Amount = 30
GO

/*Can`t add supply with 4560 Flower - Mimosa from Plantation - Kusa*/

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 7,
		@IdFlower = 4,
		@IdPlantation = 3,
		@IdWarehouse = 2,
		@Amount = 4560
GO

/*Can`t find flower with #323*/

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 7,
		@IdFlower = 323,
		@IdPlantation = 3,
		@IdWarehouse = 2,
		@Amount = 80
GO

/*Can`t find Plantation with #9999*/

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DeliveredSupply_TRAN]
		@IdSupply = 7,
		@IdFlower = 4,
		@IdPlantation = 9999,
		@IdWarehouse = 2,
		@Amount = 80
GO