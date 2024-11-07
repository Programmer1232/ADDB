
CREATE TABLE volunteers (
    vol_id CHAR(6) NOT NULL,  -- Assuming 6-character volunteer ID
    fname VARCHAR(50),
    sname VARCHAR(50),
    contact INT,
    address VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE donations (
    donation_id CHAR(5) NOT NULL,  -- Assuming 5-character donation ID
    donor_id INT,
    bike_id CHAR(4),
    value INT,
    volunteer_id CHAR(6),
    donation_date DATE
);

CREATE TABLE bikes (
    bike_id CHAR(4) NOT NULL,  -- Assuming 4-character bike ID
    description VARCHAR(50),
    bike_type VARCHAR(50),
    manufacturer VARCHAR(50)
);

CREATE TABLE donors (
    donor_id CHAR(5) NOT NULL,  
    donor_fname VARCHAR(50),
    donor_lname VARCHAR(50),
    contact_no INT,
    email VARCHAR(100)
);

SELECT 
    donor_id, 
    biketype, 
    bikedescription, 
    CONCAT('R ', FORMAT(BikeValue, 0)) AS BikeValue
FROM 
    bikes
WHERE 
    BikeValue > 1500;
    
    
SELECT DonorID, BikeType, BikeDescription, ValueAmount
FROM Bikes
WHERE ValueAmount > 1500;

DECLARE @VATRate DECIMAL(18,2) = 0.15;

SELECT 
    BikeDescription, 
    BikeManufacturer, 
    BikeType, 
    ValueAmount AS Value,
    ValueAmount * @VATRate AS VAT,
    ValueAmount + (ValueAmount * @VATRate) AS TotalAmount
FROM 
    Bikes
WHERE 
    BikeType = 'Road Bike';
    
    CREATE PROCEDURE spDonorDetails
    @BikeID VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        SELECT 
            d.DonorName, 
            d.ContactNumber, 
            v.FirstName, 
            b.DonationDate
        FROM 
            Bikes b
        INNER JOIN Donors d ON b.DonorID = d.DonorID
        INNER JOIN Volunteers v ON b.VolunteerID = v.VolunteerID
        WHERE 
            b.BikeID = @BikeID;
    END TRY
    BEGIN CATCH
        -- Handle exceptions here, e.g., log errors, send notifications
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;

-- Execute the procedure for Bike ID 'B004'
EXEC spDonorDetails 'B004';

SELECT
    bike.BikeID AS "Bike ID",
    bike.BikeType AS "Bike Type",
    bike.BikeManufacturer AS "Manufacturer",
    CONCAT('R ', FORMAT(bike.ValueAmount, 2)) AS "Bike Value",
    CASE
        WHEN bike.ValueAmount <= 1500 THEN '1-star'
        WHEN bike.ValueAmount > 1500 AND bike.ValueAmount <= 3000 THEN '2-star'
        ELSE '3-star'
    END AS "Status"
FROM
    Bikes bike;
    
    SELECT
    bike.BikeID AS "Bike ID",
    bike.BikeType AS "Bike Type",
    bike.BikeManufacturer AS "Manufacturer",
    CONCAT('R ', FORMAT(bike.ValueAmount, 2)) AS "Bike Value",
    CASE
        WHEN bike.ValueAmount <= 1500 THEN '1-star'
        WHEN bike.ValueAmount > 1500 AND bike.ValueAmount <= 3000 THEN '2-star'
        ELSE '3-star'
    END AS "Star Rating"
FROM
    Bikes bike;
    
    CREATE TRIGGER tr_ValidateBikeValue
ON Donations
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE BikeValue <= 0)
    BEGIN
        RAISERROR('Bike value cannot be less than or equal to zero.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

UPDATE Donations
SET BikeValue = 0
WHERE BikeID = 'B001';