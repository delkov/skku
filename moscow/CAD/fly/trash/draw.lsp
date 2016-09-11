      (setq temp_spline (append (list '(100 200) '(200 300) '(500 600) '(700 800)  (100 200))))


(command "._PLINE")
(apply 'command temp_spline);
(command "" "" "")