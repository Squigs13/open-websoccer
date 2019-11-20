CREATE TABLE ws3_admin (
  id SMALLINT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(40) NULL,
  password VARCHAR(64) NULL,
  password_new VARCHAR(64) NULL,
  password_new_requested INT(11) NOT NULL DEFAULT 0,
  password_salt VARCHAR(5) NULL,
  email VARCHAR(100) NULL,
  lang VARCHAR(2) NULL,
  r_admin ENUM('1','0') NOT NULL DEFAULT '0',
  r_adminuser ENUM('1','0') NOT NULL DEFAULT '0',
  r_user ENUM('1','0') NOT NULL DEFAULT '0',
  r_data ENUM('1','0') NOT NULL DEFAULT '0',
  r_attributes ENUM('1','0') NOT NULL DEFAULT '0',
  r_matches ENUM('1','0') NOT NULL DEFAULT '0',
  r_news ENUM('1','0') NOT NULL DEFAULT '0',
  r_faq ENUM('1','0') NOT NULL DEFAULT '0',
  r_survey ENUM('1','0') NOT NULL DEFAULT '0',
  r_calendar ENUM('1','0') NOT NULL DEFAULT '0',
  r_pages ENUM('1','0') NOT NULL DEFAULT '0',
  r_design ENUM('1','0') NOT NULL DEFAULT '0',
  r_demo ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_user (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nick VARCHAR(50) NULL,
  password VARCHAR(64) NULL,
  password_new VARCHAR(64) NULL,
  password_new_requested INT(11) NOT NULL DEFAULT 0,  
  password_salt VARCHAR(5) NULL,
  tokenid VARCHAR(255) NULL,
  lang VARCHAR(2) DEFAULT 'de',
  email VARCHAR(150) NULL,
  date_registered INT(11) NOT NULL DEFAULT 0,
  activation_key VARCHAR(10) NULL,
  desired_team VARCHAR(250) NULL,
  name VARCHAR(80) NULL,
  city VARCHAR(50) NULL,
  country VARCHAR(40) NULL,
  birthday DATE NULL,
  occupation VARCHAR(50) NULL,
  interests VARCHAR(250) NULL,
  fav_club VARCHAR(100) NULL,
  homepage VARCHAR(250) NULL,
  icq VARCHAR(20) NULL,
  aim VARCHAR(30) NULL,
  yim VARCHAR(30) NULL,
  msn VARCHAR(30) NULL,
  lastonline INT(11) NOT NULL DEFAULT 0,
  lastaction VARCHAR(150) NULL,
  highscore INT(10) NOT NULL DEFAULT 0,
  popularity TINYINT(3) NOT NULL DEFAULT '50',
  c_showemail ENUM('1','0') NOT NULL DEFAULT '0',
  email_transfers ENUM('1','0') NOT NULL DEFAULT '0',
  email_pn ENUM('1','0') NOT NULL DEFAULT '0',
  history TEXT NULL,
  ip VARCHAR(25) NULL,
  ip_time INT(11) NOT NULL DEFAULT 0,
  c_hideinonlinelist ENUM('1','0') NOT NULL DEFAULT '0',
  premium_balance INT(6) NOT NULL DEFAULT 0,
  picture VARCHAR(255) NULL,
  status ENUM('1','2','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_user_inactivity (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  login TINYINT(3) NOT NULL DEFAULT '0',
  login_last INT(11) NOT NULL,
  login_check INT(11) NOT NULL,
  formation TINYINT(3) NOT NULL DEFAULT '0',
  transfer TINYINT(3) NOT NULL DEFAULT '0',
  transfer_check INT(11) NOT NULL,
  contract_expiry TINYINT(3) NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_messages (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  recipient_id INT(10) NOT NULL,
  sender_id INT(10) NOT NULL,
  sender_name VARCHAR(50) NULL,
  date INT(10) NOT NULL,
  subject VARCHAR(50) NULL,
  message TEXT NULL,
  msg_read ENUM('1','0') NOT NULL DEFAULT '0',
  type ENUM('incoming','outgoing') NOT NULL DEFAULT 'incoming'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_news (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date INT(10) NOT NULL,
  author_id SMALLINT(5) NOT NULL,
  image_id INT(10) NOT NULL,
  title VARCHAR(100) NULL,
  message TEXT NULL,
  linktext1 VARCHAR(100) NULL,
  linkurl1 VARCHAR(250) NULL,
  linktext2 VARCHAR(100) NULL,
  linkurl2 VARCHAR(250) NULL,
  linktext3 VARCHAR(100) NULL,
  linkurl3 VARCHAR(250) NULL,
  c_br ENUM('1','0') NOT NULL DEFAULT '0',
  c_links ENUM('1','0') NOT NULL DEFAULT '0',
  c_smilies ENUM('1','0') NOT NULL DEFAULT '0',
  status ENUM('1','2','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_league (
  id SMALLINT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NULL,
  short VARCHAR(5) NULL,
  country VARCHAR(25) NULL,
  p_standing TINYINT(3) NOT NULL,
  p_seat TINYINT(3) NOT NULL,
  p_main_standing TINYINT(3) NOT NULL,
  p_main_seat TINYINT(3) NOT NULL,
  p_vip TINYINT(3) NOT NULL,
  price_standing SMALLINT(5) NOT NULL,
  price_seat SMALLINT(5) NOT NULL,
  price_vip SMALLINT(5) NOT NULL,
  admin_id SMALLINT(5) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_table_marker (
  id SMALLINT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  league_id SMALLINT(5) NOT NULL,
  label VARCHAR(50) NULL,
  colour VARCHAR(10) NULL,
  positions_from SMALLINT(5) NOT NULL,
  positions_to SMALLINT(5) NOT NULL,
  target_league_id INT(10) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_season (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NULL,
  league_id SMALLINT(5) NOT NULL,
  place_1_id INT(10) NOT NULL DEFAULT 0,
  place_2_id INT(10) NOT NULL DEFAULT 0,
  place_3_id INT(10) NOT NULL DEFAULT 0,
  place_4_id INT(10) NOT NULL DEFAULT 0,
  place_5_id INT(10) NOT NULL DEFAULT 0,
  completed ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_club (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NULL,
  short VARCHAR(5) NULL,
  image VARCHAR(100) NULL,
  league_id SMALLINT(5) NULL,
  user_id INT(10) NULL,
  stadium_id INT(10) NULL,
  sponsor_id INT(10) NULL,
  training_id INT(5) NULL,
  place TINYINT(2) NULL,
  sponsor_matches SMALLINT(5) NOT NULL DEFAULT 0,
  finance_budget INT(11) NOT NULL,
  price_stand SMALLINT(4) NOT NULL,
  price_seat SMALLINT(4) NOT NULL,
  price_main_stand SMALLINT(4) NOT NULL,
  price_main_seat SMALLINT(4) NOT NULL,
  price_vip SMALLINT(4) NOT NULL,
  last_standing INT(6) NOT NULL DEFAULT 0,
  last_seat INT(6) NOT NULL DEFAULT 0,
  last_main_standing INT(6) NOT NULL DEFAULT 0,
  last_main_seat INT(6) NOT NULL DEFAULT 0,
  last_vip INT(6) NOT NULL DEFAULT 0,
  championships SMALLINT(4) NOT NULL DEFAULT 0,
  st_goals INT(6) NOT NULL DEFAULT 0,
  st_goals_conceded INT(6) NOT NULL DEFAULT 0,
  st_matches SMALLINT(5) NOT NULL DEFAULT 0,
  st_wins SMALLINT(5) NOT NULL DEFAULT 0,
  st_losses SMALLINT(5) NOT NULL DEFAULT 0,
  st_draws SMALLINT(5) NOT NULL DEFAULT 0,
  st_points INT(6) NOT NULL DEFAULT 0,
  sa_goals INT(6) NOT NULL DEFAULT 0,
  sa_goals_conceded INT(6) NOT NULL DEFAULT 0,
  sa_matches SMALLINT(5) NOT NULL DEFAULT 0,
  sa_wins SMALLINT(5) NOT NULL DEFAULT 0,
  sa_losses SMALLINT(5) NOT NULL DEFAULT 0,
  sa_draws SMALLINT(5) NOT NULL DEFAULT 0,
  sa_points INT(6) NOT NULL DEFAULT 0,
  min_target_rank SMALLINT(3) NOT NULL DEFAULT 0,
  history TEXT NULL,
  scouting_last_execution INT(11) NOT NULL DEFAULT 0,
  nationalteam ENUM('1', '0') NOT NULL DEFAULT '0',
  captain_id INT(10) NULL,
  strength TINYINT(3) NOT NULL DEFAULT 0,
  user_id_actual INT(10) NULL,
  interimmanager ENUM('1', '0') NOT NULL DEFAULT '0',
  status ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_player (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(30) NULL,
  last_name VARCHAR(30) NULL,
  nickname VARCHAR(30) NULL,
  birthday DATE NOT NULL,
  club_id INT(10) NULL,
  position ENUM('Goalkeeper','Defender','Midfielder','Forward') NOT NULL DEFAULT 'Midfielder',
  position_main ENUM('GK','LB','CB', 'RB', 'LM', 'DM', 'CM', 'AM', 'RM', 'LW', 'CF', 'RW') NULL,
  position_second ENUM('GK','LB','CB', 'RB', 'LM', 'DM', 'CM', 'AM', 'RM', 'LW', 'CF', 'RW') NULL,
  nation VARCHAR(30) NULL,
  picture VARCHAR(128) NULL,
  injured TINYINT(3) NOT NULL DEFAULT 0,
  suspended TINYINT(3) NOT NULL DEFAULT 0,
  suspended_cups TINYINT(3) NOT NULL DEFAULT 0,
  suspended_nationalteam TINYINT(3) NOT NULL DEFAULT 0,
  transfer_listed ENUM('1','0') NOT NULL DEFAULT '0',
  transfer_start INT(11) NOT NULL DEFAULT 0,
  transfer_end INT(11) NOT NULL DEFAULT 0,
  transfer_min_bid INT(11) NOT NULL DEFAULT 0,
  w_strength TINYINT(3) NOT NULL,
  w_technique TINYINT(3) NOT NULL,
  w_stamina TINYINT(3) NOT NULL,
  w_fitness TINYINT(3) NOT NULL,
  w_morale TINYINT(3) NOT NULL,
  single_training ENUM('1','0') NOT NULL DEFAULT '0',
  rating_last REAL(4,2) NOT NULL DEFAULT 0,
  rating_average REAL(4,2) NOT NULL DEFAULT 0,
  contract_salary INT(10) NOT NULL,
  contract_matches SMALLINT(5) NOT NULL,
  contract_goal_bonus INT(10) NOT NULL,
  value INT(10) NOT NULL DEFAULT 0,
  st_goals INT(6) NOT NULL DEFAULT 0,
  st_assists INT(6) NOT NULL DEFAULT 0,
  st_matches SMALLINT(5) NOT NULL DEFAULT 0,
  st_yellow_card SMALLINT(5) NOT NULL DEFAULT 0,
  st_yellow_card_2nd SMALLINT(5) NOT NULL DEFAULT 0,
  st_red_card SMALLINT(5) NOT NULL DEFAULT 0,
  sa_goals INT(6) NOT NULL DEFAULT 0,
  sa_assists INT(6) NOT NULL DEFAULT 0,
  sa_matches SMALLINT(5) NOT NULL DEFAULT 0,
  sa_yellow_card SMALLINT(5) NOT NULL DEFAULT 0,
  sa_yellow_card_2nd SMALLINT(5) NOT NULL DEFAULT 0,
  sa_red_card SMALLINT(5) NOT NULL DEFAULT 0,
  history TEXT NULL,
  unsellable ENUM('1','0') NOT NULL DEFAULT '0',
  loan_fee INT(6) NOT NULL DEFAULT 0,
  loan_matches TINYINT NOT NULL DEFAULT 0,
  loan_owner_id INT(10) NULL,
  age TINYINT(3) NULL,
  status ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_transfer_bid (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_id INT(10) NOT NULL,
  club_id INT(10) NULL,
  user_id INT(10) NOT NULL,
  date INT(11) NOT NULL,
  transfer_fee INT(11) NOT NULL,
  signing_fee INT(11) NOT NULL DEFAULT 0,
  contract_matches SMALLINT(5) NOT NULL,
  contract_salary INT(7) NOT NULL,
  contract_goal_bonus SMALLINT(5) NOT NULL DEFAULT 0,
  ishighest ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_stadium (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NULL,
  city VARCHAR(30) NULL,
  country VARCHAR(20) NULL,
  p_standing INT(6) NOT NULL,
  p_seat INT(6) NOT NULL,
  p_main_standing INT(6) NOT NULL,
  p_main_seat INT(6) NOT NULL,
  p_vip INT(6) NOT NULL,
  level_pitch TINYINT(2) NOT NULL DEFAULT 3,
  level_videowall TINYINT(2) NOT NULL DEFAULT 1,
  level_seatsquality TINYINT(2) NOT NULL DEFAULT 5,
  level_vipquality TINYINT(2) NOT NULL DEFAULT 5,
  maintenance_pitch TINYINT(2) NOT NULL DEFAULT 1,
  maintenance_videowall TINYINT(2) NOT NULL DEFAULT 1,
  maintenance_seatsquality TINYINT(2) NOT NULL DEFAULT 1,
  maintenance_vipquality TINYINT(2) NOT NULL DEFAULT 1,
  picture VARCHAR(128) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_transactions (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  club_id INT(10) NOT NULL,
  sender VARCHAR(150) NULL,
  amount INT(10) NOT NULL,
  date INT(11) NOT NULL,
  details VARCHAR(200) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_sponsor (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NULL,
  image VARCHAR(100) NULL,
  league_id SMALLINT(5) NOT NULL,
  b_match INT(10) NOT NULL,
  b_home_match INT(10) NOT NULL,
  b_win INT(10) NOT NULL,
  b_championship INT(10) NOT NULL,
  max_teams SMALLINT(5) NOT NULL,
  min_place TINYINT(3) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_training (
  id SMALLINT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NULL,
  w_strength TINYINT(3) NOT NULL,
  w_technique TINYINT(3) NOT NULL,
  w_stamina TINYINT(3) NOT NULL,
  w_fitness TINYINT(3) NOT NULL,
  w_morale TINYINT(3) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_training_camp (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NULL,
  country VARCHAR(30) NULL,
  image VARCHAR(100) NULL,
  price_player_day INT(10) NOT NULL,
  p_strength TINYINT(3) NOT NULL,
  p_technique TINYINT(3) NOT NULL,
  p_stamina TINYINT(3) NOT NULL,
  p_fitness TINYINT(3) NOT NULL,
  p_morale TINYINT(3) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_training_camp_booking (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  club_id INT(10) NOT NULL,
  camp_id INT(10) NOT NULL,
  date_start INT(10) NOT NULL,
  date_end INT(10) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_tactics (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  club_id INT(10) NOT NULL,
  date INT(11) NOT NULL,
  offensive TINYINT(3) NULL DEFAULT 50,
  player1 INT(10) NOT NULL,
  player2 INT(10) NOT NULL,
  player3 INT(10) NOT NULL,
  player4 INT(10) NOT NULL,
  player5 INT(10) NOT NULL,
  player6 INT(10) NOT NULL,
  player7 INT(10) NOT NULL,
  player8 INT(10) NOT NULL,
  player9 INT(10) NOT NULL,
  player10 INT(10) NOT NULL,
  player11 INT(10) NOT NULL,
  sub1 INT(10) NULL,
  sub2 INT(10) NULL,
  sub3 INT(10) NULL,
  sub4 INT(10) NULL,
  sub5 INT(10) NULL,
  w1_out INT(10) NULL,
  w1_in INT(10) NULL,
  w1_minute TINYINT(2) NULL,
  w2_out INT(10) NULL,
  w2_in INT(10) NULL,
  w2_minute TINYINT(2) NULL,
  w3_out INT(10) NULL,
  w3_in INT(10) NULL,
  w3_minute TINYINT(2) NULL,
  setup VARCHAR(16) NULL,
  w1_condition VARCHAR(16) NULL,
  w2_condition VARCHAR(16) NULL,
  w3_condition VARCHAR(16) NULL,
  longpasses ENUM('1', '0') NOT NULL DEFAULT '0',
  counterattacks ENUM('1', '0') NOT NULL DEFAULT '0',
  freekickplayer INT(10) NULL,
  w1_position VARCHAR(4) NULL,
  w2_position VARCHAR(4) NULL,
  w3_position VARCHAR(4) NULL,
  player1_position VARCHAR(4) NOT NULL,
  player2_position VARCHAR(4) NOT NULL,
  player3_position VARCHAR(4) NOT NULL,
  player4_position VARCHAR(4) NOT NULL,
  player5_position VARCHAR(4) NOT NULL,
  player6_position VARCHAR(4) NOT NULL,
  player7_position VARCHAR(4) NOT NULL,
  player8_position VARCHAR(4) NOT NULL,
  player9_position VARCHAR(4) NOT NULL,
  player10_position VARCHAR(4) NOT NULL,
  player11_position VARCHAR(4) NOT NULL,
  match_id INT(10) NULL REFERENCES ws3_match(id) ON DELETE CASCADE,
  templatename VARCHAR(24) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_match (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  matchtype ENUM('leaguematch','cupmatch','friendly') NOT NULL DEFAULT 'leaguematch',
  penalty_kicks ENUM('1','0') NOT NULL DEFAULT '0',
  cup_name VARCHAR(30) NULL,
  cup_round VARCHAR(30) NULL,
  cup_group VARCHAR(64) NULL,
  league_id SMALLINT(5) NULL,
  season_id INT(10) NULL,
  matchday TINYINT(3) NULL,
  date INT(10) NOT NULL,
  stadium_id INT(10) NULL,
  minutes TINYINT(3) NULL,
  player_with_ball INT(10) NULL,
  prev_player_with_ball INT(10) NULL,
  home_club INT(10) NOT NULL,
  home_noformation ENUM('1','0') DEFAULT '0',
  home_offensive TINYINT(3) NULL,
  home_offensive_changed TINYINT(2) NOT NULL DEFAULT 0,
  home_goals TINYINT(2) NULL,
  home_player1 INT(10) NULL,
  home_player2 INT(10) NULL,
  home_player3 INT(10) NULL,
  home_player4 INT(10) NULL,
  home_player5 INT(10) NULL,
  home_player6 INT(10) NULL,
  home_player7 INT(10) NULL,
  home_player8 INT(10) NULL,
  home_player9 INT(10) NULL,
  home_player10 INT(10) NULL,
  home_player11 INT(10) NULL,
  home_sub1 INT(10) NULL,
  home_sub2 INT(10) NULL,
  home_sub3 INT(10) NULL,
  home_sub4 INT(10) NULL,
  home_sub5 INT(10) NULL,
  home_w1_out INT(10) NULL,
  home_w1_in INT(10) NULL,
  home_w1_minute TINYINT(2) NULL,
  home_w2_out INT(10) NULL,
  home_w2_in INT(10) NULL,
  home_w2_minute TINYINT(2) NULL,
  home_w3_out INT(10) NULL,
  home_w3_in INT(10) NULL,
  home_w3_minute TINYINT(2) NULL,
  guest_club INT(10) NOT NULL,
  guest_goals TINYINT(2) NULL,
  guest_noformation ENUM('1','0') DEFAULT '0',
  guest_offensive TINYINT(3) NULL,
  guest_offensive_changed TINYINT(2) NOT NULL DEFAULT 0,
  guest_player1 INT(10) NULL,
  guest_player2 INT(10) NULL,
  guest_player3 INT(10) NULL,
  guest_player4 INT(10) NULL,
  guest_player5 INT(10) NULL,
  guest_player6 INT(10) NULL,
  guest_player7 INT(10) NULL,
  guest_player8 INT(10) NULL,
  guest_player9 INT(10) NULL,
  guest_player10 INT(10) NULL,
  guest_player11 INT(10) NULL,
  guest_sub1 INT(10) NULL,
  guest_sub2 INT(10) NULL,
  guest_sub3 INT(10) NULL,
  guest_sub4 INT(10) NULL,
  guest_sub5 INT(10) NULL,
  guest_w1_out INT(10) NULL,
  guest_w1_in INT(10) NULL,
  guest_w1_minute TINYINT(2) NULL,
  guest_w2_out INT(10) NULL,
  guest_w2_in INT(10) NULL,
  guest_w2_minute TINYINT(2) NULL,
  guest_w3_out INT(10) NULL,
  guest_w3_in INT(10) NULL,
  guest_w3_minute TINYINT(2) NULL,
  report TEXT NULL,
  crowd INT(6) NULL,
  simulated ENUM('1','0') NOT NULL DEFAULT '0',
  soldout ENUM('1','0') NOT NULL DEFAULT '0',
  home_setup VARCHAR(16) NULL,
  home_w1_condition VARCHAR(16) NULL,
  home_w2_condition VARCHAR(16) NULL,
  home_w3_condition VARCHAR(16) NULL,
  guest_setup VARCHAR(16) NULL,
  guest_w1_condition VARCHAR(16) NULL,
  guest_w2_condition VARCHAR(16) NULL,
  guest_w3_condition VARCHAR(16) NULL,
  home_longpasses ENUM('1', '0') NOT NULL DEFAULT '0',
  home_counterattacks ENUM('1', '0') NOT NULL DEFAULT '0',
  guest_longpasses ENUM('1', '0') NOT NULL DEFAULT '0',
  guest_counterattacks ENUM('1', '0') NOT NULL DEFAULT '0',
  home_morale TINYINT(3) NOT NULL DEFAULT 0,
  guest_morale TINYINT(3) NOT NULL DEFAULT 0,
  home_user_id INT(10) NULL,
  guest_user_id INT(10) NULL,
  home_freekickplayer INT(10) NULL,
  home_w1_position VARCHAR(4) NULL,
  home_w2_position VARCHAR(4) NULL,
  home_w3_position VARCHAR(4) NULL,
  guest_freekickplayer INT(10) NULL,
  guest_w1_position VARCHAR(4) NULL,
  guest_w2_position VARCHAR(4) NULL,
  guest_w3_position VARCHAR(4) NULL,
  blocked ENUM('1', '0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_match_simulation (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT(10) NOT NULL,
  player_id INT(10) NOT NULL,
  team_id INT(10) NOT NULL,
  position VARCHAR(20) NULL,
  rating REAL(4,2) NOT NULL,
  minutes_played TINYINT(2) NOT NULL DEFAULT 0,
  yellow_card TINYINT(1) NOT NULL DEFAULT 0,
  red_card TINYINT(1) NOT NULL DEFAULT 0,
  injured TINYINT(2) NOT NULL DEFAULT 0,
  suspended TINYINT(2) NOT NULL DEFAULT 0,
  goals TINYINT(2) NOT NULL DEFAULT 0,
  field ENUM('1','Bench','Substituted') NOT NULL DEFAULT '1',
  position_main VARCHAR(5) NULL,
  age TINYINT(2) NULL,
  w_strength TINYINT(3) NULL,
  w_technique TINYINT(3) NULL,
  w_stamina TINYINT(3) NULL,
  w_fitness TINYINT(3) NULL,
  w_morale TINYINT(3) NULL,
  touches TINYINT(3) NULL,
  wontackles TINYINT(3) NULL,
  shots TINYINT(3) NULL,
  passes_successful TINYINT(3) NULL,
  passes_failed TINYINT(3) NULL,
  assists TINYINT(3) NULL,
  name VARCHAR(128) NULL,
  losttackles TINYINT(3) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_match_text (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  action_type ENUM(  'Goal',  'Substitution',  'Tackle_won',  'Tackle_lost',  'Pass_missed',  'Shot_missed',  'Shot_on_target',  'Yellow_card',  'Red_card',  'Yellow_card_2nd',  'Injury', 'Penalty_scored',  'Penalty_missed', 'Tactics_changed', 'Corner', 'Freekick_missed', 'Freekick_scored', 'Goal_with_assist' ),
  message VARCHAR(250) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_transfer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_id INT(10) NOT NULL,
  seller_user_id INT(10) NULL,
  seller_club_id INT(10) NULL,
  buyer_user_id INT(10) NULL,
  buyer_club_id INT(10) NOT NULL,
  date INT(11) NOT NULL,
  bid_id INT(11) NOT NULL DEFAULT 0,
  directtransfer_amount INT(10) NOT NULL,
  directtransfer_player1 INT(10) NOT NULL DEFAULT 0,
  directtransfer_player2 INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_session (
  session_id CHAR(32) NOT NULL PRIMARY KEY,
  session_data TEXT NOT NULL,
  expires INT(11) NOT NULL
)  DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_matchreport (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  match_id INT(10) NOT NULL,
  message_id INT(10) NOT NULL,
  minute TINYINT(3) NOT NULL,
  goals VARCHAR(8) NULL,
  playernames VARCHAR(128) NULL,
  active_home TINYINT(1) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_trainer (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  salary INT(10) NOT NULL,
  p_technique TINYINT(3) NOT NULL DEFAULT '0',
  p_stamina TINYINT(3) NOT NULL DEFAULT '0',
  premiumfee INT(10) NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_training_unit (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT(10) NOT NULL,
  trainer_id INT(10) NOT NULL,
  focus ENUM('TE','STA','MOT','FR') NOT NULL DEFAULT 'TE',
  intensity TINYINT(3) NOT NULL DEFAULT '50',
  date_executed INT(10) NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_cup (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL UNIQUE,
  winner_id INT(10) NULL,
  logo VARCHAR(128) NULL,
  winner_award INT(10) NOT NULL DEFAULT 0,
  second_award INT(10) NOT NULL DEFAULT 0,
  perround_award INT(10) NOT NULL DEFAULT 0,
  archived ENUM('1','0') NOT NULL DEFAULT '0'
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_cup_round_pending (
  team_id INT(10) NOT NULL,
  cup_round_id INT(10) NOT NULL,
  PRIMARY KEY(team_id, cup_round_id)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_cup_round_group_next (
  cup_round_id INT(10) NOT NULL,
  groupname VARCHAR(64) NOT NULL,
  rank INT(4) NOT NULL DEFAULT 0,
  target_cup_round_id INT(10) NOT NULL,
  PRIMARY KEY(cup_round_id, groupname, rank)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_notification (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  eventdate INT(11) NOT NULL,
  eventtype VARCHAR(128) NULL,
  message_key VARCHAR(255) NULL,
  message_data VARCHAR(255) NULL,
  target_pageid VARCHAR(128) NULL,
  target_querystr VARCHAR(255) NULL,
  seen ENUM('1','0') NOT NULL DEFAULT '0',
  team_id INT(10) NULL REFERENCES ws3_club(id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
  home_s1_position VARCHAR(4) NULL,
  home_s2_out INT(10) NULL,
  home_s2_in INT(10) NULL,
  home_s2_minute TINYINT(3) NULL,
  home_s2_condition VARCHAR(16) NULL,
  home_s2_position VARCHAR(4) NULL,
  home_s3_out INT(10) NULL,
  home_s3_in INT(10) NULL,
  home_s3_minute TINYINT(3) NULL,
  home_s3_condition VARCHAR(16) NULL,
  home_s3_position VARCHAR(4) NULL,
  guest_team_id INT(10) NOT NULL,
  guest_noformation ENUM('1','0') DEFAULT '0',
  guest_s1_out INT(10) NULL,
  guest_s1_in INT(10) NULL,
  guest_s1_minute TINYINT(3) NULL,
  guest_s1_condition VARCHAR(16) NULL,
  guest_s1_position VARCHAR(4) NULL,
  guest_s2_out INT(10) NULL,
  guest_s2_in INT(10) NULL,
  guest_s2_minute TINYINT(3) NULL,
  guest_s2_condition VARCHAR(16) NULL,
  guest_s2_position VARCHAR(4) NULL,
  guest_s3_out INT(10) NULL,
  guest_s3_in INT(10) NULL,
  guest_s3_minute TINYINT(3) NULL,
  guest_s3_condition VARCHAR(16) NULL,
  guest_s3_position VARCHAR(4) NULL,
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
  reliability TINYINT(3) NOT NULL DEFAULT 100,
  premiumfee INT(10) NOT NULL DEFAULT 0
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
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_nationalplayer (
  team_id INT(10) NOT NULL,
  player_id INT(10) NOT NULL,
  PRIMARY KEY (team_id, player_id)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_premiumstatement (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  action_id VARCHAR(255) NULL,
  amount INT(10) NOT NULL,
  created_date INT(11) NOT NULL,
  subject_data VARCHAR(255) NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_premiumpayment (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT(10) NOT NULL,
  amount INT(10) NOT NULL,
  created_date INT(11) NOT NULL
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

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
  matchday TINYINT(3) NOT NULL,
  rank TINYINT(3) NULL,
  FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE,
  FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE SET NULL,
  PRIMARY KEY(team_id, season_id, matchday)
) DEFAULT CHARSET=utf8, ENGINE=InnoDB;

CREATE TABLE ws3_randomevent (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255) NULL,
  effect ENUM('money', 'player_injured', 'player_suspended', 'player_happiness', 'player_fitness', 'player_stamina') NOT NULL,
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

INSERT INTO ws3_match_text (action_type, message) VALUES
('Goal', '<b>Tor von {sp1}!</b>'),
('Goal', '<b>{sp1} schießt..... TOR!</b>'),
('Goal', '<b>TOR - wunderschön gemacht von {sp1}</b>'),
('Goal', '<b>{sp1} schießt auf das Tor... und der Ball ist drin!</b>'),
('Substitution', '<i>{sp1} kommt für {sp2}.</i>'),
('Tackle_won', '{sp1} geht auf seinen Gegenspieler zu und gewinnt den Zweikampf!'),
('Tackle_won', '{sp1} in einem Zweikampf.... gewonnen!'),
('Tackle_won', '{sp1} läuft mit dem Ball am Fuß auf seinen Gegenspieler zu... und gewinnt den Zweikampf.'),
('Tackle_won', '{sp1} nimmt seinem Gegenspieler gekonnt den Ball von den Füßen.'),
('Tackle_lost', '{sp1} geht auf {sp2} zu... und verliert den Zweikampf.'),
('Tackle_lost', '{sp1} in einem Zweikampf.... und verliert ihn.'),
('Tackle_lost', '{sp1} geht mit dem Ball am Fuß auf seinen Gegenspieler zu... und verliert ihn.'),
('Tackle_lost', '{sp1} sieht seinen Gegenspieler gegenüber und lässt sich den Ball abnehmen.'),
('Pass_missed', 'Flanke von {sp1}... in die Wolken!'),
('Pass_missed', '{sp1} passt den Ball in die Mitte... genau auf die Füße des Gegners.'),
('Pass_missed', '{sp1} passt den Ball steil nach vorne... Abschlag!'),
('Pass_missed', 'Pass von {sp1}... ins Seitenaus.'),
('Shot_missed', '{sp1} hat freie Bahn und schießt... weit über das Tor.'),
('Shot_missed', '{sp1} schießt..... daneben.'),
('Shot_missed', '{sp1} schießt auf das Tor... aber genau auf den Goalkeeper.'),
('Shot_missed', 'Kopfball {sp1}... daneben.'),
('Shot_missed', '{sp1} haut mit aller Kraft auf den Ball... Abschlag.'),
('Shot_missed', '{sp1} schießt..... in die Wolken.'),
('Shot_on_target', '{sp1} schießt..... Glanzparade des Torwarts!'),
('Shot_on_target', '{sp1} schießt auf das Tor... aber der Goalkeeper macht einen Hechtsprung und hat den Ball.'),
('Shot_on_target', '{sp1} hat freie Bahn und schießt... aber der Goalkeeper kann den Ball gerade noch so um den Pfosten drehen.'),
('Shot_on_target', '{sp1} kommt zum Kopfball... ganz knapp daneben.'),
('Goal', '<b>{sp1} kommt zum Kopfball... und da flattert der Ball im Netz!</b>'),
('Yellow_card', '{sp1} bekommt nach einem Foul die gelbe Karte.'),
('Yellow_card', '{sp1} sieht die gelbe Karte.'),
('Yellow_card', '{sp1} haut seinen Gegenspieler um und bekommt dafür die gelbe Karte.'),
('Red_card', '<i>{sp1} springt von hinten in die Beine seines Gegenspielers und sieht sofort die Rote Karte.</i>'),
('Red_card', '<i>{sp1} haut seinen Gegenspieler um und sieht dafür die Rote Karte.</i>'),
('Red_card', '<i>{sp1} bekommt die Rote Karte wegen Prügelei.</i>'),
('Yellow_card_2nd', '<i>{sp1} sieht die Gelb-Rote Karte und muss vom Platz.</i>'),
('Yellow_card_2nd', '<i>{sp1} haut seinen Gegenspieler um und bekommt dafür die Gelb-Rote Karte.</i>'),
('Red_card', '<i>{sp1} sieht nach einem bösen Foul die Rote Karte und muss vom Platz.</i>'),
('Injury', '<i>{sp1} ist injured und muss vom Spielfeld getragen werden.</i>'),
('Injury', '<i>{sp1} hat sich injured und kann nicht mehr weiterspielen.</i>'),
('Penalty_scored', '{sp1} tritt an: Und trifft!'),
('Penalty_missed', '{sp1} tritt an: Aber {sp2} hält den Ball!!'),
('Penalty_missed', '{sp1} legt sich den Ball zurecht. Etwas unsicherer Anlauf... und haut den Ball über das Tor.'),
('Tactics_changed', '{sp1} ändert die Taktik.'),
('Corner', 'Corner für {ma1}. {sp1} spielt auf {sp2}...'),
('Freekick_missed', 'Freistoß für {ma1}! {sp1} schießt, aber zu ungenau.'),
('Freekick_scored', '{sp1} tritt den direkten Freistoß und trifft!'),
('Goal_with_assist', 'Tooor für {ma1}! {sp2} legt auf {sp1} ab, der nur noch einschieben muss.');

ALTER TABLE ws3_user_inactivity ADD CONSTRAINT ws3_user_inactivity_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_messages ADD CONSTRAINT ws3_messages_user_id_fk FOREIGN KEY (sender_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_club ADD CONSTRAINT ws3_club_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT ws3_club_stadium_id_fk FOREIGN KEY (stadium_id) REFERENCES ws3_stadium(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT ws3_club_sponsor_id_fk FOREIGN KEY (sponsor_id) REFERENCES ws3_sponsor(id) ON DELETE SET NULL;
ALTER TABLE ws3_club ADD CONSTRAINT ws3_club_league_id_fk FOREIGN KEY (league_id) REFERENCES ws3_league(id) ON DELETE CASCADE;
ALTER TABLE ws3_player ADD CONSTRAINT ws3_player_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transactions ADD CONSTRAINT ws3_transactions_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_bid ADD CONSTRAINT ws3_transfer_bid_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_training_camp_booking ADD CONSTRAINT ws3_training_camp_booking_fk FOREIGN KEY (camp_id) REFERENCES ws3_training_camp(id) ON DELETE CASCADE;
ALTER TABLE ws3_training_camp_booking ADD CONSTRAINT ws3_training_camp_club_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_tactics ADD CONSTRAINT ws3_tactics_club_id_fk FOREIGN KEY (club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_match ADD CONSTRAINT ws3_match_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;
ALTER TABLE ws3_match ADD CONSTRAINT ws3_match_home_id_fk FOREIGN KEY (home_club) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_match ADD CONSTRAINT ws3_match_guest_id_fk FOREIGN KEY (guest_club) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_match_simulation ADD CONSTRAINT ws3_simulation_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_match(id) ON DELETE CASCADE;
ALTER TABLE ws3_match_simulation ADD CONSTRAINT ws3_simulation_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer ADD CONSTRAINT ws3_transfer_matchesr_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer ADD CONSTRAINT ws3_transfer_selleruser_fk FOREIGN KEY (seller_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_transfer ADD CONSTRAINT ws3_transfer_sellerclub_fk FOREIGN KEY (seller_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer ADD CONSTRAINT ws3_transfer_buyeruser_fk FOREIGN KEY (buyer_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_transfer ADD CONSTRAINT ws3_transfer_buyerclub_fk FOREIGN KEY (buyer_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_matchreport ADD CONSTRAINT ws3_matchreport_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_match(id) ON DELETE CASCADE;
ALTER TABLE ws3_matchreport ADD CONSTRAINT ws3_matchreport_message_id_fk FOREIGN KEY (message_id) REFERENCES ws3_match_text(id) ON DELETE CASCADE;
ALTER TABLE ws3_training_unit ADD CONSTRAINT ws3_training_club_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup ADD CONSTRAINT ws3_cup_winner_id_fk FOREIGN KEY (winner_id) REFERENCES ws3_club(id) ON DELETE SET NULL;
ALTER TABLE ws3_cup_round ADD CONSTRAINT ws3_cupround_cup_id_fk FOREIGN KEY (cup_id) REFERENCES ws3_cup(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round ADD CONSTRAINT ws3_cupround_fromwinners_id_fk FOREIGN KEY (from_winners_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round ADD CONSTRAINT ws3_cupround_fromloser_id_fk FOREIGN KEY (from_loser_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_pending ADD CONSTRAINT ws3_cuproundpending_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_pending ADD CONSTRAINT ws3_cuproundpending_round_fk FOREIGN KEY (cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_group ADD CONSTRAINT ws3_cupgroup_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_group_next ADD CONSTRAINT ws3_groupnext_round_fk FOREIGN KEY (cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_cup_round_group_next ADD CONSTRAINT ws3_groupnext_tagetround_fk FOREIGN KEY (target_cup_round_id) REFERENCES ws3_cup_round(id) ON DELETE CASCADE;
ALTER TABLE ws3_team_league_statistics ADD CONSTRAINT ws3_statistics_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_team_league_statistics ADD CONSTRAINT ws3_statistics_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT ws3_toffer_matchesr_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT ws3_toffer_selleruser_fk FOREIGN KEY (sender_user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT ws3_toffer_sellerclub_fk FOREIGN KEY (sender_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_transfer_offer ADD CONSTRAINT ws3_toffer_buyerclub_fk FOREIGN KEY (receiver_club_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_notification ADD CONSTRAINT ws3_notification_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthplayer ADD CONSTRAINT ws3_youthplayer_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_request ADD CONSTRAINT ws3_youthrequest_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch ADD CONSTRAINT ws3_youthmatch_home_id_fk FOREIGN KEY (home_team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch ADD CONSTRAINT ws3_youthmatch_guest_id_fk FOREIGN KEY (guest_team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ws3_ymatchplayer_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ws3_ymatchplayer_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_youthplayer(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_player ADD CONSTRAINT ws3_ymatchplayer_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE;
ALTER TABLE ws3_youthmatch_reportitem ADD CONSTRAINT ws3_ymatchreport_match_id_fk FOREIGN KEY (match_id) REFERENCES ws3_youthmatch(id) ON DELETE CASCADE;
ALTER TABLE ws3_stadium_construction ADD CONSTRAINT ws3_construction_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_stadium_construction ADD CONSTRAINT ws3_construction_builder_id_fk FOREIGN KEY (builder_id) REFERENCES ws3_stadium_builder(id) ON DELETE CASCADE;
ALTER TABLE ws3_teamoftheday ADD CONSTRAINT ws3_teamofday_season_id_fk FOREIGN KEY (season_id) REFERENCES ws3_season(id) ON DELETE CASCADE;
ALTER TABLE ws3_teamoftheday ADD CONSTRAINT ws3_teamofday_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_nationalplayer ADD CONSTRAINT ws3_nationalp_player_id_fk FOREIGN KEY (player_id) REFERENCES ws3_player(id) ON DELETE CASCADE;
ALTER TABLE ws3_nationalplayer ADD CONSTRAINT ws3_nationalp_team_id_fk FOREIGN KEY (team_id) REFERENCES ws3_club(id) ON DELETE CASCADE;
ALTER TABLE ws3_premiumstatement ADD CONSTRAINT ws3_premium_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_premiumpayment ADD CONSTRAINT ws3_premiumpayment_user_id_fk FOREIGN KEY (user_id) REFERENCES ws3_user(id) ON DELETE CASCADE;
ALTER TABLE ws3_club ADD CONSTRAINT ws3_club_original_user_id_fk FOREIGN KEY (user_id_actual) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_match ADD CONSTRAINT ws3_match_home_user_id_fk FOREIGN KEY (home_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;
ALTER TABLE ws3_match ADD CONSTRAINT ws3_match_guest_user_id_fk FOREIGN KEY (guest_user_id) REFERENCES ws3_user(id) ON DELETE SET NULL;