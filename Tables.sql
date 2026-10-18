SHOW VARIABLES LIKE "secure_file_priv";

-- ------------------------------------------------
--  create database
CREATE DATABASE varzesh3_db;


-- ------------------------------------------------
-- Tournament
-- ------------------------------------------------
CREATE TABLE Tournament (
    GameID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Gender ENUM('Male','Female') NOT NULL,
    Host VARCHAR(100) NOT NULL,
    SeasonYear INT NOT NULL,
    NationalOrClubOrClubInternational ENUM('National','Club','ClubInternational') NOT NULL
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Tournament.csv'
INTO TABLE Tournament
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID, Name, Gender, Host, SeasonYear, NationalOrClubOrClubInternational);
-- ------------------------------------------------
-- League
-- ------------------------------------------------
CREATE TABLE League (
    GameID INT PRIMARY KEY,
    FOREIGN KEY (GameID)
        REFERENCES Tournament(GameID)
        ON DELETE CASCADE
);

LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/League.csv'
INTO TABLE League
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID);
-- ------------------------------------------------
-- Cup
-- ------------------------------------------------
CREATE TABLE Cup (
    GameID INT PRIMARY KEY,
    FOREIGN KEY (GameID)
        REFERENCES Tournament(GameID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Cup.csv'
INTO TABLE Cup
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID);

-- ------------------------------------------------
-- WorldCup
-- ------------------------------------------------
CREATE TABLE WorldCup (
    GameID INT PRIMARY KEY,
    FOREIGN KEY (GameID)
        REFERENCES Cup(GameID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/WorldCup.csv'
INTO TABLE WorldCup
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID);
-- ------------------------------------------------
-- Stadium
-- ------------------------------------------------
CREATE TABLE Stadium (
    StadiumID INT PRIMARY KEY,
    StadiumName VARCHAR(100) NOT NULL UNIQUE
);

LOAD DATA INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Stadium.csv'
INTO TABLE Stadium
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(StadiumID, StadiumName);
-- ------------------------------------------------
-- Stage
-- ------------------------------------------------
CREATE TABLE Stage (
    GameID INT NOT NULL,
    StageID INT NOT NULL,
    StageName VARCHAR(100) NOT NULL,
    PRIMARY KEY (GameID, StageID),
    FOREIGN KEY (GameID)
	REFERENCES Cup(GameID)
	ON DELETE CASCADE
);

LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Stage.csv'
INTO TABLE Stage
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID, StageID, StageName);
-- ------------------------------------------------
-- Weak
-- ------------------------------------------------
CREATE TABLE Weak (
    GameID INT NOT NULL,
    WeakID INT NOT NULL,
    WeakNumber INT NOT NULL,
    PRIMARY KEY (GameID, WeakID),
    FOREIGN KEY (GameID)
        REFERENCES League(GameID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Weak.csv'
INTO TABLE Weak
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID, WeakID, WeakNumber);

-- ------------------------------------------------
-- User
-- ------------------------------------------------
CREATE TABLE `User` (
    UserID INT PRIMARY KEY,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Nickname VARCHAR(50) NOT NULL UNIQUE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/User.csv'
INTO TABLE `User`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(UserID, PhoneNumber, FirstName, LastName, Nickname);

-- ------------------------------------------------
-- Group
-- ------------------------------------------------
CREATE TABLE `Group` (
    GameID INT NOT NULL,
    GroupID INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    PRIMARY KEY (GameID, GroupID),
    FOREIGN KEY (GameID)
        REFERENCES WorldCup(GameID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Group.csv'
INTO TABLE `Group`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID,GroupID,Name);
-- ==================================================
-- Match
-- ==================================================

CREATE TABLE `Match` (
    MatchID INT PRIMARY KEY,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Hour TIME NOT NULL,
    WeakID INT ,
    EnzebatiOrNot ENUM('Enzebati','Not') NOT NULL,
    GroupID INT ,
    GameID INT NOT NULL,
    StageID INT,
    StadiumID INT NOT NULL,
    FOREIGN KEY (GameID, GroupID) REFERENCES `Group`(GameID, GroupID) ON DELETE CASCADE,
    FOREIGN KEY (GameID, StageID) REFERENCES Stage(GameID, StageID) ON DELETE CASCADE,
    FOREIGN KEY (GameID, WeakID) REFERENCES Weak(GameID, WeakID) ON DELETE CASCADE,
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID) ON DELETE CASCADE,
    CHECK (Month BETWEEN 1 AND 12),
    --  دقیقاً یکی مقدار داشته باشد
    CHECK (
        (GroupID IS NOT NULL AND StageID IS NULL AND WeakID IS NULL)
        OR
        (GroupID IS NULL AND StageID IS NOT NULL AND WeakID IS NULL)
        OR
        (GroupID IS NULL AND StageID IS NULL AND WeakID IS NOT NULL)
    )
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Match.csv'
INTO TABLE `Match`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchID,Year,Month,Hour,WeakID,EnzebatiOrNot,GroupID,GameID,StageID,StadiumID);

-- ==================================================
-- MatchParticipant
-- ==================================================
CREATE TABLE MatchParticipant (
    MatchParticipantID INT,
    Team_ID INT NOT NULL,
    MatchID INT NOT NULL,
    HostOrGuest ENUM('Host','Guest') NOT NULL,
    Structure VARCHAR(50) NOT NULL,
    TotalPass INT NOT NULL,
    FoulsNumber INT NOT NULL,
    SavesNumber INT NOT NULL,
    PassesAccuracyPercentage DECIMAL(5,2) NOT NULL,
    TotalSuccessfulPass INT NOT NULL,
    FreeKicksNumber INT NOT NULL,
    ShotsWideNumber INT NOT NULL,
    OffsideNumber INT NOT NULL,
    ShotsOnTargetNumber INT NOT NULL,
    BlockedShotsNumber INT NOT NULL,
    CornerNumber INT NOT NULL,
    BigChancesNumber INT NOT NULL,
    ExpectedGoalsNumber DECIMAL(5,2) NOT NULL,
    PRIMARY KEY(MatchParticipantID,MatchID),
    FOREIGN KEY (Team_ID) REFERENCES Team(Team_ID) ON DELETE CASCADE,
    FOREIGN KEY (MatchID) REFERENCES `Match`(MatchID) ON DELETE CASCADE,
    CHECK (PassesAccuracyPercentage BETWEEN 0 AND 100),
    CHECK (ExpectedGoalsNumber >= 0)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/MatchParticipant.csv'
INTO TABLE MatchParticipant
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchParticipantID,Team_ID,MatchID,HostOrGuest,Structure,TotalPass,FoulsNumber,SavesNumber,PassesAccuracyPercentage,TotalSuccessfulPass,FreeKicksNumber,ShotsWideNumber,OffsideNumber,ShotsOnTargetNumber,BlockedShotsNumber,CornerNumber,BigChancesNumber,ExpectedGoalsNumber);
-- ==================================================
-- MatchReport
-- ==================================================
CREATE TABLE MatchReport (
    MatchReportID INT PRIMARY KEY,
    MatchID INT NOT NULL,
    DelayedOrNot ENUM('Delayed','OnTime') NOT NULL,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/MatchReport.csv'
INTO TABLE MatchReport
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchReportID,MatchID,DelayedOrNot);
-- ------------------------------------------------
-- Content
-- ------------------------------------------------
CREATE TABLE Content (
    ContentID INT PRIMARY KEY,
    Month INT NOT NULL,
    Year INT NOT NULL,
    Hour TIME NOT NULL,
    CHECK (Month BETWEEN 1 AND 12)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Content.csv'
INTO TABLE Content
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, Month, Year, Hour);




-- ------------------------------------------------
-- MultiMedia
-- ------------------------------------------------
CREATE TABLE MultiMedia (
    ContentID INT PRIMARY KEY,
    Description TEXT,
    ViewCount INT NOT NULL DEFAULT 0,
    Title VARCHAR(200) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES Content(ContentID)
        ON DELETE CASCADE,
    CHECK (ViewCount >= 0)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/MultiMedia.csv'
INTO TABLE MultiMedia
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, Description, ViewCount, Title);
-- ------------------------------------------------
-- Podcast
-- ------------------------------------------------
CREATE TABLE Podcast (
    ContentID INT PRIMARY KEY,
    VoiceFile VARCHAR(255) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES MultiMedia(ContentID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Podcast.csv'
INTO TABLE Podcast
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, VoiceFile);
-- ------------------------------------------------
-- News
-- ------------------------------------------------
CREATE TABLE News (
    ContentID INT PRIMARY KEY,
    MatchReportID INT NOT NULL,
    Video VARCHAR(255),
    Photo VARCHAR(255),
    FOREIGN KEY (ContentID)
        REFERENCES MultiMedia(ContentID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE
);


LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/News.csv'
INTO TABLE News
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, MatchReportID, Video, Photo);

-- ------------------------------------------------
-- PhotoGallery
-- ------------------------------------------------
CREATE TABLE PhotoGallery (
    ContentID INT PRIMARY KEY,
    MatchReportID INT NOT NULL,
    Photo VARCHAR(255) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES MultiMedia(ContentID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/PhotoGallery.csv'
INTO TABLE PhotoGallery
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, MatchReportID, Photo);
-- ------------------------------------------------
-- Video
-- ------------------------------------------------
CREATE TABLE Video (
    ContentID INT PRIMARY KEY,
    MatchReportID INT NOT NULL,
    Category VARCHAR(100) NOT NULL,
    VideoFile VARCHAR(255) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES MultiMedia(ContentID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Video.csv'
INTO TABLE Video
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, Category, MatchReportID, VideoFile);
-- ------------------------------------------------
-- Sooje
-- ------------------------------------------------
CREATE TABLE Sooje (
    ContentID INT PRIMARY KEY,
    VideoFile VARCHAR(255) NOT NULL,
    SenderName VARCHAR(100) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES MultiMedia(ContentID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Sooje.csv'
INTO TABLE Sooje
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, VideoFile, SenderName);
-- ------------------------------------------------
-- NewsPapaer
-- ------------------------------------------------
CREATE TABLE NewsPapaer (
    ContentID INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL,
    PictureFile VARCHAR(255) NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES Content(ContentID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/NewsPapaer.csv'
INTO TABLE NewsPapaer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ContentID, PublisherName, PictureFile);
-- ------------------------------------------------
-- Prediction
-- ------------------------------------------------
CREATE TABLE Prediction (
    PredictionID INT PRIMARY KEY,
    HostGoals INT NOT NULL,
    GuestGoals INT NOT NULL,
    UserID INT NOT NULL,
    MatchID INT NOT NULL,
    FOREIGN KEY (UserID)
        REFERENCES `User`(UserID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    CHECK (HostGoals >= 0),
    CHECK (GuestGoals >= 0)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Prediction.csv'
INTO TABLE Prediction
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(PredictionID, HostGoals, GuestGoals, UserID, MatchID);
-- ------------------------------------------------
-- Comment
-- ------------------------------------------------
CREATE TABLE Comment (
    CommentID INT PRIMARY KEY,
    Text TEXT NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Hour TIME NOT NULL,
    ContentID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (ContentID)
        REFERENCES Content(ContentID)
        ON DELETE CASCADE,
    FOREIGN KEY (UserID)
        REFERENCES `User`(UserID)
        ON DELETE CASCADE,
    CHECK (Month BETWEEN 1 AND 12)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Comment.csv'
INTO TABLE Comment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CommentID, Text, Year, Month, Hour, ContentID, UserID);
-- ------------------------------------------------
-- Like
-- ------------------------------------------------
CREATE TABLE `Like` (
    LikeID INT PRIMARY KEY,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Hour TIME NOT NULL,
    UserID INT NOT NULL,
    ContentID INT NOT NULL,
    FOREIGN KEY (UserID)
        REFERENCES `User`(UserID)
        ON DELETE CASCADE,
    FOREIGN KEY (ContentID)
        REFERENCES Content(ContentID)
        ON DELETE CASCADE,
    CHECK (Month BETWEEN 1 AND 12),
    UNIQUE (UserID, ContentID)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Like.csv'
INTO TABLE `Like`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(LikeID, Year, Month, Hour, UserID, ContentID);

-- ==================================================
-- Team
-- ==================================================

CREATE TABLE Team (
    Team_ID INT PRIMARY KEY,
    Team_Name VARCHAR(100) NOT NULL UNIQUE,
    Logo VARCHAR(255) NOT NULL
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Team.csv'
INTO TABLE Team
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Team_ID,Team_Name,Logo);

-- ==================================================
-- SportPerson
-- ==================================================
CREATE TABLE SportPerson (
    SportsPersonID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Nationality VARCHAR(50) NOT NULL
    -- UNIQUE (Name, Nationality)
);

LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/SportPerson.csv'
INTO TABLE SportPerson
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,Name,Nationality);
-- ==================================================
-- TeamPerson
-- ==================================================
CREATE TABLE TeamPerson (
    SportsPersonID INT,
    Team_ID INT,
    Age INT NOT NULL,
    ProfilePicture VARCHAR(255) NOT NULL,
    PRIMARY KEY (SportsPersonID),
    FOREIGN KEY (SportsPersonID)
	REFERENCES SportPerson(SportsPersonID)
	ON DELETE CASCADE,
    FOREIGN KEY (Team_ID)
	REFERENCES Team(Team_ID)
	ON DELETE CASCADE,
    CHECK (Age > 0)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/TeamPerson.csv'
INTO TABLE TeamPerson
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,Team_ID,Age,ProfilePicture);
-- ==================================================
-- Coach
-- ==================================================
CREATE TABLE Coach (
    SportsPersonID INT PRIMARY KEY,
    FOREIGN KEY (SportsPersonID)
	REFERENCES TeamPerson(SportsPersonID)
	ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Coach.csv'
INTO TABLE Coach
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID);
-- ==================================================
-- Davar
-- ==================================================

CREATE TABLE Davar (
    SportsPersonID INT PRIMARY KEY,
    FOREIGN KEY (SportsPersonID)
        REFERENCES SportPerson(SportsPersonID)
        ON DELETE CASCADE
);

LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Davar.csv'
INTO TABLE Davar
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID);
-- ==================================================
-- Player
-- ==================================================
CREATE TABLE Player (
    SportsPersonID INT PRIMARY KEY,
    Post VARCHAR(50) NOT NULL,
    Number INT NOT NULL UNIQUE,
    FOREIGN KEY (SportsPersonID)
        REFERENCES TeamPerson(SportsPersonID)
        ON DELETE CASCADE
);

LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Player.csv'
INTO TABLE Player
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,Post,Number);
-- ==================================================
-- Friendly
-- ==================================================

CREATE TABLE Friendly (
    GameID INT PRIMARY KEY,
    MatchID INT NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Gender ENUM('Male','Female') NOT NULL,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE
	
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Friendly.csv'
INTO TABLE Friendly
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameId,MatchID,Name,Gender );

-- ==================================================
-- Group_Has_Team
-- ==================================================

CREATE TABLE Group_Has_Team (
    Team_ID INT NOT NULL,
    GroupID INT NOT NULL,
    GameID INT NOT NULL,
    PRIMARY KEY (Team_ID, GroupID),
    FOREIGN KEY (Team_ID)
        REFERENCES Team(Team_ID)
        ON DELETE CASCADE,
	FOREIGN KEY (GameID,GroupID)
        REFERENCES `Group`(GameID,GroupID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Group_Has_Team.csv'
INTO TABLE Group_Has_Team
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(GameID,GroupID,Team_ID);
-- ==================================================
-- Transformation
-- ==================================================

CREATE TABLE Transformation (
    TransformationID INT PRIMARY KEY,
    SportsPersonID INT NOT NULL,
    Team_ID INT NOT NULL,
    Year DATE NOT NULL,
    Type ENUM('loan', 'permanent') NOT NULL,
    InOrOut BOOLEAN NOT NULL,
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (Team_ID)
        REFERENCES Team(Team_ID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Transformation.csv'
INTO TABLE Transformation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,TransformationID,Team_ID,Year,Type,InOrOut);
-- ==================================================
-- Player_PlaysFor_MatchParticipant_1,2
-- ==================================================
CREATE TABLE Player_PlaysFor_MatchParticipant_1 (
    SportsPersonID INT NOT NULL,
    MatchID INT NOT NULL,
    MatchParticipantID INT NOT NULL,
    PRIMARY KEY (SportsPersonID, MatchID, MatchParticipantID),
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID,MatchID)
        REFERENCES MatchParticipant(MatchParticipantID,MatchID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Player_PlaysFor_MatchParticipant_1.csv'
INTO TABLE Player_PlaysFor_MatchParticipant_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,MatchID,MatchParticipantID);

CREATE TABLE Player_PlaysFor_MatchParticipant_2 (
    SportsPersonID INT NOT NULL,
    MatchID INT NOT NULL,
    Location VARCHAR(100) NOT NULL,
    PRIMARY KEY (SportsPersonID, MatchID),
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Player_PlaysFor_MatchParticipant_2.csv'
INTO TABLE Player_PlaysFor_MatchParticipant_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,MatchID,Location);
-- ==================================================
-- MatchParticipant_Has_Coach
-- ==================================================
CREATE TABLE MatchParticipant_Has_Coach (
    SportsPersonID INT NOT NULL,
    MatchParticipantID INT NOT NULL,
    MatchID INT NOT NULL,
    PRIMARY KEY (SportsPersonID, MatchParticipantID,MatchID),
    FOREIGN KEY (SportsPersonID)
        REFERENCES Coach(SportsPersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID,MatchID)
        REFERENCES MatchParticipant(MatchParticipantID,MatchID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/MatchParticipant_Has_Coach.csv'
INTO TABLE MatchParticipant_Has_Coach
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,MatchID,MatchParticipantID);
SHOW WARNINGS;

-- ==================================================
-- Davar_Judges_Match
-- ==================================================
CREATE TABLE Davar_Judges_Match (
    SportsPersonID INT NOT NULL,
    MatchID INT NOT NULL,
    Position ENUM('MainReferee','AssistantReferee','VAR','FourthReferee') NOT NULL,
    PRIMARY KEY (SportsPersonID, MatchID),
    FOREIGN KEY (SportsPersonID)
        REFERENCES Davar(SportsPersonID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Davar_Judges_Match.csv'
INTO TABLE Davar_Judges_Match
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SportsPersonID,Position,MatchID);
-- ==================================================
-- Half
-- ==================================================
CREATE TABLE Half (
    HalfID INT NOT NULL,
    MatchID INT NOT NULL,
    MatchReportID INT NOT NULL,
    FirstOrSecond ENUM('First','Second') NOT NULL,
    PRIMARY KEY (HalfID, MatchReportID, MatchID),
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
	FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    
    UNIQUE (MatchReportID, FirstOrSecond)
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Half.csv'
INTO TABLE Half
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(HalfID,MatchID,MatchReportID,FirstOrSecond);
-- ==================================================
-- MatchEvent
-- ==================================================

CREATE TABLE MatchEvent (
    MatchEventID INT PRIMARY KEY,
    MatchReportID INT NOT NULL,
    HalfID INT NOT NULL,
    Minute INT NOT NULL,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
    FOREIGN KEY (HalfID)
        REFERENCES Half(HalfID)
        ON DELETE CASCADE,
    CHECK (Minute >= 0 )
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/MatchEvent.csv'
INTO TABLE MatchEvent
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchEventID,HalfID,MatchReportID,Minute);
-- ==================================================
-- Goal
-- ==================================================
CREATE TABLE Goal (
    MatchEventID INT PRIMARY KEY,
    MatchReportID INT,
    HalfID INT,
    MatchID INT,
    MatchParticipantID INT,
    SportsPersonID INT NOT NULL,
    DirectOrIndirect ENUM('Direct','Indirect') NOT NULL,

    FOREIGN KEY (MatchEventID)
        REFERENCES MatchEvent(MatchEventID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
    FOREIGN KEY (HalfID)
        REFERENCES Half(HalfID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID)
        REFERENCES MatchParticipant(MatchParticipantID)
        ON DELETE CASCADE,
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Goal.csv'
INTO TABLE Goal
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchEventID, MatchReportID, HalfID, MatchID, MatchParticipantID, SportsPersonID, DirectOrIndirect);

-- ==================================================
-- Card
-- ==================================================

CREATE TABLE Card (
    MatchEventID INT PRIMARY KEY,
    MatchReportID INT,
    HalfID INT,
    MatchID INT,
    MatchParticipantID INT,
    SportsPersonID INT NOT NULL,
    Color ENUM('Yellow','Red') NOT NULL,

    FOREIGN KEY (MatchEventID)
        REFERENCES MatchEvent(MatchEventID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
    FOREIGN KEY (HalfID)
        REFERENCES Half(HalfID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID)
        REFERENCES MatchParticipant(MatchParticipantID)
        ON DELETE CASCADE,
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Card.csv'
INTO TABLE Card
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchEventID,MatchReportID,HalfID,MatchID,MatchParticipantID,SportsPersonID,Color);
-- ==================================================
-- Penalty
-- ==================================================

CREATE TABLE Penalty (
    MatchEventID INT PRIMARY KEY,
    MatchReportID INT,
    HalfID INT,
    MatchID INT,
    MatchParticipantID INT,
    SportsPersonID INT NOT NULL,
    Result ENUM('Goal','Missed','Saved') NOT NULL,
    Type ENUM('Normal','Shootout') NOT NULL,

    FOREIGN KEY (MatchEventID)
        REFERENCES MatchEvent(MatchEventID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
    FOREIGN KEY (HalfID)
        REFERENCES Half(HalfID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID)
        REFERENCES MatchParticipant(MatchParticipantID)
        ON DELETE CASCADE,
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Penalty.csv'
INTO TABLE Penalty
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchEventID,MatchReportID,HalfID,MatchID,MatchParticipantID,SportsPersonID,Result,Type);
-- ==================================================
-- Taviz
-- ==================================================
CREATE TABLE Taviz (
    MatchEventID INT PRIMARY KEY,
    MatchReportID INT,
    HalfID INT,
    MatchID INT,
    MatchParticipantID INT,
    SportsPersonID INT NOT NULL,
    InOrOut ENUM('In','Out') NOT NULL,

    FOREIGN KEY (MatchEventID)
        REFERENCES MatchEvent(MatchEventID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchReportID)
        REFERENCES MatchReport(MatchReportID)
        ON DELETE CASCADE,
    FOREIGN KEY (HalfID)
        REFERENCES Half(HalfID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchID)
        REFERENCES `Match`(MatchID)
        ON DELETE CASCADE,
    FOREIGN KEY (MatchParticipantID)
        REFERENCES MatchParticipant(MatchParticipantID)
        ON DELETE CASCADE,
    FOREIGN KEY (SportsPersonID)
        REFERENCES Player(SportsPersonID)
        ON DELETE CASCADE
);
LOAD DATA  INFILE 'D:/Database Dr.Kahani/project/phase2/Data_Import/Taviz.csv'
INTO TABLE Taviz
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(MatchEventID,MatchReportID,HalfID,MatchID,MatchParticipantID,SportsPersonID,InOrOut);