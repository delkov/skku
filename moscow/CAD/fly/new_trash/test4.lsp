      (setq 
        ff nil
        total_point (append med_angle_point end_angle_point true_start_point_list (reverse true_end_point_list) start_angle_point med_angle_point)
       ;total_point (append end_point)
      )




;;;;;;;;;;;;;;; DRAW SPLINE ;;;;;;;;;;;;;;;;;;;
      ;(setvar "CELTSCALE" 100)
      ;(command ".-linetype" "load" "*" file "")

      (entmake
       (append (list '(0 . "SPLINE") '(100 . "AcDbEntity") '(100 . "AcDbSpline") '(70 . 40) '(71 . 3) (cons 74 (length total_point)) '(44 . 1.0e-005))
         (mapcar '(lambda (x) (cons 11 x)) total_point)
       ); append
      ); entmake
      