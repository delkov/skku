(setq lst '((10 20) (30 4)))

(entmake
       (append
         (list
           '(0 . "SPLINE")
           '(100 . "AcDbEntity")
           '(100 . "AcDbSpline")
           '(70 . 40)
           '(71 . 3)
           (cons 74 (length lst))
           '(44 . 1.0e-005)
           )
         (mapcar '(lambda (x) (cons 11 x)) lst)
         )
       )