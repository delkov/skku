(setq points_list (list (list 1.0 2.0 0.0) (list 2.0 3.0 0.0) (list 3.0 4.0 0.0) (list 3.0 4.0 0.0)) )
(command  "_.SPLINE")
(apply  'command  points_list)
(command  "" "" "");
