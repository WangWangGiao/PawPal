-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 10, 2026 at 11:08 PM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `youcapfu_pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `motivation` text NOT NULL,
  `previous_exp` text NOT NULL,
  `status` varchar(15) NOT NULL,
  `owned_id` int(11) NOT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `pet_id`, `user_id`, `motivation`, `previous_exp`, `status`, `owned_id`, `request_date`) VALUES
(5, 3, 4, 'Mochi is so cute and I aim to adopt a cat at my new house!!', '5 Year Experience pet the dog', 'Pending', 2, '2026-01-10 22:34:47');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `donation_type` varchar(10) NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `description` text NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(1, 2, 4, 'Money', 30.00, 'N/A', '2026-01-10 13:59:52'),
(2, 2, 4, 'Money', 10.00, 'N/A', '2026-01-10 14:03:57'),
(3, 2, 4, 'Food', 0.00, '2Kg Pet Food', '2026-01-10 14:05:13'),
(4, 2, 4, 'Money', 50.00, 'N/A', '2026-01-10 22:04:55'),
(5, 2, 4, 'Money', 15.00, 'N/A', '2026-01-10 22:38:42');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL COMMENT '\r\n',
  `user_id` int(11) NOT NULL COMMENT '\r\n',
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `pet_age` int(5) NOT NULL,
  `pet_gender` varchar(10) NOT NULL,
  `pet_health` text NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `pet_age`, `pet_gender`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 1, 'BubbyQ', 'Dog', 1, 'Male', 'Good and Vaccinated', 'Adoption', 'Parent didn\'t support pet animal', '[\"../uploads/pet/pets_1_1.png\",\"../uploads/pet/pets_1_2.png\",\"../uploads/pet/pets_1_3.png\"]', '37.4219983', '-122.084', '2026-01-10 11:49:49'),
(2, 1, 'Ketty', 'Cat', 2, 'Female', 'Request for food', 'Donate Request', 'Feed stray cats', '[\"../uploads/pet/pets_2_1.png\",\"../uploads/pet/pets_2_2.png\"]', '37.4219983', '-122.084', '2026-01-10 11:52:06'),
(3, 2, 'Mochi', 'Cat', 2, 'Female', 'Healthy', 'Adoption', 'Very sticky and very cute', '[\"../uploads/pet/pets_3_1.png\"]', '37.4219983', '-122.084', '2026-01-10 11:55:17'),
(5, 3, 'Sushi', 'Cat', 3, 'Female', 'Bad condition', 'Help/Rescue', 'At Road 11 Street 1, suspected fracture!!', '[\"../uploads/pet/pets_5_1.png\",\"../uploads/pet/pets_5_2.png\"]', '37.4219983', '-122.084', '2026-01-10 12:05:02');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `credit` int(10) NOT NULL,
  `avatar` text NOT NULL,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `credit`, `avatar`, `reg_date`) VALUES
(1, 'WangJyhCheng', 'laowang0421@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01135674591', 340, 'userAvatar_1.png', '2026-01-10 01:42:10'),
(2, 'Yeoh', 'yeoh@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01135674591', 100, 'userAvatar_2.png', '2026-01-10 01:49:15'),
(3, 'Hema', 'hema@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '1231512313', 0, 'userAvatar_3.png', '2026-01-10 11:15:51'),
(4, 'WangLiterati', 'wang@gmail.com', '676a16cf431c8297a4a6ffc81d1914b15605e7e1', '0124690769', 155, 'userAvatar_4.png', '2026-01-10 12:07:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '\r\n', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
