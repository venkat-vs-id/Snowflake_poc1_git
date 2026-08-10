---- Load soccer data from workspace into stage and knowledge graph tables
USE DATABASE POC1_DB;
USE SCHEMA SOCCER;

-- =====================================================
-- Create stage for loading data files
-- =====================================================
CREATE OR REPLACE STAGE SOCCER_DATA_STAGE
    FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = TRUE);

-- Load data files into the stage.
COPY FILES INTO @SOCCER_DATA_STAGE
FROM 'snow://workspace/USER$.PUBLIC."Snowflake_poc1_git_ws"/versions/live/data';

---- List all files in the STAGE dir
LIST @SOCCER_DATA_STAGE;


-- =====================================================
-- Load Data from STAGE Files
-- =====================================================

----------------------------------------------------------------
-- Create PERSONS table and load data from persons.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE PERSONS (
    PERSON_ID INT PRIMARY KEY,
    NAME VARCHAR,
    NATIONALITY VARCHAR,
    DATE_OF_BIRTH DATE,
    ROLE VARCHAR,
    POSITION VARCHAR,
    CREATED_AT DATE
);

COPY INTO PERSONS (PERSON_ID, NAME, NATIONALITY, DATE_OF_BIRTH, ROLE, POSITION, CREATED_AT)
FROM (
    SELECT
        $1:PERSON_ID::INT,
        $1:NAME::VARCHAR,
        $1:NATIONALITY::VARCHAR,
        $1:DATE_OF_BIRTH::DATE,
        $1:ROLE::VARCHAR,
        $1:POSITION::VARCHAR,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/persons.json
);

----------------------------------------------------------------
-- Create CLUBS table and load data from clubs.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE CLUBS (
    CLUB_ID INT PRIMARY KEY,
    CLUB_NAME VARCHAR,
    COUNTRY VARCHAR,
    LEAGUE VARCHAR,
    FOUNDED_YEAR INT,
    STADIUM VARCHAR,
    CREATED_AT DATE
);

COPY INTO CLUBS (CLUB_ID, CLUB_NAME, COUNTRY, LEAGUE, FOUNDED_YEAR, STADIUM, CREATED_AT)
FROM (
    SELECT
        $1:CLUB_ID::INT,
        $1:CLUB_NAME::VARCHAR,
        $1:COUNTRY::VARCHAR,
        $1:LEAGUE::VARCHAR,
        $1:FOUNDED_YEAR::INT,
        $1:STADIUM::VARCHAR,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/clubs.json
);

----------------------------------------------------------------
-- Create COACH_CONTRACTS table and load data from coach_contracts.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE COACH_CONTRACTS (
    CONTRACT_ID INT PRIMARY KEY,
    PERSON_ID INT,
    CLUB_ID INT,
    START_DATE DATE,
    END_DATE DATE,
    CONTRACT_VALUE INT,
    CREATED_AT DATE
);

COPY INTO COACH_CONTRACTS (CONTRACT_ID, PERSON_ID, CLUB_ID, START_DATE, END_DATE, CONTRACT_VALUE, CREATED_AT)
FROM (
    SELECT
        $1:CONTRACT_ID::INT,
        $1:PERSON_ID::INT,
        $1:CLUB_ID::INT,
        $1:START_DATE::DATE,
        $1:END_DATE::DATE,
        $1:CONTRACT_VALUE::INT,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/coach_contracts.json
);

----------------------------------------------------------------
-- Create MATCH_APPEARANCES table and load data from match_appearances.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE MATCH_APPEARANCES (
    APPEARANCE_ID INT PRIMARY KEY,
    PERSON_ID INT,
    MATCH_ID INT,
    MINUTES_PLAYED INT,
    GOALS_SCORED INT,
    ASSISTS INT,
    YELLOW_CARDS INT,
    RED_CARDS INT,
    CREATED_AT DATE
);

COPY INTO MATCH_APPEARANCES (APPEARANCE_ID, PERSON_ID, MATCH_ID, MINUTES_PLAYED, GOALS_SCORED, ASSISTS, YELLOW_CARDS, RED_CARDS, CREATED_AT)
FROM (
    SELECT
        $1:APPEARANCE_ID::INT,
        $1:PERSON_ID::INT,
        $1:MATCH_ID::INT,
        $1:MINUTES_PLAYED::INT,
        $1:GOALS_SCORED::INT,
        $1:ASSISTS::INT,
        $1:YELLOW_CARDS::INT,
        $1:RED_CARDS::INT,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/match_appearances.json
);

----------------------------------------------------------------
-- Create MATCHES table and load data from matches.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE MATCHES (
    MATCH_ID INT PRIMARY KEY,
    MATCH_NAME VARCHAR,
    EVENT_DATE DATE,
    VENUE VARCHAR,
    HOME_TEAM_ID INT,
    AWAY_TEAM_ID INT,
    SCORE_HOME INT,
    SCORE_AWAY INT,
    COMPETITION VARCHAR,
    CREATED_AT DATE
);

COPY INTO MATCHES (MATCH_ID, MATCH_NAME, EVENT_DATE, VENUE, HOME_TEAM_ID, AWAY_TEAM_ID, SCORE_HOME, SCORE_AWAY, COMPETITION, CREATED_AT)
FROM (
    SELECT
        $1:MATCH_ID::INT,
        $1:MATCH_NAME::VARCHAR,
        $1:EVENT_DATE::DATE,
        $1:VENUE::VARCHAR,
        $1:HOME_TEAM_ID::INT,
        $1:AWAY_TEAM_ID::INT,
        $1:SCORE_HOME::INT,
        $1:SCORE_AWAY::INT,
        $1:COMPETITION::VARCHAR,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/matches.json
);

----------------------------------------------------------------
-- Create PLAYER_CONTRACTS table and load data from player_contracts.json
----------------------------------------------------------------
CREATE OR REPLACE TABLE PLAYER_CONTRACTS (
    CONTRACT_ID INT PRIMARY KEY,
    PERSON_ID INT,
    CLUB_ID INT,
    START_DATE DATE,
    END_DATE DATE,
    CONTRACT_VALUE INT,
    JERSEY_NUMBER INT,
    CREATED_AT DATE
);

COPY INTO PLAYER_CONTRACTS (CONTRACT_ID, PERSON_ID, CLUB_ID, START_DATE, END_DATE, CONTRACT_VALUE, JERSEY_NUMBER, CREATED_AT)
FROM (
    SELECT
        $1:CONTRACT_ID::INT,
        $1:PERSON_ID::INT,
        $1:CLUB_ID::INT,
        $1:START_DATE::DATE,
        $1:END_DATE::DATE,
        $1:CONTRACT_VALUE::INT,
        $1:JERSEY_NUMBER::INT,
        $1:CREATED_AT::DATE
    FROM @SOCCER_DATA_STAGE/player_contracts.json
);

