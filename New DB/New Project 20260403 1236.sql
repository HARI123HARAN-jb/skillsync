-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.5.34


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema student_learning
--

CREATE DATABASE IF NOT EXISTS student_learning;
USE student_learning;

--
-- Definition of table `courses`
--

DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `course_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course_name` varchar(350) NOT NULL,
  `description` varchar(350) NOT NULL,
  `teacher_id` varchar(350) NOT NULL,
  `image` longblob NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `courses`
--

/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;


--
-- Definition of table `modules`
--

DROP TABLE IF EXISTS `modules`;
CREATE TABLE `modules` (
  `modules_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` varchar(345) NOT NULL,
  `module_title` varchar(350) NOT NULL,
  `video_path` varchar(1000) NOT NULL,
  `notes_path` varchar(1000) NOT NULL,
  `topic_name` varchar(345) NOT NULL,
  `teacher_id` varchar(345) NOT NULL,
  `course_id` varchar(345) NOT NULL,
  PRIMARY KEY (`modules_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `modules`
--

/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;


--
-- Definition of table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
CREATE TABLE `quiz` (
  `quiz_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` varchar(45) NOT NULL,
  `question` varchar(400) NOT NULL,
  `option_a` varchar(350) NOT NULL,
  `option_b` varchar(350) NOT NULL,
  `option_c` varchar(350) NOT NULL,
  `option_d` varchar(350) NOT NULL,
  `correct_answer` varchar(345) NOT NULL,
  `teacher_id` varchar(345) NOT NULL,
  `course_id` varchar(345) NOT NULL,
  PRIMARY KEY (`quiz_id`,`option_d`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quiz`
--

/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;


--
-- Definition of table `student_courses`
--

DROP TABLE IF EXISTS `student_courses`;
CREATE TABLE `student_courses` (
  `enroll_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(345) NOT NULL,
  `course_id` varchar(345) NOT NULL,
  `course_status` varchar(345) NOT NULL,
  `teacher_id` varchar(345) NOT NULL,
  `points` varchar(45) NOT NULL DEFAULT '0',
  `date` date DEFAULT NULL,
  PRIMARY KEY (`enroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_courses`
--

/*!40000 ALTER TABLE `student_courses` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_courses` ENABLE KEYS */;


--
-- Definition of table `student_modules`
--

DROP TABLE IF EXISTS `student_modules`;
CREATE TABLE `student_modules` (
  `m_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(345) NOT NULL,
  `modules_id` varchar(345) NOT NULL,
  `topic_id` varchar(345) NOT NULL,
  `video_status` varchar(345) NOT NULL,
  `notes_status` varchar(345) NOT NULL,
  `status` varchar(345) NOT NULL,
  `course_id` varchar(345) NOT NULL,
  PRIMARY KEY (`m_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_modules`
--

/*!40000 ALTER TABLE `student_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_modules` ENABLE KEYS */;


--
-- Definition of table `student_notifications`
--

DROP TABLE IF EXISTS `student_notifications`;
CREATE TABLE `student_notifications` (
  `notif_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(45) NOT NULL,
  `course_id` varchar(45) NOT NULL,
  `is_read` varchar(45) NOT NULL DEFAULT '0',
  `last_shown` datetime NOT NULL,
  PRIMARY KEY (`notif_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_notifications`
--

/*!40000 ALTER TABLE `student_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_notifications` ENABLE KEYS */;


--
-- Definition of table `student_quiz_attempts`
--

DROP TABLE IF EXISTS `student_quiz_attempts`;
CREATE TABLE `student_quiz_attempts` (
  `attempt_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(345) NOT NULL,
  `course_id` varchar(345) NOT NULL,
  `score` varchar(345) NOT NULL,
  `status` varchar(245) NOT NULL,
  `quiz_level` varchar(45) NOT NULL,
  `attempt_number` varchar(45) NOT NULL,
  PRIMARY KEY (`attempt_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_quiz_attempts`
--

/*!40000 ALTER TABLE `student_quiz_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_quiz_attempts` ENABLE KEYS */;


--
-- Definition of table `student_register`
--

DROP TABLE IF EXISTS `student_register`;
CREATE TABLE `student_register` (
  `student_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_name` varchar(245) NOT NULL,
  `student_mail` varchar(245) NOT NULL,
  `college_name` varchar(245) NOT NULL,
  `department` varchar(245) NOT NULL,
  `degree` varchar(245) NOT NULL,
  `register_id` varchar(245) NOT NULL,
  `address` varchar(245) NOT NULL,
  `gender` varchar(245) NOT NULL,
  `age` varchar(245) NOT NULL,
  `password` varchar(245) NOT NULL,
  `mobile` varchar(245) NOT NULL,
  `image` longblob NOT NULL,
  `Admin_Approve` varchar(245) NOT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_register`
--

/*!40000 ALTER TABLE `student_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_register` ENABLE KEYS */;


--
-- Definition of table `student_topics`
--

DROP TABLE IF EXISTS `student_topics`;
CREATE TABLE `student_topics` (
  `t_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(245) NOT NULL,
  `topic_id` varchar(245) NOT NULL,
  `course_id` varchar(245) NOT NULL,
  `status` varchar(245) NOT NULL,
  PRIMARY KEY (`t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_topics`
--

/*!40000 ALTER TABLE `student_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_topics` ENABLE KEYS */;


--
-- Definition of table `teacher_register`
--

DROP TABLE IF EXISTS `teacher_register`;
CREATE TABLE `teacher_register` (
  `teacher_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_name` varchar(245) NOT NULL,
  `teacher_mail` varchar(245) NOT NULL,
  `college_name` varchar(245) NOT NULL,
  `department` varchar(245) NOT NULL,
  `degree` varchar(245) NOT NULL,
  `college_id` varchar(245) NOT NULL,
  `address` varchar(245) NOT NULL,
  `gender` varchar(245) NOT NULL,
  `age` varchar(245) NOT NULL,
  `password` varchar(245) NOT NULL,
  `image` longblob NOT NULL,
  `Admin_Approve` varchar(245) NOT NULL,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `teacher_register`
--

/*!40000 ALTER TABLE `teacher_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher_register` ENABLE KEYS */;


--
-- Definition of table `topic_quiz`
--

DROP TABLE IF EXISTS `topic_quiz`;
CREATE TABLE `topic_quiz` (
  `question_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(245) NOT NULL,
  `option_a` varchar(245) NOT NULL,
  `option_b` varchar(245) NOT NULL,
  `option_c` varchar(245) NOT NULL,
  `option_d` varchar(245) NOT NULL,
  `correct_answer` varchar(245) NOT NULL,
  `course_id` varchar(245) NOT NULL,
  `teacher_id` varchar(245) NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `topic_quiz`
--

/*!40000 ALTER TABLE `topic_quiz` DISABLE KEYS */;
/*!40000 ALTER TABLE `topic_quiz` ENABLE KEYS */;


--
-- Definition of table `topics`
--

DROP TABLE IF EXISTS `topics`;
CREATE TABLE `topics` (
  `topic_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` varchar(245) NOT NULL,
  `topic_title` varchar(245) NOT NULL,
  `course_name` varchar(245) NOT NULL,
  `teacher_id` varchar(245) NOT NULL,
  `image` longblob NOT NULL,
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `topics`
--

/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;


--
-- Definition of table `video_progress`
--

DROP TABLE IF EXISTS `video_progress`;
CREATE TABLE `video_progress` (
  `v_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` varchar(45) NOT NULL,
  `course_id` varchar(45) NOT NULL,
  `module_id` varchar(45) NOT NULL,
  `topic_id` varchar(45) NOT NULL,
  `watched_seconds` varchar(45) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`v_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `video_progress`
--

/*!40000 ALTER TABLE `video_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `video_progress` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
