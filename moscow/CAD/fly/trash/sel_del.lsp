(setq i -1)
(repeat (sslength total_sel)
(setq i (+ 1 i))
(entdel (ssname total_sel i))

); repeat