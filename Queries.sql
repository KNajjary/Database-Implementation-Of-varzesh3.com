-- ========================================================================
-- simmple queris
-- =========================================================================
-- نمایش مسابقات یک تورنمنت
SELECT m.MatchID, t.Name, m.Year, m.Month, m.Hour
FROM `Match` m
JOIN Tournament t ON m.GameID = t.GameID
WHERE t.GameID = 1;
-- ---------------------------------------------------------------
-- نمایش مسابقات یک هفته لیگ
SELECT m.MatchID, t.Name, w.WeakNumber
FROM `Match` m
JOIN Weak w ON m.GameID = w.GameID AND m.WeakID = w.WeakID
JOIN Tournament t ON m.GameID = t.GameID
WHERE w.WeakNumber = 3;
-- نمایش تیم‌های حاضر در یک مسابقه
SELECT mp.MatchID, tm.Team_Name, mp.HostOrGuest
FROM MatchParticipant mp
JOIN Team tm ON mp.Team_ID = tm.Team_ID
WHERE mp.MatchID = 1;
-- نمایش مسابقات مرحله‌ای جام
SELECT m.MatchID, t.Name, s.StageName
FROM `Match` m
JOIN Stage s ON m.GameID = s.GameID AND m.StageID = s.StageID
JOIN Tournament t ON m.GameID = t.GameID
WHERE s.StageName = 'Final';

-- ---------------------------------------------------------------
--  Display player names along with their team names 
SELECT sp.name AS player_name, t.team_name 
FROM Player p 
JOIN TeamPerson tp ON p.SportsPersonID = tp.SportsPersonID 
JOIN Team t ON tp.Team_ID = t.Team_ID 
JOIN SportPerson sp ON p.SportsPersonID = sp.SportsPersonID;


-- ---------------------------------------------------------------
--  Count players per team
SELECT t.Team_Name, COUNT(*) AS Player_count 
FROM TeamPerson tp 
JOIN Team t ON tp.Team_ID = t.Team_ID 
JOIN Player p ON tp.SportsPersonID = p.SportsPersonID
GROUP BY t.Team_ID, t.Team_Name;
-- ---------------------------------------------------------------
--  Display groups and their respective teams 
SELECT g.Name AS Group_name, t.Team_Name 
FROM `Group` g 
JOIN Group_Has_Team ght ON g.GroupID = ght.GroupID AND g.GameID = ght.GameID
JOIN Team t ON ght.Team_ID = t.Team_ID;
-- ---------------------------------------------------------------
--  Display coaches along with their team names 
SELECT sp.Name AS Coach_name, t.Team_Name 
FROM Coach c 
JOIN SportPerson sp ON c.SportsPersonID = sp.SportsPersonID 
JOIN TeamPerson tp ON c.SportsPersonID = tp.SportsPersonID 
JOIN Team t ON tp.Team_ID = t.Team_ID;
-- ---------------------------------------------------------------
--  Display goal minutes along with half number and match ID 
SELECT g.MatchID, sp.Name, me.Minute, h.FirstOrSecond AS Half_Name
FROM Goal g 
JOIN MatchEvent me ON g.MatchEventID = me.MatchEventID 
JOIN Half h ON g.HalfID = h.HalfID AND g.MatchID = h.MatchID
JOIN SportPerson sp ON g.SportsPersonID = sp.SportsPersonID;
-- ---------------------------------------------------------------
--  Yellow and red cards count per team (Card has Sportperson_id; no Player needed)
SELECT t.Team_Name, 
       SUM(CASE WHEN c.Color = 'Yellow' THEN 1 ELSE 0 END) AS Yellow_cards,
       SUM(CASE WHEN c.Color = 'Red' THEN 1 ELSE 0 END) AS Red_cards
FROM Card c 
JOIN TeamPerson tp ON c.SportsPersonID = tp.SportsPersonID 
JOIN Team t ON tp.Team_ID = t.Team_ID 
GROUP BY t.Team_ID, t.Team_Name;
-- ---------------------------------------------------------------
--  Display card details along with player and team information 
SELECT c.Color, sp.Name AS Player_name, t.Team_Name 
FROM Card c 
JOIN SportPerson sp ON c.SportsPersonID = sp.SportsPersonID 
JOIN TeamPerson tp ON c.SportsPersonID = tp.SportsPersonID 
JOIN Team t ON tp.Team_ID = t.Team_ID;
-- ---------------------------------------------------------------
--  Display names of players who have either scored a goal or received a card in a match 
SELECT sp.Name AS Coach_name, t.Team_Name 
FROM Coach c 
JOIN SportPerson sp ON c.SportsPersonID = sp.SportsPersonID 
JOIN TeamPerson tp ON c.SportsPersonID = tp.SportsPersonID 
JOIN Team t ON tp.Team_ID = t.Team_ID;
-- ========================================================================
-- statistic queris
-- =========================================================================
--  تعداد مسابقات هر تورنمنت
SELECT t.Name, COUNT(m.MatchID) AS MatchCount
FROM Tournament t
JOIN `Match` m ON t.GameID = m.GameID
GROUP BY t.Name;
-- تعداد مسابقات هر هفته
SELECT w.WeakNumber, COUNT(m.MatchID) AS MatchCount
FROM Weak w
JOIN `Match` m ON w.GameID = m.GameID AND w.WeakID = m.WeakID
GROUP BY w.WeakNumber;

--  میانگین دقت پاس هر تیم
SELECT tm.Team_Name, AVG(mp.PassesAccuracyPercentage) AS AvgPassAccuracy
FROM MatchParticipant mp
JOIN Team tm ON mp.Team_ID = tm.Team_ID
GROUP BY tm.Team_Name
HAVING AVG(mp.PassesAccuracyPercentage) > 70;
-- مجموع خطاهای هر تیم
SELECT tm.Team_Name, SUM(mp.FoulsNumber) AS TotalFouls
FROM MatchParticipant mp
JOIN Team tm ON mp.Team_ID = tm.Team_ID
GROUP BY tm.Team_Name
HAVING SUM(mp.FoulsNumber) > 10;


-- ---------------------------------------------------------------
--  Number of matches judged by each referee 
SELECT sp.Name, COUNT(djm.MatchID) AS Matches_judged 
FROM Davar_Judges_Match djm 
JOIN SportPerson sp ON djm.SportsPersonID = sp.SportsPersonID 
GROUP BY djm.SportsPersonID, sp.Name;
-- ---------------------------------------------------------------
--  Goals scored by each player 
SELECT sp.Name, COUNT(*) AS Goals 
FROM Goal g 
JOIN SportPerson sp ON g.SportsPersonID = sp.SportsPersonID 
GROUP BY sp.SportsPersonID, sp.Name 
ORDER BY Goals DESC;
-- ---------------------------------------------------------------
--  Players who have played for more than one team 
SELECT sp.Name, COUNT(DISTINCT tr.Team_ID) AS Team_count 
FROM Transformation tr 
JOIN SportPerson sp ON tr.SportsPersonID = sp.SportsPersonID 
GROUP BY sp.SportsPersonID, sp.Name 
HAVING COUNT(DISTINCT tr.Team_ID) > 1;
-- ---------------------------------------------------------------
--  Average age of players per team
SELECT t.Team_Name, AVG(tp.Age) AS Avg_age 
FROM TeamPerson tp 
JOIN Team t ON tp.Team_ID = t.Team_ID 
JOIN Player p ON tp.SportsPersonID = p.SportsPersonID
GROUP BY t.Team_ID, t.Team_Name;

-- ---------------------------------------------------------------
-- Players who have scored in Friendly matches 
SELECT t.Team_Name, AVG(tp.Age) AS Avg_age 
FROM TeamPerson tp 
JOIN Team t ON tp.Team_ID = t.Team_ID 
JOIN Player p ON tp.SportsPersonID = p.SportsPersonID
GROUP BY t.Team_ID, t.Team_Name;
-- ========================================================================
-- پرس‌وجوهای پیشرفته با Subquery
-- =========================================================================
  -- مسابقاتی که در یک تورنمنت هستند
  SELECT MatchID
  FROM `Match`
  WHERE GameID = (
      SELECT GameID
      FROM Tournament
      WHERE Name LIKE 'Premier League 2023/24'
      LIMIT 1
  );
--  تیم‌هایی که دقت پاسشان بالاتر از میانگین کل است
SELECT DISTINCT tm.Team_Name
FROM MatchParticipant mp
JOIN Team tm ON mp.Team_ID = tm.Team_ID
WHERE mp.PassesAccuracyPercentage > (
    SELECT AVG(PassesAccuracyPercentage)
    FROM MatchParticipant
);
-- تورنمنتی که بیشترین مسابقه را دارد
SELECT Name
FROM Tournament
WHERE GameID = (
    SELECT GameID
    FROM `Match`
    GROUP BY GameID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
-- تیم‌هایی که در آخرین مسابقه‌شان دقت پاسشان بهتر از میانگین خودشان بوده
SELECT
    tm.Team_Name,
    latest_match.MatchID,
    latest_match.PassesAccuracyPercentage
FROM Team tm
JOIN
(
    SELECT mp1.Team_ID, mp1.MatchID, mp1.PassesAccuracyPercentage
    FROM MatchParticipant mp1
    WHERE mp1.MatchID =
    (
        SELECT MAX(mp2.MatchID)
        FROM MatchParticipant mp2
        WHERE mp2.Team_ID = mp1.Team_ID
    )
) AS latest_match
    ON tm.Team_ID = latest_match.Team_ID
WHERE latest_match.PassesAccuracyPercentage >
(
    SELECT AVG(mp3.PassesAccuracyPercentage)
    FROM MatchParticipant mp3
    WHERE mp3.Team_ID = latest_match.Team_ID
);
--  آخرین رکورد انتقال هر بازیکن
SELECT
    sp.Name,
    tr.Type,
    tr.InOrOut,
    t.Team_Name,
    tr.Year
FROM Transformation tr
JOIN (
    SELECT SportsPersonID, MAX(Year) AS MaxYear
    FROM Transformation
    GROUP BY SportsPersonID
) last_tr
    ON last_tr.SportsPersonID = tr.SportsPersonID
   AND last_tr.MaxYear = tr.Year
JOIN SportPerson sp
    ON sp.SportsPersonID = tr.SportsPersonID
JOIN Team t
    ON t.Team_ID = tr.Team_ID
ORDER BY tr.Year DESC, sp.Name;
-- ---------------------------------------------------------------
--   Players who are older than the average age of all players
SELECT sp.Name, tp.Age 
FROM TeamPerson tp 
JOIN SportPerson sp ON tp.SportsPersonID = sp.SportsPersonID 
WHERE tp.SportsPersonID IN (SELECT SportsPersonID FROM Player)
  AND tp.Age > (
      SELECT AVG(tp2.Age) 
      FROM TeamPerson tp2
      WHERE tp2.SportsPersonID IN (SELECT SportsPersonID FROM Player)
  );
-- ---------------------------------------------------------------
--  Players who have scored the highest number of goals 

SELECT sp.Name, COUNT(*) AS Goals 
FROM Goal g 
JOIN SportPerson sp ON g.SportsPersonID = sp.SportsPersonID 
GROUP BY sp.SportsPersonID, sp.Name 
HAVING COUNT(*) = (
    SELECT MAX(Goal_count) 
    FROM (
        SELECT COUNT(*) AS Goal_count 
        FROM Goal 
        GROUP BY SportsPersonID
    ) AS gc
);
-- ---------------------------------------------------------------
--   Teams that have at least one player with nationality 'Iran'
SELECT DISTINCT t.Team_Name 
FROM Team t 
WHERE EXISTS (
    SELECT 1
    FROM TeamPerson tp 
    JOIN SportPerson sp ON tp.SportsPersonID = sp.SportsPersonID 
    JOIN Player p ON tp.SportsPersonID = p.SportsPersonID
    WHERE tp.Team_ID = t.Team_ID AND sp.Nationality = 'Iran'
);

-- ---------------------------------------------------------------
--  report: Total goals and cards per match 
SELECT MatchID, SUM(Goals) AS Total_goals, SUM(Cards) AS Total_cards
FROM (
    SELECT MatchID, COUNT(*) AS Goals, 0 AS Cards FROM Goal GROUP BY MatchID
    UNION ALL
    SELECT MatchID, 0 AS Goals, COUNT(*) AS Cards FROM Card GROUP BY MatchID
) AS stats
GROUP BY MatchID;
-- ========================================================================
-- Triggerها
-- =========================================================================
-- جلوگیری از بیشتر شدن پاس موفق از کل پاس
DELIMITER $$

CREATE TRIGGER trg_check_successful_pass
BEFORE INSERT ON MatchParticipant
FOR EACH ROW
BEGIN
    IF NEW.TotalSuccessfulPass > NEW.TotalPass THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Successful passes cannot be more than total passes.';
    END IF;
END$$

DELIMITER ;

--  جلوگیری از ثبت بیش از دو تیم برای هر مسابقه
DELIMITER $$

CREATE TRIGGER trg_matchparticipant_max_two_teams
BEFORE INSERT ON MatchParticipant
FOR EACH ROW
BEGIN
    DECLARE participant_count INT;

    SELECT COUNT(*)
    INTO participant_count
    FROM MatchParticipant
    WHERE MatchID = NEW.MatchID;

    IF participant_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Each match can have only two participants.';
    END IF;
END$$

DELIMITER ;


-- ---------------------------------------------------------------
--  Validate that a player is participating in the match before inserting a goal
DELIMITER $$
CREATE TRIGGER check_player_in_match
BEFORE INSERT ON Goal
FOR EACH ROW
BEGIN
    DECLARE player_exists INT;
    
    SELECT COUNT(*) INTO player_exists
    FROM Player_PlaysFor_MatchParticipant_2
    WHERE SportsPersonID = NEW.SportsPersonID 
      AND MatchID = NEW.MatchID;
      
    IF player_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Player is not registered in this match (not in Player_PlaysFor_MatchParticipant_2)';
    END IF;
END$

DELIMITER ;



-- trigger test
INSERT INTO Goal (
    MatchEventID,
    MatchReportID,
    HalfID,
    MatchID,
    MatchParticipantID,
    SportsPersonID,
    DirectOrIndirect
)
VALUES (
    100,
    1,
    1,
    1,
    1,
    999,
    'Direct'
);
INSERT INTO MatchParticipant (
    MatchParticipantID,
    MatchID,
    Team_ID,
    TotalPass,
    TotalSuccessfulPass
)
VALUES (
    500,
    1,
    3,
    40,    -- TotalPass
    50     -- TotalSuccessfulPass (بیشتر از کل پاس → باید خطا بدهد)
);