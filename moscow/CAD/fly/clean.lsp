(defun c:eco_clean_2 (/)
	(alert "aaa")
(setq total_ent_list (rem_list total_ent_list))





(while (length total_ent_list)

(setq temp_ent (car total_ent_list))
                (setq temp_vla (vlax-ename->vla-object temp_ent))
              



                (vla-Delete temp_vla)
	(alert "aasssa")
;(entdel (nth 0 total_ent_list))
(setq total_ent_list (cdr total_ent_list))
)
(setq total_ent_list '())
); eco_clean