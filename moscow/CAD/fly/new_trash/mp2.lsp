(defun c:mp( / )
  
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
   ;ss total_sel
   (setq el (entlast))
  
  (command ".region" ss "")  
  (command ".union" (getfromlast el) "")

  (setq el (entlast))
  (command ".explode" (entlast) )  


(setq areas (getfromlast el))
(setq explode_counter 0)

(repeat (sslength areas)
(setq el (entlast))
(command ".explode" (ssname areas explode_counter))
(command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")  
(setq explode_counter (+ explode_counter 1))
)
 ; (command ".union" (getfromlast el)  "")  

  (princ)
) 

