(setq ss_trans (ssadd))

(setq total_ent_list_trans (rem_list total_ent_list))
(while (/= (length total_ent_list_trans) 2)
 ; (if (/= (length (entget (nth 0 total_ent_list_trans))) 0)
 ; (progn

     (ssadd (nth 2 total_ent_list_trans) ss_trans)
     ;)
 		;)
 ; ); progn
 ; ); if
(setq total_ent_list_trans (cdr total_ent_list_trans))
)





      (setq n 99)
      (setq n (list (cons 440 (+ (lsh 2 24) (fix (- 255 (* n 2.55)))))))
    
    (repeat (setq i (sslength ss_trans))
      (entmod
        (append
          (entget (ssname ss_trans (setq i (1- i))))
          n
          )
        )
      )