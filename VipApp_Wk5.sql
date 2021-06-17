-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema VIP App
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema VIP App
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `VIP App` DEFAULT CHARACTER SET utf8 ;
USE `VIP App` ;

-- -----------------------------------------------------
-- Table `VIP App`.`Territories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`Territories` (
  `TerritoryID` INT NOT NULL AUTO_INCREMENT,
  `Territory` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TerritoryID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`Countries` (
  `CountryID` INT NOT NULL AUTO_INCREMENT,
  `Country` CHAR(2) NOT NULL,
  `TerritoryID` INT NOT NULL,
  PRIMARY KEY (`CountryID`),
  INDEX `TerritoryID_idx` (`TerritoryID` ASC) VISIBLE,
  CONSTRAINT `TerritoryID`
    FOREIGN KEY (`TerritoryID`)
    REFERENCES `VIP App`.`Territories` (`TerritoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`Cities` (
  `CityID` INT NOT NULL AUTO_INCREMENT,
  `City` VARCHAR(50) NOT NULL,
  `State` CHAR(2) NOT NULL,
  `CountryID` INT NOT NULL,
  PRIMARY KEY (`CityID`),
  INDEX `CountryID_idx` (`CountryID` ASC) VISIBLE,
  CONSTRAINT `CountryID`
    FOREIGN KEY (`CountryID`)
    REFERENCES `VIP App`.`Countries` (`CountryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`Customers` (
  `CustomersID` INT NOT NULL AUTO_INCREMENT,
  `CustomersName` VARCHAR(50) NOT NULL,
  `CustomersLastName` VARCHAR(50) NOT NULL,
  `Phone` CHAR(10) NOT NULL,
  `AddressLine1` VARCHAR(150) NOT NULL,
  `AddressLine2` VARCHAR(150) NULL,
  `PostalCode` CHAR(10) NOT NULL,
  `CityID` INT NULL,
  PRIMARY KEY (`CustomersID`),
  INDEX `CityID_idx` (`CityID` ASC) VISIBLE,
  CONSTRAINT `CityID`
    FOREIGN KEY (`CityID`)
    REFERENCES `VIP App`.`Cities` (`CityID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`UserType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`UserType` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `GuestID` INT NOT NULL,
  `SubscriberID` INT NOT NULL,
  `AdminID` INT NOT NULL,
  `CustomerID` INT NULL,
  PRIMARY KEY (`UserID`, `GuestID`, `SubscriberID`, `AdminID`),
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `VIP App`.`Customers` (`CustomersID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`FreeFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`FreeFeatures` (
  `FeatureID` INT NOT NULL AUTO_INCREMENT,
  `SkipX#` INT NULL,
  `RestaurantsMap` BLOB NOT NULL,
  `NearestRestaurant` VARCHAR(50) NOT NULL,
  `WaitList` INT NULL,
  `WaitTime` TIME NULL,
  `MakePayment` DECIMAL(8) NULL,
  `GuestID` INT NULL,
  `SubscriberID` INT NULL,
  PRIMARY KEY (`FeatureID`),
  INDEX `GuestID_idx` (`GuestID` ASC, `FeatureID` ASC) VISIBLE,
  INDEX `SubscriberID_idx` (`FeatureID` ASC, `SubscriberID` ASC) VISIBLE,
  CONSTRAINT `GuestID`
    FOREIGN KEY (`GuestID` , `FeatureID`)
    REFERENCES `VIP App`.`UserType` (`GuestID` , `UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SubscriberID`
    FOREIGN KEY (`FeatureID` , `SubscriberID`)
    REFERENCES `VIP App`.`UserType` (`UserID` , `SubscriberID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`SubscriptionFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`SubscriptionFeatures` (
  `FeatureID` INT NOT NULL AUTO_INCREMENT,
  `SkipToNextAvailable` DECIMAL(5) NULL,
  `ImmediateEntry` DECIMAL(5) NULL,
  `SubscriberID` INT NOT NULL,
  PRIMARY KEY (`FeatureID`),
  INDEX `SubscriberID_idx` (`FeatureID` ASC, `SubscriberID` ASC) VISIBLE,
  CONSTRAINT `SubscriberID`
    FOREIGN KEY (`FeatureID` , `SubscriberID`)
    REFERENCES `VIP App`.`UserType` (`SubscriberID` , `SubscriberID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIP App`.`AdminFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VIP App`.`AdminFeatures` (
  `FeatureID` INT NOT NULL,
  `RecievePayment` DECIMAL(5) NULL,
  `NotifyUser` VARCHAR(50) NULL,
  `TextUser` VARCHAR(50) NULL,
  `AdminID` INT NULL,
  PRIMARY KEY (`FeatureID`),
  INDEX `AdminID_idx` (`FeatureID` ASC, `AdminID` ASC) VISIBLE,
  CONSTRAINT `AdminID`
    FOREIGN KEY (`FeatureID` , `AdminID`)
    REFERENCES `VIP App`.`UserType` (`UserID` , `AdminID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
