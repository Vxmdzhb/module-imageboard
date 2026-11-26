-- Let posters see why a post was refused (an empty post, the cooldown, a
-- locked or full thread). The message bar shows a diagnostic to a group only
-- when diagnostic_visibility lists it; nothing listed these, so guests and
-- members got the form back without a word. Codes already set in
-- Admin → Access are left alone; re-running is harmless.

-- Everyone who can post on the boards.
INSERT INTO `diagnostic_visibility` (`code`, `group_name`)
SELECT c.code, g.group_name
  FROM (SELECT 'astrx.imageboard/db_error' AS code
      UNION ALL SELECT 'astrx.imageboard/empty'
      UNION ALL SELECT 'astrx.imageboard/too_long'
      UNION ALL SELECT 'astrx.imageboard/no_board'
      UNION ALL SELECT 'astrx.imageboard/no_thread'
      UNION ALL SELECT 'astrx.imageboard/locked'
      UNION ALL SELECT 'astrx.imageboard/image_failed'
      UNION ALL SELECT 'astrx.imageboard/disabled'
      UNION ALL SELECT 'astrx.imageboard/cooldown'
      UNION ALL SELECT 'astrx.imageboard/thread_full'
      UNION ALL SELECT 'astrx.imageboard/censored') c
 CROSS JOIN (SELECT 'GUEST' AS group_name UNION ALL SELECT 'USER' UNION ALL SELECT 'MOD') g
 WHERE NOT EXISTS (SELECT 1 FROM `diagnostic_visibility` v WHERE v.`code` = c.code);
