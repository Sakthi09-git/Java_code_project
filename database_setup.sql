-- ========================================================
-- Java Code Review & Quality Analyzer Database Schema
-- Database: code_analyzer_db (phpMyAdmin / XAMPP MySQL)
-- ========================================================

CREATE DATABASE IF NOT EXISTS `code_analyzer_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `code_analyzer_db`;

-- 1. Reviews Table
CREATE TABLE IF NOT EXISTS `reviews` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `file_name` VARCHAR(255) NOT NULL,
    `code_snippet` MEDIUMTEXT NOT NULL,
    `quality_score` INT NOT NULL,
    `quality_grade` VARCHAR(10) NOT NULL,
    `verdict` VARCHAR(50) NOT NULL,
    `total_lines` INT NOT NULL,
    `code_lines` INT NOT NULL,
    `comment_lines` INT NOT NULL,
    `blank_lines` INT NOT NULL,
    `cyclomatic_complexity` INT NOT NULL,
    `maintainability_index` DOUBLE NOT NULL,
    `critical_count` INT DEFAULT 0,
    `high_count` INT DEFAULT 0,
    `medium_count` INT DEFAULT 0,
    `low_count` INT DEFAULT 0,
    `info_count` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_created_at` (`created_at`),
    INDEX `idx_file_name` (`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Code Issues Table
CREATE TABLE IF NOT EXISTS `issues` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `review_id` BIGINT NOT NULL,
    `rule_id` VARCHAR(100) NOT NULL,
    `rule_name` VARCHAR(255) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `severity` VARCHAR(20) NOT NULL,
    `line_number` INT NOT NULL,
    `column_number` INT DEFAULT 1,
    `message` TEXT NOT NULL,
    `recommendation` TEXT,
    `code_excerpt` TEXT,
    `suggested_fix` TEXT,
    INDEX `idx_review_id` (`review_id`),
    INDEX `idx_category` (`category`),
    INDEX `idx_severity` (`severity`),
    CONSTRAINT `fk_issues_review` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Rules Catalog
CREATE TABLE IF NOT EXISTS `rules_catalog` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `rule_id` VARCHAR(100) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `default_severity` VARCHAR(20) NOT NULL,
    `description` TEXT,
    `is_enabled` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Rules Catalog
INSERT INTO `rules_catalog` (`rule_id`, `name`, `category`, `default_severity`, `description`) VALUES
('SEC-001', 'SQL Injection Risk', 'SECURITY', 'CRITICAL', 'Concatenation or direct interpolation of unvalidated parameters into dynamic SQL queries.'),
('SEC-002', 'Hardcoded Secret / Credential', 'SECURITY', 'CRITICAL', 'API keys, passwords, database credentials or tokens hardcoded in source code.'),
('SEC-003', 'Insecure Command Execution', 'SECURITY', 'CRITICAL', 'Runtime.exec() or ProcessBuilder executed with potentially untrusted command strings.'),
('SEC-004', 'Insecure Cryptographic Randomness', 'SECURITY', 'HIGH', 'Usage of java.util.Random instead of java.security.SecureRandom in security contexts.'),
('SEC-005', 'Weak Hashing Algorithm', 'SECURITY', 'HIGH', 'Usage of obsolete algorithms such as MD5 or SHA-1 for hashing.'),
('SML-001', 'God Class / High Line Count', 'CODE_SMELL', 'HIGH', 'Class exceeds 400 lines of code, violating Single Responsibility Principle.'),
('SML-002', 'Long Method / Excessive Complexity', 'CODE_SMELL', 'MEDIUM', 'Method exceeds 40 lines of code or has excessive nesting levels.'),
('SML-003', 'Too Many Method Parameters', 'CODE_SMELL', 'MEDIUM', 'Method declares more than 4 parameters. Consider creating a parameter object.'),
('SML-004', 'Empty Catch Block (Swallowed Exception)', 'BUG', 'HIGH', 'Catch block is completely empty, silently hiding runtime errors and failures.'),
('SML-005', 'Generic Exception Caught / Thrown', 'CODE_SMELL', 'LOW', 'Catching or throwing raw java.lang.Exception or Throwable reduces debuggability.'),
('SML-006', 'Magic Number Literal', 'CODE_SMELL', 'LOW', 'Hardcoded numeric constants used directly instead of named constants.'),
('PRF-001', 'String Concatenation in Loops', 'PERFORMANCE', 'MEDIUM', 'Repeatedly concatenating strings with "+" inside loops leads to O(n^2) memory allocations. Use StringBuilder.'),
('PRF-002', 'Legacy Synchronized Collection', 'PERFORMANCE', 'LOW', 'Usage of legacy collections like Vector or Hashtable instead of modern Concurrent or standard collections.'),
('RES-001', 'Unclosed AutoCloseable Resource', 'BUG', 'HIGH', 'Resource such as InputStream, Connection, or Statement created without try-with-resources statement.'),
('COD-001', 'String Equality with ==', 'BUG', 'CRITICAL', 'Comparing String instances with == checks reference identity instead of value equality (.equals).'),
('COD-002', 'Missing @Override Annotation', 'BEST_PRACTICE', 'LOW', 'Overriding method from interface or superclass should be explicitly marked with @Override.'),
('COD-003', 'System.out / printStackTrace in Production', 'BEST_PRACTICE', 'LOW', 'Direct console output used instead of a configurable logging framework like SLF4J / Logback.'),
('COD-004', 'Equals without HashCode', 'BUG', 'HIGH', 'Class overrides equals() but fails to override hashCode(), violating Java Object contract.')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
