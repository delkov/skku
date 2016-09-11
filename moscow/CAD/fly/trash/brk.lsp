         (setq temp_spline_vla (vlax-ename->vla-object (entlast)))
         ;(setq temp_pline_vla (vlax-ename->vla-object (entlast)))
       ;  (setq intersect_probe (vlax-invoke temp_spline_vla 'IntersectWith temp_pline_vla acextendnone))
               ; (setq p1 '(10 200))
               ; (setq p2 '(40 400))
               ; (command "._pline" p1 p2 "")

(setq pt1 (append (list (nth 0 intersect)) (list (nth 1 intersect))))
(setq pt2 (append (list (nth 3 intersect)) (list (nth 4 intersect))))



(command "break" (vlax-vla-object->ename total_vla) pt1 pt2 )


(setq temp_spline_vla (entlast))
(setq temp_pline_vla (entlast))