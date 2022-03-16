# QBCore-billingsystem
A Billing System for QBCore converted from ESX

This is the OkOkBilling Converted to QBCore.
I'll be converting more resourcess  for you guys
Feel Free to us them and Let me know if there's any issue 

insert this into your database
CREATE TABLE `sadiqBilling` (
  `id` int(50) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `receiver_identifier` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `author_identifier` varchar(255) NOT NULL,
  `author_name` varchar(255) NULL DEFAULT NULL,
  `society` varchar(255) NOT NULL,
  `society_name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `invoice_value` int(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `notes` varchar(255) NULL DEFAULT ' ',
  `sent_date` varchar(255) NOT NULL,
  `limit_pay_date` varchar(255) NULL DEFAULT NULL,
  `fees_amount` int(50) NULL DEFAULT 0,
  `paid_date` varchar(255) NULL DEFAULT NULL
);

you can always appreciate my work via donation :

https://www.buymeacoffee.com/farhansadiq


Dependecies 

okokNotify
QBCore (all needings to run a server for QBCore )
