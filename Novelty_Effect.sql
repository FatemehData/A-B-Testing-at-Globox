SELECT
  u.id AS user_id,
  u.country,
  u.gender,
  COALESCE(g.device, 'Unknown') AS device_type,
  MAX(CASE WHEN g.group = 'A' THEN g.group END) AS group_a,
  MAX(CASE WHEN g.group = 'B' THEN g.group END) AS group_b,
  CASE
    WHEN a.spent > 0 THEN 'Yes'
    ELSE 'No'
  END AS converted,
  COALESCE(SUM(a.spent), 0) AS total_spent,
  MAX(CASE WHEN g.group = 'A' THEN a.dt END) AS conversion_date_a,
  MAX(CASE WHEN g.group = 'B' THEN a.dt END) AS conversion_date_b
FROM
  users u
  JOIN groups g ON u.id = g.uid
  LEFT JOIN (
    SELECT
      uid,
      SUM(spent) AS spent,
      dt
    FROM
      activity
    GROUP BY
      uid,
      dt
  ) a ON u.id = a.uid
GROUP BY
  u.id,
  u.country,
  u.gender,
  g.device,
  a.spent
ORDER BY
  user_id;









