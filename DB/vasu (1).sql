-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 19, 2024 at 04:46 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vasu`
--

-- --------------------------------------------------------

--
-- Table structure for table `login1`
--

CREATE TABLE `login1` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login1`
--

INSERT INTO `login1` (`username`, `password`) VALUES
('vasu', 'vasu'),
('man', 'man'),
('seetha', 'seetha'),
('vasu1', 'vasu1'),
('vasu2', 'vasu2'),
('usav', 'usav'),
('zain', 'zain'),
('user', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `predictions`
--

CREATE TABLE `predictions` (
  `name` varchar(20) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `age` int(3) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `body_part` varchar(15) NOT NULL,
  `class_name` varchar(20) NOT NULL,
  `confidence_score` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `predictions`
--

INSERT INTO `predictions` (`name`, `gender`, `age`, `phone`, `body_part`, `class_name`, `confidence_score`) VALUES
('vasu', 'vasu', 20, '9182110715', 'brain', '', 80),
('vasu', 'vasu', 20, '9182110715', 'brain', '', 80),
('vasu', 'vasu', 20, '9182110715', 'brain', 'with', 80),
('vasu', 'Male', 20, '9182110715', 'Brain', 'Error occurred', 0),
('vasu', 'Male', 20, '9182110715', 'Spine', 'Error occurred', 0),
('kilad', 'Male', 12, '9182110715', 'Brain', 'Error occurred', 0),
('kilad', 'Male', 12, '9182110715', 'Brain', 'Without\n', 0.980895),
('vasu', 'vasu', 20, '9182110715', 'brain', 'with', 80),
('vasu', 'vasu', 20, '9182110715', 'heart', 'with', 80),
('kilad', 'Male', 12, '9182110715', 'Brain', 'Without\n', 0.970472),
('kilad', 'Male', 12, '9182110715', 'Brain', 'Without\n', 0.668986),
('jain', 'Female', 66, '1234567890', 'Thorax', 'Without\n', 0.99021),
('vasu', 'vasu', 20, '9182110715', 'heart', 'with', 80),
('vasu', 'vasu', 20, '9182110715', 'hearttttt', 'with', 80),
('jaam', 'Male', 90, '1234567890', 'Facial Bones', 'Without\n', 0.490199),
('jaam', 'Male', 90, '1234567890', 'Facial Bones', 'With\n', 0.996173),
('krishna', 'Female', 30, '1234567890', 'Brain', 'Without\n', 0.957975),
('krishh', 'Male', 68, '1234567890', 'Spine', 'Without\n', 0.547159);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
