      (setq total_spline_region nil)
      (setq temp_spline nil)
      (setq intersect_probe nil)
      (setq intersect_probe_again nil)

      (repeat  (- (length start_point) 1) 

      (setq temp_spline (append (list (car start_point) (cadr start_point) (cadr end_point) (car end_point)  (car start_point))))


(command "._SPLINE")
(apply 'command temp_spline);
(command "" "" "")

      (setq temp_spline_vla (vlax-ename->vla-object (entlast)))
      (setq intersect_probe (vlax-invoke temp_spline_vla 'IntersectWith temp_spline_vla acExtendNone))

      (if (/= intersect_probe nil)
      ;       (alert "test1")
             (progn
      
            ; (alert "azaza");
             (entdel (entlast))
             (setq temp_spline_shit (append (list (car start_point) (cadr start_point) (car end_point) (cadr end_point)  (car start_point))))
             (command "._SPLINE")
             (apply 'command temp_spline_shit);
             (command "" "" "")

             ;(alert "test2")
      
            )
      )
      (setq temp_spline_shit (vlax-ename->vla-object (entlast)))
      (setq intersect_probe_again (vlax-invoke temp_spline_shit 'IntersectWith temp_spline_shit acExtendNone))

       (if (/= intersect_probe_again nil)
     ;                    ;(alert "test3")
             (progn
             (entdel (entlast));
             (setq temp_spline_shit_again (append (list (cadr start_point) (car start_point) (cadr end_point) (car end_point)  (cadr start_point))))
             (command "._SPLINE")
             (apply 'command temp_spline_shit_again);
             (command "" "" "")
       ; (alert "test again")
       )
       )
      

      (command ".region" (entlast) "")

      (setq total_spline_region (append total_spline_region (list (entlast))))

(alert "next")


      (setq start_point (cdr start_point))
      (setq end_point (cdr end_point))

      )


       (alert "test2")
       (command "._UNION")
       (apply 'command total_spline_region);
       (command "")
