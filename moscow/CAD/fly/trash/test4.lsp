      (setq draw_point (append (car temp_point) (caddr temp_point) (cadddr temp_point) (cadr temp_point)))
    ;   (entmake
    ;    (append (list '(0 . "SPLINE") '(100 . "AcDbEntity") '(100 . "AcDbSpline") '(70 . 40) '(71 . 3) (cons 74 (length draw_point)) '(44 . 1.0e-005))
    ;      (mapcar '(lambda (x) (cons 11 x)) draw_point)
    ;    ); append
    ;   ); entmake

    (command "._SPLINE")
    (apply 'command draw_point)