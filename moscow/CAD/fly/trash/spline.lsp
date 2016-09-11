(entmake
       (append
         (list
           '(0 . "SPLINE")
           '(100 . "AcDbEntity")
           '(100 . "AcDbSpline")
           '(70 . 40)
           '(71 . 3)
           (cons 74 (length total_point))
           '(44 . 1.0e-005)
           )
         (mapcar '(lambda (x) (cons 11 x)) total_point)
         )
       )