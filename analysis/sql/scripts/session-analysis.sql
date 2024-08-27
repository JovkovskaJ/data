WITH TimedEvents AS (
    SELECT
        user_id,
        session_id,
        event,
        timestamp,
        COALESCE(LAG(timestamp) OVER (PARTITION BY user_id, session_id ORDER BY timestamp), timestamp) AS previous_timestamp
    FROM
        event_data
    
), 
SessionGaps AS (
    SELECT
        user_id,
        session_id,
        event,
        timestamp,
        previous_timestamp,
        strftime('%s', timestamp) - strftime('%s', previous_timestamp) AS gap_seconds
    FROM
        TimedEvents
), 
SessionExceeds AS (
    SELECT
        user_id,
        session_id,
        event,
        timestamp,
        previous_timestamp,
        CASE WHEN gap_seconds > 300 OR previous_timestamp IS NULL THEN 1 ELSE 0 END AS session_exceeded
    FROM
        SessionGaps
), 
AdjustedSessions AS (
    SELECT
        user_id,
        session_id,
        event,
        timestamp,
        previous_timestamp,
        SUM(session_exceeded) OVER (PARTITION BY user_id, session_id ORDER BY timestamp) AS exceeded_count
    FROM
        SessionExceeds
),
NewSessionIDs AS (
    SELECT
        user_id,
        session_id || '-' || CAST(exceeded_count AS TEXT) AS new_session_id,
        event,
        timestamp,
        previous_timestamp
    FROM
        AdjustedSessions
), 
SessionDurations AS (
    SELECT
        user_id,
        new_session_id,
        MIN(timestamp) AS session_start,
        MAX(previous_timestamp) AS session_end,
        (strftime('%s', MAX(timestamp)) - strftime('%s', MIN(previous_timestamp))) / 60 AS session_duration_minutes
    FROM
        NewSessionIDs
    GROUP BY
        user_id, new_session_id
)
select  * from SessionDurations