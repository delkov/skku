(setq 
  areas_2 nil
  ss_2 nil
  el_2 nil
)
(defun c:mpu( / )
  
  (defun getfromlast_2(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  )

  (setq  ss_2 (ssget (list (cons 0 "*POLYLINE"))))
   ;(setq ss total_sel)
   (setq el_2 (entlast))
  
  (command ".region" ss_2 "")  
  (command ".union" (getfromlast_2 el_2) "")

  (setq el_2 (entlast))
  (command ".explode" (entlast) )  


(setq areas (getfromlast_2 el_2))
(setq explode_counter_2 0)



(if (= (cdr (cadr (entget (ssname areas_2 1)))) "REGION")
  (progn
    ;(alert "men2")
(repeat (sslength areas_2)
(setq el_2 (entlast))
(command ".explode" (ssname areas_2 explode_counter_2))
(command ".pedit" (entlast) "y" "j" (getfromlast_2 el_2) "" "")  
(setq explode_counter_2 (+ explode_counter_2 1))
)
);progn
);if
 
(if (= (cdr (cadr (entget (ssname areas_2 1)))) "LINE")
  (progn
  ;  (alert "one")
    (command ".pedit" (entlast) "y" "j" (getfromlast_2 el_2) "" "")
)
  )
 ; (command ".union" (getfromlast el)  "")  

  (princ)
) 

