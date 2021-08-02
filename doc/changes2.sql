use seminars;

ALTER table seminars add column on_line bool after place_description;
ALTER table seminars add column meeting_url varchar(250) after on_line;
ALTER table seminars add column meeting_code varchar(250) after meeting_url;
ALTER table seminars add column meeting_visible bool after meeting_code;

ALTER table organizations add column code varchar(250) after id;
UPDATE organizations SET code='mat'   where id=1;
UPDATE organizations SET code='bigea' where id=2;
UPDATE organizations SET code='disi'  where id=3;

DROP TABLE IF EXISTS `zoom_meetings`;
CREATE TABLE `zoom_meetings` (
  `id` bigint(15) unsigned NOT NULL PRIMARY KEY, -- no autoicreent
  `uuid` varchar(200), 
  `start_url` text, 
  `join_url` text, 
  `seminar_id` int(10) unsigned,
  CONSTRAINT `fk_seminars_zoom_meetings` FOREIGN KEY (seminar_id) REFERENCES seminars(id) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `registrations`;
CREATE TABLE `registrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  `seminar_id` int(10) unsigned,
  `user_id` int(10) unsigned,
  `email` varchar(250), 
  `name` varchar(250),
  `surname` varchar(250),
  `affiliation` varchar(250),
  `created_at` datetime,
  `updated_at` datetime,
  CONSTRAINT `fk_seminars_registrations` FOREIGN KEY (seminar_id) REFERENCES seminars(id) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_users_registrations` FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB; 

/* alter table documents drop column attach_file_name; */
/* alter table documents drop column attach_content_type; */
/* alter table documents drop column attach_file_size; */
/* alter table documents drop column attach_updated_at; */

/* alter table documents add column type varchar(100) after id; */
/* update documents set type = 'CurriculumVitae' where description = 'CV'; */


/* /1* CREATE TABLE `positions` ( *1/ */
/*   `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, */
/*   `code` varchar(50), */
/*   `name` varchar(255) */
/* ) ENGINE=InnoDB; */

/* INSERT INTO `positions` VALUES (1, "po", "Professore ordinario"), */
/*                                (2, "pa", "Professore associato"), */
/*                                (3, "ri", "Ricercatore"), */
/*                                (4, "ass", "Titolare di assegno di ricerca"), */
/*                                (5, "phd", "Dottore di ricerca"), */
/*                                (6, "phdstudent", "Dottorando di ricerca"), */ 
/*                                (7, "emeritus", "Professore Emerito"), */
/*                                (8, "other", "Altro"); */

/* ALTER table `repayments` ADD column `position_id` INT(10) UNSIGNED AFTER `gross`; */
/* ALTER table `repayments` ADD column `bond_number` INT(3) UNSIGNED AFTER `expected_refund`; */
/* ALTER table `repayments` ADD column `bond_year`   INT(3) UNSIGNED AFTER `expected_refund`; */


/* CREATE TABLE `organizations` ( */
/*   `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, */
/*   `name` varchar(255), */ 
/*   `description` varchar(255) */
/* ); */

/* INSERT INTO organizations VALUES (1, 'MAT', 'Dipartimento di Matematica'); */
/* INSERT INTO organizations VALUES (2, 'BIGEA', 'Dipartimento di Scienze Biologiche, Geologiche e Ambientali'); */

/* ALTER TABLE `seminars` ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `user_id`; */
/* UPDATE `seminars` SET organization_id=1; */

/* ALTER TABLE `cycles`   ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `user_id`; */
/* UPDATE `cycles`   set organization_id=1; */

/* ALTER TABLE `funds`    ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `id`; */
/* UPDATE `funds`    set organization_id=1; */

/* ALTER TABLE `places`   ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `id`; */
/* UPDATE `places`   set organization_id=1; */

/* ALTER TABLE `serials`  ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `id`; */
/* UPDATE `serials`  set organization_id=1; */

/* ALTER TABLE `arguments`  ADD COLUMN `organization_id` INT(10) UNSIGNED AFTER `id`; */
/* UPDATE `arguments`  set organization_id=1; */

/* ALTER TABLE `seminars`  ADD CONSTRAINT `fk_seminars_organization`  FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */
/* ALTER TABLE `cycles`    ADD CONSTRAINT `fk_cycles_organization`    FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */
/* ALTER TABLE `funds`     ADD CONSTRAINT `fk_funds_organization`     FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */
/* ALTER TABLE `places`    ADD CONSTRAINT `fk_places_organization`    FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */
/* ALTER TABLE `serials`   ADD CONSTRAINT `fk_serials_organization`   FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */
/* ALTER TABLE `arguments` ADD CONSTRAINT `fk_arguments_organization` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`); */

/* ALTER TABLE `repayments` CHANGE COLUMN `holder_id` `holder_id` INT(10) UNSIGNED  DEFAULT NULL; */

/* CREATE TABLE authorizations ( */
/*   `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY, */
/*   `user_id` int(10) unsigned NOT NULL, */
/*   `organization_id` int(10) unsigned NOT NULL, */
/*   `authlevel` int(2), */
/*   CONSTRAINT `fk_user_authorization`         FOREIGN KEY (`user_id`) REFERENCES `users` (`id`), */
/*   CONSTRAINT `fk_organization_authorization` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) */
/* ) ENGINE=InnoDB; */


