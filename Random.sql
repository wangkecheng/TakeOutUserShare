-- phpMyAdmin SQL Dump
-- version 4.7.6
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 18, 2018 at 11:12 AM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Random`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `username` char(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `hasSpeech` int(11) NOT NULL,
  `userID` int(10) UNSIGNED NOT NULL,
  `isNextShare` int(3) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`username`, `hasSpeech`, `userID`, `isNextShare`) VALUES
('曹颖异', 1, 46, 0),
('隆蝶', 1, 47, 0),
('魏宁', 0, 48, 0),
('戢勇', 0, 49, 0),
('李辉', 0, 50, 0),
('李文锐', 0, 51, 0),
('唐吉', 0, 52, 0),
('王帅', 0, 53, 0),
('杨梅', 1, 54, 1),
('陈博', 0, 55, 0),
('李力', 0, 56, 0),
('刘英杰', 0, 57, 0),
('谢磊', 0, 58, 0),
('张云飞', 0, 59, 0),
('窦瑞诗', 0, 60, 0),
('唐孝成', 1, 61, 0),
('谢磊', 0, 62, 0),
('徐国庆', 0, 63, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
