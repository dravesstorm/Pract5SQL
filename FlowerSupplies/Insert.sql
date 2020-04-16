USE [FlowerSupplies]
GO
INSERT INTO [dbo].[Flower](
	[Name])
		VALUES
			('Анемон'),
			('Астра'),
			('Гортензия'),
			('Гиацинт'),
			('Ирис'),
			('Лилия'),
			('Нарцисс'),
			('Рододендрон'),
			('Роза'),
			('Ромашка'),
			('Тюльпан'),
			('Фрезия'),
			('Хризантема');
go

INSERT INTO [dbo].[Plantation](
	[Name],
	[Address])
		VALUES
			('Blind Ambition Companies', '3121 Cross Timbers Rd #104, Flower Mound, TX 75028'),
			('Plantation Florist-Floral Promotions', '405 S State Rd 7, Plantation, FL 33317'),
			('Tiger Lily Florist', '131 Spring St suite b, Charleston, SC 29403'),
			('Enchanted Florist TN', '2115 Yeaman Pl, Nashville, TN 37206'),
			('Designs by Ming: Florist & Flower', '230 E Ontario St #2401, Chicago, IL 60611'),
			('LIHMIL Wholesale Flowers', '1501 Old Greensboro Rd, Kernersville, NC 27284');
go

INSERT INTO [dbo].[Warehouse](
	[Name],
	[Address])
		VALUES
			('Cut Flower Wholesale Inc', '2122 Faulkner Rd NE, Atlanta, GA 30324'),
			('Wholesale Flowers and Supplies', '5305 Metro St, San Diego, CA 92110'),
			('Potomac Floral Wholesale, Inc.', '2403 Linden Ln, Silver Spring, MD 20910'),
			('Wholesale Flower Market Inc', '1211 Executive Blvd, Chesapeake, VA 23320'),
			('DWF Denver Wholesale Florist', '4800 Dahlia St, Denver, CO 80216'),
			('Las Vegas Floral Wholesale Inc', '2404 Western Ave # B, Las Vegas, NV 89102');
go

INSERT INTO [dbo].[PlantationFlower](
	[idFlower],
	[idPlantation],
	[Amount])
		VALUES 
			(1,1,290),
			(2,3,123),
			(3,2,400),
			(4,4,129),
			(5,5,812),
			(6,1,2192),
			(7,6,381),
			(8,3,2219),
			(9,2,123),
			(10,4,129),		
			(11,6,2129),		
			(11,3,1129),
			(13,5,92)
go

INSERT INTO [dbo].[WarehouseFlower](
	[idFlower],
	[idWarehousen],
	[Amount])
		VALUES 
			(1,1,63),
			(2,3,71),
			(3,2,213),
			(4,4,21),
			(5,5,83),
			(6,1,91),
			(7,6,123),
			(8,3,45),
			(9,2,92),
			(10,4,98),		
			(11,6,100),		
			(12,3,202),
			(13,5,182);
go

INSERT INTO [dbo].[Supply] (
	[idPlantation], 
	[idWarehousen], 
	[SheduledDate], 
	[ClosedDate],
	[Status]
	)
		VALUES
			(1,3,'2020-04-05','2020-04-07' ,'Delivered'),
			(2,2,'2020-04-05', '2020-04-06' ,'Delivered'),
			(4,5,'2020-04-15', NULL ,'In Transit'),
			(3,4,'2020-05-20', NULL ,'Sheduled'),
			(3,5,'2020-05-10', NULL ,'Sheduled'),
			(3,1,'2020-05-09', NULL ,'Sheduled'),
			(3,2,'2020-05-08', NULL ,'Sheduled');
go

INSERT INTO [dbo].[SupplyFlower] (
	[idFlower],
	[idSupply],
	[Amount]
	)
		VALUES
			(1,1,20),
			(7,2,15),
			(4,3,30),
			(9,5,40),
			(4,7,80),
			(5,6,90),
			(6,4,20),
			(8,2,25),
			(2,5,15),
			(2,6,20),
			(2,4,10)
go

/*добавить один вид цветов*/
INSERT INTO [dbo].[Flower]( 
	[Name])
		VALUES 
		('Диффенбахия');

/*добавить несколько плантаций*/
INSERT INTO [dbo].[Plantation]( 
	 [Name],
	 [Address]
	 )
		VALUES 
		('Sunflower Farms Garden Center', '1065 S Olive St, Cherryvale, KS 67335'),
		('Blind Ambition Companies', '3121 Cross Timbers Rd #104, Flower Mound, TX 75028');