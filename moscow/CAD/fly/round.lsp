(defun Round (num dp / fac)
  (setq fac (float (expt 10 dp)))

  (if (< 0.5 (rem (setq num (* fac num)) 1))
    (/ (1+ (fix num)) fac)
    (/     (fix num)  fac))
 )