(setq 
  areas nil
  ss nil
  el nil
)
(defun c:mpu( / )
  
  (defun getfromlast(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  )

  (setq  ss (ssget (list (cons 0 "*POLYLINE"))))
   ;(setq ss total_sel)
   (setq el (entlast))
  
  (command ".region" ss "")  
  (command ".union" (getfromlast el) "")

  (setq el (entlast))
  (command ".explode" (entlast) )  


(setq areas (getfromlast el))
(setq explode_counter 0)



(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn
    ;(alert "men2")
(repeat (sslength areas)
(setq el (entlast))
(command ".explode" (ssname areas explode_counter))
(command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")  
(setq explode_counter (+ explode_counter 1))
)
);progn
);if
 
(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
  ;  (alert "one")
    (command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")
)
  )
 ; (command ".union" (getfromlast el)  "")  

  (princ)
) 

