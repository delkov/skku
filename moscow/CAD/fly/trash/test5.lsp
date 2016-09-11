        (command "_.line" '(100 200) '(300 200)"")
        (setq vlol (vlax-ename->vla-object (entlast)))
        (setq tested_point (vlax-curve-getEndPoint vlol)) 