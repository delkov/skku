      (repeat (- (length true_start_point_list) 1)

      (setq temp_spline (append (list (car true_start_point_list) (cadr true_start_point_list) (cadr true_end_point_list) (car true_end_point_list))))
      (entmake
       (append (list '(0 . "SPLINE") '(100 . "AcDbEntity") '(100 . "AcDbSpline") '(70 . 40) '(71 . 3) (cons 74 (length temp_spline)) '(44 . 1.0e-005))
         (mapcar '(lambda (x) (cons 11 x)) temp_spline)
       ); append
      ); entmake
      

      (command "region" (entlast) "")
      (setq total_spline_region (append total_spline_region (list (entlast))))


      (command "._UNION")
      (apply 'command total_spline_region);
      (command "")

      (setq true_start_point_list (cadr true_start_point_list))
      (setq true_end_point_list (cadr true_end_point_list))
      )
