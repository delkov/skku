(defun c:makelt    (/ str file fn exprt)
 
(setq old_CELTSCALE (getvar "CELTSCALE"))



  (setq
    str   "temp"
    file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
    fn    (open file "w")
  ;  exprt (getvar 'expert)
  )
  (write-line (strcat "*" str ", ---" str "---") fn)
  (write-line (strcat "A,0.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
  (close fn)
  ;(setvar 'expert 5)

(if (= (tblsearch "LTYPE" "temp") nil)
  (command ".-linetype" "load" "*" file "")
); end if


  ;(setvar 'expert exprt)
  (vl-file-delete file)


;(princ)

)