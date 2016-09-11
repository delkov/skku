(setq ss_trans (ssadd))
(setq total_ent_list_trans (rem_list total_ent_list))
(while (/= (length total_ent_list_trans) 0)
  (if (/= (cdr (assoc 6 (entget (nth 0 total_ent_list_trans)))) (itoa start_level))

  (progn
(alert "ass")
     (ssadd (nth 0 total_ent_list_trans) ss_trans)
     ;)
    ;)
  ); progn
  ); if
(setq total_ent_list_trans (cdr total_ent_list_trans))
)