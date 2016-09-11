  (setq temp_angle_spline  (append start_angle_point med_angle_point end_angle_point start_angle_point))

  (command "._PLINE")
  (apply 'command temp_angle_spline);
  (command "")