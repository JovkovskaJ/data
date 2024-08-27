# Session Analysis SQL Script

## Overview

This SQL script processes event data to analyze user sessions by breaking them down into smaller sub-sessions based on inactivity periods. It identifies gaps of more than 5 minutes between events within the same session due to a system bug and splits those sessions into separate sub-sessions. The final output provides the duration of each sub-session in minutes.

## Script Explanation

The script is organized into several Common Table Expressions (CTEs), each building on the previous one to refine the session data:

- **TimedEvents**: 
  - This CTE retrieves the original event data and adds a `previous_timestamp` column using the `LAG` window function. This column shows the timestamp of the previous event within the same session, allowing us to calculate gaps between events.

- **SessionGaps**:
  - Calculates the gap in seconds between each event and its previous event by subtracting `previous_timestamp` from `timestamp`. The result is stored in the `gap_seconds` column.

- **SessionExceeds**:
  - Flags sessions where the gap between consecutive events exceeds 300 seconds (5 minutes). If the gap is greater than 300 seconds or if it's the first event in the session (where `previous_timestamp` is `NULL`), the `session_exceeded` column is set to `1`.

- **AdjustedSessions**:
  - Uses a cumulative sum (`SUM`) to create an `exceeded_count` column that tracks how many times the session exceeded the 5-minute threshold. This helps in creating distinct sub-sessions by incrementing the count each time the session exceeds the threshold.

- **NewSessionIDs**:
  - Generates a new session ID (`new_session_id`) by concatenating the original `session_id` with the `exceeded_count`. This ensures that each sub-session has a unique ID, even if it belongs to the same original session.

- **SessionDurations**:
  - Calculates the duration of each sub-session in minutes. This is done by finding the minimum and maximum timestamps for each `new_session_id` and then calculating the difference between them, converting it from seconds to minutes.

- **Final SELECT**:
  - Outputs the results from the `SessionDurations` CTE, showing each `user_id`, `new_session_id`, the start and end times of each sub-session, and the duration of each sub-session in minutes.

## How to Run the Script

1. **Prerequisites**:
   - Ensure you have SQLite installed or an engine of your choice and that your `event_data` table contains the necessary data, including `user_id`, `session_id`, `event`, and `timestamp` columns. You can create a test data to mimic the scenario.

2. **Load the Script**:
   - Save the SQL script to a file, for example, `session_analysis.sql`.
   - Run the script in your SQLite environment:

   ```bash
   .read sql/session_analysis.sql
