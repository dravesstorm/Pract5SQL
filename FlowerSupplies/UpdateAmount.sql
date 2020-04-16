/*изменить количество цветов в поставке*/
UPDATE [dbo].[SupplyFlower] 
	SET 
		[Amount]=15
			WHERE 
				[dbo].[SupplyFlower].idSupply = 1
				and [dbo].[SupplyFlower].idFlower = 1;