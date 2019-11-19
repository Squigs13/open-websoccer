  
ALTER TABLE ws3_admin ADD password_salt VARCHAR(5);
ALTER TABLE ws3_admin MODIFY password VARCHAR(64);
ALTER TABLE ws3_admin MODIFY password_new VARCHAR(64);
ALTER TABLE ws3_admin ADD lang VARCHAR(2);

ALTER TABLE ws3_user ADD password_salt VARCHAR(5);
ALTER TABLE ws3_user ADD tokenid VARCHAR(255);
ALTER TABLE ws3_user ADD lang VARCHAR(2) DEFAULT 'de';
ALTER TABLE ws3_user MODIFY password VARCHAR(64);
ALTER TABLE ws3_user MODIFY password_new VARCHAR(64);
ALTER TABLE ws3_user ADD c_hideinonlinelist ENUM('1','0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_user ADD premium_balance INT(6) NOT NULL DEFAULT 0;
ALTER TABLE ws3_user ADD picture VARCHAR(255) NULL;

ALTER TABLE ws3_transfer_bid ADD club_id INT(10);

ALTER TABLE ws3_player ADD unsellable ENUM('1','0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_player ADD position_main ENUM('GK','LB','CB', 'RB', 'LM', 'DM', 'CM', 'AM', 'RM', 'LW', 'CF', 'RW') NULL;
ALTER TABLE ws3_player ADD picture VARCHAR(128) NULL;
ALTER TABLE ws3_player ADD position_second ENUM('GK','LB','CB', 'RB', 'LM', 'DM', 'CM', 'AM', 'RM', 'LW', 'CF', 'RW') NULL;
ALTER TABLE ws3_player ADD loan_fee INT(6) NOT NULL DEFAULT 0;
ALTER TABLE ws3_player ADD loan_matches TINYINT NOT NULL DEFAULT 0;
ALTER TABLE ws3_player ADD loan_owner_id INT(10) NOT NULL DEFAULT 0;
ALTER TABLE ws3_player ADD suspended_cups TINYINT(3) NOT NULL DEFAULT 0;
ALTER TABLE ws3_player ADD suspended_nationalteam TINYINT(3) NOT NULL DEFAULT 0;

ALTER TABLE ws3_tactics ADD offensive TINYINT(3) NULL DEFAULT 50;
ALTER TABLE ws3_tactics ADD setup VARCHAR(16) NULL;
ALTER TABLE ws3_tactics ADD w1_condition VARCHAR(16) NULL;
ALTER TABLE ws3_tactics ADD w2_condition VARCHAR(16) NULL;
ALTER TABLE ws3_tactics ADD w3_condition VARCHAR(16) NULL;
ALTER TABLE ws3_tactics ADD longpasses ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_tactics ADD counterattacks ENUM('1', '0') NOT NULL DEFAULT '0';

ALTER TABLE ws3_match_simulation ADD position_main VARCHAR(5) NULL;
ALTER TABLE ws3_match_simulation ADD age TINYINT(2) NULL;
ALTER TABLE ws3_match_simulation ADD w_strength TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD w_technique TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD w_stamina TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD w_fitness TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD w_morale TINYINT(3) NULL;

ALTER TABLE ws3_match_simulation ADD touches TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD wontackles TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD shots TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD passes_successful TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD passes_failed TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD assists TINYINT(3) NULL;
ALTER TABLE ws3_match_simulation ADD name VARCHAR(128) NULL;

ALTER TABLE ws3_match ADD minutes TINYINT(3) NULL;
ALTER TABLE ws3_match ADD player_with_ball INT(10) NULL;
ALTER TABLE ws3_match ADD prev_player_with_ball INT(10) NULL;
ALTER TABLE ws3_match ADD home_offensive TINYINT(3) NULL;
ALTER TABLE ws3_match ADD guest_offensive TINYINT(3) NULL;
ALTER TABLE ws3_match ADD home_offensive_changed TINYINT(2) NOT NULL DEFAULT 0;
ALTER TABLE ws3_match ADD guest_offensive_changed TINYINT(2) NOT NULL DEFAULT 0;
ALTER TABLE ws3_match ADD cup_group VARCHAR(64) NULL;
ALTER TABLE ws3_match ADD soldout ENUM('1','0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD home_setup VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD home_w1_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD home_w2_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD home_w3_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD guest_setup VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD guest_w1_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD guest_w2_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD guest_w3_condition VARCHAR(16) NULL;
ALTER TABLE ws3_match ADD home_noformation ENUM('1','0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD guest_noformation ENUM('1','0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD home_longpasses ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD home_counterattacks ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD guest_longpasses ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD guest_counterattacks ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_match ADD home_morale TINYINT(3) NOT NULL DEFAULT 0;
ALTER TABLE ws3_match ADD guest_morale TINYINT(3) NOT NULL DEFAULT 0;

ALTER TABLE ws3_match_text CHANGE  action  action 
	ENUM(  'Goal',  'Substitution',  'Tackle_won',  'Tackle_lost',  'Pass_missed',  'Shot_missed',  'Shot_on_target',  'Yellow_card',  'Red_card',  'Yellow_card_2nd',  'Injury', 'Penalty_scored',  'Penalty_missed' );

ALTER TABLE ws3_table_marker ADD target_league_id INT(10) NULL;

ALTER TABLE ws3_club ADD min_target_rank SMALLINT(3) NOT NULL DEFAULT 0;
ALTER TABLE ws3_club ADD scouting_last_execution INT(11) NOT NULL DEFAULT 0;
ALTER TABLE ws3_club ADD nationalteam ENUM('1', '0') NOT NULL DEFAULT '0';
ALTER TABLE ws3_club ADD captain_id INT(10) NOT NULL DEFAULT 0;
ALTER TABLE ws3_club ADD interimmanager ENUM('1', '0') NOT NULL DEFAULT '0';

ALTER TABLE ws3_stadium ADD level_pitch TINYINT(2) NOT NULL DEFAULT 3;
ALTER TABLE ws3_stadium ADD level_videowall TINYINT(2) NOT NULL DEFAULT 1;
ALTER TABLE ws3_stadium ADD level_seatsquality TINYINT(2) NOT NULL DEFAULT 5;
ALTER TABLE ws3_stadium ADD level_vipquality TINYINT(2) NOT NULL DEFAULT 5;
ALTER TABLE ws3_stadium ADD maintenance_pitch TINYINT(2) NOT NULL DEFAULT 1;
ALTER TABLE ws3_stadium ADD maintenance_videowall TINYINT(2) NOT NULL DEFAULT 1;
ALTER TABLE ws3_stadium ADD maintenance_seatsquality TINYINT(2) NOT NULL DEFAULT 1;
ALTER TABLE ws3_stadium ADD maintenance_vipquality TINYINT(2) NOT NULL DEFAULT 1;
	
CREATE TABLE ws3_transfer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_id INT(10) NOT NULL,
  seller_user_id INT(10) NULL,
  seller_club_id INT(10) NULL,
  buyer_user_id INT(10) NOT NULL,
  buyer_club_id INT(10) NOT NULL,
  date INT(11) NOT NULL,
  bid_id INT(11) NOT NULL,
  directtransfer_amount INT(10) NOT NULL,
  directtransfer_player1 INT(10) NOT NULL DEFAULT 0,
  directtransfer_player2 INT(10) NOT NULL DEFAULT 0
);

CREATE TABLE ws3_session (
  session_id CHAR(32) NOT NULL PRIMARY KEY,
  session_data TEXT NOT NULL,
  expires INT(11) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ws3_matchreport (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT(10) NOT NULL,
  message_id INT(10) NOT NULL,
  minute TINYINT(3) NOT NULL,
  goals VARCHAR(8) NULL,
  playernames VARCHAR(128) NULL,
  active_home TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE ws3_trainer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  salary INT(10) NOT NULL,
  p_technique TINYINT(3) NOT NULL DEFAULT '0',
  p_stamina TINYINT(3) NOT NULL DEFAULT '0'
);

CREATE TABLE ws3_training_unit (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT(10) NOT NULL,
  trainer_id INT(10) NOT NULL,
  focus ENUM('TE','STA','MOT','FR') NOT NULL DEFAULT 'TE',
  intensity TINYINT(3) NOT NULL DEFAULT '50',
  date_executed INT(10) NOT NULL DEFAULT '0'
);

CREATE TABLE ws3_cup (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL UNIQUE,
  winner_id INT(10) NULL DEFAULT 0,
  logo VARCHAR(128) NULL,
  winner_award INT(10) NOT NULL DEFAULT 0,
  second_award INT(10) NOT NULL DEFAULT 0,
  perround_award INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_cup_round (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cup_id INT(10) NOT NULL,
  name VARCHAR(64) NOT NULL,
  from_winners_round_id INT(10) NULL,
  from_loser_round_id INT(10) NULL,
  firstround_date INT(11) NOT NULL,
  secondround_date INT(11) NULL,
  finalround ENUM('1','0') NOT NULL DEFAULT '0',
  groupmatches ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_cup_round_pending (
  team_id INT(10) NOT NULL,
  cup_round_id INT(10) NOT NULL,
  PRIMARY KEY(team_id, cup_round_id)
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_cup_round_group (
  cup_round_id INT(10) NOT NULL,
  team_id INT(10) NOT NULL,
  name VARCHAR(64) NOT NULL,
  tab_points INT(4) NOT NULL DEFAULT 0,
  tab_goals INT(4) NOT NULL DEFAULT 0,
  tab_goals_conceded INT(4) NOT NULL DEFAULT 0,
  tab_wins INT(4) NOT NULL DEFAULT 0,
  tab_draws INT(4) NOT NULL DEFAULT 0,
  tab_losses INT(4) NOT NULL DEFAULT 0,
  PRIMARY KEY(cup_round_id, team_id)
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_cup_round_group_next (
  cup_round_id INT(10) NOT NULL,
  groupname VARCHAR(64) NOT NULL,
  rank INT(4) NOT NULL DEFAULT 0,
  target_cup_round_id INT(10) NOT NULL,
  PRIMARY KEY(cup_round_id, groupname, rank)
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_team_league_statistics (
  team_id INT(10) NOT NULL,
  season_id INT(10) NOT NULL,
  total_points INT(6) NOT NULL DEFAULT 0,
  total_goals INT(6) NOT NULL DEFAULT 0,
  total_goals_conceded INT(6) NOT NULL DEFAULT 0,
  total_goalsdiff INT(6) NOT NULL DEFAULT 0,
  total_wins INT(6) NOT NULL DEFAULT 0,
  total_draws INT(6) NOT NULL DEFAULT 0,
  total_losses INT(6) NOT NULL DEFAULT 0,
  home_points INT(6) NOT NULL DEFAULT 0,
  home_goals INT(6) NOT NULL DEFAULT 0,
  home_goals_conceded INT(6) NOT NULL DEFAULT 0,
  home_goalsdiff INT(6) NOT NULL DEFAULT 0,
  home_wins INT(6) NOT NULL DEFAULT 0,
  home_draws INT(6) NOT NULL DEFAULT 0,
  home_losses INT(6) NOT NULL DEFAULT 0,
  guest_points INT(6) NOT NULL DEFAULT 0,
  guest_goals INT(6) NOT NULL DEFAULT 0,
  guest_goals_conceded INT(6) NOT NULL DEFAULT 0,
  guest_goalsdiff INT(6) NOT NULL DEFAULT 0,
  guest_wins INT(6) NOT NULL DEFAULT 0,
  guest_draws INT(6) NOT NULL DEFAULT 0,
  guest_losses INT(6) NOT NULL DEFAULT 0,
  PRIMARY KEY(team_id, season_id)
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_transfer_offer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_id INT(10) NOT NULL,
  sender_user_id INT(10) NOT NULL,
  sender_club_id INT(10) NOT NULL,
  receiver_club_id INT(10) NOT NULL,
  submitted_date INT(11) NOT NULL,
  offer_amount INT(10) NOT NULL,
  offer_message VARCHAR(255) NULL,
  offer_player1 INT(10) NOT NULL DEFAULT 0,
  offer_player2 INT(10) NOT NULL DEFAULT 0,
  rejected_date INT(11) NOT NULL DEFAULT 0,
  rejected_message VARCHAR(255) NULL,
  rejected_allow_alternative ENUM('1','0') NOT NULL DEFAULT '0',
  admin_approval_pending ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_notification (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  eventdate INT(11) NOT NULL,
  eventtype VARCHAR(128) NULL,
  message_key VARCHAR(255) NULL,
  message_data VARCHAR(255) NULL,
  target_pageid VARCHAR(128) NULL,
  target_querystr VARCHAR(255) NULL,
  seen ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_youthplayer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT(10) NOT NULL,
  firstname VARCHAR(32) NOT NULL,
  lastname VARCHAR(32) NOT NULL,
  age TINYINT NOT NULL,
  position ENUM('Goalkeeper','Defender','Midfielder','Forward') NOT NULL,
  nation VARCHAR(32) NULL,
  strength TINYINT(3) NOT NULL,
  strength_last_change TINYINT(3) NOT NULL DEFAULT 0,
  st_goals SMALLINT(5) NOT NULL DEFAULT 0,
  st_matches SMALLINT(5) NOT NULL DEFAULT 0,
  st_assists SMALLINT(5) NOT NULL DEFAULT 0,
  st_cards_yellow SMALLINT(5) NOT NULL DEFAULT 0,
  st_cards_yellow_red SMALLINT(5) NOT NULL DEFAULT 0,
  st_cards_red SMALLINT(5) NOT NULL DEFAULT 0,
  transfer_fee INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_youthscout (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(32) NOT NULL,
  expertise TINYINT(3) NOT NULL,
  fee INT(10) NOT NULL,
  speciality ENUM('Goalkeeper','Defender','Midfielder','Forward') NULL
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_youthmatch_request (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT(10) NOT NULL,
  matchdate INT(11) NOT NULL,
  reward INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_youthmatch (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  matchdate INT(11) NOT NULL,
  home_team_id INT(10) NOT NULL,
  home_noformation ENUM('1','0') DEFAULT '0',
  home_s1_out INT(10) NULL,
  home_s1_in INT(10) NULL,
  home_s1_minute TINYINT(3) NULL,
  home_s1_condition VARCHAR(16) NULL,
  home_s2_out INT(10) NULL,
  home_s2_in INT(10) NULL,
  home_s2_minute TINYINT(3) NULL,
  home_s2_condition VARCHAR(16) NULL,
  home_s3_out INT(10) NULL,
  home_s3_in INT(10) NULL,
  home_s3_minute TINYINT(3) NULL,
  home_s3_condition VARCHAR(16) NULL,
  guest_team_id INT(10) NOT NULL,
  guest_noformation ENUM('1','0') DEFAULT '0',
  guest_s1_out INT(10) NULL,
  guest_s1_in INT(10) NULL,
  guest_s1_minute TINYINT(3) NULL,
  guest_s1_condition VARCHAR(16) NULL,
  guest_s2_out INT(10) NULL,
  guest_s2_in INT(10) NULL,
  guest_s2_minute TINYINT(3) NULL,
  guest_s2_condition VARCHAR(16) NULL,
  guest_s3_out INT(10) NULL,
  guest_s3_in INT(10) NULL,
  guest_s3_minute TINYINT(3) NULL,
  guest_s3_condition VARCHAR(16) NULL,
  home_goals TINYINT(2) NULL,
  guest_goals TINYINT(2) NULL,
  simulated ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_youthmatch_player (
  match_id INT(10) NOT NULL,
  team_id INT(10) NOT NULL,
  player_id INT(10) NOT NULL,
  playernumber TINYINT(2) NOT NULL,
  position VARCHAR(24) NOT NULL,
  position_main VARCHAR(8) NOT NULL,
  grade REAL(4,2) NOT NULL DEFAULT 3.0,
  minutes_played TINYINT(2) NOT NULL DEFAULT 0,
  card_yellow TINYINT(1) NOT NULL DEFAULT 0,
  card_red TINYINT(1) NOT NULL DEFAULT 0,
  goals TINYINT(2) NOT NULL DEFAULT 0,
  state ENUM('1','Bench','Substituted') NOT NULL DEFAULT '1',
  strength TINYINT(3) NOT NULL,
  touches TINYINT(3) NOT NULL DEFAULT 0,
  wontackles TINYINT(3) NOT NULL DEFAULT 0,
  shots TINYINT(3) NOT NULL DEFAULT 0,
  passes_successful TINYINT(3) NOT NULL DEFAULT 0,
  passes_failed TINYINT(3) NOT NULL DEFAULT 0,
  assists TINYINT(3) NOT NULL DEFAULT 0,
  name VARCHAR(128) NOT NULL,
  FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE,
  PRIMARY KEY (match_id, player_id)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_youthmatch_reportitem (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT(10) NOT NULL,
  minute TINYINT(3) NOT NULL,
  message_key VARCHAR(32) NOT NULL,
  message_data VARCHAR(255) NULL,
  home_on_ball ENUM('1','0') NOT NULL DEFAULT '0',
  FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_stadium_builder (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(32) NOT NULL,
  picture VARCHAR(128) NULL,
  fixedcosts INT(10) NOT NULL DEFAULT 0,
  cost_per_seat INT(10) NOT NULL DEFAULT 0,
  construction_time_days TINYINT(3) NOT NULL DEFAULT 0,
  construction_time_days_min TINYINT(3) NOT NULL DEFAULT 0,
  min_stadium_size INT(10) NOT NULL DEFAULT 0,
  max_stadium_size INT(10) NOT NULL DEFAULT 0,
  reliability TINYINT(3) NOT NULL DEFAULT 100
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_stadium_construction (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT(10) NOT NULL,
  builder_id INT(10) NOT NULL,
  started INT(11) NOT NULL,
  deadline INT(11) NOT NULL,
  p_standing INT(6) NOT NULL DEFAULT 0,
  p_seat INT(6) NOT NULL DEFAULT 0,
  p_main_standing INT(6) NOT NULL DEFAULT 0,
  p_main_seat INT(6) NOT NULL DEFAULT 0,
  p_vip INT(6) NOT NULL DEFAULT 0,
  FOREIGN KEY (builder_id) REFERENCES ws3_stadium_builder(id) ON DELETE RESTRICT
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_teamoftheday (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  season_id INT(10) NOT NULL,
  matchday TINYINT(3) NOT NULL,
  statistic_id INT(10) NOT NULL,
  player_id INT(10) NOT NULL,
  position_main VARCHAR(20) NULL
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_nationalplayer (
  team_id INT(10) NOT NULL,
  player_id INT(10) NOT NULL,
  PRIMARY KEY (team_id, player_id)
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_premiumstatement (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  action_id VARCHAR(255) NULL,
  amount INT(10) NOT NULL,
  created_date INT(11) NOT NULL,
  subject_data VARCHAR(255) NULL
) DEFAULT CHARSET=utf8;

CREATE TABLE ws3_premiumpayment (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  amount INT(10) NOT NULL,
  created_date INT(11) NOT NULL
) DEFAULT CHARSET=utf8;

INSERT INTO ws3_match_text (action, message) VALUES
('Penalty_scored', '{sp1} tritt an: Und trifft!'),
('Penalty_missed', '{sp1} tritt an: Aber {sp2} hält den Ball!!'),
('Penalty_missed', '{sp1} legt sich den Ball zurecht. Etwas unsicherer Anlauf... und haut den Ball über das Tor.');

-- delete alle existing formations because order of players has changed.
DELETE FROM ws3_tactics WHERE 1;


-- UPDATE 5.0.0
SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE ws3_user ENGINE=InnoDB;

ALTER TABLE ws3_user_inactivity ENGINE=InnoDB;
ALTER TABLE ws3_user_inactivity ADD CONSTRAINT user_inactivity_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

ALTER TABLE ws3_messages ENGINE=InnoDB;
ALTER TABLE ws3_messages ADD CONSTRAINT messages_user_id_fk FOREIGN KEY (sender_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

ALTER TABLE ws3_stadium ENGINE=InnoDB;
ALTER TABLE ws3_sponsor ENGINE=InnoDB;
ALTER TABLE ws3_league ENGINE=InnoDB;

ALTER TABLE ws3_club ENGINE=InnoDB;
ALTER TABLE ws3_club MODIFY league_id SMALLINT(5) NULL;
ALTER TABLE ws3_club MODIFY user_id INT(10) NULL;
ALTER TABLE ws3_club MODIFY stadium_id INT(10) NULL;
ALTER TABLE ws3_club MODIFY sponsor_id INT(10) NULL;
ALTER TABLE ws3_club ADD CONSTRAINT club_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT club_stadium_id_fk FOREIGN KEY (stadium_id) REFERENCES ws3_stadium(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT club_sponsor_id_fk FOREIGN KEY (sponsor_id) REFERENCES ws3_sponsor(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT club_league_id_fk FOREIGN KEY (league_id) REFERENCES ws3_league(id) ON DELETE CASCADE;

ALTER TABLE ws3_player ENGINE=InnoDB;
ALTER TABLE ws3_player MODIFY club_id INT(10) NULL;
ALTER TABLE ws3_player ADD CONSTRAINT player_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_accounts ENGINE=InnoDB;
ALTER TABLE ws3_accounts ADD CONSTRAINT accounts_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_transfer_bid ENGINE=InnoDB;
ALTER TABLE ws3_transfer_bid ADD CONSTRAINT transfer_bid_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

ALTER TABLE ws3_training_camp ENGINE=InnoDB;
ALTER TABLE ws3_training_camp_booking ENGINE=InnoDB;
ALTER TABLE ws3_training_camp_booking ADD CONSTRAINT training_camp_booking_fk FOREIGN KEY (camp_id) REFERENCES ws3_training_camp(id) ON DELETE CASCADE;
ALTER TABLE ws3_training_camp_booking ADD CONSTRAINT training_camp_club_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_tactics ENGINE=InnoDB;
ALTER TABLE ws3_tactics MODIFY sub1 INT(10) NULL;
ALTER TABLE ws3_tactics MODIFY sub2 INT(10) NULL;
ALTER TABLE ws3_tactics MODIFY sub3 INT(10) NULL;
ALTER TABLE ws3_tactics MODIFY sub4 INT(10) NULL;
ALTER TABLE ws3_tactics MODIFY sub5 INT(10) NULL;
ALTER TABLE ws3_tactics ADD CONSTRAINT aufstellung_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_season ENGINE=InnoDB;
ALTER TABLE ws3_match ENGINE=InnoDB;
ALTER TABLE ws3_match MODIFY season_id INT(10) NULL;
ALTER TABLE ws3_match MODIFY matchday TINYINT(3) NULL;
ALTER TABLE ws3_match MODIFY home_goals TINYINT(2) NULL;
ALTER TABLE ws3_match MODIFY guest_goals TINYINT(2) NULL;
ALTER TABLE ws3_match MODIFY crowd INT(6) NULL;
ALTER TABLE ws3_match ADD CONSTRAINT match_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;
ALTER TABLE ws3_match ADD CONSTRAINT match_home_id_fk FOREIGN KEY (home_club) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_match ADD CONSTRAINT match_guest_id_fk FOREIGN KEY (guest_club) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_match_simulation ENGINE=InnoDB;
ALTER TABLE ws3_match_simulation ADD CONSTRAINT berechnung_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_match(id) ON DELETE CASCADE;
ALTER TABLE ws3_match_simulation ADD CONSTRAINT berechnung_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;

ALTER TABLE ws3_transfer ENGINE=InnoDB;
ALTER TABLE ws3_transfer MODIFY seller_user_id INT(10) NULL;
ALTER TABLE ws3_transfer MODIFY buyer_user_id INT(10) NULL;
ALTER TABLE ws3_transfer ADD CONSTRAINT transfer_matchesr_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer ADD CONSTRAINT transfer_selleruser_fk FOREIGN KEY (seller_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_transfer ADD CONSTRAINT transfer_sellerclub_fk FOREIGN KEY (seller_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer ADD CONSTRAINT transfer_buyeruser_fk FOREIGN KEY (buyer_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_transfer ADD CONSTRAINT transfer_buyerclub_fk FOREIGN KEY (buyer_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_match_text ENGINE=InnoDB;
ALTER TABLE ws3_matchreport ENGINE=InnoDB;
ALTER TABLE ws3_matchreport ADD CONSTRAINT matchreport_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_match(id) ON DELETE CASCADE;
ALTER TABLE ws3_matchreport ADD CONSTRAINT matchreport_message_id_fk FOREIGN KEY (message_id) REFERENCES ws3_match_text(id) ON DELETE CASCADE;

ALTER TABLE ws3_training_unit ENGINE=InnoDB;
ALTER TABLE ws3_training_unit ADD CONSTRAINT training_club_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_cup ENGINE=InnoDB;
ALTER TABLE ws3_cup MODIFY winner_id INT(10) NULL;
ALTER TABLE ws3_cup ADD CONSTRAINT cup_winner_id_fk FOREIGN KEY (winner_id) REFERENCES ws3_club(id) ON DELETE SET NULL;

ALTER TABLE ws3_cup_round ENGINE=InnoDB;
ALTER TABLE ws3_cup_round ADD CONSTRAINT cupround_cup_id_fk FOREIGN KEY (cup_id) REFERENCES ws3_cup(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round ADD CONSTRAINT cupround_fromwinners_id_fk FOREIGN KEY (from_winners_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round ADD CONSTRAINT cupround_fromloser_id_fk FOREIGN KEY (from_loser_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;

ALTER TABLE ws3_cup_round_pending ENGINE=InnoDB;
ALTER TABLE ws3_cup_round_pending ADD CONSTRAINT cuproundpending_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_pending ADD CONSTRAINT cuproundpending_round_fk FOREIGN KEY (cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;

ALTER TABLE ws3_cup_round_group ENGINE=InnoDB;
ALTER TABLE ws3_cup_round_group ADD CONSTRAINT cupgroup_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_cup_round_group_next ENGINE=InnoDB;
ALTER TABLE ws3_cup_round_group_next ADD CONSTRAINT groupnext_round_fk FOREIGN KEY (cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_group_next ADD CONSTRAINT groupnext_tagetround_fk FOREIGN KEY (target_cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;

ALTER TABLE ws3_team_league_statistics ENGINE=InnoDB;
ALTER TABLE ws3_team_league_statistics ADD CONSTRAINT statistics_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_team_league_statistics ADD CONSTRAINT statistics_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;

ALTER TABLE ws3_transfer_offer ENGINE=InnoDB;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT toffer_matchesr_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT toffer_selleruser_fk FOREIGN KEY (sender_user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT toffer_sellerclub_fk FOREIGN KEY (sender_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT toffer_buyerclub_fk FOREIGN KEY (receiver_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_notification ENGINE=InnoDB;
ALTER TABLE ws3_notification ADD CONSTRAINT notification_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

ALTER TABLE ws3_youthplayer ENGINE=InnoDB;
ALTER TABLE ws3_youthplayer ADD CONSTRAINT youthplayer_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_youthmatch_request ENGINE=InnoDB;
ALTER TABLE ws3_youthmatch_request ADD CONSTRAINT youthrequest_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_youthmatch ENGINE=InnoDB;
ALTER TABLE ws3_youthmatch ADD CONSTRAINT youthmatch_home_id_fk FOREIGN KEY (home_team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch ADD CONSTRAINT youthmatch_guest_id_fk FOREIGN KEY (guest_team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_youthmatch_player ENGINE=InnoDB;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ymatchplayer_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ymatchplayer_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_youthplayer(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ymatchplayer_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE;

ALTER TABLE ws3_youthmatch_reportitem ENGINE=InnoDB;
ALTER TABLE ws3_youthmatch_reportitem ADD CONSTRAINT ymatchreport_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE;

ALTER TABLE ws3_stadium_builder ENGINE=InnoDB;
ALTER TABLE ws3_stadium_construction ENGINE=InnoDB;
ALTER TABLE ws3_stadium_construction ADD CONSTRAINT construction_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_stadium_construction ADD CONSTRAINT construction_builder_id_fk FOREIGN KEY (builder_id) REFERENCES ws3_stadium_builder(id) ON DELETE CASCADE;

ALTER TABLE ws3_teamoftheday ENGINE=InnoDB;
ALTER TABLE ws3_teamoftheday ADD CONSTRAINT teamofday_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;
ALTER TABLE ws3_teamoftheday ADD CONSTRAINT teamofday_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;

ALTER TABLE ws3_nationalplayer ENGINE=InnoDB;
ALTER TABLE ws3_nationalplayer ADD CONSTRAINT nationalp_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_nationalplayer ADD CONSTRAINT nationalp_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_premiumstatement ENGINE=InnoDB;
ALTER TABLE ws3_premiumstatement ADD CONSTRAINT premium_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

ALTER TABLE ws3_premiumpayment ENGINE=InnoDB;
ALTER TABLE ws3_premiumpayment ADD CONSTRAINT premiumpayment_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE ws3_match_text CHANGE  action  action 
	ENUM(  'Goal',  'Substitution',  'Tackle_won',  'Tackle_lost',  'Pass_missed',  'Shot_missed',  'Shot_on_target',  'Yellow_card',  'Red_card',  'Yellow_card_2nd',  'Injury', 'Penalty_scored',  'Penalty_missed', 'Tactics_changed', 'Corner', 'Freekick_missed', 'Freekick_scored', 'Goal_with_assist' );
INSERT INTO ws3_match_text (action, message) VALUES
('Tactics_changed', '{sp1} ändert die Taktik.'),
('Corner', 'Corner für {ma1}. {sp1} spielt auf {sp2}...'),
('Freekick_missed', 'Freistoß für {ma1}! {sp1} schießt, aber zu ungenau.'),
('Freekick_scored', '{sp1} tritt den direkten Freistoß und trifft!'),
('Goal_with_assist', 'Tooor für {ma1}! {sp2} legt auf {sp1} ab, der nur noch einschieben muss.');
	
ALTER TABLE ws3_club ADD strength TINYINT(3) NOT NULL DEFAULT 0;
ALTER TABLE ws3_club ADD user_id_actual INT(10) NULL;
ALTER TABLE ws3_club ADD CONSTRAINT club_original_user_id_fk FOREIGN KEY (user_id_actual) REFERENCES ws3_user(id) ON DELETE SET NULL;

ALTER TABLE ws3_match_simulation ADD losttackles TINYINT(3) NULL;

ALTER TABLE ws3_stadium ADD picture VARCHAR(128) NULL;

ALTER TABLE ws3_match ADD home_user_id INT(10) NULL;
ALTER TABLE ws3_match ADD guest_user_id INT(10) NULL;
ALTER TABLE ws3_match ADD CONSTRAINT match_home_user_id_fk FOREIGN KEY (home_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_match ADD CONSTRAINT match_guest_user_id_fk FOREIGN KEY (guest_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
	
ALTER TABLE ws3_cup ADD archived ENUM('1','0') NOT NULL DEFAULT '0';

ALTER TABLE ws3_transfer_bid ADD ishighest ENUM('1','0') NOT NULL DEFAULT '0';

ALTER TABLE ws3_trainer ADD premiumfee INT(10) NOT NULL DEFAULT 0;
ALTER TABLE ws3_stadium_builder ADD premiumfee INT(10) NOT NULL DEFAULT 0;

ALTER TABLE ws3_player ADD age TINYINT(3) NULL;

ALTER TABLE ws3_notification ADD team_id INT(10) NULL REFERENCES ws3_club(id) ON DELETE CASCADE;

ALTER TABLE ws3_tactics ADD freekickplayer INT(10) NULL;
ALTER TABLE ws3_tactics ADD w1_position VARCHAR(4) NULL;
ALTER TABLE ws3_tactics ADD w2_position VARCHAR(4) NULL;
ALTER TABLE ws3_tactics ADD w3_position VARCHAR(4) NULL;
ALTER TABLE ws3_tactics ADD player1_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player2_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player3_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player4_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player5_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player6_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player7_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player8_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player9_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player10_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD player11_position VARCHAR(4) NOT NULL;
ALTER TABLE ws3_tactics ADD match_id INT(10) NULL REFERENCES ws3_match(id) ON DELETE CASCADE;
ALTER TABLE ws3_tactics ADD templatename VARCHAR(24) NULL;

ALTER TABLE ws3_match ADD home_freekickplayer INT(10) NULL;
ALTER TABLE ws3_match ADD home_w1_position VARCHAR(4) NULL;
ALTER TABLE ws3_match ADD home_w2_position VARCHAR(4) NULL;
ALTER TABLE ws3_match ADD home_w3_position VARCHAR(4) NULL;

ALTER TABLE ws3_match ADD guest_freekickplayer INT(10) NULL;
ALTER TABLE ws3_match ADD guest_w1_position VARCHAR(4) NULL;
ALTER TABLE ws3_match ADD guest_w2_position VARCHAR(4) NULL;
ALTER TABLE ws3_match ADD guest_w3_position VARCHAR(4) NULL;

ALTER TABLE ws3_youthmatch ADD home_s1_position VARCHAR(4) NULL;
ALTER TABLE ws3_youthmatch ADD home_s2_position VARCHAR(4) NULL;
ALTER TABLE ws3_youthmatch ADD home_s3_position VARCHAR(4) NULL;
ALTER TABLE ws3_youthmatch ADD guest_s1_position VARCHAR(4) NULL;
ALTER TABLE ws3_youthmatch ADD guest_s2_position VARCHAR(4) NULL;
ALTER TABLE ws3_youthmatch ADD guest_s3_position VARCHAR(4) NULL;

CREATE TABLE ws3_useractionlog (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  action_id VARCHAR(255) NULL,
  created_date INT(11) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_shoutmessage (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  message VARCHAR(255) NOT NULL,
  created_date INT(11) NOT NULL,
  match_id INT(10) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE,
  FOREIGN KEY (match_id) REFERENCES ws3_match(id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_userabsence (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  deputy_id INT(10) NULL,
  from_date INT(11) NOT NULL,
  to_date INT(11) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE,
  FOREIGN KEY (deputy_id) REFERENCES ws3_user(id) ON DELETE SET NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_leaguehistory (
  team_id INT(10) NOT NULL,
  season_id INT(10) NOT NULL,
  user_id INT(10) NULL,
  matchday TINYINT(3) NULL,
  rank TINYINT(3) NULL,
  FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE,
  FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE SET NULL,
  PRIMARY KEY(team_id, season_id, matchday)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_randomevent (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255) NULL,
  effect ENUM('money', 'player_injured', 'player_blocked', 'player_happiness', 'player_fitness', 'player_stamina') NOT NULL,
  effect_money_amount INT(10) NOT NULL DEFAULT 0,
  effect_blocked_matches INT(10) NOT NULL DEFAULT 0,
  effect_skillchange TINYINT(3) NOT NULL DEFAULT 0,
  weight TINYINT(3) NOT NULL DEFAULT 1
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_randomevent_occurrence (
  user_id INT(10) NOT NULL,
  team_id INT(10) NOT NULL,
  event_id INT(10) NOT NULL,
  occurrence_date INT(10) NOT NULL,
  FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE,
  FOREIGN KEY (event_id) REFERENCES ws3_randomevent(id) ON DELETE CASCADE,
  PRIMARY KEY(user_id, team_id, occurrence_date)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_badge (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  description VARCHAR(255) NULL,
  level ENUM('bronze', 'silver', 'gold') NOT NULL DEFAULT 'bronze',
  event ENUM('membership_since_x_days', 'win_with_x_goals_difference', 'completed_season_at_x', 'x_trades', 'cupwinner', 'stadium_construction_by_x') NOT NULL,
  event_benchmark INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_badge_user (
  user_id INT(10) NOT NULL REFERENCES ws3_user(id) ON DELETE CASCADE,
  badge_id INT(10) NOT NULL REFERENCES ws3_badge(id) ON DELETE CASCADE,
  date_rewarded INT(10) NOT NULL,
  PRIMARY KEY(user_id, badge_id)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_achievement (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL REFERENCES ws3_user(id) ON DELETE CASCADE,
  team_id INT(10) NOT NULL REFERENCES ws3_club(id) ON DELETE CASCADE,
  season_id INT(10) NULL REFERENCES ws3_season(id) ON DELETE CASCADE,
  cup_round_id INT(10) NULL REFERENCES ws3_cup_round(id) ON DELETE CASCADE,
  rank TINYINT(3) NULL,
  date_recorded INT(10) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_stadiumbuilding (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL,
  picture VARCHAR(255) NULL,
  required_building_id INT(10) NULL,
  costs INT(10) NOT NULL,
  premiumfee INT(10) NOT NULL DEFAULT 0,
  construction_time_days TINYINT(3) NOT NULL DEFAULT 0,
  effect_training TINYINT(3) NOT NULL DEFAULT 0,
  effect_youthscouting TINYINT(3) NOT NULL DEFAULT 0,
  effect_tickets TINYINT(3) NOT NULL DEFAULT 0,
  effect_fanpopularity TINYINT(3) NOT NULL DEFAULT 0,
  effect_injury TINYINT(3) NOT NULL DEFAULT 0,
  effect_income INT(10) NOT NULL DEFAULT 0,
  FOREIGN KEY (required_building_id) REFERENCES ws3_stadiumbuilding(id) ON DELETE SET NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_buildings_of_team (
  building_id INT(10) NOT NULL,
  team_id INT(10) NOT NULL,
  construction_deadline INT(11) NULL,
  FOREIGN KEY (building_id) REFERENCES ws3_stadiumbuilding(id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE,
  PRIMARY KEY (building_id, team_id)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

-- update player's age
UPDATE ws3_player SET age = TIMESTAMPDIFF(YEAR,birthday,CURDATE()) WHERE 1;

ALTER TABLE ws3_match ADD blocked ENUM('1', '0') NOT NULL DEFAULT '0';

ALTER TABLE ws3_player ADD st_assists INT(6) NOT NULL DEFAULT 0;
ALTER TABLE ws3_player ADD sa_assists INT(6) NOT NULL DEFAULT 0;
