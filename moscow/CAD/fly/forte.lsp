(if (entget (nth 0 total_ent_list))
(progn
(entdel (nth 0 total_ent_list))
(alert "aaazaza")
); progn
); if