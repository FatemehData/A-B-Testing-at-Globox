SELECT
  u.id AS user_id,
  u.country,
  u.gender,
  COALESCE(g.device, 'Unknown') AS device_type,
  g.group AS test_group,
  CASE
    WHEN a.spent > 0 THEN 'Yes'
    ELSE 'No'
  END AS converted,
  COALESCE(SUM(a.spent), 0) AS total_spent
FROM
  users u
  JOIN groups g ON u.id = g.uid
  LEFT JOIN (
    SELECT
      uid,
      device,
      SUM(spent) AS spent
    FROM
      activity
    GROUP BY
      uid,
      device
  ) a ON u.id = a.uid
GROUP BY
  u.id,
  u.country,
  u.gender,
  g.device,
  g.group,
  a.spent
ORDER BY
  user_id; 