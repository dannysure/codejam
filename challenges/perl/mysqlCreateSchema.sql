CREATE TABLE `nasdaq_prices` (
`ticker` varchar(5),
`date` int(8),
`open` decimal(7,2),
`high` decimal(7,2),
`low` decimal(7,2),
`close` decimal(7,2),
`vol` int(8)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;