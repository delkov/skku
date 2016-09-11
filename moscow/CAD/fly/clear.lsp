; (defun c:eco_cleaner (/)

; (setq del_counter 0)
; (repeat (length total_ent_list)
; (entdel (nth del_counter total_ent_list))
; (setq del_counter (+ del_counter 1))
; (alert "aa")
; )
; (setq total_ent_list '())

; ); eco_clean
(while (length total_ent_list)
(entdel (nth 0 total_ent_list))
(setq total_ent_list (cdr total_ent_list))
)
